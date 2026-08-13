# prerender-business-september.ps1
# Rendert September-Reels mit Andis eigenen Videos + FFmpeg,
# laedt sie auf fal.ai Storage (kostenlos) und aktualisiert die CSVs.

$basePath  = "C:\Users\andre\claude-workspace-vorlage"
$videoDir  = "C:\Users\Andreas\Medien_Business\Business&Spirit\Videos_Reels"
$tmpDir    = "C:\Users\andre\AppData\Local\Temp\bus_render"
$musicFile = "$basePath\music\background-chill.mp3"
$fontFile  = "C\:/Windows/Fonts/arialbd.ttf"
$falKey    = "7600112e-4d6f-4202-b107-b899fe36595c:4faa681903cdd51d757c18b7d0cc6c11"
$falHdr    = @{ "Authorization" = "Key $falKey"; "Content-Type" = "application/json" }

$srcVideos = @(
    "$videoDir\B&S-Reel-1.mp4",
    "$videoDir\B&S-Reel-2.mp4",
    "$videoDir\B&S-Reel-3.mp4",
    "$videoDir\B&S-Reel-4.mp4"
)

if (-not (Test-Path $tmpDir)) { New-Item -ItemType Directory -Path $tmpDir | Out-Null }

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
    param([string]$datum, [string]$overlayText, [string]$sourceVideo)

    $safe   = $datum -replace "\.", "_"
    $outMp4 = Join-Path $tmpDir "sep_${safe}_out.mp4"

    # Overlay-Text splitten (unterstuetzt literal \n und echte Newlines)
    $rawLines = $overlayText -split "\\n|`n"
    $l1 = if ($rawLines.Count -gt 0) { $rawLines[0].Trim() } else { "" }
    $l2 = if ($rawLines.Count -gt 1) { $rawLines[1].Trim() } else { "" }
    $l3 = if ($rawLines.Count -gt 2) { $rawLines[2].Trim() } else { "" }

    # Nur Doppelpunkt escapen (Apostrophe kommen in den Texten nicht vor)
    $l1 = $l1 -replace ":", "\:"
    $l2 = $l2 -replace ":", "\:"
    $l3 = $l3 -replace ":", "\:"

    $box = "box=1:boxcolor=white@0.85:boxborderw=14"
    $dt  = "drawtext=fontfile='$fontFile':text='$l1':x=(w-tw)/2:y=h*0.63:fontsize=40:fontcolor=#1A2230:$box," +
           "drawtext=fontfile='$fontFile':text='$l2':x=(w-tw)/2:y=h*0.72:fontsize=40:fontcolor=#1A2230:$box," +
           "drawtext=fontfile='$fontFile':text='$l3':x=(w-tw)/2:y=h*0.81:fontsize=34:fontcolor=#1A2230:$box"

    if (Test-Path $musicFile) {
        & ffmpeg -y -i $sourceVideo -i $musicFile `
            -filter_complex "[0:v]$dt[v];[1:a]volume=0.15[a]" `
            -map "[v]" -map "[a]" -shortest -c:v libx264 -c:a aac $outMp4 2>$null
    } else {
        & ffmpeg -y -i $sourceVideo -vf $dt -c:v libx264 -c:a copy $outMp4 2>$null
    }

    if (-not (Test-Path $outMp4) -or (Get-Item $outMp4).Length -lt 10000) {
        return $null
    }
    return $outMp4
}

# ---- August 12.08 ----
Write-Host ""
Write-Host "=== August 12.08 ===" -ForegroundColor Yellow
$augCsvPath = "$basePath\outputs\contentplan_business_und_spirit_august_v2.csv"
$augRows    = Import-Csv $augCsvPath -Delimiter "," -Encoding UTF8
$aug1208    = $augRows | Where-Object { $_.Datum -eq "12.08.2026" -and $_."Post-Typ" -eq "Reel" }

if ($aug1208 -and $aug1208."Bild-URL" -like "*PLATZ*") {
    Write-Host "[12.08] Render mit B&S-Reel-1..." -ForegroundColor Cyan
    $outFile = Render-Video -datum "12.08.2026" -overlayText $aug1208."Text-Overlay" -sourceVideo $srcVideos[0]
    if ($outFile) {
        $mb = [math]::Round((Get-Item $outFile).Length / 1MB, 1)
        Write-Host "  FFmpeg OK ($mb MB)" -ForegroundColor Green
        try {
            $url = Upload-ToFal -filePath $outFile
            Write-Host "  Upload OK: $url" -ForegroundColor Green
            $aug1208."Bild-URL"     = $url
            $aug1208."Text-Overlay" = ""
            $augRows | Export-Csv $augCsvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        } catch {
            Write-Host "  FEHLER Upload: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "  FEHLER: FFmpeg fehlgeschlagen" -ForegroundColor Red
    }
} else {
    Write-Host "  Bereits vorhanden oder kein Platzhalter." -ForegroundColor DarkGray
}

# ---- September Reels ----
Write-Host ""
Write-Host "=== September Reels ===" -ForegroundColor Yellow
$sepCsvPath = "$basePath\outputs\contentplan_business_und_spirit_september_v2.csv"
$sepRows    = Import-Csv $sepCsvPath -Delimiter "," -Encoding UTF8

$vidIdx  = 1
$ok      = 0
$fehler  = 0

foreach ($row in $sepRows) {
    if ($row."Post-Typ" -ne "Reel") { continue }
    if ($row."Bild-URL" -notlike "PLATZHALTER*") { continue }
    if ([string]::IsNullOrWhiteSpace($row."Text-Overlay")) { continue }

    $src = $srcVideos[$vidIdx % 4]
    $vidIdx++

    Write-Host "[$($row.Datum)] Render mit $(Split-Path $src -Leaf)..." -ForegroundColor Cyan
    $outFile = Render-Video -datum $row.Datum -overlayText $row."Text-Overlay" -sourceVideo $src

    if ($outFile) {
        $mb = [math]::Round((Get-Item $outFile).Length / 1MB, 1)
        Write-Host "  FFmpeg OK ($mb MB)" -ForegroundColor Green
        try {
            $url = Upload-ToFal -filePath $outFile
            Write-Host "  Upload OK" -ForegroundColor Green
            $row."Bild-URL"     = $url
            $row."Text-Overlay" = ""
            # Story desselben Tags mitaktualisieren
            $story = $sepRows | Where-Object { $_.Datum -eq $row.Datum -and $_."Post-Typ" -eq "Story" }
            if ($story) { $story."Bild-URL" = $url }
            $ok++
        } catch {
            Write-Host "  FEHLER Upload: $_" -ForegroundColor Red
            $fehler++
        }
    } else {
        Write-Host "  FEHLER: FFmpeg fehlgeschlagen" -ForegroundColor Red
        $fehler++
    }
}

$sepRows | Export-Csv $sepCsvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation

Write-Host ""
Write-Host "=== Ergebnis ===" -ForegroundColor Yellow
Write-Host "September: $ok OK, $fehler Fehler" -ForegroundColor Green
Write-Host "CSVs gespeichert." -ForegroundColor Cyan
