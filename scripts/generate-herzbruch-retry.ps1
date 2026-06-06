# generate-herzbruch-retry.ps1
# Wiederholt fehlgeschlagene Lektionsbilder fuer "Herzbruch-Notfall-Kurs"

$FAL_KEY = "7600112e-4d6f-4202-b107-b899fe36595c:4faa681903cdd51d757c18b7d0cc6c11"
$OUT_DIR = "C:\Users\andre\claude-workspace-vorlage\outputs\kurse\herzbruch-notfall-kurs\lektions-bilder"
$HEADERS = @{ "Authorization" = "Key $FAL_KEY"; "Content-Type" = "application/json" }
$S = "Flat digital illustration, dark deep burgundy and dark plum background, dark human silhouette, soft warm golden or amber glowing light element, high contrast, atmospheric glow, emotional healing mood, clean minimal vector art style, no text, 16:9"

$RETRY = @(
    @{ d="m3-l5-alkohol-social-media.jpg";  p="$S. A silhouette gently setting aside glowing distractions. Symbol of managing alcohol, caffeine and social media during crisis." }
    @{ d="m3-l6-panik-toolbox.jpg";         p="$S. A silhouette holding a small glowing box of calming tools. Symbol of a panic toolbox with body scan, cold and self-talk." }
    @{ d="m4-l3-gedankenkreisen.jpg";       p="$S. A silhouette watching circular thoughts drift into a contained glowing box. Symbol of stopping thought spirals with worry time and reframing." }
    @{ d="m4-l4-digital-detox.jpg";         p="$S. A silhouette calmly muting a glowing phone feed. Symbol of digital detox and cleaning the social media feed." }
    @{ d="m4-l5-selbstmitgefuehl.jpg";      p="$S. A silhouette holding their own hand gently in warm golden light. Symbol of self-compassion and observing emotions like waves." }
    @{ d="m4-l6-grenzen-kommunizieren.jpg"; p="$S. A silhouette speaking calmly with a soft glowing boundary between two figures. Symbol of communicating personal boundaries clearly." }
    @{ d="m5-l1-kommunikation.jpg";         p="$S. Two silhouettes exchanging a glowing document calmly. Symbol of neutral communication guidelines for necessary contact." }
    @{ d="m5-l2-besitz-uebergaben.jpg";     p="$S. Two silhouettes with a glowing object passed peacefully between them. Symbol of fair handovers of shared belongings." }
    @{ d="m5-l3-accounts-passwoerter.jpg";  p="$S. A silhouette with a glowing padlock being reset. Symbol of separating digital accounts and protecting privacy." }
    @{ d="m5-l4-alltagsstruktur.jpg";       p="$S. A silhouette arranging glowing objects in a new personal space. Symbol of restructuring living space and daily routines alone." }
    @{ d="m5-l5-finanzen.jpg";              p="$S. A silhouette with a small glowing practical checklist. Symbol of financial and administrative tasks after separation." }
    @{ d="m5-l6-erinnerungen.jpg";          p="$S. A silhouette placing glowing memories into a box and closing it gently. Symbol of archiving memories without deleting them." }
    @{ d="m6-l1-tagesstruktur.jpg";         p="$S. A silhouette with three soft golden anchors along a daily timeline. Symbol of morning, evening and SOS anchors as new daily structure." }
    @{ d="m6-l2-support-netzwerk.jpg";      p="$S. A silhouette with one to three steady glowing figures nearby. Symbol of activating a small reliable support network." }
    @{ d="m6-l3-mini-freuden.jpg";          p="$S. A silhouette with small warm golden sparks floating gently around them. Symbol of a personal self-soothing list and mini joys." }
    @{ d="m6-l4-sinn-werte.jpg";            p="$S. A silhouette holding a glowing compass pointing forward. Symbol of updating personal values as a compass through uncertainty." }
    @{ d="m6-l5-energiepflege.jpg";         p="$S. A silhouette in a restorative position, warm amber light strengthening around the body. Symbol of sustainable energy through sleep and movement." }
    @{ d="m6-l6-momentum.jpg";              p="$S. A silhouette marking small glowing milestones on a path ahead. Symbol of building momentum through micro goals and tracking small wins." }
    @{ d="m7-l2-rueckfallplan.jpg";         p="$S. A silhouette calmly prepared with a soft glowing safety net behind them. Symbol of a relapse prevention plan for difficult days." }
    @{ d="m7-l3-regeln-ab-tag30.jpg";       p="$S. A silhouette stepping forward with clear glowing guideposts ahead. Symbol of new personal rules after 30 days for contact and daily life." }
    @{ d="m7-l4-nachsorgeplan.jpg";         p="$S. A silhouette with a glowing four-week calendar path unfolding ahead. Symbol of a personal aftercare plan for the coming weeks." }
    @{ d="m7-l5-faq.jpg";                   p="$S. A silhouette navigating small glowing obstacles with calm confidence. Symbol of common questions and practical solutions after separation." }
    @{ d="m7-l6-ressourcen.jpg";            p="$S. A silhouette holding a small glowing card and an organized resource list. Symbol of a printable emergency card and resource overview." }
)

function Generate-Image($prompt, $datei) {
    $body = @{ prompt=$prompt; aspect_ratio="16:9"; num_images=1; style_type="ILLUSTRATION" } | ConvertTo-Json -Depth 5
    try {
        $r = Invoke-RestMethod -Uri "https://fal.run/fal-ai/ideogram/v2" -Method POST -Headers $HEADERS -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) -ContentType "application/json; charset=utf-8"
        Invoke-WebRequest -Uri $r.images[0].url -OutFile (Join-Path $OUT_DIR $datei)
        Write-Host "  OK: $datei" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  FEHLER: $datei" -ForegroundColor Red
        return $false
    }
}

Write-Host ""
Write-Host "Retry: 23 fehlgeschlagene Bilder..." -ForegroundColor Yellow
$i = 0
foreach ($l in $RETRY) {
    $i++
    Write-Host "[$i/23] " -NoNewline -ForegroundColor DarkGray
    Generate-Image -prompt $l.p -datei $l.d
    Start-Sleep -Seconds 1
}
Write-Host ""
Write-Host "Fertig!" -ForegroundColor Green
