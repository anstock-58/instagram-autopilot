# Make.com Szenario: Neustart Webhook v3
**Szenario-ID:** 5524877
**URL:** https://eu1.make.com/1533502/scenarios/5524877/edit

---

## Komplette Struktur

```
Webhook [1] → Router [16] → Reel-Pfad
                           → Foto-Pfad
```

### Reel-Pfad (1st Route)
Filter: `1.post_typ = Reel`

```
HTTP [3] → Instagram [9] → (Reel-Publish Filter) → Facebook [14]
```

| Modul | Typ | Konfiguration |
|-------|-----|---------------|
| HTTP [3] | fal.ai Kling text-to-video | URL: `https://fal.run/fal-ai/kling-video/v3/standard/text-to-video` POST, Auth: Key + API-Key, Body: `{"prompt": "{{1.videoprompt}}", "duration": "5", "aspect_ratio": "9:16"}` |
| Instagram [9] | Create a reel post | Connection: FB - Business & Spirit, Page: @business.und.spirit, Video URL: `{{3.data.video.url}}`, Caption: `{{1.text}}` |
| Facebook [14] | Publish a Reel | Connection: FB - Business & Spirit, Page: Business & Spirit., URL: `{{3.data.video.url}}`, Description: `{{1.text}}` |

Filter "Reel-Publish" zwischen [9] und [14]: `1.post_typ = Reel`

---

### Foto-Pfad (2nd Route)
Filter: `1.post_typ = Foto`

```
HTTP [4] → Instagram [18] → Facebook [19]
```

| Modul | Typ | Konfiguration |
|-------|-----|---------------|
| HTTP [4] | fal.ai Flux image | URL: `https://fal.run/fal-ai/flux/dev` POST, Auth: Key + API-Key, Body: `{"prompt": "{{1.bildprompt}}"}` |
| Instagram [18] | Create a photo post | Connection: FB - Business & Spirit, Page: @business.und.spirit, Photo URL: `{{4.data.images[].url}}`, Caption: `{{1.text}}` |
| Facebook [19] | Create a Post with Photos | Connection: FB - Business & Spirit, Page: Business & Spirit., Photos URL: `{{4.data.images[].url}}`, Post caption: `{{1.text}}` |

---

## Webhook Payload (aus post-trigger.ps1)

```json
{
  "post_typ": "Reel" oder "Foto",
  "plattform": "Instagram",
  "text": "Caption-Text",
  "link": "https://...",
  "bildprompt": "Flux-Prompt",
  "videoprompt": "Kling-Prompt",
  "textoverlay": "(wird nicht mehr verwendet)",
  "datum": "03.05.2026"
}
```

---

## Verbindungen / Zugangsdaten

- **Instagram Connection:** FB - Business & Spirit (Andreas Stock) — OAuth über Facebook
- **Facebook Connection:** FB - Business & Spirit (Andreas Stock) — `__IMTCONN__: 6974772`
- **fal.ai API Key:** in `context/secrets.md`
- **Webhook URL:** in `context/secrets.md`

---

## Wichtige Variablen-Pfade

| Was | Variable |
|-----|----------|
| Kling Video-URL | `{{3.data.video.url}}` |
| Flux Bild-URL | `{{4.data.images[].url}}` |
| Caption/Text | `{{1.text}}` |
| Post-Typ | `{{1.post_typ}}` |
| Videoprompt | `{{1.videoprompt}}` |
| Bildprompt | `{{1.bildprompt}}` |

---

## Hinweise

- Text-Overlay wurde entfernt — Kling rendert Text unzuverlässig
- Facebook postet parallel zu Instagram (Reel + Foto)
- Creatomate für Text-Overlay + Musik geplant (noch nicht implementiert)
- GitHub Actions triggert täglich 17:55 Uhr CEST (cron: `55 15 * * *`)
