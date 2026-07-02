# post-trigger-song-geschenke.ps1
# Erstellt AI-Video mit Voiceover via Blotato Visual Templates API und postet auf Instagram @song.geschenke.
# Template: AI Video with AI Voice (ai-story-video)
# Laeuft taeglich via GitHub Actions (09:00 CEST Story, 18:00 CEST Reel).
# Account: @song.geschenke (Blotato ID via GitHub Secret SONG_GESCHENKE_ACCOUNT_ID)
# Zwei Produkte: Songgeschenke (SONG, ab 29 Euro) und Hymnenschmiede (HYMNE, ab 59 Euro)

# ============================================================
# KONFIGURATION
# ============================================================
$basePath    = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }
$logPath     = Join-Path $basePath "outputs\post-trigger-song-geschenke-log.txt"
$archivPath  = Join-Path $basePath "outputs\post-archiv-song-geschenke.csv"

# CSV automatisch nach aktuellem Monat waehlen
$monatMap = @{1="januar";2="februar";3="maerz";4="april";5="mai";6="juni";
              7="juli";8="august";9="september";10="oktober";11="november";12="dezember"}
$monat    = $monatMap[(Get-Date).Month]
$csvNamen = @("contentplan_song_geschenke_${monat}_v2.csv", "contentplan_song_geschenke_${monat}_v1.csv")
$csvPath  = $null
foreach ($name in $csvNamen) {
    $pfad = Join-Path $basePath "outputs\$name"
    if (Test-Path $pfad) { $csvPath = $pfad; break }
}
if (-not $csvPath) { Write-Host "FEHLER: Kein Song-Geschenke CSV fuer Monat '$monat' gefunden."; exit 1 }

$apiKey          = if ($env:BLOTATO_API_KEY) { $env:BLOTATO_API_KEY } else { "blt_KiCyq1rBxLUqnWdUJaH6Qaij4V07Q6wvcIH8/aQLrXA=" }
$apiBase         = "https://backend.blotato.com/v2"
$accountIdIG     = if ($env:SONG_GESCHENKE_ACCOUNT_ID) { $env:SONG_GESCHENKE_ACCOUNT_ID } else { "XXXXX" }  # GitHub Secret SONG_GESCHENKE_ACCOUNT_ID setzen!
$aiVideoTemplate = "/base/v2/ai-story-video/5903fe43-514d-40ee-a060-0d6628c5f8fd/v1"
$voiceName       = "Charlie (Australian, natural)"

$zeitfensterFrueh = -10
$zeitfensterSpaet = 180
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

function Create-AIVideo {
    param(
        [string]$imagePrompt,
        [string]$voiceScript,
        [string]$ctaScript,
        [string]$typ,
        [string]$videoName
    )

    $scenes = @(
        @{ mediaSource = $imagePrompt; script = $voiceScript },
        @{ mediaSource = $imagePrompt; script = $ctaScript }
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
    $headers   = @{ "blotato-api-key" = $apiKey; "Content-Type" = "application/json; charset=utf-8" }

    Write-Log "Erstelle Song-Geschenke AI-Video ($typ)"

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

    if (-not $jobId) { Write-Log "Keine Job-ID gefunden."; return $null }

    Write-Log "Rendering laeuft (Job: $jobId)..."
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
            if ($state -like "*failed*" -or $state -eq "error") {
                Write-Log "Rendering fehlgeschlagen."
                return $null
            }
        } catch { Write-Log "Fehler beim Status-Check: $_" }
    }
    Write-Log "Timeout."
    return $null
}

function Post-Instagram {
    param([string]$caption, [string]$mediaUrl, [string]$targetType, [string]$mediaType = "")

    $target = @{ targetType = $targetType }
    if ($mediaType -ne "") { $target["mediaType"] = $mediaType }

    $payload = @{
        post = @{
            accountId = $accountIdIG
            content   = @{ text = $caption; platform = "instagram"; mediaUrls = @($mediaUrl) }
            target    = $target
        }
    }

    $json      = $payload | ConvertTo-Json -Depth 10 -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $headers   = @{ "blotato-api-key" = $apiKey; "Content-Type" = "application/json; charset=utf-8" }

    Write-Log "Poste auf Instagram ($targetType / $mediaType)"

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

Write-Log "=== Song-Geschenke Trigger gestartet | Heute: $heute | Jetzt: $($jetzt.ToString('HH:mm')) ==="

try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV konnte nicht gelesen werden: $_"; exit 1
}

$postType = $env:POST_TYPE  # "story" oder "reel" — von GitHub Actions gesetzt

$heuteRowsAlle = $rows | Where-Object {
    $_.Datum -eq $heute -and $_.Plattform -eq "Instagram" -and
    (-not $postType -or
     ($postType -eq "story" -and $_.'Post-Typ' -eq "Story") -or
     ($postType -eq "reel"  -and $_.'Post-Typ' -ne "Story"))
}
$heuteRows = $heuteRowsAlle | Where-Object { $_.Status.Trim() -eq "Geplant" }

