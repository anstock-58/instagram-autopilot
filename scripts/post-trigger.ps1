# post-trigger.ps1
# Liest das Contentplan-CSV, findet den heutigen Post und feuert den Make.com Webhook.
# Laeuft taeglich um 17:55 Uhr via Windows Task Scheduler oder GitHub Actions.

# Basis-Pfad: GitHub Actions oder lokaler PC
$basePath   = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }

$csvPath    = Join-Path $basePath "outputs\contentplan_mai_v2.csv"
$webhookUrl = if ($env:NEUSTART_WEBHOOK_URL) { $env:NEUSTART_WEBHOOK_URL } else { "https://hook.eu1.make.com/q1np77hliej89lqdl38ux1bgj9as5xdw" }
$logPath    = Join-Path $basePath "outputs\post-trigger-log.txt"
$archivPath = Join-Path $basePath "outputs\post-archiv.csv"

$heute = (Get-Date).ToString("dd.MM.yyyy")

function Write-Log {
    param([string]$msg)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $msg"
    $line | Out-File -FilePath $logPath -Append -Encoding UTF8
    Write-Output $line
}

Write-Log "=== Trigger gestartet | Heute: $heute ==="

try {
    $rows = Import-Csv -Path $csvPath -Delimiter "," -Encoding UTF8
} catch {
    Write-Log "FEHLER: CSV konnte nicht gelesen werden: $_"
    exit 1
}

$heuteRows = $rows | Where-Object { $_.Datum -eq $heute -and $_.Status -eq "Geplant" }

if (-not $heuteRows) {
    Write-Log "Kein Post fuer heute gefunden (oder bereits gepostet). Nichts zu tun."
    exit 0
}

foreach ($heuteRow in $heuteRows) {
    $typ       = $heuteRow.'Post-Typ'.Trim()
    $plattform = $heuteRow.Plattform.Trim()

    Write-Log "Post gefunden: $typ | $plattform"

    if ($plattform -eq "Facebook") {
        Write-Log "Facebook-Post uebersprungen (noch nicht implementiert)."
        continue
    }

    if ($typ -eq "Karussell") {
        Write-Log "Karussell uebersprungen (noch nicht implementiert)."
        continue
    }

    $erlaubteTypen = @("Reel", "Foto", "Text")
    if ($erlaubteTypen -notcontains $typ) {
        Write-Log "Unbekannter Post-Typ '$typ' - uebersprungen."
        continue
    }

    $musikUrl = $heuteRow.'Musik-URL'.Trim()

    $payload = @{
        post_typ    = $typ
        plattform   = $plattform
        text        = $heuteRow.Text
        link        = $heuteRow.Link
        bildprompt  = $heuteRow.Bildprompt
        videoprompt = $heuteRow.Videoprompt
        textoverlay = ($heuteRow.'Text-Overlay' -replace "`r`n", "\n" -replace "`n", "\n").Trim()
        musikurl    = $musikUrl
        datum       = $heute
    }

    $json = $payload | ConvertTo-Json -Compress
    Write-Log "Sende Payload: $json"

    try {
        $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
        $response = Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $jsonBytes -ContentType "application/json; charset=utf-8" -ErrorAction Stop
        Write-Log "Webhook erfolgreich. Antwort: $($response | ConvertTo-Json -Compress)"

        # Archiv-Eintrag schreiben
        $archivZeile = "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$typ`",`"$plattform`",`"$($heuteRow.Videoprompt)`",`"$($heuteRow.Text -replace '"','""')`""
        if (-not (Test-Path $archivPath)) {
            "Zeitstempel,Datum,Post-Typ,Plattform,Videoprompt,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
        }
        $archivZeile | Out-File -FilePath $archivPath -Append -Encoding UTF8
        Write-Log "Archiv-Eintrag gespeichert: $archivPath"

        # Status im CSV auf "Gepostet" setzen
        $rows | ForEach-Object {
            if ($_.Datum -eq $heute -and $_.Plattform -eq $plattform -and $_.Status -eq "Geplant") {
                $_.Status = "Gepostet"
            }
        }
        $rows | Export-Csv -Path $csvPath -Delimiter "," -Encoding UTF8 -NoTypeInformation
        Write-Log "Status auf 'Gepostet' gesetzt: $plattform | $typ"

    } catch {
        Write-Log "FEHLER Webhook ($plattform | $typ): $_"
    }
}

Write-Log "=== Fertig ==="
