$basePath  = "C:\Users\andre\claude-workspace-vorlage"
$blankoDir = "C:\Users\Andreas\Medien_Business\Business&Spirit\Blanko-Clips"
$tmpDir    = "C:\Users\andre\AppData\Local\Temp\bus_render"
$musicFile = "$basePath\music\background-chill.mp3"
$fontFile  = "C\:/Windows/Fonts/arialbd.ttf"
$falKey    = "7600112e-4d6f-4202-b107-b899fe36595c:4faa681903cdd51d757c18b7d0cc6c11"
$falHdr    = @{ "Authorization" = "Key $falKey"; "Content-Type" = "application/json" }
$augCsvPath = "$basePath\outputs\contentplan_business_und_spirit_august_v2.csv"

if (-not (Test-Path $tmpDir)) { New-Item -ItemType Directory -Path $tmpDir | Out-Null }

$srcVideos = @(Get-ChildItem "$blankoDir\*.mp4" | Sort-Object Name | Select-Object -ExpandProperty FullName)
Write-Host "$($srcVideos.Count) Blanko-Clips gefunden." -ForegroundColor DarkGray

function Upload-ToFal {
    param([string]$filePath)
    $fileName  = Split-Path $filePath -Leaf
    $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
    $initBody  = ConvertTo-Json @{ file_name = $fileName; content_type = "video/mp4" }
    $init = Invoke-RestMethod `
        -Uri "https://rest.alpha.fal.ai/storage/upload/initiate" `
        -Method POST -Headers $falHdr `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($initBody)) `
        -ContentType "application/json; charset=utf-8" -ErrorAction Stop
    try {
        Invoke-RestMethod -Uri $init.upload_url -Method PUT -Body $fileBytes `
            -ContentType "video/mp4" -ErrorAction Stop | Out-Null
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -notin @(200, 204)) { throw }
    }
    return $init.file_url
}

function Render-Video {
    param([string]$datum, [string]$l1, [string]$l2, [string]$l3, [string]$sourceVideo)
    $safe   = $datum -replace "\.", "_"
    $outMp4 = Join-Path $tmpDir "aug_ext_${safe}_out.mp4"

    $e1 = $l1 -replace ":", "\:"
    $e2 = $l2 -replace ":", "\:"
    $e3 = $l3 -replace ":", "\:"

    # Groesserer Text, engere Zeilenabstaende
    $box = "box=1:boxcolor=white@0.88:boxborderw=18"
    $dt  = "drawtext=fontfile='$fontFile':text='$e1':x=(w-tw)/2:y=h*0.64:fontsize=56:fontcolor=#1A2230:$box," +
           "drawtext=fontfile='$fontFile':text='$e2':x=(w-tw)/2:y=h*0.725:fontsize=56:fontcolor=#1A2230:$box," +
           "drawtext=fontfile='$fontFile':text='$e3':x=(w-tw)/2:y=h*0.81:fontsize=46:fontcolor=#1A2230:$box"

    if (Test-Path $musicFile) {
        & ffmpeg -y -i $sourceVideo -i $musicFile `
            -filter_complex "[0:v]$dt[v];[1:a]volume=0.15[a]" `
            -map "[v]" -map "[a]" -shortest -c:v libx264 -c:a aac $outMp4 2>$null
    } else {
        & ffmpeg -y -i $sourceVideo -vf $dt -c:v libx264 -c:a copy $outMp4 2>$null
    }

    if (-not (Test-Path $outMp4) -or (Get-Item $outMp4).Length -lt 10000) { return $null }
    return $outMp4
}

# Captions als UTF-8 Datei auslagern um Encoding-Probleme zu vermeiden
$postsFile = "$basePath\scripts\aug-ext-posts.json"
$posts = Get-Content $postsFile -Encoding UTF8 | ConvertFrom-Json

$augRows = [System.Collections.ArrayList](Import-Csv $augCsvPath -Delimiter "," -Encoding UTF8)

Write-Host "=== August-Extension 13.08-31.08 ===" -ForegroundColor Yellow
$vidIdx = 0; $ok = 0; $fehler = 0

foreach ($post in $posts) {
    $datum = $post.Datum
    $existing = $augRows | Where-Object { $_.Datum -eq $datum -and $_."Post-Typ" -eq "Reel" }
    if ($existing) {
        Write-Host "[$datum] bereits vorhanden, uebersprungen." -ForegroundColor DarkGray
        continue
    }

    $src = $srcVideos[$vidIdx % $srcVideos.Count]
    $vidIdx++

    Write-Host "[$datum] Render $(Split-Path $src -Leaf)..." -ForegroundColor Cyan
    $outFile = Render-Video -datum $datum -l1 $post.L1 -l2 $post.L2 -l3 "Kennst du das? Lies die Caption." -sourceVideo $src

    $reelUrl = ""
    if ($outFile) {
        $mb = [math]::Round((Get-Item $outFile).Length / 1MB, 1)
        Write-Host "  FFmpeg OK ($mb MB)" -ForegroundColor Green
        try {
            $reelUrl = Upload-ToFal -filePath $outFile
            Write-Host "  Upload OK" -ForegroundColor Green
            $ok++
        } catch {
            Write-Host "  FEHLER: $_" -ForegroundColor Red; $fehler++
        }
    } else {
        Write-Host "  FEHLER: FFmpeg fehlgeschlagen" -ForegroundColor Red; $fehler++
    }

    $base = [PSCustomObject]@{
        "Datum"=""; "Uhrzeit"=""; "Plattform"="Instagram"; "Post-Typ"=""
        "Text"=""; "Link"="https://sicher-weiterlesen.com/standortcheck"
        "Bild-URL"=$reelUrl; "Bildprompt"=""; "Videoprompt"=""; "Text-Overlay"=""
        "Karussell-Slides"=""; "Status"="Geplant"; "Musik-URL"=""
    }
    $reel = $base.PSObject.Copy(); $reel.Datum=$datum; $reel.Uhrzeit="18:00"; $reel."Post-Typ"="Reel"; $reel.Text=$post.Caption
    $story = $base.PSObject.Copy(); $story.Datum=$datum; $story.Uhrzeit="09:00"; $story."Post-Typ"="Story"; $story.Text=$post.Story
    $augRows.Add($reel) | Out-Null
    $augRows.Add($story) | Out-Null
}

$sorted = $augRows | Sort-Object { [datetime]::ParseExact($_.Datum, "dd.MM.yyyy", $null) }
$sorted | Export-Csv $augCsvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation

Write-Host ""
Write-Host "=== Ergebnis: $ok OK, $fehler Fehler ===" -ForegroundColor Yellow
Write-Host "August-CSV gespeichert." -ForegroundColor Cyan
