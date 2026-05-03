# post-trigger-tac.ps1
# Liest den TAC-Contentplan, findet den heutigen Post und feuert den Make.com Webhook.
# Laeuft taeglich um 17:55 Uhr via GitHub Actions.

$basePath   = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }

$csvPath    = Join-Path $basePath "outputs\contentplan_tac_juni.csv"
$webhookUrl = $env:TAC_WEBHOOK_URL
$logPath    = Join-Path $basePath "outputs\post-trigger-tac-log.txt"
$archivPath = Join-Path $basePath "outputs\post-archiv-tac.csv"

$heute = (Get-Date).ToString("dd.MM.yyyy")

function Write-Log {
    param([string]$msg)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $msg"
    $line | Out-File -FilePath $logPath -Append -Encoding UTF8
    Write-Output $line
}

Write-Log "=== TAC Trigger gestartet | Heute: $heute ==="

if (-not $webhookUrl) {
    Write-Log "FEHLER: TAC_WEBHOOK_URL nicht gesetzt. Abbruch."
    exit 1
}

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

if ($plattform -eq "Facebook") {
    Write-Log "Facebook-Post uebersprungen (noch nicht implementiert)."
    exit 0
}

if ($typ -eq "Karussell") {
    Write-Log "Karussell uebersprungen (noch nicht implementiert)."
    exit 0
}

if ($typ -ne "Reel" -and $typ -ne "Foto") {
    Write-Log "Unbekannter Post-Typ '$typ' - uebersprungen."
    exit 0
}

$payload = @{
    post_typ    = $typ
    plattform   = $plattform
    text        = $heuteRow.Text
    link        = $heuteRow.Link
    bildprompt  = $heuteRow.Bildprompt
    videoprompt = $heuteRow.Videoprompt
    textoverlay = $heuteRow.'Text-Overlay'
    datum       = $heute
}

$json = $payload | ConvertTo-Json -Compress
Write-Log "Sende Payload: $json"

try {
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $response = Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $jsonBytes -ContentType "application/json; charset=utf-8" -ErrorAction Stop
    Write-Log "Webhook erfolgreich. Antwort: $($response | ConvertTo-Json -Compress)"

    $archivZeile = "`"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`",`"$heute`",`"$typ`",`"$plattform`",`"$($heuteRow.Videoprompt)`",`"$($heuteRow.Text -replace '"','""')`""
    if (-not (Test-Path $archivPath)) {
        "Zeitstempel,Datum,Post-Typ,Plattform,Videoprompt,Caption" | Out-File -FilePath $archivPath -Encoding UTF8
    }
    $archivZeile | Out-File -FilePath $archivPath -Append -Encoding UTF8
    Write-Log "Archiv-Eintrag gespeichert: $archivPath"

} catch {
    Write-Log "FEHLER Webhook: $_"
    exit 1
}

Write-Log "=== Fertig ==="
