$apiKey = "7600112e-4d6f-4202-b107-b899fe36595c:4faa681903cdd51d757c18b7d0cc6c11"

$body = @{
    prompt = "Ultra wide Facebook cover photo banner, cinematic wide format, a confident distinguished European man in his late 50s with silver hair, standing at floor-to-ceiling window overlooking modern city skyline at golden hour, back slightly turned, calm reflective posture, dark professional suit, warm golden morning light, minimal executive office, bokeh city lights in background, subject positioned on right third of image, left two thirds dark and open for text overlay, no text, photorealistic, high quality, cinematic lighting"
    image_size = "landscape_16_9"
    num_inference_steps = 28
    guidance_scale = 3.5
} | ConvertTo-Json

$headers = @{
    "Authorization" = "Key $apiKey"
    "Content-Type"  = "application/json"
}

$response = Invoke-RestMethod -Uri "https://fal.run/fal-ai/flux/dev" -Method Post -Headers $headers -Body $body
$imageUrl = $response.images[0].url
Write-Host "Bild URL: $imageUrl"

# Bild herunterladen
$outputPath = "C:\Users\andre\claude-workspace-vorlage\outputs\facebook-cover.jpg"
Invoke-WebRequest -Uri $imageUrl -OutFile $outputPath
Write-Host "Gespeichert: $outputPath"
