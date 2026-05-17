# telegram-pause-bot.ps1
# Telegram-Bot der Blotato-Posting-Automation pausieren und fortsetzen kann.
# Laeuft als Windows Task alle 5 Minuten.
# Kein Make.com. Reines PowerShell + Telegram Bot API.
#
# BEFEHLE (an @AndiKIAgent_bot schicken):
#   pause instagram      -> Instagram-Posts pausieren
#   pause linkedin       -> LinkedIn-Posts pausieren
#   pause alle           -> alles pausieren
#   weiter instagram     -> Instagram fortsetzen
#   weiter linkedin      -> LinkedIn fortsetzen
#   weiter alle          -> alles fortsetzen
#   status               -> aktuellen Pause-Status anzeigen

# ============================================================
# KONFIGURATION
# ============================================================
$botToken  = if ($env:TELEGRAM_KI_AGENT_TOKEN) { $env:TELEGRAM_KI_AGENT_TOKEN } else { $null }
if (-not $botToken) { Write-Output "FEHLER: TELEGRAM_KI_AGENT_TOKEN nicht gesetzt."; exit 1 }
$apiBase   = "https://api.telegram.org/bot$botToken"
$basePath  = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }

# Pause-Dateien — deren Existenz bedeutet: diese Plattform ist pausiert
$pauseIG   = Join-Path $basePath "outputs" "pause_instagram.txt"
$pauseLI   = Join-Path $basePath "outputs" "pause_linkedin.txt"

# Speichert die zuletzt verarbeitete Update-ID (verhindert doppelte Verarbeitung)
$updateIdFile = Join-Path $basePath "outputs" "telegram-bot-last-update.txt"
$logPath      = Join-Path $basePath "outputs" "telegram-pause-bot-log.txt"

# ============================================================
# HILFSFUNKTIONEN
# ============================================================
function Write-Log {
    param([string]$msg)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $msg"
    $line | Out-File -FilePath $logPath -Append -Encoding UTF8
    Write-Output $line
}

function Send-TelegramMessage {
    param([string]$chatId, [string]$text)
    $body = @{ chat_id = $chatId; text = $text; parse_mode = "HTML" } | ConvertTo-Json -Compress
    try {
        Invoke-RestMethod -Uri "$apiBase/sendMessage" -Method POST `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) | Out-Null
    } catch {
        Write-Log "FEHLER beim Senden der Telegram-Antwort: $_"
    }
}

function Get-PauseStatus {
    $ig = if (Test-Path $pauseIG) { "PAUSIERT ⏸" } else { "aktiv ✅" }
    $li = if (Test-Path $pauseLI) { "PAUSIERT ⏸" } else { "aktiv ✅" }
    return "Instagram: $ig`nLinkedIn:  $li"
}

# ============================================================
# LETZTE UPDATE-ID LADEN
# ============================================================
$lastUpdateId = 0
if (Test-Path $updateIdFile) {
    try { $lastUpdateId = [int](Get-Content $updateIdFile -Encoding UTF8) } catch { $lastUpdateId = 0 }
}
$offset = $lastUpdateId + 1

# ============================================================
# TELEGRAM UPDATES ABRUFEN
# ============================================================
Write-Log "=== Telegram Pause Bot gestartet | Offset: $offset ==="

try {
    $response = Invoke-RestMethod -Uri "$apiBase/getUpdates?offset=$offset&timeout=5" -Method GET -ErrorAction Stop
} catch {
    Write-Log "FEHLER beim Abrufen der Telegram-Updates: $_"
    exit 1
}

if (-not $response.ok -or $response.result.Count -eq 0) {
    Write-Log "Keine neuen Nachrichten."
    exit 0
}

# ============================================================
# NACHRICHTEN VERARBEITEN
# ============================================================
foreach ($update in $response.result) {

    $updateId = $update.update_id
    $chatId   = $update.message.chat.id
    $text     = $update.message.text

    if (-not $text) {
        $lastUpdateId = $updateId
        continue
    }

    $cmd = $text.Trim().ToLower()
    Write-Log "Nachricht von Chat $chatId : '$cmd'"

    $antwort = switch -Wildcard ($cmd) {

        "pause instagram" {
            Get-Date -Format "yyyy-MM-dd HH:mm" | Out-File -FilePath $pauseIG -Encoding UTF8
            "Instagram-Posting pausiert ⏸`n`nHeute werden keine Instagram-Posts gesendet.`nZum Fortsetzen: <b>weiter instagram</b>"
        }

        "pause linkedin" {
            Get-Date -Format "yyyy-MM-dd HH:mm" | Out-File -FilePath $pauseLI -Encoding UTF8
            "LinkedIn-Posting pausiert ⏸`n`nHeute werden keine LinkedIn-Posts gesendet.`nZum Fortsetzen: <b>weiter linkedin</b>"
        }

        "pause alle" {
            Get-Date -Format "yyyy-MM-dd HH:mm" | Out-File -FilePath $pauseIG -Encoding UTF8
            Get-Date -Format "yyyy-MM-dd HH:mm" | Out-File -FilePath $pauseLI -Encoding UTF8
            "Alle Posts pausiert ⏸⏸`n`nInstagram + LinkedIn werden heute nicht gepostet.`nZum Fortsetzen: <b>weiter alle</b>"
        }

        "weiter instagram" {
            if (Test-Path $pauseIG) { Remove-Item $pauseIG -Force }
            "Instagram-Posting fortgesetzt ✅`n`nNächste geplante Posts laufen wieder automatisch."
        }

        "weiter linkedin" {
            if (Test-Path $pauseLI) { Remove-Item $pauseLI -Force }
            "LinkedIn-Posting fortgesetzt ✅`n`nNächste geplante Posts laufen wieder automatisch."
        }

        "weiter alle" {
            if (Test-Path $pauseIG) { Remove-Item $pauseIG -Force }
            if (Test-Path $pauseLI) { Remove-Item $pauseLI -Force }
            "Alle Posts fortgesetzt ✅✅`n`nInstagram + LinkedIn laufen wieder automatisch."
        }

        "status" {
            "Aktueller Posting-Status:`n`n$(Get-PauseStatus)"
        }

        default {
            $null  # Unbekannte Befehle ignorieren — Bot antwortet nicht auf normalen Chat-Verlauf
        }
    }

    if ($antwort) {
        Send-TelegramMessage -chatId $chatId -text $antwort
        Write-Log "Antwort gesendet: $antwort"
    }

    $lastUpdateId = $updateId
}

# ============================================================
# LETZTE UPDATE-ID SPEICHERN
# ============================================================
$lastUpdateId | Out-File -FilePath $updateIdFile -Encoding UTF8
Write-Log "=== Fertig | Letztes Update: $lastUpdateId ==="
