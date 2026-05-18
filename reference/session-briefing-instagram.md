# Session-Briefing: Instagram Autopilot

Lies zuerst `/prime`, dann diesen Text.

---

## Stand heute (18.05.2026) — verbindlich für alle Sessions

### Architektur (gilt für ALLE Accounts gleich)

```
contentplan_[account]_[monat]_v1.csv
  → GitHub Actions (täglich, PC muss NICHT an sein)
    → scripts/post-trigger-[account].ps1
      → Blotato REST API
        → AI Video mit Voiceover + Captions
          → Instagram Story (09:00 CEST) + Reel (18:00 CEST)
```

- **Kein Make.com, kein Windows Task, kein fal.ai, kein Creatomate**
- **Nur Blotato** — Videogenerierung und Posting in einem

---

### Wie ein Post entsteht

1. GitHub Actions startet täglich: 06:55 UTC = 08:55 CEST (Story) und 15:55 UTC = 17:55 CEST (Reel)
2. Skript liest CSV, findet heutigen Post
3. Ruft `POST /v2/videos/from-templates` auf
4. Template: `ai-story-video` — ID: `5903fe43-514d-40ee-a060-0d6628c5f8fd`
5. Scene 1: KI-Bild aus Videoprompt + Voiceover (Caption-Text bereinigt + Produkt-Abschluss)
6. Scene 2: CTA (accountspezifisch — siehe unten)
7. Fertiges Video via `POST /v2/posts` auf Instagram

---

### Wie ein Post aussieht

- KI-generiertes Bild (aus Videoprompt, Editorial-Zeitungsstil)
- Voiceover: Caption-Text gesprochen (Emojis/Hashtags entfernt) + kurzer Abschluss
- Captions: animiert, unten, gelb hervorgehoben
- Story: `mediaType: "story"` — Reel: `mediaType: "reel"`
- Caption-Text (mit Emojis, Hashtags) als Instagram-Post-Text

---

### Voiceover-Logik (Standard für alle Accounts)

Der Voiceover-Abschluss richtet sich nach dem Link in der CSV-Spalte "Link":

| Link enthält | Abschluss-Satz |
|---|---|
| `alfima` | "ALFIMA — kostenlos in meiner Bio." |
| `instagram-autopilot` | "Instagram Autopilot — in meiner Bio." |
| `ki-audio-empire` | "KI-Hoerbuch — in meiner Bio." |
| `ki-prompt-paket` | "30 Prompts gratis — in meiner Bio." |
| leer / anderes | "Mehr dazu — in meiner Bio." |

**Accounts mit eigenem CTA** (z.B. KLARHEIT für business.und.spirit) → Scene 2 entsprechend anpassen.

---

### Blotato Account-IDs

| Account | Blotato ID | Skript | Workflows |
|---|---|---|---|
| @business.und.spirit | `46248` | `post-trigger-business-und-spirit.ps1` | `bus-story.yml` + `bus-reel.yml` |
| @ki_support | `46341` | `post-trigger-ki-support.ps1` | `ki-support-story.yml` + `ki-support-reel.yml` |
| @andi.mit.system | `46471` | `post-trigger-andi-mit-system.ps1` | `andi-mit-system-story.yml` + `andi-mit-system-reel.yml` |
| LinkedIn Andreas Stock | `21656` | `post-trigger.ps1` | — |
| LinkedIn Dropservice | `21657` | `post-trigger.ps1` | — |

---

### CSV-Namenskonvention

```
outputs/contentplan_[account]_[monat]_v1.csv
```

Beispiele:
- `contentplan_ki_support_juni_v1.csv`
- `contentplan_business_und_spirit_juni_v1.csv`
- `contentplan_andi_mit_system_juni_v1.csv`

**CSV-Spalten**: Datum, Uhrzeit, Plattform, Post-Typ, Text, Link, Bild-URL, Bildprompt, Videoprompt, Text-Overlay, Karussell-Slides, Status, Musik-URL

---

### GitHub

- Repo: `https://github.com/anstock-58/instagram-autopilot`
- Branch: `master`
- Secret: `BLOTATO_API_KEY` hinterlegt
- Alle Workflows in `.github/workflows/`

---

### Für eine neue Account-Session

1. `/prime` ausführen
2. `reference/session-briefing-instagram.md` lesen (diese Datei)
3. Referenz-Skript: `scripts/post-trigger-ki-support.ps1`
4. Aufgabe: Contentplan für den Account erstellen — gleiche Technik, eigener Inhalt
5. Contentplan als CSV in `outputs/` speichern, committen, pushen

**Niemals fragen ob Slideshow oder AI-Video — immer AI-Video mit Voiceover.**
**Niemals die Account-ID ändern ohne Blotato zu prüfen.**
