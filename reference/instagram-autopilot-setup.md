# Instagram Autopilot — Aktuelle Konfiguration

Stand: 16.05.2026 — Vollständig auf GitHub Actions + Blotato umgestellt ✅

---

## Architektur

```
contentplan_juni_v1.csv (Instagram)
contentplan_mai_v2.csv  (LinkedIn + Mai-Reste)
  → GitHub Actions (Cloud, PC muss NICHT an sein)
    → scripts/post-trigger.ps1
      → Blotato REST API
        → Instagram @business.und.spirit
        → LinkedIn Dipl.-Ing. Andreas Stock
```

**Kein Make.com. Kein Webhook. Kein Windows Task Scheduler für Posting.**

---

## GitHub Actions Zeitplan

| Workflow | Cron (UTC) | Lokale Zeit (CEST) | Was |
|---|---|---|---|
| autopilot-story.yml | `55 6 * * *` | 08:55 | Story posten |
| autopilot-reel.yml | `55 15 * * *` | 17:55 | Reel/Foto posten |
| pause-control.yml | via repository_dispatch | auf Anfrage | Pause/Start |

Workflows liegen in `.github/workflows/`.

---

## Blotato API

- **Endpoint**: `POST https://backend.blotato.com/v2/posts`
- **Auth Header**: `blotato-api-key: KEY` (NICHT Authorization Bearer!)
- **API Key**: in `context/secrets.md`

### Account IDs

| Account | Blotato ID |
|---|---|
| @business.und.spirit (Instagram) | 46248 |
| @andi.mit.system (Instagram) | 46471 |
| @ki_support (Instagram) | 46341 |
| LinkedIn Dipl.-Ing. Andreas Stock | 21656 |
| LinkedIn Dropservice (Ersu/Leon) | 21657 |

### targetType-Werte

| Post-Typ | targetType |
|---|---|
| Instagram Feed (Reel/Foto) | `instagram` |
| Instagram Story | `instagramStory` |
| LinkedIn | `linkedin` |

---

## CSVs

| Datei | Inhalt |
|---|---|
| `outputs/contentplan_juni_v1.csv` | 30 Stories (09:00) + 30 Reels (18:00) für Juni — Instagram |
| `outputs/contentplan_mai_v2.csv` | Mai-Reste (16–31 Mai) + LinkedIn-Posts Mai+Juni |

**Spalten**: Datum, Uhrzeit, Plattform, Post-Typ, Text, Link, Bild-URL, Bildprompt, Videoprompt, Text-Overlay, Karussell-Slides, Status, Musik-URL

Das Skript wählt automatisch die CSV nach aktuellem Monat (v2 vor v1).

---

## Pause-Mechanismus

- **PAUSED-Datei** im GitHub-Repo = Autopilot pausiert
- **Datei fehlt** = Autopilot läuft
- Gesteuert via GitHub repository_dispatch API (Telegram-Bot geplant)
- GitHub PAT in `context/secrets.md`

---

## Skript

- **Pfad**: `scripts/post-trigger.ps1`
- **Log**: `outputs/post-trigger-log.txt`
- **Archiv**: `outputs/post-archiv.csv`
- Zeitfenster: -10 bis +45 Minuten um geplante Uhrzeit
- Setzt Status auf "Gepostet" nach erfolgreichem Post

**Unterstützte Post-Typen**: Reel, Foto, Story, Text  
**Noch nicht implementiert**: Karussell, Facebook

---

## Bildgenerierung

Bilder werden einmalig per Batch mit `scripts/generate-juni-images.ps1` via fal.ai FLUX Schnell generiert. Blotato generiert keine Bilder — nur posten. URLs werden in die CSV-Spalte `Bild-URL` eingetragen.

---

## GitHub Repo

- **URL**: `https://github.com/anstock-58/instagram-autopilot`
- **Branch**: `master`
- **Secret**: `BLOTATO_API_KEY` in GitHub Settings → Secrets → Actions

---

## Was Make.com noch macht

Make.com läuft noch für den **Telegram KI Agent** (@AndiKIAgent_bot, Szenario 5699211).  
Für das Posting wird Make.com nicht mehr benötigt.
