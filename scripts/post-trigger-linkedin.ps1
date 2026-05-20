# post-trigger-linkedin.ps1
# Postet LinkedIn-Posts via Blotato REST API + setzt automatisch ersten Kommentar.
# Laeuft taeglich via Windows Task um 17:55 Uhr.
#
# HINWEIS: LinkedIn Access Token laeuft ca. alle 2 Monate ab.
# Neues Token holen: OAuth-Flow mit scope "openid profile w_member_social"
# Client ID: 77bep19aqx7m00 -- Details in context/secrets.md

# ============================================================
# KONFIGURATION
# ============================================================
$basePath   = "C:\Users\andre\claude-workspace-vorlage"
$logPath    = Join-Path (Join-Path $basePath "outputs") "post-trigger-log.txt"
$archivPath = Join-Path (Join-Path $basePath "outputs") "post-archiv.csv"

# CSV automatisch nach aktuellem Monat waehlen
$monatMap = @{1="januar";2="februar";3="maerz";4="april";5="mai";6="juni";
              7="juli";8="august";9="september";10="oktober";11="november";12="dezember"}
$monat    = $monatMap[(Get-Date).Month]
$csvNamen = @("contentplan_${monat}_v2.csv", "contentplan_${monat}_v1.csv")
$csvPath  = $null
foreach ($name in $csvNamen) {
    $pfad = Join-Path (Join-Path $basePath "outputs") $name
    if (Test-Path $pfad) { $csvPath = $pfad; break }
}
if (-not $csvPath) { Write-Output "FEHLER: Kein CSV fuer Monat '$monat' gefunden."; exit 1 }

# Blotato
$apiKey      = "blt_KiCyq1rBxLUqnWdUJaH6Qaij4V07Q6wvcIH8/aQLrXA="
$apiBase     = "https://backend.blotato.com/v2"
$accountIdLI = "21656"   # LinkedIn Dipl.-Ing. Andreas Stock

# LinkedIn OAuth fuer Kommentare
$liToken   = "AQUG9awTudfi_YV61hZFa5WQmwyYTkc68sMtXGVkbAifgc6fhR1BLWJmW_qp2HPx2zLVci5UAHI7KTgPzrfUhAx-dnShKC3jUYo0Na1DzHX3DZTLCHHEuOlmBlw82E9BZIYe9Z426gN7oVN5uM2g4Mu1CVXKkQKDnPQs_XiaiQZGts-rv8UbxMBuMpSWe9MpETWkMR-yP26tWmzYFQz-pRgeKcPTvaJ8jftWbFDvpGuwzsJDDAyxV2Q2XpPaAhpwCC3vGH7UHHAfnsKiQKMuVhlPR4_QEkkHW-BfZQofcTxXiBE0-rs8fautgrzySu7QqwiZAwhHOeAwpsIjKj9X4RvRboMIvg"
$liPersonUrn = "urn:li:person:TVPJInaVk9"
$ersterKommentar = "Mach den Standort-Check und erkenne, ob du im Funktionsmodus bist. Hier kannst du ihn kostenlos herunterladen: https://sicher-weiterlesen.com/standortcheck"

# Pause-Datei
$pauseLI = Join-Path (Join-Path $basePath "outputs") "pause_linkedin.txt"

# Zeitfenster: -10 bis +45 Minuten um die geplante Zeit
$zeitfensterFrueh = -10
$zeitfensterSpaet = 45

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

    Write-Log "Sende an Blotato LinkedIn: Caption $($caption.Length) Zeichen, Bild: $(if($mediaUrl){'ja'}else{'nein'})"

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/posts" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "LinkedIn OK. SubmissionId: $($response.postSubmissionId)"
        return $response.postSubmissionId
    } catch {
        Write-Log "FEHLER LinkedIn-Post: $_"
        return $null
    }
}

function Wait-ForLinkedInPostUrl {
    param([string]$submissionId)
    # Wartet bis Blotato den Post als "published" meldet und gibt die LinkedIn-Post-URL zurueck
    $headers = @{ "blotato-api-key" = $apiKey }
    $maxWait = 24   # 24 x 5 Sekunden = 2 Minuten
    Write-Log "Warte auf LinkedIn Post-URL (Submission: $submissionId)..."

    for ($i = 1; $i -le $maxWait; $i++) {
        Start-Sleep -Seconds 5
        try {
            $r = Invoke-RestMethod -Uri "$apiBase/posts/$submissionId" -Method GET -Headers $headers -ErrorAction Stop
            $state = $r.state.type
            Write-Log "Blotato Post-Status ($i): $state"
            if ($state -eq "published" -and $r.state.postUrl) {
                return $r.state.postUrl
            }
            if ($state -eq "failed" -or $state -eq "error") {
                Write-Log "Post fehlgeschlagen laut Blotato: $($r | ConvertTo-Json -Compress -Depth 3)"
                return $null
            }
        } catch {
            Write-Log "Fehler beim Blotato Status-Check: $_"
        }
    }
    Write-Log "Timeout: LinkedIn Post-URL nach 2 Minuten nicht verfuegbar."
    return $null
}

