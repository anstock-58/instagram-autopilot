# post-trigger-linkedin-dropservice.ps1
# Postet LinkedIn-Posts fuer Dropservice-Profil direkt via LinkedIn API.
# Laeuft via GitHub Actions (workflow_dispatch, getriggert von cron-job.org).
#
# Benoetigte GitHub Secrets:
#   LINKEDIN_ACCESS_TOKEN_DS -- LinkedIn OAuth Token fuer Dropservice (fin.affairs.ansto, alle 2 Monate erneuern)
#   LINKEDIN_PERSON_URN_DS   -- urn:li:person:da9CqePqC2 (Dropservice-Profil)

# ============================================================
# KONFIGURATION
# ============================================================
$basePath    = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { "C:\Users\andre\claude-workspace-vorlage" }
$outputsPath = Join-Path $basePath "outputs"
$logPath     = Join-Path $outputsPath "post-trigger-linkedin-dropservice-log.txt"
$archivPath  = Join-Path $outputsPath "post-archiv-linkedin-dropservice.csv"

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

$liToken     = if ($env:LINKEDIN_ACCESS_TOKEN_DS)  { $env:LINKEDIN_ACCESS_TOKEN_DS }  else { "" }
$liPersonUrn = if ($env:LINKEDIN_PERSON_URN_DS)    { $env:LINKEDIN_PERSON_URN_DS }    else { "urn:li:person:da9CqePqC2" }

$ersterKommentar  = "Du willst mehr wissen oder einen Termin vereinbaren? Hier geht es zur Kontaktseite: https://ansto-finaffairs.com/terminbuchung/"
$pauseDS          = Join-Path $outputsPath "pause_linkedin_dropservice.txt"
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

    $authHeaders = @{
        "Authorization"             = "Bearer $liToken"
        "Content-Type"              = "application/json"
        "X-Restli-Protocol-Version" = "2.0.0"
    }

    $assetUrn = $null

    if ($mediaUrl -and $mediaUrl.Trim() -ne "") {
        # Schritt 1: Upload bei LinkedIn registrieren
        $registerBody = @{
            registerUploadRequest = @{
                recipes              = @("urn:li:digitalmediaRecipe:feedshare-image")
                owner                = $liPersonUrn
                serviceRelationships = @(@{
                    relationshipType = "OWNER"
                    identifier       = "urn:li:userGeneratedContent"
                })
            }
        } | ConvertTo-Json -Depth 10
        $registerBytes = [System.Text.Encoding]::UTF8.GetBytes($registerBody)

        try {
            $registerResponse = Invoke-RestMethod -Uri "https://api.linkedin.com/v2/assets?action=registerUpload" `
                -Method POST -Headers $authHeaders -Body $registerBytes -ErrorAction Stop
            $uploadUrl = $registerResponse.value.uploadMechanism.'com.linkedin.digitalmedia.uploading.MediaUploadHttpRequest'.uploadUrl
            $assetUrn  = $registerResponse.value.asset
            Write-Log "Bild-Upload registriert. Asset: $assetUrn"
        } catch {
            Write-Log "FEHLER beim Registrieren des Bild-Uploads: $_"
            return $null
        }

        # Schritt 2: Bild herunterladen und zu LinkedIn hochladen
        try {
            $tempFile  = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), ([System.Guid]::NewGuid().ToString() + ".jpg"))
            Invoke-WebRequest -Uri $mediaUrl.Trim() -OutFile $tempFile -ErrorAction Stop
            $imageBytes = [System.IO.File]::ReadAllBytes($tempFile)
            Remove-Item -LiteralPath $tempFile -Force

            Invoke-RestMethod -Uri $uploadUrl -Method PUT -Body $imageBytes `
                -ContentType "image/jpeg" -ErrorAction Stop | Out-Null
            Write-Log "Bild hochgeladen ($($imageBytes.Length) Bytes)."
        } catch {
            Write-Log "FEHLER beim Bild-Upload: $_"
            return $null
        }
    }

    # Schritt 3: Post erstellen
    if ($assetUrn) {
        $postObj = @{
            author          = $liPersonUrn
            lifecycleState  = "PUBLISHED"
            specificContent = @{
                "com.linkedin.ugc.ShareContent" = @{
                    shareCommentary    = @{ text = $caption }
                    shareMediaCategory = "IMAGE"
                    media              = @(@{
                        status      = "READY"
                        description = @{ text = "" }
                        media       = $assetUrn
                        title       = @{ text = "" }
                    })
                }
            }
            visibility = @{ "com.linkedin.ugc.MemberNetworkVisibility" = "PUBLIC" }
        }
    } else {
        $postObj = @{
            author          = $liPersonUrn
            lifecycleState  = "PUBLISHED"
            specificContent = @{
                "com.linkedin.ugc.ShareContent" = @{
                    shareCommentary    = @{ text = $caption }
                    shareMediaCategory = "NONE"
                }
            }
            visibility = @{ "com.linkedin.ugc.MemberNetworkVisibility" = "PUBLIC" }
        }
    }

    $postBytes = [System.Text.Encoding]::UTF8.GetBytes(($postObj | ConvertTo-Json -Depth 10))

    try {
        $response = Invoke-RestMethod -Uri "https://api.linkedin.com/v2/ugcPosts" `
            -Method POST -Headers $authHeaders -Body $postBytes -ErrorAction Stop
        Write-Log "Dropservice LinkedIn gepostet. URN: $($response.id)"
        return $response.id
    } catch {
        Write-Log "FEHLER beim LinkedIn-Post: $_"
        return $null
    }
}

function Post-LinkedInKommentar {
    param([string]$shareUrn, [string]$kommentarText)

    $urnEncoded = [Uri]::EscapeDataString($shareUrn)
    $bodyBytes  = [System.Text.Encoding]::UTF8.GetBytes((@{
        actor   = $liPersonUrn
        message = @{ text = $kommentarText }
    } | ConvertTo-Json -Compress))
    $headers = @{
        "Authorization"             = "Bearer $liToken"
        "Content-Type"              = "application/json"
        "X-Restli-Protocol-Version" = "2.0.0"
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

Write-Log "=== Dropservice LinkedIn Trigger | $heute | $($jetzt.ToString('HH:mm')) | CSV: $(Split-Path $csvPath -Leaf) ==="

if (Test-Path $pauseDS) {
    Write-Log "Dropservice LinkedIn pausiert. Abbruch."
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

Write-Log "$(@($heuteRows).Count) Post(s) fuer heute gefunden."

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

    $shareUrn = Post-LinkedIn -caption $caption -mediaUrl $mediaUrl

    if ($shareUrn) {
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

        Post-LinkedInKommentar -shareUrn $shareUrn -kommentarText $ersterKommentar
    }
}

Write-Log "=== Fertig ==="
