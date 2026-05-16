# post-trigger.ps1
# Erstellt Slideshow-Video via Blotato Visual Templates API und postet auf Instagram.
# Laeuft taeglich via GitHub Actions (08:55 Story, 17:55 Reel).

# ============================================================
# KONFIGURATION
# ============================================================
$basePath    = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }
$logPath     = Join-Path $basePath "outputs" "post-trigger-log.txt"
$archivPath  = Join-Path $basePath "outputs" "post-archiv.csv"

# CSV automatisch nach aktuellem Monat waehlen
$monatMap = @{1="januar";2="februar";3="maerz";4="april";5="mai";6="juni";
              7="juli";8="august";9="september";10="oktober";11="november";12="dezember"}
$monat    = $monatMap[(Get-Date).Month]
$csvNamen = @("contentplan_${monat}_v2.csv", "contentplan_${monat}_v1.csv")
$csvPath  = $null
foreach ($name in $csvNamen) {
    $pfad = Join-Path $basePath "outputs" $name
    if (Test-Path $pfad) { $csvPath = $pfad; break }
}
if (-not $csvPath) { Write-Output "FEHLER: Kein CSV fuer Monat '$monat' gefunden."; exit 1 }

$apiKey          = if ($env:BLOTATO_API_KEY) { $env:BLOTATO_API_KEY } else { "blt_KiCyq1rBxLUqnWdUJaH6Qaij4V07Q6wvcIH8/aQLrXA=" }
$apiBase         = "https://backend.blotato.com/v2"
$accountIdIG     = "46248"   # @business.und.spirit Instagram
$slideshowTemplate = "/base/v2/image-slideshow/5903b592-1255-43b4-b9ac-f8ed7cbf6a5f/v1"

$zeitfensterFrueh = -10
$zeitfensterSpaet = 45

# ============================================================
# HILFSFUNKTIONEN
# ============================================================
function Write-Log {
    param([string]$msg)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $msg"
    $line | Out-File -FilePath $logPath -Append -Encoding UTF8
    Write-Output $line
}

function Create-Slideshow {
    param(
        [string]$imageSource,   # Videoprompt aus CSV (Blotato generiert Bild)
        [string]$textOverlay,   # Text-Overlay aus CSV
        [string]$typ            # "Story" oder "Reel"/"Foto"
    )

    $aspectRatio = if ($typ -eq "Story") { "9:16" } else { "9:16" }

    # Slides: Hauptbild + CTA-Slide
    $slides = @(
        @{ imageSource = $imageSource; textOverlay = $textOverlay },
        @{ imageSource = $imageSource; textOverlay = "Kommentiere KLARHEIT - ich antworte dir" }
    )

    $payload = @{
        templateId = $slideshowTemplate
        inputs     = @{
            slides      = $slides
            textPosition = "bottom"
            textStyle    = "elegant"
            aspectRatio  = $aspectRatio
            transition   = "fade"
        }
        render = $true
    }

    $json      = $payload | ConvertTo-Json -Depth 10 -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $headers   = @{
        "blotato-api-key" = $apiKey
        "Content-Type"    = "application/json; charset=utf-8"
    }

    Write-Log "Erstelle Slideshow ($typ): $json"

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/videos/from-templates" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "Slideshow Response: $($response | ConvertTo-Json -Depth 5 -Compress)"
        return $response
    } catch {
        Write-Log "FEHLER Slideshow-Erstellung: $_"
        return $null
    }
}

function Get-VideoUrl {
    param($response)
    # Verschiedene moegliche Response-Formate abfangen
    if ($response.videoUrl)       { return $response.videoUrl }
    if ($response.url)            { return $response.url }
    if ($response.data.videoUrl)  { return $response.data.videoUrl }
    if ($response.data.url)       { return $response.data.url }
    if ($response.outputUrl)      { return $response.outputUrl }
    return $null
}

function Post-Instagram {
    param(
        [string]$caption,
        [string]$mediaUrl,
        [string]$targetType   # "instagram" oder "instagramStory"
    )

    $payload = @{
        post = @{
            accountId = $accountIdIG
            content   = @{
                text      = $caption
                platform  = "instagram"
                mediaUrls = @($mediaUrl)
            }
            target    = @{ targetType = $targetType }
        }
    }

    $json      = $payload | ConvertTo-Json -Depth 10 -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $headers   = @{
        "blotato-api-key" = $apiKey
        "Content-Type"    = "application/json; charset=utf-8"
    }

    Write-Log "Poste auf Instagram ($targetType): Caption-Laenge $($caption.Length) Zeichen"

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/posts" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "Instagram OK. SubmissionId: $($response.postSubmissionId)"
        return $true
    } catch {
        Write-Log "FEHLER Instagram-Post: $_"
        return $false
    }
}