if (-not $heuteRows) {
    if (@($heuteRowsAlle | Where-Object { $_.Status.Trim() -eq "Gepostet" }).Count -gt 0) {
        Write-Log "Bereits gepostet (frueherer Lauf/Backup-Cron). Stille."
    } else {
        Write-Log "Kein geplanter Instagram-Post fuer heute. Fertig."
    }
    exit 0
}

Write-Log "$(@($heuteRows).Count) Instagram-Post(s) fuer heute gefunden."

foreach ($row in $heuteRows) {

    $typ     = $row.'Post-Typ'.Trim()
    $uhrzeit = $row.Uhrzeit.Trim()

    try {
        $postZeit    = [datetime]::ParseExact("$heute $uhrzeit", "dd.MM.yyyy HH:mm", $null)
        $diffMinuten = ($jetzt - $postZeit).TotalMinutes
        if (-not $isManualRun -and -not $postType -and ($diffMinuten -lt $zeitfensterFrueh -or $diffMinuten -gt $zeitfensterSpaet)) {
            Write-Log "Zeitfenster nicht passend fuer $typ um $uhrzeit (diff: $([math]::Round($diffMinuten,1)) min)."
            continue
        }
    } catch { Write-Log "WARNUNG: Uhrzeit '$uhrzeit' konnte nicht geparst werden." }

    Write-Log "Post faellig: $typ | $uhrzeit"

    $imageSource = $row.Videoprompt.Trim()
    $caption     = $row.Text
    $link        = $row.Link.Trim()
    $textOverlay = $row.'Text-Overlay'.Trim()

    if (-not $imageSource -or $imageSource -eq "") { $imageSource = $row.'Bild-URL'.Trim() }
    if (-not $imageSource -or $imageSource -eq "") { Write-Log "FEHLER: Kein Videoprompt/Bild-URL. Post uebersprungen."; continue }

    # Voiceover: Emojis, Hashtags und CTA-Zeilen (mit Schreib [KEYWORD]) entfernen
    $voiceoverBase = $caption -replace '[🎁🎵🎶🎼🎤🎙️🎸🎹🎺🎻💍❤️💝💛🕊️🕯️🥂🎂🎊🎈🎉🎪🏆🥇⚽👔👏💼🏟️🏢⚡🎗️🎀✨💡📲💰🔥✅❌→←↑↓👆👇👉👈]', ''
    $voiceoverBase = $voiceoverBase -replace 'Link in Bio.*', ''
    $voiceoverBase = ($voiceoverBase -split "`n" | Where-Object { $_ -notmatch '(?i)(schreib|kommentiere)\s+\w+' }) -join "`n"
    $voiceoverBase = $voiceoverBase -replace '#\S+', ''
    $voiceoverBase = $voiceoverBase.Trim()

    # CTA-Script abhaengig vom Produkt (HYMNE vs SONG, erkennbar am Text-Overlay)
    if ($textOverlay -match "HYMNE") {
        $ctaScript = "Schreib HYMNE in die Kommentare, dann meld ich mich persoenlich bei dir."
    } else {
        $ctaScript = "Schreib SONG in die Kommentare, dann schick ich dir den Link dazu."
    }
    $voiceover = $voiceoverBase

    $videoName     = "Song-Geschenke $typ $heute"
    $videoResponse = Create-AIVideo -imagePrompt $imageSource -voiceScript $voiceover -ctaScript $ctaScript -typ $typ -videoName $videoName
    if (-not $videoResponse) { Write-Log "AI-Video fehlgeschlagen. Post uebersprungen."; continue }
    $videoUrl = Wait-ForVideoUrl -response $videoResponse
    if (-not $videoUrl) { Write-Log "Keine Video-URL. Post uebersprungen."; continue }

    $targetType = "instagram"
    $mediaType  = if ($typ -eq "Story") { "story" } else { "reel" }

    $erfolg = Post-Instagram -caption $caption -mediaUrl $videoUrl -targetType $targetType -mediaType $mediaType

    if ($erfolg) {
        if (-not (Test-Path $archivPath)) {
            "Zeitstempel,Datum,Uhrzeit,Post-Typ,Plattform,Media-URL,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
        }
        "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$uhrzeit`",`"$typ`",`"Instagram`",`"$videoUrl`",`"$($caption -replace '"','""')`"" | Out-File -FilePath $archivPath -Append -Encoding UTF8

        $rows | ForEach-Object {
            if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and $_.Plattform -eq "Instagram" -and $_.Status.Trim() -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf 'Gepostet' gesetzt."
        Send-Telegram "✅ @song.geschenke — $typ gepostet ($heute $uhrzeit)"
    } else {
        Send-Telegram "❌ @song.geschenke — $typ fehlgeschlagen ($heute $uhrzeit)"
    }
}

Write-Log "=== Fertig ==="
