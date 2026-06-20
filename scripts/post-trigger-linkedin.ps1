# post-trigger-linkedin.ps1
# Postet LinkedIn-Posts via Blotato REST API und setzt automatisch den ersten Kommentar.
# Laeuft via GitHub Actions (workflow_dispatch, getriggert von cron-job.org).
#
# Benoetigte GitHub Secrets:
#   BLOTATO_API_KEY       -- Blotato API Key
#   LINKEDIN_ACCESS_TOKEN -- LinkedIn OAuth Token (alle 2 Monate erneuern)
#   LINKEDIN_PERSON_URN   -- urn:li:person:TVPJInaVk9

# ============================================================
# KONFIGURATION
# ============================================================
$basePath   = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }
$outputsPath = Join-Path $basePath "outputs"
$logPath    = Join-Path $outputsPath "post-trigger-linkedin-log.txt"
$archivPath = Join-Path $outputsPath "post-archiv-linkedin.csv"

# CSV automatisch nach aktuellem Monat waehlen
$monatMap = @{1="januar";2="februar";3="maerz";4="april";5="mai";6="juni";
              7="juli";8="august";9="september";10="oktober";11="november";12="dezember"}
$monat    = $monatMap[(Get-Date).Month]
$csvNamen = @(
    "contentplan_linkedin_${monat}_v2.csv",
    "contentplan_linkedin_${monat}_v1.csv",
    "contentplan_${monat}_v2.csv",
    "contentplan_${monat}_v1.csv"
)
$csvPath = $null
foreach ($name in $csvNamen) {
    $pfad = Join-Path $outputsPath $name
    if (Test-Path $pfad) { $csvPath = $pfad; break }
}
if (-not $csvPath) {
    Write-Output "FEHLER: Kein CSV fuer Monat '$monat' gefunden."
    exit 1
}

# API-Zugangsdaten aus Env-Vars (GitHub Secrets)
$apiKey       = if ($env:BLOTATO_API_KEY) { $env:BLOTATO_API_KEY } else { "blt_KiCyq1rBxLUqnWdUJaH6Qaij4V07Q6wvcIH8/aQLrXA=" }
$liToken      = if ($env:LINKEDIN_ACCESS_TOKEN) { $env:LINKEDIN_ACCESS_TOKEN } else { "AQUG9awTudfi_YV61hZFa5WQmwyYTkc68sMtXGVkbAifgc6fhR1BLWJmW_qp2HPx2zLVci5UAHI7KTgPzrfUhAx-dnShKC3jUYo0Na1DzHX3DZTLCHHEuOlmBlw82E9BZIYe9Z426gN7oVN5uM2g4Mu1CVXKkQKDnPQs_XiaiQZGts-rv8UbxMBuMpSWe9MpETWkMR-yP26tWmzYFQz-pRgeKcPTvaJ8jftWbFDvpGuwzsJDDAyxV2Q2XpPaAhpwCC3vGH7UHHAfnsKiQKMuVhlPR4_QEkkHW-BfZQofcTxXiBE0-rs8fautgrzySu7QqwiZAwhHOeAwpsIjKj9X4RvRboMIvg" }
$liPersonUrn  = if ($env:LINKEDIN_PERSON_URN)   { $env:LINKEDIN_PERSON_URN }   else { "urn:li:person:TVPJInaVk9" }
$apiBase      = "https://backend.blotato.com/v2"
$accountIdLI  = "21656"

$ersterKommentar = "Mach den Standort-Check und erkenne, ob du im Funktionsmodus bist. Hier kannst du ihn kostenlos herunterladen: https://sicher-weiterlesen.com/standortcheck"

# Pause-Datei (lokal oder im Repo)
$pauseLI = Join-Path $outputsPath "pause_linkedin.txt"

# Zeitfenster: -30 bis +90 Minuten (grosszuegig fuer GitHub Actions Delays)
$zeitfensterFrueh = -30
$zeitfensterSpaet = 90

# ============================================================
# HILFSFUNKTIONEN
# ============================================================
function Write-Log {
    param([string]$msg)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $msg"
    $line | Out-File -FilePath $logPath -Append -Encoding UTF8
    Write-Host $line
}

function Post-LinkedIn {
    param([string]$caption, [string]$mediaUrl)

    $payloadObj = @{
        post = @{
            accountId = $accountIdLI
            content   = @{
                text     = $caption
                platform = "linkedin"
            }
            target = @{ targetType = "linkedin" }
        }
    }
    if ($mediaUrl -and $mediaUrl.Trim() -ne "") {
        $payloadObj.post.content.mediaUrls = @($mediaUrl.Trim())
    } else {
        $payloadObj.post.content.mediaUrls = @()
    }

    $json      = $payloadObj | ConvertTo-Json -Depth 10 -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $headers   = @{
        "blotato-api-key" = $apiKey
        "Content-Type"    = "application/json; charset=utf-8"
    }

    Write-Log "Sende an Blotato LinkedIn: $($caption.Length) Zeichen, Bild: $(if($mediaUrl -and $mediaUrl.Trim() -ne ''){'ja'}else{'nein'})"

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/posts" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "LinkedIn gepostet. SubmissionId: $($response.postSubmissionId)"
        return $response.postSubmissionId
    } catch {
        Write-Log "FEHLER beim LinkedIn-Post: $_"
        return $null
    }
}