function Post-LinkedInKommentar {
    param([string]$shareUrn, [string]$kommentarText)
    # Nutzt curl.exe mit Temp-Datei um PS-Escaping-Probleme zu vermeiden
    $tempFile = Join-Path $env:TEMP "li_comment_payload.json"
    $safeText = $kommentarText -replace '"', '\"'
    "{`"actor`":`"$liPersonUrn`",`"message`":{`"text`":`"$safeText`"}}" | Out-File -FilePath $tempFile -Encoding utf8 -NoNewline

    $urnEncoded = [Uri]::EscapeDataString($shareUrn)
    $result = & curl.exe -s -w "`nHTTP_CODE:%{http_code}" --max-time 15 `
        -X POST `
        "https://api.linkedin.com/v2/socialActions/$urnEncoded/comments" `
        -H "Authorization: Bearer $liToken" `
        -H "Content-Type: application/json" `
        -H "X-Restli-Protocol-Version: 2.0.0" `
        -d "@$tempFile"

    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

    $httpCode = ($result | Select-String "HTTP_CODE:(\d+)").Matches.Groups[1].Value
    if ($httpCode -eq "201") {
        Write-Log "Erster Kommentar gesetzt. URN: $shareUrn"
        return $true
    } else {
        Write-Log "FEHLER Kommentar (HTTP $httpCode): $result"
        return $false
    }
}

# ============================================================
# HAUPTLOGIK
# ============================================================
$heute = (Get-Date).ToString("dd.MM.yyyy")
$jetzt = Get-Date

Write-Log "=== LinkedIn Trigger gestartet | Heute: $heute | Jetzt: $($jetzt.ToString('HH:mm')) ==="

# Pause-Check
if (Test-Path $pauseLI) {
    Write-Log "LinkedIn pausiert (pause_linkedin.txt gesetzt). Abbruch."
    exit 0
}

try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV konnte nicht gelesen werden: $_"
    exit 1
}

$heuteRows = $rows | Where-Object { $_.Datum -eq $heute -and $_.Status -eq "Geplant" -and $_.Plattform -eq "LinkedIn" }

if (-not $heuteRows) {
    Write-Log "Kein geplanter LinkedIn-Post fuer heute. Fertig."
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
        Write-Log "WARNUNG: Uhrzeit '$uhrzeit' konnte nicht geparst werden."
    }

    Write-Log "Post faellig: $typ | $uhrzeit"

    $mediaUrl = $row.'Bild-URL'.Trim()
    $caption  = $row.Text

    if ($typ -eq "Foto" -and (-not $mediaUrl -or $mediaUrl -eq "")) {
        Write-Log "LinkedIn Foto ohne Bild-URL - uebersprungen."
        continue
    }

    # Posten via Blotato
    $submissionId = Post-LinkedIn -caption $caption -mediaUrl $mediaUrl

    if ($submissionId) {
        # Archiv
        if (-not (Test-Path $archivPath)) {
            "Zeitstempel,Datum,Uhrzeit,Post-Typ,Plattform,Media-URL,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
        }
        $archivZeile = "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$uhrzeit`",`"$typ`",`"LinkedIn`",`"$mediaUrl`",`"$($caption -replace '"','""')`""
        $archivZeile | Out-File -FilePath $archivPath -Append -Encoding UTF8

        # Status auf Gepostet setzen
        $rows | ForEach-Object {
            if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and $_.Plattform -eq "LinkedIn" -and $_.Status -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf 'Gepostet' gesetzt."

        # Automatischer erster Kommentar
        $postUrl = Wait-ForLinkedInPostUrl -submissionId $submissionId
        if ($postUrl) {
            Write-Log "Post-URL: $postUrl"
            # Share-URN aus URL extrahieren: https://linkedin.com/feed/update/urn:li:share:XXXX
            if ($postUrl -match "urn:li:[^/\s]+") {
                $shareUrn = $Matches[0]
                Write-Log "Share-URN: $shareUrn"
                Start-Sleep -Seconds 5
                Post-LinkedInKommentar -shareUrn $shareUrn -kommentarText $ersterKommentar
            } else {
                Write-Log "WARNUNG: Konnte Share-URN nicht aus URL extrahieren: $postUrl"
            }
        } else {
            Write-Log "WARNUNG: Kein erster Kommentar gesetzt (Post-URL nicht verfuegbar)."
        }
    }
}

Write-Log "=== Fertig ==="
