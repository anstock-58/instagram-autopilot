# generate-matthias-v2.ps1
# Generiert 9 konsistente Matthias-Bilder via Flux PuLID + animiert mit Kling
# Voraussetzung: fal.ai Credits aufgeladen (mind. 150 Credits)
# Starten ab 12.08.2026

$FAL_KEY     = "7600112e-4d6f-4202-b107-b899fe36595c:4faa681903cdd51d757c18b7d0cc6c11"
$MASTER_IMG  = "C:\Users\andre\claude-workspace-vorlage\outputs\business-und-spirit\Bilder\avatar-01-fenster.jpg"
$OUT_DIR     = "C:\Users\andre\claude-workspace-vorlage\outputs\business-und-spirit\Bilder\v2"
$VIDEO_DIR   = "C:\Users\andre\claude-workspace-vorlage\outputs\business-und-spirit\Videos\v2"
$PULID_MODEL = "fal-ai/flux-pulid"
$KLING_MODEL = "fal-ai/kling-video/v1.6/standard/image-to-video"

$HEADERS = @{
    "Authorization" = "Key $FAL_KEY"
    "Content-Type"  = "application/json"
}

# 9 Szenen mit Matthias — konsistentes Outfit (grauer Blazer, dunkles Shirt)
$SZENEN = @(
    @{
        Nr          = 1
        Name        = "matthias-v2-01-buerofenster"
        Prompt      = "Distinguished European man in his late 50s, silver slicked-back hair, short grey beard, grey wool blazer over dark grey t-shirt, standing alone at large office window at dusk, city lights outside, one hand resting on window frame, pensive gaze outward, cinematic side lighting, 9:16 vertical, photorealistic editorial"
        KlingPrompt = "subtle breathing, slow blink, faint city lights flicker through window, atmospheric stillness"
    }
    @{
        Nr          = 2
        Name        = "matthias-v2-02-konferenztisch"
        Prompt      = "Distinguished European man in his late 50s, silver slicked-back hair, short grey beard, grey wool blazer over dark grey t-shirt, sitting alone at end of long conference table after a meeting, papers in front, hands folded, quiet reflective expression, warm office light, 9:16 vertical, photorealistic editorial"
        KlingPrompt = "subtle breathing, slow blink, fingers gently tap table once, still and composed"
    }
    @{
        Nr          = 3
        Name        = "matthias-v2-03-auto"
        Prompt      = "Distinguished European man in his late 50s, silver slicked-back hair, short grey beard, grey wool blazer over dark grey t-shirt, sitting in driver seat of car at night, streetlights reflecting on windshield, hands on steering wheel, distant thoughtful gaze, cinematic night atmosphere, 9:16 vertical, photorealistic editorial"
        KlingPrompt = "city lights slowly passing in windshield reflection, subtle head movement with road motion"
    }
    @{
        Nr          = 4
        Name        = "matthias-v2-04-haustuer"
        Prompt      = "Distinguished European man in his late 50s, silver slicked-back hair, short grey beard, grey wool blazer over dark grey t-shirt, standing at front door of home at evening, keys in hand, pausing before entering, a brief moment of stillness, warm light from inside, 9:16 vertical, photorealistic editorial"
        KlingPrompt = "subtle breathing, slow blink, gaze moves down then back up, keys rest still in hand"
    }
    @{
        Nr          = 5
        Name        = "matthias-v2-05-kuechentisch"
        Prompt      = "Distinguished European man in his late 50s, silver slicked-back hair, short grey beard, grey wool blazer over dark grey t-shirt, sitting alone at kitchen table late at night, cup of tea in front of him, elbows on table, head slightly bowed in thought, dim warm light, 9:16 vertical, photorealistic editorial"
        KlingPrompt = "subtle breathing, forehead slightly shifts in hand, very still, late night atmosphere"
    }
    @{
        Nr          = 6
        Name        = "matthias-v2-06-strasse"
        Prompt      = "Distinguished European man in his late 50s, silver slicked-back hair, short grey beard, grey wool blazer over dark grey t-shirt, walking alone on empty city street at evening, hands in pockets, unfocused gaze forward, urban background, quiet solitary mood, 9:16 vertical, photorealistic editorial"
        KlingPrompt = "slow walk cycle, coat moves gently, evening light, unfocused gaze forward"
    }
    @{
        Nr          = 7
        Name        = "matthias-v2-07-balkon"
        Prompt      = "Distinguished European man in his late 50s, silver slicked-back hair, short grey beard, grey wool blazer over dark grey t-shirt, standing on apartment balcony at night, arms resting on railing, looking over city rooftops, quiet contemplative expression, distant city lights, 9:16 vertical, photorealistic editorial"
        KlingPrompt = "subtle breathing, slow blink, faint wind moves hair slightly, distant rooftops still"
    }
    @{
        Nr          = 8
        Name        = "matthias-v2-08-sessel"
        Prompt      = "Distinguished European man in his late 50s, silver slicked-back hair, short grey beard, grey wool blazer over dark grey t-shirt, sitting in armchair in dimly lit living room at night, not reading, just sitting quietly, hands in lap, direct honest gaze toward camera, warm lamp light, 9:16 vertical, photorealistic editorial"
        KlingPrompt = "subtle breathing, slow direct gaze at camera, slight facial muscle movement, quiet presence"
    }
    @{
        Nr          = 9
        Name        = "matthias-v2-09-park"
        Prompt      = "Distinguished European man in his late 50s, silver slicked-back hair, short grey beard, grey wool blazer over dark grey t-shirt, sitting alone on a park bench in autumn light, looking into the distance, hands resting on knees, quiet and still, golden afternoon light through trees, 9:16 vertical, photorealistic editorial"
        KlingPrompt = "subtle breathing, slow blink, leaves gently move in background, stillness and depth"
    }
)

