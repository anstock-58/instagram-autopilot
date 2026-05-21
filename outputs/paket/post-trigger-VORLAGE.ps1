# post-trigger.ps1
# Liest den Contentplan, findet den heutigen Post und sendet ihn an Make.com.
# Laeuft taeglich automatisch via Windows Task Scheduler.
#
# ============================================================
# EINRICHTUNG: Ersetze die drei Werte unten mit deinen eigenen
# ============================================================

$csvPath    = "C:\DEIN-PFAD\contentplan.csv"          # Pfad zu deiner CSV-Datei
$webhookUrl = "https://hook.eu1.make.com/DEIN-WEBHOOK" # Deine Make.com Webhook-URL
$logPath    = "C:\DEIN-PFAD\post-trigger-log.txt"      # Pfad fuer die Log-Datei

# ============================================================

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

$heuteRow = $rows | Where-Object { $_.Datum -eq $heute } | Select-Object -First 1

if (-not $heuteRow) {
    Write-Log "Kein Post fuer heute gefunden. Nichts zu tun."
    exit 0
}

$typ       = $heuteRow.'Post-Typ'.Trim()
$plattform = $heuteRow.Plattform.Trim()

Write-Log "Post gefunden: $typ | $plattform"

if ($typ -eq "Karussell") {
    Write-Log "Karussell uebersprungen (noch nicht implementiert)."
    exit 0
}

if ($typ -ne "Reel" -and $typ -ne "Foto") {
    Write-Log "Unbekannter Post-Typ '$typ' - uebersprungen."
    exit 0
}

$musikUrl = $heuteRow.'Musik-URL'.Trim()

$payload = @{
    post_typ    = $typ
    plattform   = $plattform
    text        = $heuteRow.Text
    link        = $heuteRow.Link
    videoprompt = $heuteRow.Videoprompt
    textoverlay = ($heuteRow.'Text-Overlay' -replace "`r`n", "\n" -replace "`n", "\n").Trim()
    musikurl    = $musikUrl
    datum       = $heute
}

$json = $payload | ConvertTo-Json -Compress

try {
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $response = Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $jsonBytes -ContentType "application/json; charset=utf-8" -ErrorAction Stop
    Write-Log "Webhook erfolgreich."
} catch {
    Write-Log "FEHLER Webhook: $_"
    exit 1
}

Write-Log "=== Fertig ==="