# ============================================================
# HAUPTLOGIK
# ============================================================
$heute = (Get-Date).ToString("dd.MM.yyyy")
$jetzt = Get-Date

Write-Log "=== Trigger gestartet | Heute: $heute | Jetzt: $($jetzt.ToString('HH:mm')) ==="

try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV konnte nicht gelesen werden: $_"
    exit 1
}

$heuteRows = $rows | Where-Object { $_.Datum -eq $heute -and $_.Status -eq "Geplant" -and $_.Plattform -eq "Instagram" }

if (-not $heuteRows) {
    Write-Log "Kein geplanter Instagram-Post fuer heute. Fertig."
    exit 0
}

Write-Log "$(@($heuteRows).Count) Instagram-Post(s) fuer heute gefunden."

foreach ($row in $heuteRows) {

    $typ     = $row.'Post-Typ'.Trim()
    $uhrzeit = $row.Uhrzeit.Trim()

    if ($typ -eq "Karussell") {
        Write-Log "Karussell uebersprungen (nicht implementiert)."
        continue
    }

    # Zeitfenster pruefen
    try {
        $postZeit    = [datetime]::ParseExact("$heute $uhrzeit", "dd.MM.yyyy HH:mm", $null)
        $diffMinuten = ($jetzt - $postZeit).TotalMinutes
        if ($diffMinuten -lt $zeitfensterFrueh -or $diffMinuten -gt $zeitfensterSpaet) {
            Write-Log "Zeitfenster nicht passend fuer $typ um $uhrzeit (diff: $([math]::Round($diffMinuten,1)) min)."
            continue
        }
    } catch {
        Write-Log "WARNUNG: Uhrzeit '$uhrzeit' konnte nicht geparst werden."
    }

    Write-Log "Post faellig: $typ | $uhrzeit"

    $imageSource = $row.Videoprompt.Trim()
    $textOverlay = $row.'Text-Overlay'.Trim()
    $caption     = $row.Text

    # Fallback: wenn kein Videoprompt, Bild-URL direkt nutzen
    if (-not $imageSource -or $imageSource -eq "") {
        $imageSource = $row.'Bild-URL'.Trim()
    }

    if (-not $imageSource -or $imageSource -eq "") {
        Write-Log "FEHLER: Weder Videoprompt noch Bild-URL vorhanden. Post uebersprungen."
        continue
    }

    # Slideshow erstellen
    $slideshowResponse = Create-Slideshow -imageSource $imageSource -textOverlay $textOverlay -typ $typ
    if (-not $slideshowResponse) {
        Write-Log "Slideshow-Erstellung fehlgeschlagen. Post uebersprungen."
        continue
    }

    # Video-URL aus Response extrahieren
    $videoUrl = Get-VideoUrl -response $slideshowResponse
    if (-not $videoUrl) {
        Write-Log "Keine Video-URL in Response. Volle Response: $($slideshowResponse | ConvertTo-Json -Depth 5)"
        Write-Log "Post uebersprungen."
        continue
    }

    Write-Log "Video-URL: $videoUrl"

    # targetType bestimmen
    $targetType = if ($typ -eq "Story") { "instagramStory" } else { "instagram" }

    # Auf Instagram posten
    $erfolg = Post-Instagram -caption $caption -mediaUrl $videoUrl -targetType $targetType

    if ($erfolg) {
        # Archiv
        if (-not (Test-Path $archivPath)) {
            "Zeitstempel,Datum,Uhrzeit,Post-Typ,Plattform,Media-URL,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
        }
        $archivZeile = "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$uhrzeit`",`"$typ`",`"Instagram`",`"$videoUrl`",`"$($caption -replace '"','""')`""
        $archivZeile | Out-File -FilePath $archivPath -Append -Encoding UTF8

        # Status setzen
        $rows | ForEach-Object {
            if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and $_.Plattform -eq "Instagram" -and $_.Status -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf 'Gepostet' gesetzt."
    }
}

Write-Log "=== Fertig ==="