function Get-NeuesterLinkedInPostUrn {
    # Holt die Share-URN des neuesten LinkedIn-Posts via Blotato GET /v2/posts
    # Wartet bis zu 3 Minuten auf den neuen Post
    $headers = @{ "blotato-api-key" = $apiKey }
    $maxWait = 36   # 36 x 5 Sekunden = 3 Minuten
    Write-Log "Warte auf neuen LinkedIn-Post (max 3 Min)..."

    for ($i = 1; $i -le $maxWait; $i++) {
        Start-Sleep -Seconds 5
        try {
            $r = Invoke-RestMethod -Uri "$apiBase/posts?limit=5" -Method GET -Headers $headers -ErrorAction Stop
            $liPost = $r.items | Where-Object { $_.platform -eq "linkedin" -and $_.state.type -eq "published" -and $_.state.postUrl } | Select-Object -First 1
            if ($liPost) {
                $postUrl = $liPost.state.postUrl
                Write-Log "Post-URL gefunden ($i): $postUrl"
                # URN aus URL extrahieren: https://linkedin.com/feed/update/urn:li:share:XXXX
                if ($postUrl -match "urn:li:[^/\s?&]+") {
                    return $Matches[0]
                }
            }
        } catch {
            Write-Log "Fehler beim Blotato-Status-Check: $_"
        }
    }
    Write-Log "Timeout: LinkedIn-Post-URL nach 3 Minuten nicht gefunden."
    return $null
}

function Post-LinkedInKommentar {
    param([string]$shareUrn, [string]$kommentarText)

    $urnEncoded = [Uri]::EscapeDataString($shareUrn)
    $bodyObj = @{
        actor   = $liPersonUrn
        message = @{ text = $kommentarText }
    }
    $bodyJson  = $bodyObj | ConvertTo-Json -Compress
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($bodyJson)
    $headers   = @{
        "Authorization"              = "Bearer $liToken"
        "Content-Type"               = "application/json"
        "X-Restli-Protocol-Version"  = "2.0.0"
    }

    try {
        Invoke-RestMethod -Uri "https://api.linkedin.com/v2/socialActions/$urnEncoded/comments" `
            -Method POST -Headers $headers -Body $bodyBytes -ErrorAction Stop | Out-Null
        Write-Log "Erster Kommentar gesetzt."
        return $true
    } catch {
        $code = $_.Exception.Response.StatusCode.value__
        Write-Log "FEHLER Kommentar (HTTP $code): $($_.Exception.Message)"
        return $false
    }
}

# ============================================================
# HAUPTLOGIK
# ============================================================
$heute = (Get-Date).ToString("dd.MM.yyyy")
$jetzt = Get-Date

Write-Log "=== LinkedIn Trigger gestartet | $heute | $($jetzt.ToString('HH:mm')) | CSV: $(Split-Path $csvPath -Leaf) ==="

# Pause-Check
if (Test-Path $pauseLI) {
    Write-Log "LinkedIn pausiert (pause_linkedin.txt). Abbruch."
    exit 0
}

try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV nicht lesbar: $_"
    exit 1
}

$heuteRows = $rows | Where-Object {
    $_.Datum -eq $heute -and $_.Status -eq "Geplant" -and $_.Plattform -eq "LinkedIn"
}

if (-not $heuteRows) {
    Write-Log "Kein geplanter LinkedIn-Post fuer heute ($heute). Fertig."
    exit 0
}

Write-Log "$(@($heuteRows).Count) LinkedIn-Post(s) fuer heute gefunden."

foreach ($row in $heuteRows) {

    $typ     = $row.'Post-Typ'.Trim()
    $uhrzeit = $row.Uhrzeit.Trim()

    # Zeitfenster pruefen
    try {
        $postZeit    = [datetime]::ParseExact("$heute $uhrzeit", "dd.MM.yyyy HH:mm", $null)
        $diffMinuten = ($jetzt - $postZeit).TotalMinutes
        if ($diffMinuten -lt $zeitfensterFrueh -or $diffMinuten -gt $zeitfensterSpaet) {
            Write-Log "Zeitfenster nicht passend fuer $typ um $uhrzeit (diff: $([math]::Round($diffMinuten,1)) min)."
            continue
        }
    } catch {
        Write-Log "WARNUNG: Uhrzeit '$uhrzeit' konnte nicht geparst werden -- uebersprungen."
        continue
    }

    Write-Log "Post faellig: $typ | $uhrzeit"

    $mediaUrl = $row.'Bild-URL'.Trim()
    $caption  = $row.Text

    if ($typ -eq "Foto" -and (-not $mediaUrl -or $mediaUrl -eq "")) {
        Write-Log "Foto-Post ohne Bild-URL -- uebersprungen."
        continue
    }

    # Posten
    $submissionId = Post-LinkedIn -caption $caption -mediaUrl $mediaUrl

    if ($submissionId) {
        # Archiv
        if (-not (Test-Path $archivPath)) {
            "Zeitstempel,Datum,Uhrzeit,Post-Typ,Plattform,Media-URL,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
        }
        "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$uhrzeit`",`"$typ`",`"LinkedIn`",`"$mediaUrl`",`"$($caption -replace '"','""')`"" |
            Out-File -FilePath $archivPath -Append -Encoding UTF8

        # Status setzen
        $rows | ForEach-Object {
            if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and $_.Plattform -eq "LinkedIn" -and $_.Status -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf 'Gepostet' gesetzt."

        # Erster Kommentar
        $shareUrn = Get-NeuesterLinkedInPostUrn
        if ($shareUrn) {
            Write-Log "Share-URN: $shareUrn"
            Post-LinkedInKommentar -shareUrn $shareUrn -kommentarText $ersterKommentar
        } else {
            Write-Log "WARNUNG: Kein erster Kommentar gesetzt -- URN nicht gefunden."
        }
    }
}

Write-Log "=== Fertig ==="
