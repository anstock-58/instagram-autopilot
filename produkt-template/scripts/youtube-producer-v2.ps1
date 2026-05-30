# YouTube Producer v2.0 - Vollautomatische Videoproduktion
# Liest Konfiguration aus context/setup-status.md
# Generiert Audio (ElevenLabs), Bilder (fal.ai), Video (FFmpeg), laedt auf YouTube hoch
# Version 2.0 - Kunden-Edition ohne hardcodierte Pfade

$ErrorActionPreference = "Stop"

# --- Konfiguration aus Setup-Status laden ---
$SetupStatusPfad = Join-Path $PSScriptRoot "..\context\setup-status.md"
$KanalProfilPfad = Join-Path $PSScriptRoot "..\context\kanal-profil.md"
$CsvPfad         = Join-Path $PSScriptRoot "..\outputs\contentplan.csv"
$LogPfad         = Join-Path $PSScriptRoot "..\outputs\producer-log.txt"
$FFmpegPfad      = "C:\ffmpeg\bin\ffmpeg.exe"
$FfprobePfad     = "C:\ffmpeg\bin\ffprobe.exe"

# API-Keys aus Setup-Status lesen
function Lese-Wert($Inhalt, $Schluessel) {
    $Zeile = $Inhalt | Where-Object { $_ -match "^\s*$Schluessel\s*:\s*(.+)" }
    if ($Zeile) { return ($Zeile -replace "^\s*$Schluessel\s*:\s*", "").Trim() }
    return ""
}

if (-not (Test-Path $SetupStatusPfad)) {
    Write-Host "FEHLER: context/setup-status.md nicht gefunden." -ForegroundColor Red
    Write-Host "Bitte zuerst /setup in Claude Code ausfuehren." -ForegroundColor Yellow
    exit 1
}

$SetupInhalt        = Get-Content $SetupStatusPfad -Encoding UTF8
$ElevenLabsKey      = Lese-Wert $SetupInhalt "ElevenLabsKey"
$FalApiKey          = Lese-Wert $SetupInhalt "FalApiKey"
$GoogleClientId     = Lese-Wert $SetupInhalt "GoogleClientId"
$GoogleClientSecret = Lese-Wert $SetupInhalt "GoogleClientSecret"
$GoogleRefreshToken = Lese-Wert $SetupInhalt "GoogleRefreshToken"

# Pflicht-Keys pruefen
if ($ElevenLabsKey -eq "") {
    Write-Host "FEHLER: ElevenLabs API-Key fehlt." -ForegroundColor Red
    Write-Host "Bitte /setup ausfuehren und ElevenLabs-Key eintragen." -ForegroundColor Yellow
    exit 1
}
if ($FalApiKey -eq "") {
    Write-Host "FEHLER: fal.ai API-Key fehlt." -ForegroundColor Red
    Write-Host "Bitte /setup ausfuehren und fal.ai-Key eintragen." -ForegroundColor Yellow
    exit 1
}
if (-not (Test-Path $FFmpegPfad)) {
    Write-Host "FEHLER: FFmpeg nicht gefunden unter $FFmpegPfad" -ForegroundColor Red
    Write-Host "Bitte FFmpeg installieren: https://www.gyan.dev/ffmpeg/builds/" -ForegroundColor Yellow
    exit 1
}

# --- Logging ---
function Log($Meldung) {
    $Zeitstempel = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Zeile = "$Zeitstempel | $Meldung"
    Write-Host $Zeile
    Add-Content -Path $LogPfad -Value $Zeile -Encoding UTF8
}

# --- Schritt 1: CSV lesen ---
Log "=== YouTube Producer v2.0 gestartet ==="

if (-not (Test-Path $CsvPfad)) {
    Log "FEHLER: contentplan.csv nicht gefunden unter $CsvPfad"
    Log "Bitte zuerst /research in Claude Code ausfuehren."
    exit 1
}

$Videos = Import-Csv -Path $CsvPfad -Encoding UTF8
$OffeneVideos = $Videos | Where-Object { $_.Status -eq "Offen" }

if ($OffeneVideos.Count -eq 0) {
    Log "Kein offenes Video gefunden. Bitte zuerst /research ausfuehren."
    exit
}

