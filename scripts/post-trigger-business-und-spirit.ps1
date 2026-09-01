# post-trigger-business-und-spirit.ps1
# Erstellt AI-Video mit Voiceover via Blotato Visual Templates API und postet auf Instagram @business.und.spirit.
# Template: AI Video with AI Voice (ai-story-video)
# Laeuft taeglich via GitHub Actions (08:55 CEST Story, 17:55 CEST Reel).
# Account: @business.und.spirit (Blotato ID 46248)

# ============================================================
# KONFIGURATION
# ============================================================
$basePath    = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }
$logPath     = Join-Path $basePath "outputs\post-trigger-business-und-spirit-log.txt"
$archivPath  = Join-Path $basePath "outputs\post-archiv-business-und-spirit.csv"

# CSV automatisch nach aktuellem Monat waehlen
$monatMap = @{1="januar";2="februar";3="maerz";4="april";5="mai";6="juni";
              7="juli";8="august";9="september";10="oktober";11="november";12="dezember"}
$monat    = $monatMap[(Get-Date).Month]
$csvNamen = @("contentplan_business_und_spirit_${monat}_v2.csv", "contentplan_business_und_spirit_${monat}_v1.csv")
$csvPath  = $null
foreach ($name in $csvNamen) {
    $pfad = Join-Path $basePath "outputs\$name"
    if (Test-Path $pfad) { $csvPath = $pfad; break }
}
if (-not $csvPath) { Write-Host "FEHLER: Kein Business-und-Spirit CSV fuer Monat '$monat' gefunden."; exit 1 }

$apiKey          = if ($env:BLOTATO_API_KEY) { $env:BLOTATO_API_KEY } else { "blt_KiCyq1rBxLUqnWdUJaH6Qaij4V07Q6wvcIH8/aQLrXA=" }
$apiBase         = "https://backend.blotato.com/v2"
$accountIdIG     = "46248"   # @business.und.spirit Instagram
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

    Write-Log "Erstelle Business-und-Spirit AI-Video ($typ)"

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

