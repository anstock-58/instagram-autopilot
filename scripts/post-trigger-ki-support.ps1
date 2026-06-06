# post-trigger-ki-support.ps1
# Erstellt AI-Video mit Voiceover via Blotato Visual Templates API und postet auf Instagram @ki_support.
# Template: AI Video with AI Voice (ai-story-video)
# Laeuft taeglich via GitHub Actions (08:55 CEST Story, 17:55 CEST Reel).
# Account: @ki_support (Blotato ID 46341)

# ============================================================
# KONFIGURATION
# ============================================================
$basePath    = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }
$logPath     = Join-Path $basePath "outputs\post-trigger-ki-support-log.txt"
$archivPath  = Join-Path $basePath "outputs\post-archiv-ki-support.csv"

# CSV automatisch nach aktuellem Monat waehlen
$monatMap = @{1="januar";2="februar";3="maerz";4="april";5="mai";6="juni";
              7="juli";8="august";9="september";10="oktober";11="november";12="dezember"}
$monat    = $monatMap[(Get-Date).Month]
$csvNamen = @("contentplan_ki_support_${monat}_v2.csv", "contentplan_ki_support_${monat}_v1.csv")
$csvPath  = $null
foreach ($name in $csvNamen) {
    $pfad = Join-Path $basePath "outputs\$name"
    if (Test-Path $pfad) { $csvPath = $pfad; break }
}
if (-not $csvPath) { Write-Host "FEHLER: Kein KI-Support CSV fuer Monat '$monat' gefunden."; exit 1 }

$apiKey          = if ($env:BLOTATO_API_KEY) { $env:BLOTATO_API_KEY } else { "blt_KiCyq1rBxLUqnWdUJaH6Qaij4V07Q6wvcIH8/aQLrXA=" }
$apiBase         = "https://backend.blotato.com/v2"
$accountIdIG     = "46341"   # @ki_support Instagram
$aiVideoTemplate = "/base/v2/ai-story-video/5903fe43-514d-40ee-a060-0d6628c5f8fd/v1"
$voiceName       = "Daniel (British, authoritative)"   # ElevenLabs-Stimme (Andi-Vorgabe 06.06.2026: Daniel fuer ki_support + andi.mit.system)

$zeitfensterFrueh = -10
$zeitfensterSpaet = 45
$isManualRun = $env:GITHUB_EVENT_NAME -eq "workflow_dispatch"

$telegramToken  = $env:TELEGRAM_BOT_TOKEN
$telegramChatId = "1246764172"

# ============================================================
# HILFSFUNKTIONEN
# ============================================================
function Write-Log {
    param([string]$msg)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $msg"
    $line | Out-File -FilePath $logPath -Append -Encoding UTF8
    Write-Host $line
}

function Send-Telegram {
    param([string]$text)
    try {
        $body = @{ chat_id = $telegramChatId; text = $text } | ConvertTo-Json -Compress
        $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$telegramToken/sendMessage" `
            -Method POST -ContentType "application/json; charset=utf-8" -Body $bodyBytes -ErrorAction Stop | Out-Null
    } catch {
        Write-Log "Telegram-Benachrichtigung fehlgeschlagen: $_"
    }
}

function Optimize-ForTTS {
    param([string]$text)
    # Sätze fürs Sprechen optimieren: kurze klare Einheiten, gezielte Pausen
    $result = $text

    # Leerzeilen als Pause erhalten (werden als Sprechpause interpretiert)
    # Lange Sätze (>90 Zeichen) an Konjunktionen trennen
    $result = $result -replace '(.{60,}?)(, aber|, denn|, weil|, wenn|, dass|, und dann|, sodass)', '$1. $2' -replace '^, ', ''

    # "Das ist" / "Das war" / "Das heißt" am Satzanfang nach Leerzeile = kurze Pause davor
    $result = $result -replace '(\n)(Das ist |Das war |Das heißt |Das bedeutet )', '$1... $2'

    # Rhetorische Fragen bekommen eine kurze Pause danach
    $result = $result -replace '(\?)\n', "?`n`n"

    # Aufzählungen mit Punkt trennen statt Komma (bessere Sprech-Pausen)
    # "A. B. C." statt "A, B, C" wenn drei kurze Items in einer Zeile
    # (Nur wenn Items < 30 Zeichen sind)

    # Trim & bereinigen
    $result = $result -replace '\n{3,}', "`n`n"
    $result = $result.Trim()

    return $result
}

