# post-trigger.ps1
# Instagram Autopilot — postet täglich Story und Reel via Blotato AI Video API.
# Laeuft automatisch via GitHub Actions (09:00 Story, 18:00 Reel CEST).
#
# ============================================================
# EINZIGE ANPASSUNG: Deine Blotato Account-ID eintragen
# ============================================================
$accountIdIG = "DEINE_BLOTATO_ID"   # <--- HIER DEINE ID EINTRAGEN (5-stellige Zahl)
# ============================================================

# ============================================================
# KONFIGURATION — NICHTS HIER AENDERN
# ============================================================
$basePath = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { Split-Path -Parent $PSScriptRoot }

# CSV nach aktuellem Monat suchen
$monatMap = @{
    1="januar"; 2="februar"; 3="maerz"; 4="april"; 5="mai"; 6="juni";
    7="juli"; 8="august"; 9="september"; 10="oktober"; 11="november"; 12="dezember"
}
$monat   = $monatMap[(Get-Date).Month]
$csvNamen = @(
    "contentplan_${monat}_v2.csv",
    "contentplan_${monat}_v1.csv"
)
$csvPath = $null
foreach ($name in $csvNamen) {
    $pfad = Join-Path $basePath "outputs\$name"
    if (Test-Path $pfad) { $csvPath = $pfad; break }
}
if (-not $csvPath) {
    Write-Host "FEHLER: Kein CSV fuer Monat '$monat' gefunden."
    Write-Host "Erwartet: outputs/contentplan_${monat}_v1.csv"
    exit 1
}

$logPath  = Join-Path $basePath "outputs\autopilot-log.txt"
$archivPath = Join-Path $basePath "outputs\post-archiv.csv"

$apiKey          = $env:BLOTATO_API_KEY
$apiBase         = "https://backend.blotato.com/v2"
$aiVideoTemplate = "/base/v2/ai-story-video/5903fe43-514d-40ee-a060-0d6628c5f8fd/v1"
$voiceName       = "Daniel (British, authoritative)"

$zeitfensterFrueh = -10
$zeitfensterSpaet = 45

# ============================================================
# HILFSFUNKTIONEN
# ============================================================
function Write-Log {
    param([string]$msg)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $msg"
    $line | Out-File -FilePath $logPath -Append -Encoding UTF8
    Write-Host $line
}

function Create-AIVideo {
    param(
        [string]$imagePrompt,
        [string]$voiceScript,
        [string]$typ
    )

    $scenes = @(
        @{
            mediaSource = $imagePrompt
            script      = $voiceScript
        },
        @{
            mediaSource = $imagePrompt
            script      = "Schreib mir jetzt — ich beantworte jeden Kommentar persoenlich."
        }
    )

    $payload = @{
        templateId = $aiVideoTemplate
        inputs     = @{
            scenes          = $scenes
            enableVoiceover = $true
            voiceName       = $voiceName
            aiImageModel    = "fal-ai/imagen4/preview/fast"
            animateAiImages = $false
            captionPosition = "bottom"
            highlightColor  = "#FFFF00"
            transition      = "fade"
            aspectRatio     = "9:16"
            trimToVoiceover = $true
        }
        render = $true
    }

    $json      = $payload | ConvertTo-Json -Depth 10 -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $headers   = @{
        "blotato-api-key" = $apiKey
        "Content-Type"    = "application/json; charset=utf-8"
    }

    Write-Log "Erstelle AI-Video ($typ)..."

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/videos/from-templates" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "AI-Video gestartet. Response: $($response | ConvertTo-Json -Depth 3 -Compress)"
        return $response
    } catch {
        Write-Log "FEHLER AI-Video: $_"
        return $null
    }
}

function Wait-ForVideoUrl {
    param($response)
    $headers = @{ "blotato-api-key" = $apiKey }

    # Job-ID aus Response extrahieren
    $jobId = $null
    if ($response.item.id)  { $jobId = $response.item.id }
    elseif ($response.id)   { $jobId = $response.id }

    # URL direkt vorhanden?
    if ($response.item.mediaUrl) { return $response.item.mediaUrl }
    if ($response.mediaUrl)      { return $response.mediaUrl }

    if (-not $jobId) {
        Write-Log "FEHLER: Keine Job-ID in Response. $($response | ConvertTo-Json -Depth 3 -Compress)"
        return $null
    }

    # Auf fertiges Video warten (max. 5 Minuten)
    Write-Log "Warte auf Video-Rendering (Job: $jobId)..."
    for ($i = 1; $i -le 60; $i++) {
        Start-Sleep -Seconds 5
        try {
            # WICHTIG: Korrekter Endpoint ist /videos/creations/{id}
            $status = Invoke-RestMethod -Uri "$apiBase/videos/creations/$jobId" -Method GET -Headers $headers -ErrorAction Stop
            $state  = $status.item.status
            Write-Log "Render-Status ($i): $state"

            if ($state -eq "done" -or $state -eq "completed" -or $state -eq "ready") {
                if ($status.item.mediaUrl) { return $status.item.mediaUrl }
                Write-Log "Status done aber keine URL. $($status | ConvertTo-Json -Depth 3 -Compress)"
                return $null
            }
            if ($state -match "failed|error") {
                Write-Log "Rendering fehlgeschlagen. $($status | ConvertTo-Json -Depth 3 -Compress)"
                return $null
            }
        } catch {
            Write-Log "Status-Check Fehler: $_"
        }
    }
    Write-Log "Timeout: Video nach 5 Minuten nicht fertig."
    return $null
}

