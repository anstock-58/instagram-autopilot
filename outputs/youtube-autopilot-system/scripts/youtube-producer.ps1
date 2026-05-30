# YouTube Producer - Vollautomatische Videoproduktion
# Liest contentplan.csv, generiert Audio via ElevenLabs, Bilder via fal.ai,
# baut Video via FFmpeg und laedt es automatisch als "Nicht gelistet" auf YouTube hoch.
# Version 1.2

$ErrorActionPreference = "Stop"

# ============================================================
# ZUGANGSDATEN — Diese Werte beim Setup eintragen
# Anleitung: reference/setup-anleitung.md
# ============================================================

$ElevenLabsApiKey   = "DEIN_ELEVENLABS_API_KEY_HIER"
$FalApiKey          = "DEIN_FAL_AI_API_KEY_HIER"
$GoogleClientId     = "DEINE_GOOGLE_CLIENT_ID_HIER"
$GoogleClientSecret = "DEIN_GOOGLE_CLIENT_SECRET_HIER"
$GoogleRefreshToken = "DEIN_GOOGLE_REFRESH_TOKEN_HIER"
$FFmpegPath         = "PFAD_ZU_FFMPEG_HIER"    # Beispiel: "C:\ffmpeg\bin\ffmpeg.exe"

# ============================================================
# PFADE — Werden automatisch gesetzt, nicht manuell aendern
# ============================================================

$SkriptOrdner = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceOrdner = Split-Path -Parent $SkriptOrdner
$CsvPfad = Join-Path $WorkspaceOrdner "outputs\contentplan.csv"
$LogPfad = Join-Path $WorkspaceOrdner "outputs\producer-log.txt"

# ============================================================
# STANDARD-MUSIK — Optional: URL zu royalty-free Hintergrundmusik
# Pixabay.com bietet kostenlose, lizenzfreie Tracks
# Leer lassen = kein Hintergrundmusik
# ============================================================

$StandardMusikUrl = ""  # Beispiel: "https://cdn.pixabay.com/audio/2024/01/01/audio_xxx.mp3"

# ============================================================
# AB HIER NICHTS MEHR AENDERN
# ============================================================

function Log($Meldung) {
    $Zeitstempel = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Zeile = "$Zeitstempel | $Meldung"
    Write-Host $Zeile
    Add-Content -Path $LogPfad -Value $Zeile -Encoding UTF8
}

# --- Schritt 0: Zugangsdaten pruefen ---
if ($ElevenLabsApiKey -eq "DEIN_ELEVENLABS_API_KEY_HIER") {
    Write-Host "FEHLER: ElevenLabs API Key nicht eingetragen. Bitte scripts/youtube-producer.ps1 oeffnen und den Key eintragen." -ForegroundColor Red
    exit 1
}
if ($FalApiKey -eq "DEIN_FAL_AI_API_KEY_HIER") {
    Write-Host "FEHLER: fal.ai API Key nicht eingetragen." -ForegroundColor Red
    exit 1
}
if ($FFmpegPath -eq "PFAD_ZU_FFMPEG_HIER") {
    Write-Host "FEHLER: FFmpeg Pfad nicht eingetragen." -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $FFmpegPath)) {
    Write-Host "FEHLER: FFmpeg nicht gefunden unter: $FFmpegPath" -ForegroundColor Red
    exit 1
}

$FFprobePfad = Join-Path (Split-Path $FFmpegPath) "ffprobe.exe"

# --- Schritt 1: CSV lesen ---
Log "=== YouTube Producer gestartet ==="

if (-not (Test-Path $CsvPfad)) {
    Log "FEHLER: contentplan.csv nicht gefunden unter: $CsvPfad"
    Log "Bitte zuerst /content-plan ausfuehren um den Contentplan zu erstellen."
    exit 1
}

$Videos = Import-Csv -Path $CsvPfad -Encoding UTF8
$OffeneVideos = $Videos | Where-Object { $_.Status -eq "Offen" }