function Render-Local {
    param([string]$videoUrl, [string]$overlayText = "", [bool]$isStory = $false)

    $falKey     = if ($env:FAL_KEY) { $env:FAL_KEY } else { "7600112e-4d6f-4202-b107-b899fe36595c:4faa681903cdd51d757c18b7d0cc6c11" }
    $falHeaders = @{ "Authorization" = "Key $falKey"; "Content-Type" = "application/json" }

    $tmpDir     = [System.IO.Path]::GetTempPath()
    $inputFile  = Join-Path $tmpDir "bus_input_$(Get-Random).mp4"
    $outputFile = Join-Path $tmpDir "bus_output_$(Get-Random).mp4"
    $musicFile  = Join-Path $basePath "music\background-chill.mp3"
    $fontFile   = if ($env:GITHUB_WORKSPACE) { "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" } else { "C\:/Windows/Fonts/arialbd.ttf" }

    try {
        Write-Log "FFmpeg: Video herunterladen..."
        Invoke-WebRequest -Uri $videoUrl -OutFile $inputFile -ErrorAction Stop

        # Overlay-Text in 3 Zeilen aufteilen
        $lines = $overlayText -split "`n"
        $line1 = if ($lines.Count -gt 0) { $lines[0].Trim() } else { "" }
        $line2 = if ($lines.Count -gt 1) { $lines[1].Trim() } else { "" }
        $line3 = if ($lines.Count -gt 2) { $lines[2].Trim() } else { "" }

        # Sonderzeichen escapen fuer FFmpeg drawtext
        $line1 = $line1 -replace ":", "\:" -replace "'", "'\\'''"
        $line2 = $line2 -replace ":", "\:" -replace "'", "'\\'''"
        $line3 = $line3 -replace ":", "\:" -replace "'", "'\\'''"

        $box = "box=1:boxcolor=white@0.85:boxborderw=14"
        # Story: Text oben (absolute Pixel), Reel: Text unten (relativ)
        $y1 = if ($isStory) { "110" } else { "h*0.63" }
        $y2 = if ($isStory) { "210" } else { "h*0.72" }
        $y3 = if ($isStory) { "300" } else { "h*0.81" }
        $dt = "drawtext=fontfile='$fontFile':text='$line1':x=(w-tw)/2:y=$y1:fontsize=32:fontcolor=#1A2230:$box"
        if ($line2 -ne "") { $dt += ",drawtext=fontfile='$fontFile':text='$line2':x=(w-tw)/2:y=$y2:fontsize=32:fontcolor=#1A2230:$box" }
        if ($line3 -ne "") { $dt += ",drawtext=fontfile='$fontFile':text='$line3':x=(w-tw)/2:y=$y3:fontsize=26:fontcolor=#1A2230:$box" }

        if ($overlayText.Trim() -eq "") {
            # Story-Modus: nur Original-Ton entfernen + Musik drauf, kein Text
            if (Test-Path $musicFile) {
                Write-Log "FFmpeg: Story-Modus (Musik, kein Text)..."
                $ffmpegOut = & ffmpeg -y -i $inputFile -i $musicFile `
                    -filter_complex "[1:a]volume=0.15[a]" `
                    -map "0:v" -map "[a]" -shortest -c:v copy -c:a aac $outputFile 2>&1
            } else {
                Write-Log "FFmpeg: Story-Modus (stumm, kein Musikfile)..."
                $ffmpegOut = & ffmpeg -y -i $inputFile -an -c:v copy $outputFile 2>&1
            }
            $ffmpegOut | Select-Object -Last 20 | ForEach-Object { Write-Log "ffmpeg: $_" }
        } elseif (Test-Path $musicFile) {
            Write-Log "FFmpeg: Render mit Text + Musik (Font: $fontFile)..."
            Write-Log "FFmpeg dt: [$($dt)]"
            $fc = "[0:v]$($dt)[v];[1:a]volume=0.15[a]"
            $ffmpegOut = & ffmpeg -y -i $inputFile -i $musicFile `
                -filter_complex $fc `
                -map "[v]" -map "[a]" -shortest -c:v libx264 -c:a aac $outputFile 2>&1
            $ffmpegOut | Select-Object -Last 20 | ForEach-Object { Write-Log "ffmpeg: $_" }
        } else {
            Write-Log "FFmpeg: Render mit Text (kein Musikfile)..."
            $ffmpegOut = & ffmpeg -y -i $inputFile -vf "$($dt)" -c:v libx264 -c:a copy $outputFile 2>&1
            $ffmpegOut | Select-Object -Last 20 | ForEach-Object { Write-Log "ffmpeg: $_" }
        }

        if (-not (Test-Path $outputFile) -or (Get-Item $outputFile).Length -lt 10000) {
            Write-Log "FFmpeg fehlgeschlagen — Output fehlt oder zu klein"
            return $null
        }

        Write-Log "FFmpeg OK. Hochladen auf fal.ai..."
        $fileName = "bus_rendered_$(Get-Date -Format 'yyyyMMdd_HHmmss').mp4"
        $initBody = @{ file_name = $fileName; content_type = "video/mp4" } | ConvertTo-Json
        $init = Invoke-RestMethod -Uri "https://rest.alpha.fal.ai/storage/upload/initiate" `
            -Method POST -Headers $falHeaders `
            -Body ([System.Text.Encoding]::UTF8.GetBytes($initBody)) `
            -ContentType "application/json; charset=utf-8" -ErrorAction Stop

        $fileBytes = [System.IO.File]::ReadAllBytes($outputFile)
        try {
            Invoke-RestMethod -Uri $init.upload_url -Method PUT -Body $fileBytes `
                -ContentType "video/mp4" -ErrorAction Stop | Out-Null
        } catch {
            if ($_.Exception.Response.StatusCode.value__ -notin @(200, 204)) { throw }
        }

        Write-Log "Upload OK: $($init.file_url)"
        return $init.file_url

    } catch {
        Write-Log "FEHLER Render-Local: $_"
        return $null
    } finally {
        if (Test-Path $inputFile)  { Remove-Item $inputFile  -Force -ErrorAction SilentlyContinue }
        if (Test-Path $outputFile) { Remove-Item $outputFile -Force -ErrorAction SilentlyContinue }
    }
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

    Write-Log "Payload: $json"
    try {
        $response = Invoke-RestMethod -Uri "$apiBase/posts" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "Instagram OK. Response: $($response | ConvertTo-Json -Compress)"
        return $true
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        try {
            $stream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $body   = $reader.ReadToEnd()
        } catch { $body = "(kein Body)" }
        Write-Log "FEHLER Instagram-Post HTTP $statusCode`: $body"
        return $false
    }
}

# ============================================================

function Post-Instagram-Karussell {
    param([string]$caption, [string[]]$mediaUrls)

    $payload = @{
        post = @{
            accountId = $accountIdIG
            content   = @{ text = $caption; platform = "instagram"; mediaUrls = $mediaUrls }
            target    = @{ targetType = "instagram" }
        }
    }

    $json      = $payload | ConvertTo-Json -Depth 10 -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $headers   = @{ "blotato-api-key" = $apiKey; "Content-Type" = "application/json; charset=utf-8" }

    Write-Log "Poste Karussell auf Instagram ($($mediaUrls.Count) Slides)"

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/posts" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "Karussell OK. SubmissionId: $($response.postSubmissionId)"
        return $true
    } catch {
        Write-Log "FEHLER Karussell-Post: $_"
        return $false
    }
}

# HAUPTLOGIK
# ============================================================
$heute = (Get-Date).ToString("dd.MM.yyyy")
$jetzt = Get-Date

Write-Log "=== Business-und-Spirit Trigger gestartet | Heute: $heute | Jetzt: $($jetzt.ToString('HH:mm')) ==="

try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV konnte nicht gelesen werden: $_"; exit 1
}

$postType = $env:POST_TYPE  # "story" oder "reel" — von GitHub Actions gesetzt, leer bei lokalem Lauf