function Post-Instagram {
    param(
        [string]$caption,
        [string]$mediaUrl,
        [string]$targetType,
        [string]$mediaType = ""
    )

    $target = @{ targetType = $targetType }
    if ($mediaType -ne "") { $target["mediaType"] = $mediaType }

    $payload = @{
        post = @{
            accountId = $accountIdIG
            content   = @{
                text      = $caption
                platform  = "instagram"
                mediaUrls = @($mediaUrl)
            }
            target    = $target
        }
    }

    $json      = $payload | ConvertTo-Json -Depth 10 -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $headers   = @{
        "blotato-api-key" = $apiKey
        "Content-Type"    = "application/json; charset=utf-8"
    }

    Write-Log "Poste auf Instagram ($targetType $mediaType)..."

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/posts" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "Instagram Post OK. ID: $($response.postSubmissionId)"
        return $true
    } catch {
        Write-Log "FEHLER Instagram-Post: $_"
        return $false
    }
}

# ============================================================
# HAUPTLOGIK
# ============================================================
$heute = (Get-Date).ToString("dd.MM.yyyy")
$jetzt = Get-Date

Write-Log "=== Autopilot gestartet | $heute | $($jetzt.ToString('HH:mm')) ==="

# CSV einlesen
try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV nicht lesbar: $_"
    exit 1
}

# Heutige geplante Posts filtern
$heuteRows = $rows | Where-Object {
    $_.Datum -eq $heute -and
    $_.Status -eq "Geplant" -and
    $_.Plattform -eq "Instagram"
}

if (-not $heuteRows) {
    Write-Log "Kein geplanter Instagram-Post fuer heute. Fertig."
    exit 0
}

Write-Log "$(@($heuteRows).Count) Post(s) fuer heute gefunden."

foreach ($row in $heuteRows) {

    $typ     = $row.'Post-Typ'.Trim()
    $uhrzeit = $row.Uhrzeit.Trim()

    # Karussell nicht unterstuetzt
    if ($typ -eq "Karussell") {
        Write-Log "Karussell uebersprungen."
        continue
    }

    # Zeitfenster pruefen (-10 bis +45 Minuten zur geplanten Uhrzeit)
    try {
        $postZeit    = [datetime]::ParseExact("$heute $uhrzeit", "dd.MM.yyyy HH:mm", $null)
        $diffMinuten = ($jetzt - $postZeit).TotalMinutes
        if ($diffMinuten -lt $zeitfensterFrueh -or $diffMinuten -gt $zeitfensterSpaet) {
            Write-Log "Zeitfenster nicht passend fuer $typ um $uhrzeit (diff: $([math]::Round($diffMinuten,1)) min). Uebersprungen."
            continue
        }
    } catch {
        Write-Log "WARNUNG: Uhrzeit '$uhrzeit' nicht parsbar."
    }

    Write-Log "Post faellig: $typ um $uhrzeit"

    $imageSource = $row.Videoprompt.Trim()
    $textOverlay = $row.'Text-Overlay'.Trim()
    $caption     = $row.Text
    $link        = $row.Link.Trim()

    if (-not $imageSource) { $imageSource = $row.'Bild-URL'.Trim() }
    if (-not $imageSource) {
        Write-Log "FEHLER: Kein Videoprompt und keine Bild-URL. Post uebersprungen."
        continue
    }

    # Voiceover-Text: Caption bereinigen + Link-Abschluss anhaengen
    $voiceoverBase = $caption -replace '[💡📲🎧🎁💻🧠🔥✅❌→←↑↓👆👇👉👈⚡✨🎯💰📈🏆]', ''
    $voiceoverBase = $voiceoverBase -replace '#\S+', ''
    $voiceoverBase = $voiceoverBase -replace 'Link in Bio.*', ''
    $voiceoverBase = $voiceoverBase.Trim()

    # Optionaler Link-Abschluss basierend auf Link-Spalte
    $abschluss = switch -Wildcard ($link) {
        "*alfima*"              { "ALFIMA — kostenlos in meiner Bio." }
        "*instagram-autopilot*" { "Instagram Autopilot — in meiner Bio." }
        "*ki-audio-empire*"     { "KI-Hoerbuch — in meiner Bio." }
        default                 { "Mehr dazu — in meiner Bio." }
    }
    $voiceover = "$voiceoverBase $abschluss"

    # AI-Video erstellen
    $videoResponse = Create-AIVideo -imagePrompt $imageSource -voiceScript $voiceover -typ $typ
    if (-not $videoResponse) {
        Write-Log "AI-Video fehlgeschlagen. Post uebersprungen."
        continue
    }

    # Video-URL aus Rendering holen
    $videoUrl = Wait-ForVideoUrl -response $videoResponse
    if (-not $videoUrl) {
        Write-Log "Keine Video-URL. Post uebersprungen."
        continue
    }

    Write-Log "Video-URL: $videoUrl"

    # Auf Instagram posten
    $mediaType = if ($typ -eq "Story") { "story" } else { "reel" }
    $erfolg = Post-Instagram -caption $caption -mediaUrl $videoUrl -targetType "instagram" -mediaType $mediaType

    if ($erfolg) {
        # Archiv-Eintrag
        if (-not (Test-Path $archivPath)) {
            "Zeitstempel,Datum,Uhrzeit,Typ,Plattform,Video-URL,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
        }
        "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$uhrzeit`",`"$typ`",`"Instagram`",`"$videoUrl`",`"$($caption -replace '"','""')`"" |
            Out-File -FilePath $archivPath -Append -Encoding UTF8

        # Status in CSV auf "Gepostet" setzen
        $rows | ForEach-Object {
            if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and
                $_.Plattform -eq "Instagram" -and $_.Status -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf Gepostet gesetzt."
    }
}

Write-Log "=== Fertig ==="