# ---- Hilfsfunktionen ----

function Upload-ToFal($filePath) {
    $fileName    = Split-Path $filePath -Leaf
    $contentType = if ($filePath -match "\.mp4$") { "video/mp4" } else { "image/jpeg" }
    $fileBytes   = [System.IO.File]::ReadAllBytes($filePath)

    $initBody = @{ file_name = $fileName; content_type = $contentType } | ConvertTo-Json
    $init = Invoke-RestMethod `
        -Uri "https://rest.alpha.fal.ai/storage/upload/initiate" `
        -Method POST -Headers $HEADERS `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($initBody)) `
        -ContentType "application/json; charset=utf-8" -ErrorAction Stop

    try {
        Invoke-RestMethod -Uri $init.upload_url -Method PUT -Body $fileBytes `
            -ContentType $contentType -ErrorAction Stop | Out-Null
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -notin @(200, 204)) { throw }
    }

    return $init.file_url
}

function Generate-PuLID($referenceUrl, $prompt) {
    $body = @{
        reference_image_url = $referenceUrl
        prompt              = $prompt
        image_size          = @{ width = 576; height = 1024 }
        num_inference_steps = 20
        guidance_scale      = 3.5
    } | ConvertTo-Json -Depth 5

    $r = Invoke-RestMethod `
        -Uri "https://fal.run/$PULID_MODEL" `
        -Method POST -Headers $HEADERS `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
        -ContentType "application/json; charset=utf-8" -ErrorAction Stop

    if ($r.images -and $r.images.Count -gt 0) { return $r.images[0].url }
    return $null
}

function Generate-KlingVideo($imageUrl, $prompt) {
    $body = @{
        image_url    = $imageUrl
        prompt       = $prompt
        duration     = "5"
        aspect_ratio = "9:16"
    } | ConvertTo-Json

    $r = Invoke-RestMethod `
        -Uri "https://fal.run/$KLING_MODEL" `
        -Method POST -Headers $HEADERS `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
        -ContentType "application/json; charset=utf-8" -ErrorAction Stop

    if ($r.video) { return $r.video.url }
    if ($r.videos -and $r.videos.Count -gt 0) { return $r.videos[0].url }
    return $null
}

# ---- Hauptprogramm ----

Write-Host ""
Write-Host "Matthias V2 — Konsistenter Avatar via Flux PuLID + Kling" -ForegroundColor Yellow
Write-Host "Mastergesicht: $MASTER_IMG" -ForegroundColor Gray
Write-Host ""

if (-not (Test-Path $OUT_DIR))   { New-Item -ItemType Directory -Path $OUT_DIR   | Out-Null }
if (-not (Test-Path $VIDEO_DIR)) { New-Item -ItemType Directory -Path $VIDEO_DIR | Out-Null }

# Schritt 1: Masterbild hochladen
Write-Host "Schritt 1: Masterbild auf fal.ai hochladen..." -ForegroundColor Cyan
$masterUrl = Upload-ToFal -filePath $MASTER_IMG
Write-Host "  OK: $masterUrl" -ForegroundColor Green
Write-Host ""

$ergebnisse = @()

foreach ($s in $SZENEN) {
    Write-Host "[$($s.Nr)/9] $($s.Name)" -ForegroundColor Cyan

    $imgPath   = Join-Path $OUT_DIR "$($s.Name).jpg"
    $videoPath = Join-Path $VIDEO_DIR "$($s.Name).mp4"

    # Schritt 2: PuLID Bild generieren
    $imgUrl = $null
    if (Test-Path $imgPath) {
        Write-Host "  Bild bereits vorhanden — lade hoch..." -ForegroundColor DarkGreen
        $imgUrl = Upload-ToFal -filePath $imgPath
    } else {
        Write-Host "  PuLID generiert Bild..." -ForegroundColor Gray
        try {
            $imgUrl = Generate-PuLID -referenceUrl $masterUrl -prompt $s.Prompt
            if ($imgUrl) {
                Invoke-WebRequest -Uri $imgUrl -OutFile $imgPath
                Write-Host "  Bild OK: $imgPath" -ForegroundColor Green
            } else {
                Write-Host "  FEHLER: Kein Bild generiert" -ForegroundColor Red
                $ergebnisse += [PSCustomObject]@{ Szene = $s.Nr; Status = "FEHLER Bild" }
                continue
            }
        } catch {
            Write-Host "  FEHLER PuLID: $_" -ForegroundColor Red
            $ergebnisse += [PSCustomObject]@{ Szene = $s.Nr; Status = "FEHLER PuLID: $_" }
            continue
        }
    }

    # Schritt 3: Kling Video generieren
    if (Test-Path $videoPath) {
        Write-Host "  Video bereits vorhanden — uebersprungen" -ForegroundColor DarkGreen
        $videoUrl = Upload-ToFal -filePath $videoPath
    } else {
        Write-Host "  Kling animiert..." -ForegroundColor Gray
        try {
            $videoUrl = Generate-KlingVideo -imageUrl $imgUrl -prompt $s.KlingPrompt
            if ($videoUrl) {
                Invoke-WebRequest -Uri $videoUrl -OutFile $videoPath
                Write-Host "  Video OK: $($s.Name).mp4" -ForegroundColor Green
                Write-Host "  URL: $videoUrl" -ForegroundColor DarkGray
            } else {
                Write-Host "  FEHLER: Kein Video generiert" -ForegroundColor Red
                $ergebnisse += [PSCustomObject]@{ Szene = $s.Nr; Status = "FEHLER Video" }
                continue
            }
        } catch {
            Write-Host "  FEHLER Kling: $_" -ForegroundColor Red
            $ergebnisse += [PSCustomObject]@{ Szene = $s.Nr; Status = "FEHLER Kling: $_" }
            continue
        }
    }

    $ergebnisse += [PSCustomObject]@{
        Szene    = $s.Nr
        Name     = $s.Name
        VideoURL = $videoUrl
        Status   = "OK"
    }

    Start-Sleep -Seconds 3
}

# Ergebnis
Write-Host ""
Write-Host "=== Ergebnis ===" -ForegroundColor Yellow
$ergebnisse | ForEach-Object {
    $farbe = if ($_.Status -eq "OK") { "Green" } else { "Red" }
    Write-Host "  Szene $($_.Szene): $($_.Status)" -ForegroundColor $farbe
    if ($_.VideoURL) { Write-Host "    $($_.VideoURL)" -ForegroundColor DarkGray }
}

$ergebnisse | Export-Csv -Path (Join-Path $VIDEO_DIR "matthias-v2-urls.csv") -NoTypeInformation -Encoding UTF8
Write-Host ""
Write-Host "Fertig! URLs in matthias-v2-urls.csv" -ForegroundColor Green
Write-Host "Naechster Schritt: URLs in den September-Contentplan eintragen." -ForegroundColor Yellow
