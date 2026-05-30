# YouTube OAuth - einmaliger Token-Abruf
# Liest Client-ID und Client-Secret aus context/setup-status.md
# Wird automatisch von /setup ausgefuehrt

$SetupStatusPfad = Join-Path $PSScriptRoot "..\context\setup-status.md"

function Lese-Wert($Inhalt, $Schluessel) {
    $Zeile = $Inhalt | Where-Object { $_ -match "^\s*$Schluessel\s*:\s*(.+)" }
    if ($Zeile) { return ($Zeile -replace "^\s*$Schluessel\s*:\s*", "").Trim() }
    return ""
}

$SetupInhalt        = Get-Content $SetupStatusPfad -Encoding UTF8
$GoogleClientId     = Lese-Wert $SetupInhalt "GoogleClientId"
$GoogleClientSecret = Lese-Wert $SetupInhalt "GoogleClientSecret"

if ($GoogleClientId -eq "" -or $GoogleClientSecret -eq "") {
    Write-Host "FEHLER: Google Client-ID oder Client-Secret fehlt in context/setup-status.md" -ForegroundColor Red
    Write-Host "Bitte /setup ausfuehren." -ForegroundColor Yellow
    exit 1
}

$Scope       = "https://www.googleapis.com/auth/youtube.upload https://www.googleapis.com/auth/youtube"
$RedirectUri = "http://localhost:8080/"

Add-Type -AssemblyName System.Web

$Listener = New-Object System.Net.HttpListener
$Listener.Prefixes.Add($RedirectUri)
$Listener.Start()

$AuthUrl = "https://accounts.google.com/o/oauth2/auth" +
    "?client_id=$([Uri]::EscapeDataString($GoogleClientId))" +
    "&redirect_uri=$([Uri]::EscapeDataString($RedirectUri))" +
    "&scope=$([Uri]::EscapeDataString($Scope))" +
    "&response_type=code" +
    "&access_type=offline" +
    "&prompt=consent"

Write-Host "Browser oeffnet sich - bitte mit deinem YouTube-Kanal-Google-Konto anmelden und Zugriff erlauben..."
Start-Process $AuthUrl

$Context = $Listener.GetContext()
$Code    = [System.Web.HttpUtility]::ParseQueryString($Context.Request.Url.Query)["code"]

$Html   = "<html><body style='font-family:sans-serif;padding:40px'><h2>Autorisierung erfolgreich!</h2><p>Fenster schliessen und zu Claude Code zurueckkehren.</p></body></html>"
$Buffer = [System.Text.Encoding]::UTF8.GetBytes($Html)
$Context.Response.ContentLength64 = $Buffer.Length
$Context.Response.OutputStream.Write($Buffer, 0, $Buffer.Length)
$Context.Response.Close()
$Listener.Stop()

$TokenResponse = Invoke-RestMethod `
    -Uri "https://oauth2.googleapis.com/token" `
    -Method POST `
    -Body @{
        code          = $Code
        client_id     = $GoogleClientId
        client_secret = $GoogleClientSecret
        redirect_uri  = $RedirectUri
        grant_type    = "authorization_code"
    }

Write-Host ""
Write-Host "=== REFRESH TOKEN ===" -ForegroundColor Green
Write-Host $TokenResponse.refresh_token
Write-Host "=====================" -ForegroundColor Green
