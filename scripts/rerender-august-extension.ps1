$basePath   = "C:\Users\andre\claude-workspace-vorlage"
$blankoDir  = "C:\Users\Andreas\Medien_Business\Business&Spirit\Blanko-Clips"
$musicDir   = "$basePath\music"
$tmpDir     = "C:\Users\andre\AppData\Local\Temp\bus_render"
$fontFile   = "C\:/Windows/Fonts/arialbd.ttf"
$falKey     = "7600112e-4d6f-4202-b107-b899fe36595c:4faa681903cdd51d757c18b7d0cc6c11"
$falHdr     = @{ "Authorization" = "Key $falKey"; "Content-Type" = "application/json" }
$augCsvPath = "$basePath\outputs\contentplan_business_und_spirit_august_v2.csv"
$textsFile  = "$basePath\scripts\overlay-texts-aug-ext.json"

if (-not (Test-Path $tmpDir)) { New-Item -ItemType Directory -Path $tmpDir | Out-Null }

$srcVideos = @(Get-ChildItem "$blankoDir\*.mp4" | Sort-Object Name | Select-Object -ExpandProperty FullName)
Write-Host "$($srcVideos.Count) Blanko-Clips gefunden." -ForegroundColor DarkGray

$musicFiles = @(Get-ChildItem "$musicDir\*.mp3" | Sort-Object Name | Select-Object -ExpandProperty FullName)
Write-Host "$($musicFiles.Count) Musik-Tracks: $($musicFiles | ForEach-Object { Split-Path $_ -Leaf } | Join-String ', ')" -ForegroundColor DarkGray

$posts = Get-Content $textsFile -Encoding UTF8 | ConvertFrom-Json

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
    param([string]$datum, [string]$l1, [string]$l2, [string]$l3, [string]$src, [string]$music)
    $safe   = $datum -replace "\.", "_"
    $outMp4 = Join-Path $tmpDir "aug3_${safe}_out.mp4"

    $e1 = $l1 -replace ":", "\:" -replace "'", ""
    $e2 = $l2 -replace ":", "\:" -replace "'", ""
    $e3 = $l3 -replace ":", "\:" -replace "'", ""

    $box   = "box=1:boxcolor=white@0.88:boxborderw=18"
    $scale = "scale=1080:1920:flags=lanczos:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2"
    $dt    = "drawtext=fontfile='$fontFile':text='$e1':x=(w-tw)/2:y=h*0.63:fontsize=68:fontcolor=#1A2230:$box," +
             "drawtext=fontfile='$fontFile':text='$e2':x=(w-tw)/2:y=h*0.715:fontsize=68:fontcolor=#1A2230:$box," +
             "drawtext=fontfile='$fontFile':text='$e3':x=(w-tw)/2:y=h*0.81:fontsize=46:fontcolor=#1A2230:$box"

    if (Test-Path $music) {
        & ffmpeg -y -i $src -i $music `
            -filter_complex "[0:v]$scale,$dt[v];[1:a]volume=0.12[a]" `
            -map "[v]" -map "[a]" -shortest -c:v libx264 -c:a aac $outMp4 2>$null
    } else {
        & ffmpeg -y -i $src `
            -filter_complex "[0:v]$scale,$dt[v]" `
            -map "[v]" -c:v libx264 $outMp4 2>$null
    }

    if (-not (Test-Path $outMp4) -or (Get-Item $outMp4).Length -lt 10000) { return $null }
    return $outMp4
}

$augRows = Import-Csv $augCsvPath -Delimiter "," -Encoding UTF8

Write-Host ""
Write-Host "=== Re-Render August 13.08-31.08 ===" -ForegroundColor Yellow
$vidIdx = 0; $musIdx = 0; $ok = 0; $fehler = 0

foreach ($post in $posts) {
    $datum = $post.Datum
    $src   = $srcVideos[$vidIdx % $srcVideos.Count]; $vidIdx++
    $music = $musicFiles[$musIdx % $musicFiles.Count]; $musIdx++

    Write-Host "[$datum]  Video: $(Split-Path $src -Leaf)" -ForegroundColor Cyan
    Write-Host "         Musik: $(Split-Path $music -Leaf)" -ForegroundColor DarkGray
    Write-Host "         Text:  $($post.L1) / $($post.L2)" -ForegroundColor DarkGray

    $outFile = Render-Video -datum $datum -l1 $post.L1 -l2 $post.L2 `
               -l3 "Kennst du das? Lies die Caption." -src $src -music $music

    $url = ""
    if ($outFile) {
        $mb = [math]::Round((Get-Item $outFile).Length / 1MB, 1)
        Write-Host "  FFmpeg OK ($mb MB)" -ForegroundColor Green
        try {
            $url = Upload-ToFal -filePath $outFile
            Write-Host "  Upload OK -> $($url.Substring(0,50))..." -ForegroundColor Green
            $ok++
        } catch {
            Write-Host "  FEHLER Upload: $_" -ForegroundColor Red; $fehler++
        }
    } else {
        Write-Host "  FEHLER FFmpeg" -ForegroundColor Red; $fehler++
    }

    if ($url) {
        $reel  = $augRows | Where-Object { $_.Datum -eq $datum -and $_."Post-Typ" -eq "Reel" }
        $story = $augRows | Where-Object { $_.Datum -eq $datum -and $_."Post-Typ" -eq "Story" }
        if ($reel)  { $reel."Bild-URL"  = $url }
        if ($story) { $story."Bild-URL" = $url }
    }
    Write-Host ""
}

$augRows | Export-Csv $augCsvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
Write-Host "=== Ergebnis: $ok OK, $fehler Fehler ===" -ForegroundColor $(if ($fehler -gt 0) { "Red" } else { "Green" })
Write-Host "CSV gespeichert: $augCsvPath" -ForegroundColor Cyan
