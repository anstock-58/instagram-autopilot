# post-trigger.ps1
# Liest das Contentplan-CSV, findet den heutigen Post und postet direkt ueber Blotato REST API.
# Laeuft taeglich via Windows Task Scheduler (09:00 Story, 18:00 Reel).
# Kein Make.com, kein Webhook — reiner Blotato-Direct-Post.

# ============================================================
# KONFIGURATION
# ============================================================
$basePath      = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }
$csvPath       = Join-Path $basePath "outputs" "contentplan_juni_v1.csv"
$logPath       = Join-Path $basePath "outputs" "post-trigger-log.txt"
$archivPath    = Join-Path $basePath "outputs" "post-archiv.csv"

$apiKey        = if ($env:BLOTATO_API_KEY) { $env:BLOTATO_API_KEY } else { "blt_KiCyq1rBxLUqnWdUJaH6Qaij4V07Q6wvcIH8/aQLrXA=" }
$apiBase       = "https://backend.blotato.com/v2"
$accountId     = "46248"   # @business.und.spirit

# Zeitfenster: Post gilt als "jetzt faellig" wenn er -10 bis +45 Minuten um die geplante Zeit liegt
# (-10 weil Task 5 Minuten VOR der Postzeit startet, z.B. 08:55 fuer 09:00-Post)
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

function Post-Blotato {
    param(
        [string]$caption,
        [string]$mediaUrl,
        [string]$targetType   # "instagram" fuer Feed/Reel, "instagramStory" fuer Story
    )

    # Payload als JSON bauen
    $payloadObj = @{
        post = @{
            accountId = $accountId
            content   = @{
                text      = $caption
                platform  = "instagram"
            }
            target    = @{
                targetType = $targetType
            }
        }
    }

    # Media-URL nur hinzufuegen wenn vorhanden
    if ($mediaUrl -and $mediaUrl.Trim() -ne "") {
        $payloadObj.post.content.mediaUrls = @($mediaUrl.Trim())
    }

    $json      = $payloadObj | ConvertTo-Json -Depth 10 -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $headers   = @{
        "blotato-api-key" = $apiKey
        "Content-Type"    = "application/json; charset=utf-8"
    }

    Write-Log "Sende an Blotato ($targetType): $json"

    try {
        $response = Invoke-RestMethod -Uri "$apiBase/posts" -Method POST -Headers $headers -Body $jsonBytes -ErrorAction Stop
        Write-Log "Blotato OK. SubmissionId: $($response.postSubmissionId)"
        return $true
    } catch {
        Write-Log "FEHLER Blotato-Post: $_"
        return $false
    }
}

# ============================================================
# HAUPTLOGIK
# ============================================================
$heute    = (Get-Date).ToString("dd.MM.yyyy")
$jetzt    = Get-Date

Write-Log "=== Trigger gestartet | Heute: $heute | Jetzt: $($jetzt.ToString('HH:mm')) ==="

# CSV laden
try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV konnte nicht gelesen werden: $_"
    exit 1
}

# Heutige, geplante Posts filtern
$heuteRows = $rows | Where-Object { $_.Datum -eq $heute -and $_.Status -eq "Geplant" }

if (-not $heuteRows) {
    Write-Log "Kein geplanter Post fuer heute gefunden. Nichts zu tun."
    exit 0
}

Write-Log "$(@($heuteRows).Count) Post(s) fuer heute gefunden — pruefe Zeitfenster..."

foreach ($row in $heuteRows) {

    $typ       = $row.'Post-Typ'.Trim()
    $plattform = $row.Plattform.Trim()
    $uhrzeit   = $row.Uhrzeit.Trim()    # Format: "09:00" oder "18:00"

    # Plattform und Typ pruefen
    if ($plattform -eq "Facebook") {
        Write-Log "Facebook uebersprungen (noch nicht implementiert)."
        continue
    }
    if ($typ -eq "Karussell") {
        Write-Log "Karussell uebersprungen (noch nicht implementiert)."
        continue
    }
    $erlaubteTypen = @("Reel", "Foto", "Story", "Text")
    if ($erlaubteTypen -notcontains $typ) {
        Write-Log "Unbekannter Post-Typ '$typ' — uebersprungen."
        continue
    }

    # Zeitfenster pruefen
    try {
        $postZeit   = [datetime]::ParseExact("$heute $uhrzeit", "dd.MM.yyyy HH:mm", $null)
        $diffMinuten = ($jetzt - $postZeit).TotalMinutes
        if ($diffMinuten -lt $zeitfensterFrueh -or $diffMinuten -gt $zeitfensterSpaet) {
            Write-Log "Zeitfenster nicht passend fuer $typ um $uhrzeit (diff: $([math]::Round($diffMinuten,1)) min) — uebersprungen."
            continue
        }
    } catch {
        Write-Log "WARNUNG: Uhrzeit '$uhrzeit' konnte nicht geparst werden — Post wird trotzdem gesendet."
    }

    Write-Log "Post faellig: $typ | $plattform | $uhrzeit"

    # Media-URL holen
    $mediaUrl = $row.'Bild-URL'.Trim()
    if (-not $mediaUrl -or $mediaUrl -eq "") {
        Write-Log "WARNUNG: Keine Bild-URL/Video-URL in CSV fuer $typ am $heute um $uhrzeit."
        Write-Log "Bitte URL manuell in CSV eintragen. Post wird OHNE Bild gesendet (nur Caption)."
        # Fuer Stories ohne Bild macht kein Sinn — ueberspringen
        if ($typ -eq "Story") {
            Write-Log "Story ohne Bild uebersprungen."
            continue
        }
    }

    # Blotato targetType bestimmen
    $targetType = switch ($typ) {
        "Story"          { "instagramStory" }
        "Reel"           { "instagram"       }
        "Foto"           { "instagram"       }
        "Text"           { "instagram"       }
        default          { "instagram"       }
    }

    # Caption (Text + Musik-URL wird NICHT an Blotato uebergeben — Musik separat via UI)
    $caption = $row.Text

    # Posten
    $erfolg = Post-Blotato -caption $caption -mediaUrl $mediaUrl -targetType $targetType

    if ($erfolg) {
        # Archiv-Eintrag
        if (-not (Test-Path $archivPath)) {
            "Zeitstempel,Datum,Uhrzeit,Post-Typ,Plattform,Media-URL,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
        }
        $archivZeile = "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$uhrzeit`",`"$typ`",`"$plattform`",`"$mediaUrl`",`"$($caption -replace '"','""')`""
        $archivZeile | Out-File -FilePath $archivPath -Append -Encoding UTF8
        Write-Log "Archiv gespeichert."

        # Status im CSV auf "Gepostet" setzen
        $rows | ForEach-Object {
            if ($_.Datum -eq $heute -and $_.Uhrzeit -eq $uhrzeit -and $_.Plattform -eq $plattform -and $_.Status -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf 'Gepostet' gesetzt."
    }
}

Write-Log "=== Fertig ==="
