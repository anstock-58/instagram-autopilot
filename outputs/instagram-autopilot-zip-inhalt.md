# Instagram Reel Autopilot — ZIP-Paket Inhalt
Stand: Mai 2026

---

## Dateien im ZIP (was in das Download-Paket gehört)

```
Instagram-Reel-Autopilot/
├── 1_Anleitung_Instagram_Reel_Autopilot.pdf     ← aus instagram-autopilot-system-v1.md exportieren
├── 2_Make-Blueprint_importieren.json             ← scripts/make-blueprint-webhook-v3.json
├── 3_post-trigger.ps1                            ← scripts/post-trigger.ps1
├── 4_contentplan_vorlage.csv                     ← leere CSV-Vorlage (unten)
├── 5_Setup-Prompt_Claude-Code.txt               ← Setup-Prompt (unten)
└── 6_Quick-Start-Checkliste.pdf                  ← aus diesem Dokument exportieren
```

---

## Datei 4 — Contentplan CSV-Vorlage (leer)

```csv
Datum,Uhrzeit,Plattform,Post-Typ,Text,Link,Bild-URL,Bildprompt,Videoprompt,Text-Overlay,Karussell-Slides,Status
01.06.2026,18:00,Instagram,Reel,"Caption hier eintippen","","","","Videoprompt hier eintippen","Zeile 1\nZeile 2",,"geplant"
01.06.2026,18:00,Instagram,Foto,"Caption hier eintippen","","","Bildprompt hier eintippen","","",,"geplant"
```

**Spalten-Erklärung:**

| Spalte | Was hineinkommt |
|--------|----------------|
| Datum | TT.MM.JJJJ |
| Uhrzeit | HH:MM (Uhrzeit des geplanten Posts) |
| Plattform | Instagram (Facebook automatisch mitgepostet) |
| Post-Typ | Reel oder Foto |
| Text | Die Caption — mit Emojis, Hashtags und CTA |
| Link | Optional (wird geloggt, nicht gepostet) |
| Bild-URL | Leer lassen (nur wenn externes Bild) |
| Bildprompt | Nur bei Foto-Posts: Flux-Prompt |
| Videoprompt | Nur bei Reel-Posts: Kling-Prompt |
| Text-Overlay | Text im Video: Zeilen mit \n trennen (z.B. "Kein Burnout.\nÜberlastung.") |
| Karussell-Slides | Noch nicht implementiert — leer lassen |
| Status | geplant → wird vom Skript auf "gesendet" gesetzt |

---

## Datei 5 — Setup-Prompt für Claude Code

```
Ich möchte ein vollautomatisches Instagram-Posting-System aufbauen.

Das System soll täglich automatisch einen Post auf Instagram veröffentlichen —
entweder ein KI-generiertes Reel (Kling v3 via fal.ai) oder ein KI-generiertes Foto
(FLUX via fal.ai). Die Posts kommen aus einem Contentplan als CSV-Datei.

Bitte baue folgendes System für mich auf:

ARCHITEKTUR:
Contentplan CSV → Windows Task Scheduler → PowerShell Skript → Make.com Webhook
→ fal.ai (Video oder Bild generieren) → Instagram Business Account (posten)

SCHRITT 1 - WORKSPACE:
Erstelle folgende Ordnerstruktur in meinem Workspace:
- outputs/ (für Contentplan CSV und Logs)
- scripts/ (für PowerShell Skript und Make.com Blueprint)
- context/ (für Profil und Strategiedateien)

SCHRITT 2 - CONTENTPLAN CSV:
Erstelle eine CSV-Datei outputs/contentplan.csv mit diesen Spalten:
Datum, Uhrzeit, Plattform, Post-Typ, Text, Link, Bild-URL, Bildprompt, Videoprompt, Text-Overlay, Karussell-Slides, Status

Befülle den Plan mit zehn Posts für die nächsten zwei Wochen passend zu meiner Nische.
(Ich gebe dir meine Nische, Zielgruppe und Tonalität im nächsten Schritt.)

SCHRITT 3 - POWERSHELL SKRIPT:
Erstelle scripts/post-trigger.ps1 das:
- Den Contentplan CSV liest (UTF-8)
- Den heutigen Post findet (nach Datum)
- Den Post als JSON-Payload an einen Make.com Webhook sendet (UTF-8 encoded)
- Alles in outputs/post-trigger-log.txt protokolliert
- Facebook-Posts und Karussell-Posts überspringt mit Hinweis

Das JSON-Payload soll folgende Felder enthalten:
post_typ, datum, plattform, text, link, bildprompt, videoprompt, textoverlay

SCHRITT 4 - WINDOWS TASK SCHEDULER:
Zeig mir Schritt für Schritt, wie ich einen Windows Task einrichte,
der das Skript täglich zur gewünschten Uhrzeit ausführt.

SCHRITT 5 - MAKE.COM BLUEPRINT:
Ich habe bereits eine Blueprint-JSON-Datei im Paket (make-blueprint-webhook-v3.json).
Zeig mir wie ich diese in Make.com importiere und die Verbindungen (Instagram, fal.ai) einrichte.

Meine Nische: [HIER DEINE NISCHE EINTRAGEN]
Meine Zielgruppe: [HIER DEINE ZIELGRUPPE EINTRAGEN]
Mein Ton: [HIER DEINEN STIL BESCHREIBEN]

Bitte fang mit Schritt 1 an und warte auf meine Bestätigung bevor du weitergehst.
```