function Create-AIVideo {
    param(
        [string]$imagePrompt,   # Videoprompt aus CSV (Blotato generiert KI-Bild)
        [string]$voiceScript,   # Hauptbotschaft (ohne CTA)
        [string]$ctaScript,     # CTA fuer Scene 2 (Keyword + Bio-Hinweis)
        [string]$typ,           # "Story" oder "Reel"/"Foto"
        [string]$videoName      # Anzeigename in Blotato
    )

    # Scene 1: Hauptbotschaft mit KI-Bild und Voiceover (kein CTA)
    # Scene 2: Einmal sauberer CTA mit richtigem Keyword
    $scenes = @(
        @{
            mediaSource = $imagePrompt
            script      = $voiceScript
        },
        @{
            mediaSource = $imagePrompt
            script      = $ctaScript
        }
    )

    $payload = @{
        templateId = $aiVideoTemplate
        title      = $videoName
        name       = $videoName
        inputs     = @{
            scenes          = $scenes
            enableVoiceover = $true
            voiceName       = $voiceName
            aiImageModel    = "replicate/black-forest-labs/flux-schnell"
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

    Write-Log "Erstelle KI-Support AI-Video ($typ) mit Voiceover: Prompt-Laenge $($imagePrompt.Length) | Script-Laenge $($voiceScript.Length)"

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/videos/from-templates" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "AI-Video Response: $($response | ConvertTo-Json -Depth 5 -Compress)"
        return $response
    } catch {
        Write-Log "FEHLER AI-Video-Erstellung: $_"
        return $null
    }
}

function Wait-ForVideoUrl {
    param($response)
    $headers = @{ "blotato-api-key" = $apiKey }

    $jobId = $null
    if ($response.item.id)  { $jobId = $response.item.id }
    elseif ($response.id)   { $jobId = $response.id }

    if ($response.item.mediaUrl) { return $response.item.mediaUrl }
    if ($response.mediaUrl)      { return $response.mediaUrl }
    if ($response.videoUrl)      { return $response.videoUrl }
    if ($response.url)           { return $response.url }

    if (-not $jobId) {
        Write-Log "Keine Job-ID in Response gefunden. Response: $($response | ConvertTo-Json -Depth 3 -Compress)"
        return $null
    }

    Write-Log "Rendering laeuft (Job: $jobId) - warte bis zu 5 Minuten..."
    $maxWait = 120
    for ($i = 1; $i -le $maxWait; $i++) {
        Start-Sleep -Seconds 5
        try {
            $status = Invoke-RestMethod -Uri "$apiBase/videos/creations/$jobId" -Method GET -Headers $headers -ErrorAction Stop
            $state  = $status.item.status
            Write-Log "Render-Status ($i): $state"
            if ($state -eq "done" -or $state -eq "completed" -or $state -eq "ready") {
                if ($status.item.mediaUrl)  { return $status.item.mediaUrl }
                if ($status.item.videoUrl)  { return $status.item.videoUrl }
                if ($status.item.url)       { return $status.item.url }
                Write-Log "Status done aber keine URL: $($status | ConvertTo-Json -Depth 5 -Compress)"
                return $null
            }
            if ($state -eq "creation-from-template-failed" -or $state -eq "failed" -or $state -eq "error") {
                Write-Log "Rendering fehlgeschlagen: $($status | ConvertTo-Json -Depth 5 -Compress)"
                return $null
            }
        } catch {
            Write-Log "Fehler beim Status-Check: $_"
        }
    }
    Write-Log "Timeout: Video nach 10 Minuten noch nicht fertig."
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

    Write-Log "Poste auf Instagram ($targetType): Caption-Laenge $($caption.Length) Zeichen"

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/posts" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "Instagram OK. SubmissionId: $($response.postSubmissionId)"
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

Write-Log "=== KI-Support Trigger gestartet | Heute: $heute | Jetzt: $($jetzt.ToString('HH:mm')) ==="

try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV konnte nicht gelesen werden: $_"
    exit 1
}

$postType = $env:POST_TYPE  # "story" oder "reel" — von GitHub Actions gesetzt, leer bei lokalem Lauf

$heuteRows = $rows | Where-Object {
    $_.Datum -eq $heute -and $_.Status.Trim() -eq "Geplant" -and $_.Plattform -eq "Instagram" -and
    (-not $postType -or
     ($postType -eq "story" -and $_.'Post-Typ' -eq "Story") -or
     ($postType -eq "reel"  -and $_.'Post-Typ' -ne "Story" -and $_.'Post-Typ' -ne "Karussell"))
}

if (-not $heuteRows) {
    Write-Log "Kein geplanter Instagram-Post fuer heute. Fertig."
    Send-Telegram "📅 @ki_support — kein Post fuer heute geplant ($heute)"
    exit 0
}

Write-Log "$(@($heuteRows).Count) Instagram-Post(s) fuer heute gefunden."

foreach ($row in $heuteRows) {

    $typ     = $row.'Post-Typ'.Trim()
    $uhrzeit = $row.Uhrzeit.Trim()

    if ($typ -eq "Karussell") {
        Write-Log "Karussell uebersprungen (nicht implementiert)."
        continue
    }

    # Zeitfenster pruefen
    try {
        $postZeit    = [datetime]::ParseExact("$heute $uhrzeit", "dd.MM.yyyy HH:mm", $null)
        $diffMinuten = ($jetzt - $postZeit).TotalMinutes
        if (-not $isManualRun -and -not $postType -and ($diffMinuten -lt $zeitfensterFrueh -or $diffMinuten -gt $zeitfensterSpaet)) {
            Write-Log "Zeitfenster nicht passend fuer $typ um $uhrzeit (diff: $([math]::Round($diffMinuten,1)) min)."
            continue
        }
    } catch {
        Write-Log "WARNUNG: Uhrzeit '$uhrzeit' konnte nicht geparst werden."
    }

    Write-Log "Post faellig: $typ | $uhrzeit"

    $imageSource = $row.Videoprompt.Trim()
    $textOverlay = $row.'Text-Overlay'.Trim()
    $caption     = $row.Text
    $link        = $row.Link.Trim()

    if (-not $imageSource -or $imageSource -eq "") {
        $imageSource = $row.'Bild-URL'.Trim()
    }

    if (-not $imageSource -or $imageSource -eq "") {
        Write-Log "FEHLER: Weder Videoprompt noch Bild-URL vorhanden. Post uebersprungen."
        continue
    }

    # Voiceover: nur Hauptbotschaft, alle CTAs raus — CTA kommt einmal in Scene 2
    $voiceoverBase = $caption -replace '[💡📲🎧🎁💻🧠🔥✅❌→←↑↓👆👇👉👈⚡✨🎯💰📈🏆🎤🎵🎶🎼🎙️]', ''
    $voiceoverBase = $voiceoverBase -replace 'Link in Bio.*', ''
    $voiceoverBase = $voiceoverBase -replace '(?i)(Kommentiere|Schreib)\s+\w+.*', ''  # alle CTAs raus
    $voiceoverBase = $voiceoverBase -replace '#\S+', ''
    $voiceoverBase = $voiceoverBase.Trim()

    $keyword = switch -Wildcard ($link) {
        "*instagram-autopilot*" { "AUTOPILOT" }
        "*ki-audio-empire*"     { "HÖRBUCH" }
        "*ki-prompt-paket*"     { "PROMPTS" }
        "*alfima*"              { "TOOL" }
        default                 { "KI" }
    }
    $ctaScript = "Wenn dich das interessiert — schreib START. Ich schick dir sofort alle Details."
    $voiceover = Optimize-ForTTS -text $voiceoverBase

    # FOTO-MODUS: Wenn Bild-URL direkt vorhanden, kein AI-Video rendern
    $directImageUrl = $row.'Bild-URL'.Trim()
    if ($directImageUrl -and $directImageUrl -match "^https://") {
        Write-Log "Foto-Modus: Direktes Bild posten (keine Credits)"
        $videoUrl = $directImageUrl
    } else {
    # AI-Video mit Voiceover erstellen
    $videoName     = "KI-Support $typ $heute"
    $videoResponse = Create-AIVideo -imagePrompt $imageSource -voiceScript $voiceover -ctaScript $ctaScript -typ $typ -videoName $videoName
    if (-not $videoResponse) {
        Write-Log "AI-Video-Erstellung fehlgeschlagen. Post uebersprungen."
        continue
    }

    # Video-URL aus Response extrahieren (wartet auf async Rendering)
    $videoUrl = Wait-ForVideoUrl -response $videoResponse
    if (-not $videoUrl) {
        Write-Log "Keine Video-URL in Response. Post uebersprungen."
        continue
    }

    Write-Log "Video-URL: $videoUrl"
    }
    $targetType = "instagram"
    $mediaType  = if ($typ -eq "Story") { "story" } else { "reel" }

    $erfolg = Post-Instagram -caption $caption -mediaUrl $videoUrl -targetType $targetType -mediaType $mediaType

    if ($erfolg) {
        if (-not (Test-Path $archivPath)) {
            "Zeitstempel,Datum,Uhrzeit,Post-Typ,Plattform,Media-URL,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
        }
        $archivZeile = "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$uhrzeit`",`"$typ`",`"Instagram`",`"$videoUrl`",`"$($caption -replace '"','""')`""
        $archivZeile | Out-File -FilePath $archivPath -Append -Encoding UTF8

        $rows | ForEach-Object {
            if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and $_.Plattform -eq "Instagram" -and $_.Status.Trim() -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf 'Gepostet' gesetzt."
        Send-Telegram "✅ @ki_support — $typ gepostet ($heute $uhrzeit)"
    } else {
        Send-Telegram "❌ @ki_support — $typ fehlgeschlagen ($heute $uhrzeit)"
    }
}

Write-Log "=== Fertig ==="

