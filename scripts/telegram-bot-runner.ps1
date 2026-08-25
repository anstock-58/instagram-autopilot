# telegram-bot-runner.ps1
# Dauerschleife: ruft telegram-pause-bot.ps1 alle 5 Minuten auf.
# Einmalig starten — laeuft dann dauerhaft im Hintergrund.

$botScript = "C:\Users\andre\claude-workspace-vorlage\scripts\telegram-pause-bot.ps1"
$logPath   = "C:\Users\andre\claude-workspace-vorlage\outputs\telegram-pause-bot-log.txt"

while ($true) {
    try {
        & $botScript
    } catch {
        "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | RUNNER-FEHLER: $_" |
            Out-File -FilePath $logPath -Append -Encoding UTF8
    }
    Start-Sleep -Seconds 300
}