if ($OffeneVideos.Count -eq 0) {
    Log "Kein offenes Video gefunden. Alle Videos sind bereits produziert oder kein Eintrag mit Status 'Offen'."
    Log "Tipp: /skript-erstellen ausfuehren um ein neues Video vorzubereiten."
    exit
}

Log "Gefunden: $($OffeneVideos.Count) offene(s) Video(s)."

foreach ($Video in $OffeneVideos) {

    Log "Starte Produktion: $($Video.Titel)"

    # Status sofort auf InProduktion setzen
    $AlleVideos = Import-Csv -Path $CsvPfad -Encoding UTF8
    foreach ($Eintrag in $AlleVideos) {
        if ($Eintrag.Datum -eq $Video.Datum -and $Eintrag.Titel -eq $Video.Titel) {
            $Eintrag.Status = "InProduktion"
        }
    }
    $AlleVideos | Export-Csv -Path $CsvPfad -Encoding UTF8 -NoTypeInformation

    $Ausgabeordner = $Video.Ausgabeordner
    if ($Ausgabeordner -eq "" -or $Ausgabeordner -eq $null) {
        Log "FEHLER: Kein Ausgabeordner in CSV eingetragen. /skript-erstellen erneut ausfuehren."
        continue
    }

    if (-not (Test-Path $Ausgabeordner)) {
        New-Item -ItemType Directory -Path $Ausgabeordner -Force | Out-Null
        Log "Ordner erstellt: $Ausgabeordner"
    }

    # --- Schritt 2: Audio generieren (ElevenLabs) ---
    Log "Generiere Audio via ElevenLabs..."

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
    Invoke-RestMethod `
        -Uri "https://api.elevenlabs.io/v1/text-to-speech/$($Video.Stimme_ID)" `
        -Method POST `
        -Headers @{ "xi-api-key" = $ElevenLabsApiKey; "Content-Type" = "application/json; charset=utf-8" } `
        -Body $TtsBodyBytes `
        -OutFile $AudioPfad

    Log "Audio gespeichert: $AudioPfad"

    # --- Kapitelmarken berechnen ---
    $Beschreibung = $Video.Beschreibung
    if ($Video.Kapitel -ne "" -and $Video.Kapitel -ne $null) {
        $FfprobeRaw = & $FFprobePfad -v quiet -show_entries format=duration -of csv=p=0 $AudioPfad
        $GesamtSekunden = [double]$FfprobeRaw.Trim()

        $KapitelNamen = $Video.Kapitel -split " \| "
        $AnzahlKapitel = $KapitelNamen.Count
        $KapitelZeilen = @("00:00 $($KapitelNamen[0].Trim())")

        for ($i = 1; $i -lt $AnzahlKapitel; $i++) {
            $Sek = [int]($GesamtSekunden * $i / $AnzahlKapitel)
            $Min = [int]($Sek / 60)
            $Rest = $Sek % 60
            $Timestamp = "{0:D2}:{1:D2}" -f $Min, $Rest
            $KapitelZeilen += "$Timestamp $($KapitelNamen[$i].Trim())"
        }

        $KapitelBlock = $KapitelZeilen -join "`n"
        $Beschreibung = $Video.Beschreibung + "`n`n" + $KapitelBlock
        Log "Kapitelmarken erstellt: $AnzahlKapitel Kapitel"
    }

    # --- Schritt 3: Bilder generieren (fal.ai FLUX Schnell) ---
    Log "Generiere Szenenbilder via fal.ai..."

    $BildPrompts = @(
        $Video.Bildprompt_1, $Video.Bildprompt_2, $Video.Bildprompt_3,
        $Video.Bildprompt_4, $Video.Bildprompt_5, $Video.Bildprompt_6,
        $Video.Bildprompt_7, $Video.Bildprompt_8, $Video.Bildprompt_9,
        $Video.Bildprompt_10
    ) | Where-Object { $_ -ne "" -and $_ -ne $null }

    $BildPfade = @()
    $BildNummer = 1

    foreach ($Prompt in $BildPrompts) {
        Log "Bild $BildNummer generieren..."

        $FalBody = @{
            prompt                = $Prompt
            image_size            = "landscape_16_9"
            num_images            = 1
            enable_safety_checker = $false
        } | ConvertTo-Json

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
            Invoke-WebRequest -Uri $BildUrl -OutFile $BildDateiname -UseBasicParsing
            $BildPfade += $BildDateiname
            Log "Bild $BildNummer gespeichert."
        } else {
            Log "WARNUNG: Bild $BildNummer konnte nicht generiert werden (Timeout)."
        }

        $BildNummer++
    }

    if ($BildPfade.Count -eq 0) {
        Log "FEHLER: Keine Bilder generiert. Produktion abgebrochen."
        continue
    }

    # --- Schritt 3b: Thumbnail generieren (Ideogram V3 mit eingebettetem Text) ---
    Log "Generiere Thumbnail via fal.ai (Ideogram V3)..."
    $ThumbnailPfad = ""

    if ($Video.Thumbnail_Text -ne "" -and $Video.Thumbnail_Prompt -ne "") {

        $TextZeilen = $Video.Thumbnail_Text -split " / "
        $TextZeile1 = if ($TextZeilen.Count -ge 1) { $TextZeilen[0].Trim() } else { "" }
        $TextZeile2 = if ($TextZeilen.Count -ge 2) { $TextZeilen[1].Trim() } else { "" }

        $IdeogramPrompt = $Video.Thumbnail_Prompt
        if ($TextZeile1 -ne "") { $IdeogramPrompt += ". Large bold white text at top reads: $TextZeile1" }
        if ($TextZeile2 -ne "") { $IdeogramPrompt += ". Large bold yellow text at bottom reads: $TextZeile2" }
        $IdeogramPrompt += ". YouTube thumbnail style, no watermark, cinematic"

        $ThumbBody = @{
            prompt          = $IdeogramPrompt
            aspect_ratio    = "16:9"
            rendering_speed = "QUALITY"
            style_type      = "REALISTIC"
        } | ConvertTo-Json

        $ThumbStart = Invoke-RestMethod `
            -Uri "https://queue.fal.run/fal-ai/ideogram/v3" `
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
            $ThumbnailRaw  = Join-Path $Ausgabeordner "thumbnail_raw.png"
            $ThumbnailPfad = Join-Path $Ausgabeordner "thumbnail.png"
            Invoke-WebRequest -Uri $ThumbUrl -OutFile $ThumbnailRaw -UseBasicParsing
            & $FFmpegPath -y -i $ThumbnailRaw -vf "scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720" $ThumbnailPfad
            Remove-Item $ThumbnailRaw -Force
            Log "Thumbnail gespeichert und auf 1280x720 skaliert: $ThumbnailPfad"
        } else {
            Log "WARNUNG: Thumbnail konnte nicht generiert werden."
        }

    } elseif ($Video.Thumbnail_Prompt -ne "") {

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
            $ThumbnailPfad = Join-Path $Ausgabeordner "thumbnail.jpg"
            Invoke-WebRequest -Uri $ThumbUrl -OutFile $ThumbnailPfad -UseBasicParsing
            Log "Thumbnail (FLUX) gespeichert: $ThumbnailPfad"
        } else {
            Log "WARNUNG: Thumbnail konnte nicht generiert werden."
        }
    }

    # --- Schritt 4: Audiodauer ermitteln ---
    Log "Ermittle Audiodauer..."
    $FfprobeOutput = & $FFprobePfad -v quiet -print_format json -show_format $AudioPfad | ConvertFrom-Json
    $GesamtDauer   = [double]$FfprobeOutput.format.duration
    $DauerProBild  = [Math]::Ceiling($GesamtDauer / $BildPfade.Count)
    Log "Gesamtdauer: $([Math]::Round($GesamtDauer, 1)) Sek - $DauerProBild Sek pro Bild"

    # --- Schritt 5: Video zusammenbauen (FFmpeg) ---
    Log "Baue Video mit FFmpeg..."

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

    & $FFmpegPath -y -f concat -safe 0 -i $BildlisteP -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -r 25 $VideoOhneTon
    if ($LASTEXITCODE -ne 0) { throw "FFmpeg Slideshow fehlgeschlagen (Exit $LASTEXITCODE)" }

    $MusikUrl = if ($Video.Musik_URL -ne "" -and $Video.Musik_URL -ne $null) { $Video.Musik_URL } else { $StandardMusikUrl }

    if ($MusikUrl -ne "" -and $MusikUrl -ne $null) {
        $MusikPfad = Join-Path $Ausgabeordner "musik.mp3"
        Invoke-WebRequest -Uri $MusikUrl -OutFile $MusikPfad -UseBasicParsing
        Log "Musik geladen: $MusikUrl"

        $FilterComplex = '[1:a]loudnorm=I=-16:LRA=11:TP=-1.5[norm];[norm]volume=1.5[voiceover];[2:a]aloop=loop=-1:size=2147483647,volume=0.06[musik];[voiceover][musik]amix=inputs=2:duration=first:normalize=0[audio]'
        $MapAudio = '[audio]'
        & $FFmpegPath -y `
            -i $VideoOhneTon `
            -i $AudioPfad `
            -i $MusikPfad `
            -filter_complex $FilterComplex `
            -map 0:v -map $MapAudio `
            -c:v copy -c:a aac -shortest `
            $VideoFertig
        if ($LASTEXITCODE -ne 0) { throw "FFmpeg Audio-Mix fehlgeschlagen (Exit $LASTEXITCODE)" }
    } else {
        & $FFmpegPath -y `
            -i $VideoOhneTon `
            -i $AudioPfad `
            -c:v copy -af loudnorm -c:a aac -shortest `
            $VideoFertig
        if ($LASTEXITCODE -ne 0) { throw "FFmpeg Voiceover-Mix fehlgeschlagen (Exit $LASTEXITCODE)" }
    }

    Log "Video fertig: $VideoFertig"

    # --- Schritt 6: YouTube Upload ---
    $YouTubeUrl = ""

    if ($GoogleClientId -ne "DEINE_GOOGLE_CLIENT_ID_HIER" -and $GoogleRefreshToken -ne "DEIN_GOOGLE_REFRESH_TOKEN_HIER") {
        Log "Lade Video auf YouTube hoch..."

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

        $TagsArray = ($Video.Tags -split ",") | ForEach-Object { $_.Trim() }
        $VideoMeta = @{
            snippet = @{
                title       = $Video.Titel
                description = $Beschreibung
                tags        = $TagsArray
                categoryId  = "27"
            }
            status = @{
                privacyStatus           = "unlisted"
                selfDeclaredMadeForKids = $false
                containsSyntheticMedia  = $true
                license                 = "youtube"
                embeddable              = $true
                publicStatsViewable     = $true
            }
        } | ConvertTo-Json -Depth 5

        $VideoMeta = [regex]::Replace($VideoMeta, '\\u([0-9A-Fa-f]{4})', {
            param($m)
            [char][int]("0x" + $m.Groups[1].Value)
        })

        $VideoMetaBytes = [System.Text.Encoding]::UTF8.GetBytes($VideoMeta)
        $VideoGroesse   = (Get-Item $VideoFertig).Length

        $InitResponse = Invoke-WebRequest `
            -Uri "https://www.googleapis.com/upload/youtube/v3/videos?uploadType=resumable&part=snippet,status" `
            -Method POST `
            -UseBasicParsing `
            -Headers @{
                "Authorization"           = "Bearer $AccessToken"
                "Content-Type"            = "application/json; charset=UTF-8"
                "X-Upload-Content-Type"   = "video/mp4"
                "X-Upload-Content-Length" = $VideoGroesse.ToString()
            } `
            -Body $VideoMetaBytes
        $UploadUri = $InitResponse.Headers.Location

        $ChunkSize  = 8 * 1024 * 1024
        $FileStream = [System.IO.File]::OpenRead($VideoFertig)
        $Buffer     = New-Object byte[] $ChunkSize
        $BytesSent  = 0
        $VideoId    = $null

        try {
            while ($BytesSent -lt $VideoGroesse) {
                $BytesRead = $FileStream.Read($Buffer, 0, $ChunkSize)
                $ChunkEnd  = $BytesSent + $BytesRead - 1

                $Req = [System.Net.HttpWebRequest]::Create($UploadUri)
                $Req.Method        = "PUT"
                $Req.ContentType   = "video/mp4"
                $Req.ContentLength = $BytesRead
                $Req.Headers.Add("Authorization", "Bearer $AccessToken")
                $Req.Headers.Add("Content-Range", "bytes $BytesSent-$ChunkEnd/$VideoGroesse")

                $ReqStream = $Req.GetRequestStream()
                $ReqStream.Write($Buffer, 0, $BytesRead)
                $ReqStream.Close()

                try {
                    $Resp = $Req.GetResponse()
                    $RespReader = New-Object System.IO.StreamReader($Resp.GetResponseStream())
                    $UploadResult = $RespReader.ReadToEnd() | ConvertFrom-Json
                    $VideoId = $UploadResult.id
                } catch [System.Net.WebException] {
                    if ($_.Exception.Response -and [int]$_.Exception.Response.StatusCode -eq 308) {
                        # 308 Resume Incomplete = Chunk OK, weitermachen
                    } else { throw }
                }

                $BytesSent += $BytesRead
                $Prozent = [Math]::Round($BytesSent / $VideoGroesse * 100)
                Log "Upload: $Prozent% ($([Math]::Round($BytesSent/1MB,1)) MB / $([Math]::Round($VideoGroesse/1MB,1)) MB)"
            }
        } finally {
            $FileStream.Close()
        }

        $YouTubeUrl = "https://www.youtube.com/watch?v=$VideoId"
        Log "Video hochgeladen (nicht gelistet): $YouTubeUrl"

        if ($ThumbnailPfad -ne "" -and (Test-Path $ThumbnailPfad)) {
            Start-Sleep -Seconds 5
            $ThumbBytes  = [System.IO.File]::ReadAllBytes($ThumbnailPfad)
            $ContentType = if ($ThumbnailPfad -match "\.png$") { "image/png" } else { "image/jpeg" }
            Invoke-RestMethod `
                -Uri "https://www.googleapis.com/upload/youtube/v3/thumbnails/set?videoId=$VideoId&uploadType=media" `
                -Method Post `
                -Headers @{ "Authorization" = "Bearer $AccessToken" } `
                -ContentType $ContentType `
                -Body $ThumbBytes | Out-Null
            Log "Thumbnail hochgeladen."
        }

        Log "YouTube Studio: https://studio.youtube.com/video/$VideoId/edit"
        Log "Pruefen und auf Oeffentlich schalten wenn bereit."

    } else {
        Log "Google API nicht konfiguriert — Video liegt lokal bereit: $VideoFertig"
        Log "Bitte den Google Refresh Token in setup-anleitung.md Abschnitt 4 einrichten."
    }

    # --- Schritt 7: Status aktualisieren ---
    $AlleVideos = Import-Csv -Path $CsvPfad -Encoding UTF8
    foreach ($Eintrag in $AlleVideos) {
        if ($Eintrag.Datum -eq $Video.Datum -and $Eintrag.Titel -eq $Video.Titel) {
            $Eintrag.Status = "Produziert"
        }
    }
    $AlleVideos | Export-Csv -Path $CsvPfad -Encoding UTF8 -NoTypeInformation
    Log "Status auf 'Produziert' gesetzt."

    Log "=== Produktion abgeschlossen: $($Video.Titel) ==="
    if ($YouTubeUrl -ne "") { Log "YouTube URL: $YouTubeUrl" }
}

Log "=== YouTube Producer beendet ==="