$heuteRowsAlle = $rows | Where-Object {
    $_.Datum -eq $heute -and $_.Plattform -eq "Instagram" -and
    (-not $postType -or
     ($postType -eq "story" -and $_.'Post-Typ' -eq "Story") -or
     ($postType -eq "reel"  -and $_.'Post-Typ' -ne "Story"))
}
$heuteRows = $heuteRowsAlle | Where-Object { $_.Status.Trim() -eq "Geplant" }

# Kein Telegram bei "schon gepostet" (Backup-Lauf nach erfolgreichem Hauptlauf) oder "nichts geplant" -- beides ist in Ordnung, Stille gewuenscht (07.06.2026)
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

    if ($typ -eq "Karussell") {
        $slidesRaw = $row.'Karussell-Slides'.Trim()
        if (-not $slidesRaw) { Write-Log "FEHLER: Keine Karussell-Slides. Post uebersprungen."; continue }
        $slideUrls = $slidesRaw -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
        $caption   = $row.Text
        $erfolg    = Post-Instagram-Karussell -caption $caption -mediaUrls $slideUrls
        if ($erfolg) {
            $rows | ForEach-Object {
                if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and $_.Plattform -eq "Instagram" -and $_.Status.Trim() -eq "Geplant" -and $_.'Post-Typ' -eq "Karussell") {
                    $_.Status = "Gepostet"
                }
            }
            $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
            Send-Telegram "✅ @business.und.spirit — Karussell gepostet ($heute $uhrzeit)"
        } else {
            Send-Telegram "❌ @business.und.spirit — Karussell fehlgeschlagen ($heute $uhrzeit)"
        }
        continue
    }

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

    if (-not $imageSource -or $imageSource -eq "") { $imageSource = $row.'Bild-URL'.Trim() }
    if (-not $imageSource -or $imageSource -eq "") { Write-Log "FEHLER: Kein Videoprompt/Bild-URL. Post uebersprungen."; continue }

    $voiceoverBase = $caption -replace '[💡📲🎧🎁💻🧠🔥✅❌→←↑↓👆👇👉👈⚡✨🎯💰📈🏆🎤🎵🎶🎼🎙️]', ''
    $voiceoverBase = $voiceoverBase -replace 'Link in Bio.*', ''
    $voiceoverBase = ($voiceoverBase -split "`n" | Where-Object { $_ -notmatch '(?i)(schreib|kommentiere)\s+\w+' }) -join "`n"  # Ganze CTA-Zeilen raus (nicht nur ab Keyword)
    $voiceoverBase = $voiceoverBase -replace '#\S+', ''
    $voiceoverBase = $voiceoverBase.Trim()

    # @business.und.spirit: CHECK -> Standortcheck; Selbstcheck -> Bio-Link
    $keyword = "CHECK"
    if ($link -match "selbstcheck") {
        $ctaScript = "Den Sofortcheck findest du unter meinem Bio-Link. Vier Fragen, zwei Minuten, kostenlos."
    } else {
        $ctaScript = "Schreib CHECK in die Kommentare, dann schick ich dir den kostenlosen Standortcheck direkt zu."
    }
    $voiceover = $voiceoverBase

    # FOTO-MODUS: Wenn Bild-URL direkt vorhanden, Creatomate fuer Overlay + Musik
    $directImageUrl = $row.'Bild-URL'.Trim()
    if ($directImageUrl -and $directImageUrl -match "^https://") {
        $overlayText = $row.'Text-Overlay'.Trim()
        if ($overlayText -or $typ -eq "Story") {
            $modus = if ($typ -eq "Story") { "Story (Musik" + $(if ($overlayText) { " + Text" } else { ", kein Text" }) + ")" } else { "Reel + Overlay + Musik" }
            Write-Log "FFmpeg-Modus: $modus"
            $renderedUrl = Render-Local -videoUrl $directImageUrl -overlayText $overlayText -isStory ($typ -eq "Story")
            if ($renderedUrl) {
                Write-Log "FFmpeg OK: $renderedUrl"
                $videoUrl = $renderedUrl
            } else {
                Write-Log "FFmpeg fehlgeschlagen — nutze Original-Video"
                $videoUrl = $directImageUrl
            }
        } else {
            Write-Log "Foto-Modus: Direktes Video posten (kein Overlay)"
            $videoUrl = $directImageUrl
        }
    } else {
        $videoName     = "Business-und-Spirit $typ $heute"
        $videoResponse = Create-AIVideo -imagePrompt $imageSource -voiceScript $voiceover -ctaScript $ctaScript -typ $typ -videoName $videoName
        if (-not $videoResponse) { Write-Log "AI-Video fehlgeschlagen. Post uebersprungen."; continue }
        $videoUrl = Wait-ForVideoUrl -response $videoResponse
        if (-not $videoUrl) { Write-Log "Keine Video-URL. Post uebersprungen."; continue }
    }

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
        Send-Telegram "✅ @business.und.spirit — $typ gepostet ($heute $uhrzeit)"
    } else {
        Send-Telegram "❌ @business.und.spirit — $typ fehlgeschlagen ($heute $uhrzeit)"
    }
}

Write-Log "=== Fertig ==="
