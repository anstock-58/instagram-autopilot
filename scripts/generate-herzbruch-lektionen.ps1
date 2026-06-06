# generate-herzbruch-lektionen.ps1
# Generiert 42 Lektionsbilder fuer "Herzbruch-Notfall-Kurs" via Ideogram V2

$FAL_KEY = "7600112e-4d6f-4202-b107-b899fe36595c:4faa681903cdd51d757c18b7d0cc6c11"
$OUT_DIR = "C:\Users\andre\claude-workspace-vorlage\outputs\kurse\herzbruch-notfall-kurs\lektions-bilder"

if (-not (Test-Path $OUT_DIR)) { New-Item -ItemType Directory -Path $OUT_DIR | Out-Null }

$HEADERS = @{
    "Authorization" = "Key $FAL_KEY"
    "Content-Type"  = "application/json"
}

$S = "Flat digital illustration, dark deep burgundy and dark plum background, dark human silhouette, soft warm golden or amber glowing light element, high contrast, atmospheric glow, emotional healing mood, clean minimal vector art style, no text, 16:9"

$LEKTIONEN = @(
    @{ d="m1-l1-realitaets-check.jpg";      p="$S. A silhouette sitting still, a soft warm light illuminating just the immediate space around them. Symbol of honest assessment of what happened and what is needed now." }
    @{ d="m1-l2-stabil-bleiben.jpg";        p="$S. A silhouette breathing slowly, a gentle amber glow pulsing from the chest. Symbol of 24 to 72 hour emergency rituals for breathing and body." }
    @{ d="m1-l3-sicherheitsnetz.jpg";       p="$S. A silhouette held gently by a glowing net of warm light. Symbol of SOS contacts, avoiding triggers and setting personal rules." }
    @{ d="m1-l4-journaling.jpg";            p="$S. A silhouette writing in a softly glowing journal, small golden sparks rising. Symbol of starting a feelings diary and mini goals." }
    @{ d="m1-l5-kontakt-stopp.jpg";         p="$S. A silhouette stepping back from a glowing phone screen that dims and fades. Symbol of initiating 72 hours without contact and digital hygiene." }
    @{ d="m1-l6-warnsignale.jpg";           p="$S. A silhouette noticing a small amber warning light nearby, calmly reaching toward it. Symbol of recognizing warning signs and knowing when to seek help." }

    @{ d="m2-l1-bindungssystem.jpg";        p="$S. A silhouette with a glowing brain area showing warm amber disruption patterns. Symbol of the attachment system and withdrawal state of the brain after separation." }
    @{ d="m2-l2-trauer-zyklisch.jpg";       p="$S. A silhouette surrounded by soft glowing waves moving in and out. Symbol of grief being cyclical with phases and waves." }
    @{ d="m2-l3-gruebelschleifen.jpg";      p="$S. A silhouette with looping golden threads around the head slowly dissolving. Symbol of demystifying rumination and cognitive distortions." }
    @{ d="m2-l4-nervensystem.jpg";          p="$S. A silhouette with a glowing nervous system pathway calming from tense to settled. Symbol of regulating fight flight freeze and fawn responses." }
    @{ d="m2-l5-koerperliche-symptome.jpg"; p="$S. A silhouette resting, soft amber light normalizing around the body. Symbol of normalizing physical symptoms like appetite, sleep and energy loss." }
    @{ d="m2-l6-richtige-hilfe.jpg";        p="$S. A silhouette with three soft glowing figures nearby at different distances. Symbol of choosing the right support from friends, counseling or therapy." }

    @{ d="m3-l1-schlafprotokoll.jpg";       p="$S. A silhouette lying in restful sleep, three soft golden pillars of light above them. Symbol of an acute sleep protocol with three key pillars." }
    @{ d="m3-l2-essen-trinken.jpg";         p="$S. A silhouette with a small warm glowing bowl in their hands. Symbol of minimal nutrition standards and simple rescue meals." }
    @{ d="m3-l3-sofort-regulieren.jpg";     p="$S. A silhouette with hands on chest, warm amber light pulsing through breath. Symbol of immediate regulation with TIPP, 4-7-8 and room orientation." }
    @{ d="m3-l4-bewegung.jpg";              p="$S. A silhouette walking in soft golden morning light outdoors. Symbol of a 20-minute movement and daylight reset." }
    @{ d="m3-l5-alkohol-social-media.jpg";  p="$S. A silhouette gently setting aside glowing distractions. Symbol of managing alcohol, caffeine and social media during crisis." }
    @{ d="m3-l6-panik-toolbox.jpg";         p="$S. A silhouette holding a small glowing box of calming tools. Symbol of a panic toolbox with body scan, cold and self-talk." }

    @{ d="m4-l1-kontaktpause.jpg";          p="$S. A silhouette standing calmly behind a soft glowing boundary line. Symbol of planning and maintaining no contact or low contact." }
    @{ d="m4-l2-trigger-management.jpg";    p="$S. A silhouette calmly stepping around glowing trigger spots on the ground. Symbol of managing trigger locations, objects and routines." }
    @{ d="m4-l3-gedankenkreisen.jpg";       p="$S. A silhouette watching circular thoughts drift into a contained glowing box. Symbol of stopping thought spirals with worry time, noting and reframing." }
    @{ d="m4-l4-digital-detox.jpg";         p="$S. A silhouette calmly muting a glowing phone feed. Symbol of digital detox, muting the ex and cleaning the social media feed." }
    @{ d="m4-l5-selbstmitgefuehl.jpg";      p="$S. A silhouette holding their own hand gently in warm golden light. Symbol of self-compassion and emotion surfing in 10 minutes." }
    @{ d="m4-l6-grenzen-kommunizieren.jpg"; p="$S. A silhouette speaking calmly to another with a soft glowing boundary between them. Symbol of communicating boundaries with short clear phrases." }

    @{ d="m5-l1-kommunikation.jpg";         p="$S. Two silhouettes exchanging a glowing document calmly and clearly. Symbol of communication guidelines for necessary contact around children and household." }
    @{ d="m5-l2-besitz-uebergaben.jpg";     p="$S. Two silhouettes with a glowing object being passed between them peacefully. Symbol of fair handovers of possessions, keys and shared belongings." }
    @{ d="m5-l3-accounts-passwoerter.jpg";  p="$S. A silhouette with a glowing padlock being reset. Symbol of separating digital accounts and protecting data privacy." }
    @{ d="m5-l4-alltagsstruktur.jpg";       p="$S. A silhouette arranging glowing objects in a new personal space. Symbol of restructuring living space and daily routines." }
    @{ d="m5-l5-finanzen.jpg";              p="$S. A silhouette with a small glowing checklist of practical tasks. Symbol of a quick financial and administrative checklist after separation." }
    @{ d="m5-l6-erinnerungen.jpg";          p="$S. A silhouette gently placing glowing memories into a box and closing it. Symbol of managing memories by archiving, boxing or ordering them." }

    @{ d="m6-l1-tagesstruktur.jpg";         p="$S. A silhouette with three soft golden anchors along a daily timeline. Symbol of a new daily structure with morning, evening and SOS anchors." }
    @{ d="m6-l2-support-netzwerk.jpg";      p="$S. A silhouette with one to three steady glowing figures nearby. Symbol of activating a reliable support network of one to three people." }
    @{ d="m6-l3-mini-freuden.jpg";          p="$S. A silhouette with small warm golden sparks floating around them. Symbol of self-soothing tools and a mini joy list." }
    @{ d="m6-l4-sinn-werte.jpg";            p="$S. A silhouette holding a glowing compass pointing forward. Symbol of a values and meaning update as a compass through chaos." }
    @{ d="m6-l5-energiepflege.jpg";         p="$S. A silhouette in a restorative position, warm amber light strengthening around them. Symbol of energy care through sleep, nutrition and movement." }
    @{ d="m6-l6-momentum.jpg";              p="$S. A silhouette marking small glowing milestones on a path ahead. Symbol of building momentum through micro goals, tracking wins and reflection." }

    @{ d="m7-l1-fortschritt-messen.jpg";    p="$S. A silhouette with a glowing scale or marker showing steady progress. Symbol of measuring progress with scales, markers and milestones." }
    @{ d="m7-l2-rueckfallplan.jpg";         p="$S. A silhouette calmly prepared with a small glowing safety net behind them. Symbol of a relapse plan for contact urges, trigger days and holidays." }
    @{ d="m7-l3-regeln-ab-tag30.jpg";       p="$S. A silhouette stepping forward with clear glowing guideposts ahead. Symbol of new rules after day 30 for ex contact, dating and social media." }
    @{ d="m7-l4-nachsorgeplan.jpg";         p="$S. A silhouette with a glowing four-week calendar path ahead. Symbol of a personal 4-week aftercare plan." }
    @{ d="m7-l5-faq.jpg";                   p="$S. A silhouette navigating small glowing obstacles with calm confidence. Symbol of frequently asked questions and common stumbling blocks." }
    @{ d="m7-l6-ressourcen.jpg";            p="$S. A silhouette holding a small glowing card and a neatly organized resource list. Symbol of a resource list and printable emergency card." }
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
Write-Host "Generiere 42 Lektionsbilder..." -ForegroundColor Yellow
Write-Host "Ausgabe: $OUT_DIR" -ForegroundColor Gray
Write-Host ""

$i = 0
foreach ($l in $LEKTIONEN) {
    $i++
    Write-Host "[$i/42] " -NoNewline -ForegroundColor DarkGray
    Generate-Image -prompt $l.p -datei $l.d
    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "Fertig! $i Bilder in:" -ForegroundColor Green
Write-Host $OUT_DIR -ForegroundColor Gray