foreach ($Video in $OffeneVideos) {

    Log "Starte Produktion: $($Video.Titel)"

    $Ausgabeordner = $Video.Ausgabeordner
    if (-not (Test-Path $Ausgabeordner)) {
        New-Item -ItemType Directory -Path $Ausgabeordner -Force | Out-Null
        Log "Ordner erstellt: $Ausgabeordner"
    }

    # --- Schritt 2: Audio generieren (ElevenLabs) ---
    Log "Schritt 1/4: Audio wird generiert (ElevenLabs)..."

    $AudioPfad = Join-Path $Ausgabeordner "voiceover.mp3"

    $TtsBody = @{
        text         = $Video.Skript
        model_id     = "eleven_multilingual_v2"
        voice_settings = @{
            stability        = 0.5
            similarity_boost = 0.75
            style            = 0.3
            use_speaker_boost = $true
        }
    } | ConvertTo-Json -Depth 5

    $TtsBodyBytes = [System.Text.Encoding]::UTF8.GetBytes($TtsBody)

    try {
        Invoke-RestMethod `
            -Uri "https://api.elevenlabs.io/v1/text-to-speech/$($Video.Stimme_ID)" `
            -Method POST `
            -Headers @{ "xi-api-key" = $ElevenLabsKey; "Content-Type" = "application/json; charset=utf-8" } `
            -Body $TtsBodyBytes `
            -OutFile $AudioPfad
        Log "Audio gespeichert: $AudioPfad"
    } catch {
        Log "FEHLER bei ElevenLabs: $($_.Exception.Message)"
        Log "Moegliche Ursachen: API-Key falsch, Zeichenlimit erreicht, Stimmen-ID falsch."
        throw
    }

    # --- Schritt 3: Bilder generieren (fal.ai) ---
    Log "Schritt 2/4: Bilder werden generiert (fal.ai KI)..."

    $BildPrompts = @(
        $Video.Bildprompt_1, $Video.Bildprompt_2, $Video.Bildprompt_3,
        $Video.Bildprompt_4, $Video.Bildprompt_5, $Video.Bildprompt_6,
        $Video.Bildprompt_7, $Video.Bildprompt_8, $Video.Bildprompt_9,
        $Video.Bildprompt_10
    ) | Where-Object { $_ -ne "" }

    $BildPfade = @()
    $BildNummer = 1

    foreach ($Prompt in $BildPrompts) {
        Log "Bild $BildNummer von $($BildPrompts.Count) generieren..."

        $FalBody = @{
            prompt                = $Prompt
            image_size            = "landscape_16_9"
            num_images            = 1
            enable_safety_checker = $false
        } | ConvertTo-Json

        try {
            $FalStart = Invoke-RestMethod `
                -Uri "https://queue.fal.run/fal-ai/flux/schnell" `
                -Method POST `
                -Headers @{ "Authorization" = "Key $FalApiKey"; "Content-Type" = "application/json" } `
                -Body $FalBody

            $StatusUrl = $FalStart.status_url
            $ResultUrl = $FalStart.response_url

            $MaxVersuche = 30
            $Versuch = 0
            $BildUrl = $null

            do {
                Start-Sleep -Seconds 3
                $Status = Invoke-RestMethod `
                    -Uri $StatusUrl `
                    -Method GET `
                    -Headers @{ "Authorization" = "Key $FalApiKey" }
                $Versuch++
                if ($Status.status -eq "COMPLETED") {
                    $Result = Invoke-RestMethod `
                        -Uri $ResultUrl `
                        -Method GET `
                        -Headers @{ "Authorization" = "Key $FalApiKey" }
                    $BildUrl = $Result.images[0].url
                    break
                }
            } while ($Versuch -lt $MaxVersuche)

            if ($BildUrl) {
                $BildDateiname = Join-Path $Ausgabeordner ("bild-" + $BildNummer.ToString("D2") + ".jpg")
                Invoke-WebRequest -Uri $BildUrl -OutFile $BildDateiname
                $BildPfade += $BildDateiname
                Log "Bild $BildNummer gespeichert."
            } else {
                Log "WARNUNG: Bild $BildNummer konnte nicht generiert werden (Timeout)."
            }
        } catch {
            Log "FEHLER bei Bild $BildNummer: $($_.Exception.Message)"
            Log "Moegliche Ursachen: fal.ai API-Key falsch oder Guthaben aufgebraucht."
            throw
        }

        $BildNummer++
    }

    # --- Schritt 3b: Thumbnail generieren ---
    $ThumbnailPfad = Join-Path $Ausgabeordner "thumbnail.jpg"

    if ($Video.Thumbnail_Prompt -ne "") {
        Log "Thumbnail wird generiert..."

        $ThumbBody = @{
            prompt                = $Video.Thumbnail_Prompt
            image_size            = "landscape_16_9"
            num_images            = 1
            enable_safety_checker = $false
        } | ConvertTo-Json

        $ThumbStart = Invoke-RestMethod `
            -Uri "https://queue.fal.run/fal-ai/flux/schnell" `
            -Method POST `
            -Headers @{ "Authorization" = "Key $FalApiKey"; "Content-Type" = "application/json" } `
            -Body $ThumbBody

        $ThumbStatusUrl = $ThumbStart.status_url
        $ThumbResultUrl = $ThumbStart.response_url
        $ThumbVersuch = 0
        $ThumbUrl = $null

        do {
            Start-Sleep -Seconds 3
            $ThumbStatus = Invoke-RestMethod -Uri $ThumbStatusUrl -Method GET -Headers @{ "Authorization" = "Key $FalApiKey" }
            $ThumbVersuch++
            if ($ThumbStatus.status -eq "COMPLETED") {
                $ThumbResult = Invoke-RestMethod -Uri $ThumbResultUrl -Method GET -Headers @{ "Authorization" = "Key $FalApiKey" }
                $ThumbUrl = $ThumbResult.images[0].url
                break
            }
        } while ($ThumbVersuch -lt 30)

        if ($ThumbUrl) {
            Invoke-WebRequest -Uri $ThumbUrl -OutFile $ThumbnailPfad
            Log "Thumbnail gespeichert."
        } else {
            Log "WARNUNG: Thumbnail konnte nicht generiert werden."
        }
    }

    if ($BildPfade.Count -eq 0) {
        Log "FEHLER: Keine Bilder generiert. Produktion abgebrochen."
        exit 1
    }

    # --- Schritt 4: Audiodauer ermitteln ---
    Log "Audiodauer wird ermittelt..."

    try {
        $FfprobeOutput = & $FfprobePfad -v quiet -print_format json -show_format $AudioPfad | ConvertFrom-Json
        $GesamtDauer   = [double]$FfprobeOutput.format.duration
        $DauerProBild  = [Math]::Ceiling($GesamtDauer / $BildPfade.Count)
        Log "Audiodauer: $([Math]::Round($GesamtDauer, 1)) Sek. — $DauerProBild Sek. pro Bild"
    } catch {
        Log "FEHLER beim Ermitteln der Audiodauer: $($_.Exception.Message)"
        Log "Pruefen ob FFmpeg korrekt unter $FFmpegPfad installiert ist."
        throw
    }

    # --- Schritt 5: Video zusammenbauen (FFmpeg) ---
    Log "Schritt 3/4: Video wird zusammengebaut (FFmpeg)..."

    $BildlisteP      = Join-Path $Ausgabeordner "bildliste.txt"
    $BildlisteInhalt = ""
    foreach ($Pfad in $BildPfade) {
        $BildlisteInhalt += "file '$Pfad'`nduration $DauerProBild`n"
    }
    $BildlisteInhalt += "file '$($BildPfade[-1])'"

    $EncOhneBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($BildlisteP, $BildlisteInhalt, $EncOhneBom)

    $VideoOhneTon = Join-Path $Ausgabeordner "video_ohne_ton.mp4"
    $VideoFertig  = Join-Path $Ausgabeordner "video_fertig.mp4"

    & $FFmpegPfad -y -f concat -safe 0 -i $BildlisteP `
        -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" `
        -c:v libx264 -r 25 $VideoOhneTon
    if ($LASTEXITCODE -ne 0) { throw "FFmpeg Slideshow fehlgeschlagen (Exit $LASTEXITCODE)" }

    if ($Video.Musik_URL -ne "") {
        $MusikPfad = Join-Path $Ausgabeordner "musik.mp3"
        Invoke-WebRequest -Uri $Video.Musik_URL -OutFile $MusikPfad

        $FilterComplex = '[1:a]loudnorm[norm];[norm]volume=1.0[voiceover];[2:a]volume=0.08[musik];[voiceover][musik]amix=inputs=2:duration=first[audio]'
        $MapAudio = '[audio]'
        & $FFmpegPfad -y `
            -i $VideoOhneTon -i $AudioPfad -i $MusikPfad `
            -filter_complex $FilterComplex `
            -map 0:v -map $MapAudio `
            -c:v copy -c:a aac -shortest `
            $VideoFertig
    } else {
        & $FFmpegPfad -y `
            -i $VideoOhneTon -i $AudioPfad `
            -c:v copy -af loudnorm -c:a aac -shortest `
            $VideoFertig
    }
    if ($LASTEXITCODE -ne 0) { throw "FFmpeg Audio-Mix fehlgeschlagen (Exit $LASTEXITCODE)" }

    Log "Video fertig: $VideoFertig"

    # --- Schritt 6: YouTube Upload ---
    $YouTubeUrl = ""
    if ($GoogleClientId -ne "" -and $GoogleRefreshToken -ne "") {
        Log "Schritt 4/4: Upload auf YouTube..."

        try {
            $TokenResponse = Invoke-RestMethod `
                -Uri "https://oauth2.googleapis.com/token" `
                -Method POST `
                -Body @{
                    client_id     = $GoogleClientId
                    client_secret = $GoogleClientSecret
                    refresh_token = $GoogleRefreshToken
                    grant_type    = "refresh_token"
                }
            $AccessToken = $TokenResponse.access_token
        } catch {
            Log "FEHLER: YouTube-Autorisierung fehlgeschlagen."
            Log "Bitte /setup neu ausfuehren (Phase 3c — OAuth)."
            throw
        }

        $TagsArray = ($Video.Tags -split ",") | ForEach-Object { $_.Trim() }
        $VideoMeta = @{
            snippet = @{
                title       = $Video.Titel
                description = $Video.Beschreibung
                tags        = $TagsArray
                categoryId  = "27"
            }
            status = @{
                privacyStatus           = "unlisted"
                selfDeclaredMadeForKids = $false
            }
        } | ConvertTo-Json -Depth 5

        $VideoMetaBytes = [System.Text.Encoding]::UTF8.GetBytes($VideoMeta)
        $VideoGroesse   = (Get-Item $VideoFertig).Length

        $InitResponse = Invoke-WebRequest `
            -Uri "https://www.googleapis.com/upload/youtube/v3/videos?uploadType=resumable&part=snippet,status" `
            -Method POST `
            -Headers @{
                "Authorization"           = "Bearer $AccessToken"
                "Content-Type"            = "application/json; charset=UTF-8"
                "X-Upload-Content-Type"   = "video/mp4"
                "X-Upload-Content-Length" = $VideoGroesse.ToString()
            } `
            -Body $VideoMetaBytes
        $UploadUri = $InitResponse.Headers.Location

        $WebClient = New-Object System.Net.WebClient
        $WebClient.Headers.Add("Content-Type", "video/mp4")
        $WebClient.Headers.Add("Authorization", "Bearer $AccessToken")
        $UploadBytes  = $WebClient.UploadFile($UploadUri, "PUT", $VideoFertig)
        $UploadResult = [System.Text.Encoding]::UTF8.GetString($UploadBytes) | ConvertFrom-Json
        $VideoId      = $UploadResult.id
        $YouTubeUrl   = "https://www.youtube.com/watch?v=$VideoId"
        Log "Video hochgeladen (nicht gelistet): $YouTubeUrl"

        if (Test-Path $ThumbnailPfad) {
            $ThumbWebClient = New-Object System.Net.WebClient
            $ThumbWebClient.Headers.Add("Content-Type", "image/jpeg")
            $ThumbWebClient.Headers.Add("Authorization", "Bearer $AccessToken")
            $ThumbWebClient.UploadFile(
                "https://www.googleapis.com/upload/youtube/v3/thumbnails/set?videoId=$VideoId&uploadType=media",
                "POST",
                $ThumbnailPfad
            ) | Out-Null
            Log "Thumbnail hochgeladen."
        }

        Log "YouTube Studio: https://studio.youtube.com/video/$VideoId/edit"
        Log "Bitte Thumbnail in Canva bearbeiten, dann auf Oeffentlich schalten."

    } else {
        Log "YouTube-Upload nicht konfiguriert. Video liegt lokal: $VideoFertig"
        Log "Bitte /setup ausfuehren um YouTube-Upload einzurichten."
    }

    # --- Schritt 7: Status aktualisieren ---
    $AlleVideos = Import-Csv -Path $CsvPfad -Encoding UTF8
    foreach ($Eintrag in $AlleVideos) {
        if ($Eintrag.Datum -eq $Video.Datum -and $Eintrag.Kanal -eq $Video.Kanal) {
            $Eintrag.Status = "Produziert"
        }
    }
    $AlleVideos | Export-Csv -Path $CsvPfad -Encoding UTF8 -NoTypeInformation
    Log "Status auf 'Produziert' gesetzt."

    Log "=== Produktion abgeschlossen: $($Video.Titel) ==="
    if ($YouTubeUrl -ne "") {
        Write-Host ""
        Write-Host "=== VIDEO IST FERTIG ===" -ForegroundColor Green
        Write-Host "YouTube URL: $YouTubeUrl" -ForegroundColor Green
        Write-Host "Naechster Schritt: Thumbnail in Canva bearbeiten, dann auf Oeffentlich schalten." -ForegroundColor Yellow
        Write-Host "========================" -ForegroundColor Green
    }
}
