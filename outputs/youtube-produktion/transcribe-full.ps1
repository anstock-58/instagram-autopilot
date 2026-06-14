$ApiKey = "sk_4580977e80cf53081138deb1c73cfde9e1f7c693e0d5b929"
$FilePath = "C:\Users\Andreas\Medien_Business\Business_YT_Bewusst_Einfach\YT-Videos\BEZIEHUNG\LiebeOderAngst_Video_1\voiceover.mp3"

$Boundary = [System.Guid]::NewGuid().ToString()
$FileBytes = [System.IO.File]::ReadAllBytes($FilePath)
$FileName = [System.IO.Path]::GetFileName($FilePath)

$LF = "`r`n"
$BodyStart = (
    "--$Boundary$LF" +
    "Content-Disposition: form-data; name=`"model_id`"$LF$LF" +
    "scribe_v1$LF" +
    "--$Boundary$LF" +
    "Content-Disposition: form-data; name=`"file`"; filename=`"$FileName`"$LF" +
    "Content-Type: audio/mpeg$LF$LF"
)
$BodyEnd = "$LF--$Boundary--$LF"

$BodyStartBytes = [System.Text.Encoding]::UTF8.GetBytes($BodyStart)
$BodyEndBytes   = [System.Text.Encoding]::UTF8.GetBytes($BodyEnd)

$RequestBody = New-Object byte[] ($BodyStartBytes.Length + $FileBytes.Length + $BodyEndBytes.Length)
[Array]::Copy($BodyStartBytes, 0, $RequestBody, 0, $BodyStartBytes.Length)
[Array]::Copy($FileBytes, 0, $RequestBody, $BodyStartBytes.Length, $FileBytes.Length)
[Array]::Copy($BodyEndBytes, 0, $RequestBody, $BodyStartBytes.Length + $FileBytes.Length, $BodyEndBytes.Length)

$Result = Invoke-RestMethod -Uri "https://api.elevenlabs.io/v1/speech-to-text" -Method POST `
    -Headers @{ "xi-api-key" = $ApiKey } `
    -ContentType "multipart/form-data; boundary=$Boundary" `
    -Body $RequestBody

$Result.text | Out-File -FilePath "C:\Users\andre\claude-workspace-vorlage\outputs\youtube-produktion\be19-full-transcript.txt" -Encoding utf8
$Result.words | ConvertTo-Json -Depth 5 | Out-File -FilePath "C:\Users\andre\claude-workspace-vorlage\outputs\youtube-produktion\be19-full-words.json" -Encoding utf8
Write-Host "Fertig"
