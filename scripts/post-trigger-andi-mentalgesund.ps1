# post-trigger-andi-mentalgesund.ps1
# Erstellt AI-Video mit Voiceover via Blotato Visual Templates API und postet auf Instagram @andi.mentalgesund.
# Template: AI Video with AI Voice (ai-story-video)
# Laeuft taeglich via GitHub Actions (06:55 UTC Story, 15:55 UTC Reel).
# Account: @andi.mentalgesund (Blotato ID - bitte in secrets.md eintragen)

# ============================================================
# KONFIGURATION
# ============================================================
$basePath    = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }
$logPath     = Join-Path $basePath "outputs\post-trigger-andi-mentalgesund-log.txt"
$archivPath  = Join-Path $basePath "outputs\post-archiv-andi-mentalgesund.csv"

# CSV automatisch nach aktuellem Monat waehlen
$monatMap = @{1="januar";2="februar";3="maerz";4="april";5="mai";6="juni";
              7="juli";8="august";9="september";10="oktober";11="november";12="dezember"}
$monat    = $monatMap[(Get-Date).Month]
$csvNamen = @("contentplan_andi_mentalgesund_${monat}_v2.csv", "contentplan_andi_mentalgesund_${monat}_v1.csv")
$csvPath  = $null
foreach ($name in $csvNamen) {
    $pfad = Join-Path $basePath "outputs\$name"
    if (Test-Path $pfad) { $csvPath = $pfad; break }
}
if (-not $csvPath) { Write-Host "FEHLER: Kein Andi-Mentalgesund CSV fuer Monat '$monat' gefunden."; exit 1 }

$apiKey          = if ($env:BLOTATO_API_KEY) { $env:BLOTATO_API_KEY } else { "blt_KiCyq1rBxLUqnWdUJaH6Qaij4V07Q6wvcIH8/aQLrXA=" }
$apiBase         = "https://backend.blotato.com/v2"
$accountIdIG     = if ($env:MENTALGESUND_ACCOUNT_ID) { $env:MENTALGESUND_ACCOUNT_ID } else { "ACCOUNT_ID_PLACEHOLDER" }
$aiVideoTemplate = "/base/v2/ai-story-video/5903fe43-514d-40ee-a060-0d6628c5f8fd/v1"
$voiceName       = "Charlie (Australian, natural)"   # ElevenLabs-Stimme â€” beste Deutsch-Prosody unter den 20 Blotato-Stimmen

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
    # Saetze fuers Sprechen optimieren: kurze klare Einheiten, gezielte Pausen
    $result = $text

    # Lange Saetze (>60 Zeichen) an Konjunktionen trennen
    $result = $result -replace '(.{60,}?)(, aber|, denn|, weil|, wenn|, dass|, und dann|, sodass)', '$1. $2' -replace '^, ', ''

    # "Das ist" / "Das war" / "Das heisst" am Satzanfang nach Leerzeile = kurze Pause davor
    $result = $result -replace '(\n)(Das ist |Das war |Das heisst |Das bedeutet )', '$1... $2'

    # Rhetorische Fragen bekommen eine kurze Pause danach
    $result = $result -replace '(\?)\n', "?`n`n"

    # Trim und bereinigen
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

    Write-Log "Erstelle Andi-Mentalgesund AI-Video ($typ) mit Voiceover: Prompt-Laenge $($imagePrompt.Length) | Script-Laenge $($voiceScript.Length)"

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
    $maxWait = 60
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
    Write-Log "Timeout: Video nach 5 Minuten noch nicht fertig."
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

Write-Log "=== Andi-Mentalgesund Trigger gestartet | Heute: $heute | Jetzt: $($jetzt.ToString('HH:mm')) ==="

try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV konnte nicht gelesen werden: $_"
    exit 1
}

$postType = $env:POST_TYPE  # "story" oder "reel" â€” von GitHub Actions gesetzt, leer bei lokalem Lauf

$heuteRows = $rows | Where-Object {
    $_.Datum -eq $heute -and $_.Status -eq "Geplant" -and $_.Plattform -eq "Instagram" -and
    (-not $postType -or
     ($postType -eq "story" -and $_.'Post-Typ' -eq "Story") -or
     ($postType -eq "reel"  -and $_.'Post-Typ' -ne "Story" -and $_.'Post-Typ' -ne "Karussell"))
}

if (-not $heuteRows) {
    Write-Log "Kein geplanter Instagram-Post fuer heute. Fertig."
    Send-Telegram "ðŸ“… @andi.mentalgesund â€” kein Post fuer heute geplant ($heute)"
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
    $caption     = $row.Text
    $link        = $row.Link.Trim()

    if (-not $imageSource -or $imageSource -eq "") {
        $imageSource = $row.'Bild-URL'.Trim()
    }

    if (-not $imageSource -or $imageSource -eq "") {
        $imageSource = $row.Bildprompt.Trim()
    }

    if (-not $imageSource -or $imageSource -eq "") {
        Write-Log "FEHLER: Weder Videoprompt noch Bild-URL noch Bildprompt vorhanden. Post uebersprungen."
        continue
    }

    # Voiceover: Hauptbotschaft ohne Emojis, Links und CTAs â€” CTA kommt einmal in Scene 2
    $voiceoverBase = $caption -replace '[^\p{L}\p{N}\p{P}\p{Z}\n\r]', ''
    $voiceoverBase = $voiceoverBase -replace 'Link in Bio.*', ''
    $voiceoverBase = $voiceoverBase -replace '(?i)(Schreib|Kommentiere)\s+\w+.*', ''  # CTAs raus
    $voiceoverBase = $voiceoverBase -replace '#\S+', ''
    $voiceoverBase = $voiceoverBase.Trim()

    $ctaScript = "Schreib NEIN in die Kommentare. Oder klick den Link in der Bio."
    $voiceover = Optimize-ForTTS -text $voiceoverBase

    # AI-Video mit Voiceover erstellen
    $videoName     = "Mentalgesund $typ $heute"
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
            if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and $_.Plattform -eq "Instagram" -and $_.Status -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf 'Gepostet' gesetzt."
        Send-Telegram "âœ… @andi.mentalgesund â€” $typ gepostet ($heute $uhrzeit)"
    } else {
        Send-Telegram "âŒ @andi.mentalgesund â€” $typ fehlgeschlagen ($heute $uhrzeit)"
    }
}

Write-Log "=== Fertig ==="

