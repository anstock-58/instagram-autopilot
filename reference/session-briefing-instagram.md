# Session-Briefing: Instagram Autopilot

Lies zuerst `/prime`, dann diesen Text.

---

## Stand heute (16.05.2026) — verbindlich für alle Sessions

### Architektur
- **Posting läuft über GitHub Actions** — PC muss NICHT an sein
- **Kein Make.com, kein Windows Task, kein fal.ai, kein Creatomate**
- **Nur Blotato** — sowohl für Bildgenerierung als auch für Posting

### Wie ein Post entsteht (Automation)
1. GitHub Actions startet täglich: 08:55 CEST (Story) und 17:55 CEST (Reel)
2. `scripts/post-trigger.ps1` liest das CSV
3. Ruft `POST /v2/videos/from-templates` auf — Blotato generiert das Bild aus dem Videoprompt und erstellt eine Slideshow mit Text-Overlay
4. Template-ID: `5903b592-1255-43b4-b9ac-f8ed7cbf6a5f` (Image Slideshow with Text Overlays)
5. Slideshow hat 2 Slides: Hauptbild mit Text + CTA-Slide "Kommentiere KLARHEIT"
6. Fertiges Video wird via `POST /v2/posts` auf Instagram gepostet

### Wie ein Post aussieht
- Slideshow aus Bildern (Blotato generiert via AI)
- Weißer Text unten auf dem Bild (textStyle: elegant, textColor: #FFFFFF)
- Zweiter Slide immer mit CTA
- Caption darunter (der lange Fließtext aus der CSV-Spalte "Text")
- Kein Voiceover, keine Musik (Template unterstützt es nicht — akzeptiert)

### Was NICHT mehr genutzt wird
- fal.ai (war für Bildgenerierung, jetzt macht Blotato das)
- Creatomate (war für Text-Overlay, jetzt macht Blotato das)
- Make.com (war für Posting-Trigger, jetzt GitHub Actions)
- Windows Task Scheduler (PC muss nicht an sein)

### Blotato Account-IDs
- @business.und.spirit Instagram → `46248`
- @ki_support Instagram → `46341`
- @andi.mit.system Instagram → `46471`
- LinkedIn Dipl.-Ing. Andreas Stock → `21656`
- LinkedIn Dropservice → `21657`

### CSVs
- `outputs/contentplan_juni_v1.csv` — Instagram @business.und.spirit, Juni
- `outputs/contentplan_mai_v2.csv` — Instagram @business.und.spirit, Mai-Reste + LinkedIn

### GitHub
- Repo: `https://github.com/anstock-58/instagram-autopilot`
- Secret: `BLOTATO_API_KEY` hinterlegt
- Workflows: `.github/workflows/autopilot-story.yml` + `autopilot-reel.yml`

### Für andere Accounts (andere Sessions)
Gleiche Architektur, anderes CSV, andere Account-ID in `$accountIdIG`.
Skript kopieren als `post-trigger-[account].ps1`, eigenen Workflow anlegen.

---

## Was du als neue Session tun sollst

1. `/prime` ausführen
2. `reference/instagram-autopilot-setup.md` lesen
3. `scripts/post-trigger.ps1` lesen — das ist die Referenz-Implementierung
4. Dann auf Andis Aufgabe eingehen — nur anderer Inhalt, gleiche Technik