---

## Datei 6 — Quick-Start Checkliste

### Instagram Reel Autopilot — Quick-Start in zehn Schritten

**Einmalige Einrichtung (ca. zwei bis vier Stunden):**

☐ **Schritt 1 — Accounts prüfen**
Instagram Business Account aktiv? Make.com Account erstellt? fal.ai Account mit Guthaben?

☐ **Schritt 2 — Claude Code öffnen**
Den mitgelieferten Setup-Prompt (Datei 5) in Claude Code einfügen.
Deine Nische und Zielgruppe am Ende eintragen.

☐ **Schritt 3 — Contentplan befüllen**
Claude Code erstellt dir einen ersten Plan. Prüfen, anpassen, speichern.

☐ **Schritt 4 — Make.com Blueprint importieren**
In Make.com: Neues Szenario → Importieren → Datei 2 (make-blueprint-webhook-v3.json) hochladen.

☐ **Schritt 5 — Verbindungen in Make.com einrichten**
Instagram Business Verbindung herstellen.
fal.ai API Key eintragen (aus deinem fal.ai Dashboard).

☐ **Schritt 6 — Webhook URL kopieren**
In Make.com den Webhook-URL kopieren.

☐ **Schritt 7 — Webhook URL ins PowerShell-Skript eintragen**
post-trigger.ps1 öffnen, Webhook URL bei $webhookUrl eintragen, speichern.

☐ **Schritt 8 — Skript testen**
PowerShell öffnen, post-trigger.ps1 manuell ausführen.
Log-Datei prüfen: outputs/post-trigger-log.txt

☐ **Schritt 9 — Windows Task Scheduler einrichten**
Aufgabe anlegen: täglich zur gewünschten Uhrzeit das Skript ausführen.
Anleitung Seite 12 in der PDF.

☐ **Schritt 10 — Ersten echten Post testen**
Datum im Contentplan auf heute setzen, Status auf "geplant".
Skript manuell starten. Make.com prüfen. Instagram prüfen.

**Wenn alles grün ist — das System läuft.**
Ab jetzt nur noch Contentplan ausfüllen. Den Rest erledigt die Automation.

---

## Hinweise für den ZIP-Zusammenbau

**Was du tun musst:**

eins. `instagram-autopilot-system-v1.md` als PDF exportieren → `1_Anleitung_Instagram_Reel_Autopilot.pdf`
zwei. `scripts/make-blueprint-webhook-v3.json` → umbenennen in `2_Make-Blueprint_importieren.json`
drei. `scripts/post-trigger.ps1` → direkt übernehmen als `3_post-trigger.ps1`
vier. Die CSV-Vorlage oben als `4_contentplan_vorlage.csv` speichern
fünf. Den Setup-Prompt oben als `5_Setup-Prompt_Claude-Code.txt` speichern
sechs. Die Checkliste oben als PDF exportieren → `6_Quick-Start-Checkliste.pdf`

Dann ZIP-Archiv erstellen: Rechtsklick → Senden an → ZIP.
Fertig zum Upload in ALFIMA.
