# post-trigger-linkedin-dropservice.ps1
# Postet LinkedIn-Posts fuer Dropservice-Profil (AI Creatives) via Blotato REST API.
# Laeuft via GitHub Actions (workflow_dispatch, getriggert von cron-job.org).
#
# Benoetigte GitHub Secrets:
#   BLOTATO_API_KEY       -- Blotato API Key
#   LINKEDIN_ACCESS_TOKEN -- LinkedIn OAuth Token (alle 2 Monate erneuern)
#   LINKEDIN_PERSON_URN   -- urn:li:person:TVPJInaVk9

# ============================================================
# KONFIGURATION
# ============================================================
$basePath    = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }
$outputsPath = Join-Path $basePath "outputs"
$logPath     = Join-Path $outputsPath "post-trigger-linkedin-dropservice-log.txt"
$archivPath  = Join-Path $outputsPath "post-archiv-linkedin-dropservice.csv"

# CSV automatisch nach aktuellem Monat waehlen
$monatMap = @{1="januar";2="februar";3="maerz";4="april";5="mai";6="juni";
              7="juli";8="august";9="september";10="oktober";11="november";12="dezember"}
$monat    = $monatMap[(Get-Date).Month]
$csvNamen = @(
    "contentplan_linkedin_dropservice_${monat}_v2.csv",
    "contentplan_linkedin_dropservice_${monat}_v1.csv"
)
$csvPath = $null
foreach ($name in $csvNamen) {
    $pfad = Join-Path $outputsPath $name
    if (Test-Path $pfad) { $csvPath = $pfad; break }
}
if (-not $csvPath) {
    Write-Output "FEHLER: Kein Dropservice-CSV fuer Monat '$monat' gefunden."
    exit 1
}

# API-Zugangsdaten aus Env-Vars (GitHub Secrets)
$apiKey      = if ($env:BLOTATO_API_KEY)       { $env:BLOTATO_API_KEY }       else { "blt_KiCyq1rBxLUqnWdUJaH6Qaij4V07Q6wvcIH8/aQLrXA=" }
$liToken     = if ($env:LINKEDIN_ACCESS_TOKEN)  { $env:LINKEDIN_ACCESS_TOKEN }  else { "" }
$liPersonUrn = if ($env:LINKEDIN_PERSON_URN)    { $env:LINKEDIN_PERSON_URN }    else { "urn:li:person:TVPJInaVk9" }
$apiBase     = "https://backend.blotato.com/v2"
$accountIdLI = "21657"   # Dropservice-Profil (Ersu Consulting / Leon Weidner)

$ersterKommentar = "Du willst sehen wie das fuer dein Business aussieht? Schreib mir DEMO -- ich zeig dir in 20 Minuten ein fertiges Beispiel fuer deinen Account."

# Pause-Datei
$pauseDS = Join-Path $outputsPath "pause_linkedin_dropservice.txt"

# Zeitfenster: -30 bis +90 Minuten
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
    }

    $json      = $payloadObj | ConvertTo-Json -Depth 10 -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $headers   = @{
        "blotato-api-key" = $apiKey
        "Content-Type"    = "application/json; charset=utf-8"
    }

    Write-Log "Sende an Blotato Dropservice: $($caption.Length) Zeichen, Bild: $(if($mediaUrl -and $mediaUrl.Trim() -ne ''){'ja'}else{'nein'})"

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/posts" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "Dropservice LinkedIn gepostet. SubmissionId: $($response.postSubmissionId)"
        return $response.postSubmissionId
    } catch {
        Write-Log "FEHLER beim LinkedIn-Post: $_"
        return $null
    }
}

function Get-NeuesterLinkedInPostUrn {
    $headers = @{ "blotato-api-key" = $apiKey }
    $maxWait = 36
    Write-Log "Warte auf neuen LinkedIn-Post (max 3 Min)..."

    for ($i = 1; $i -le $maxWait; $i++) {
        Start-Sleep -Seconds 5
        try {
            $r = Invoke-RestMethod -Uri "$apiBase/posts?limit=5" -Method GET -Headers $headers -ErrorAction Stop
            $liPost = $r.items | Where-Object { $_.platform -eq "linkedin" -and $_.state.type -eq "published" -and $_.state.postUrl } | Select-Object -First 1
            if ($liPost) {
                $postUrl = $liPost.state.postUrl
                Write-Log "Post-URL gefunden ($i): $postUrl"
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

    $tempFile = [System.IO.Path]::GetTempFileName()
    $safeText = $kommentarText -replace '\\', '\\\\' -replace '"', '\"'
    [System.IO.File]::WriteAllText($tempFile, "{`"actor`":`"$liPersonUrn`",`"message`":{`"text`":`"$safeText`"}}", [System.Text.Encoding]::UTF8)

    $urnEncoded = [Uri]::EscapeDataString($shareUrn)

    $result = & curl -s -w "`nHTTP_CODE:%{http_code}" --max-time 15 `
        -X POST `
        "https://api.linkedin.com/v2/socialActions/$urnEncoded/comments" `
        -H "Authorization: Bearer $liToken" `
        -H "Content-Type: application/json" `
        -H "X-Restli-Protocol-Version: 2.0.0" `
        --data-binary "@$tempFile"

    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

    $httpCode = if ($result -match "HTTP_CODE:(\d+)") { $Matches[1] } else { "000" }
    if ($httpCode -eq "201") {
        Write-Log "Erster Kommentar gesetzt."
        return $true
    } else {
        Write-Log "FEHLER Kommentar (HTTP $httpCode): $($result -replace 'HTTP_CODE:\d+', '')"
        return $false
    }
}

# ============================================================
# HAUPTLOGIK
# ============================================================
$heute = (Get-Date).ToString("dd.MM.yyyy")
$jetzt = Get-Date

Write-Log "=== Dropservice LinkedIn Trigger | $heute | $($jetzt.ToString('HH:mm')) | CSV: $(Split-Path $csvPath -Leaf) ==="

if (Test-Path $pauseDS) {
    Write-Log "Dropservice LinkedIn pausiert (pause_linkedin_dropservice.txt). Abbruch."
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
    Write-Log "Kein geplanter Dropservice-Post fuer heute ($heute). Fertig."
    exit 0
}

Write-Log "$(@($heuteRows).Count) Dropservice-Post(s) fuer heute gefunden."

foreach ($row in $heuteRows) {

    $typ     = $row.'Post-Typ'.Trim()
    $uhrzeit = $row.Uhrzeit.Trim()

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

    $submissionId = Post-LinkedIn -caption $caption -mediaUrl $mediaUrl

    if ($submissionId) {
        if (-not (Test-Path $archivPath)) {
            "Zeitstempel,Datum,Uhrzeit,Post-Typ,Plattform,Media-URL,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
        }
        "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$uhrzeit`",`"$typ`",`"LinkedIn-Dropservice`",`"$mediaUrl`",`"$($caption -replace '"','""')`"" |
            Out-File -FilePath $archivPath -Append -Encoding UTF8

        $rows | ForEach-Object {
            if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and $_.Plattform -eq "LinkedIn" -and $_.Status -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf 'Gepostet' gesetzt."

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
