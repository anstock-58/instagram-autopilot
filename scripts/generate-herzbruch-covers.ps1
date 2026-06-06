# generate-herzbruch-covers.ps1
# Generiert 7 Modul-Cover fuer "Herzbruch-Notfall-Kurs" via Ideogram V2

$FAL_KEY = "7600112e-4d6f-4202-b107-b899fe36595c:4faa681903cdd51d757c18b7d0cc6c11"
$OUT_DIR = "C:\Users\andre\claude-workspace-vorlage\outputs\kurse\herzbruch-notfall-kurs\bilder"

if (-not (Test-Path $OUT_DIR)) { New-Item -ItemType Directory -Path $OUT_DIR | Out-Null }

$HEADERS = @{
    "Authorization" = "Key $FAL_KEY"
    "Content-Type"  = "application/json"
}

$S = "Flat digital illustration, dark deep burgundy and dark plum background, dark human silhouette, soft warm golden or amber glowing light element, high contrast, atmospheric glow, emotional healing mood, clean minimal vector art style, no text, 16:9"

$BILDER = @(
    @{ d="modul-1-sicher-landen.jpg";       p="$S. A dark silhouette sitting on the ground, knees drawn in, surrounded by a soft warm golden circle of light. Symbol of finding safety and orientation in the first days after separation." }
    @{ d="modul-2-warum-es-weh-tut.jpg";    p="$S. A dark silhouette with a glowing fracture line in the chest area, warm amber light seeping through it. Symbol of understanding why heartbreak hurts so deeply." }
    @{ d="modul-3-koerper-stabilisieren.jpg"; p="$S. A dark silhouette standing upright, glowing warm roots extending from the feet into the ground. Symbol of grounding and stabilizing the body first." }
    @{ d="modul-4-kopf-beruhigen.jpg";      p="$S. A dark silhouette with tangled glowing threads around the head slowly unraveling into calm. Symbol of quieting the mind and managing emotions." }
    @{ d="modul-5-entflechten.jpg";         p="$S. Two dark silhouettes gently separating, a warm golden thread between them loosening. Symbol of practically untangling a shared life." }
    @{ d="modul-6-kraftquellen.jpg";        p="$S. A dark silhouette standing tall, small warm golden lights glowing around them like candles. Symbol of rebuilding inner resources and joy." }
    @{ d="modul-7-ausblick.jpg";            p="$S. A dark silhouette walking toward a soft warm amber horizon opening ahead. Symbol of moving forward with a relapse prevention plan." }
)

function Generate-Image($prompt, $datei) {
    $body = @{
        prompt       = $prompt
        aspect_ratio = "16:9"
        num_images   = 1
        style_type   = "ILLUSTRATION"
    } | ConvertTo-Json -Depth 5

    try {
        $r = Invoke-RestMethod `
            -Uri "https://fal.run/fal-ai/ideogram/v2" `
            -Method POST `
            -Headers $HEADERS `
            -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
            -ContentType "application/json; charset=utf-8"

        $url = $r.images[0].url
        $outPath = Join-Path $OUT_DIR $datei
        Invoke-WebRequest -Uri $url -OutFile $outPath
        Write-Host "  OK: $datei" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  FEHLER: $datei" -ForegroundColor Red
        return $false
    }
}

Write-Host ""
Write-Host "Generiere 7 Modul-Cover..." -ForegroundColor Yellow
Write-Host "Ausgabe: $OUT_DIR" -ForegroundColor Gray
Write-Host ""

$i = 0
foreach ($b in $BILDER) {
    $i++
    Write-Host "[$i/7] " -NoNewline -ForegroundColor DarkGray
    Generate-Image -prompt $b.p -datei $b.d
    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "Fertig! $i Cover in:" -ForegroundColor Green
Write-Host $OUT_DIR -ForegroundColor Gray
