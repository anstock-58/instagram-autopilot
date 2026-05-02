# Instagram Reel Autopilot — KI Social Media Automation
## Vollautomatische Posts mit Claude Code + Make.com + fal.ai

---

## Was dieses System macht

Einmal einrichten. Dann läuft es von selbst.

Du trägst deinen Contentplan als CSV-Datei ein — Claude Code erledigt den Rest. Jeden Tag um die eingestellte Uhrzeit generiert das System automatisch ein KI-Video oder KI-Bild und postet es mit der richtigen Caption auf Instagram. Kein manuelles Posten. Kein Kopieren. Kein Formatieren.

Reels werden mit Kling v3 (fal.ai) als cinematic B-Roll generiert.
Fotos werden mit FLUX (fal.ai) generiert.
Das Posting läuft vollautomatisch über Make.com und die Instagram Graph API.

---

## Architektur

```
Contentplan CSV  →  Windows Task Scheduler  →  PowerShell Skript
     →  Make.com Webhook  →  fal.ai (Video/Bild)  →  Instagram
```

---

## Was du brauchst

**Konten (alle kostenlos oder bereits vorhanden):**
- Claude Code (bereits vorhanden)
- Make.com Account (Free Tier reicht für den Anfang)
- fal.ai Account (Pay-per-use, kein Abo)
- Instagram Business Account
- Facebook Developer Account (kostenlos)
- Windows PC (für Task Scheduler)

**Laufende Kosten:**
- fal.ai Kling Video: ca. 0,30–0,50 USD pro Reel
- fal.ai FLUX Bild: ca. 0,03 USD pro Foto
- Make.com: kostenlos (Free Tier)
- Gesamtkosten bei täglichem Posting: ca. 10–15 USD/Monat

---

## Die drei Kernkomponenten

### 1. Contentplan CSV
Eine einfache Tabellendatei mit allen geplanten Posts.
Spalten: Datum, Uhrzeit, Plattform, Post-Typ, Text, Link, Bildprompt, Videoprompt, Text-Overlay, Status

Einmal befüllen — Claude Code kann den Plan für Wochen im Voraus erstellen.

### 2. PowerShell Trigger-Skript (post-trigger.ps1)
Läuft täglich automatisch via Windows Task Scheduler.
Liest den Contentplan, findet den heutigen Post, sendet alles an Make.com.
Logs werden automatisch gespeichert.

### 3. Make.com Szenario
Empfängt den Webhook, ruft fal.ai auf (Video oder Bild), wartet auf das Ergebnis und postet automatisch auf Instagram.
Zwei parallele Pfade: Reel-Pfad und Foto-Pfad, automatisch gesteuert über den Post-Typ.

---

## Erweiterungsmöglichkeiten je nach Budget

**Kostenlos erweiterbar:**
- Text-Overlay im Video (über Prompt-Engineering in Kling)
- Mehrere Instagram Accounts (neues Make.com Szenario pro Account)
- LinkedIn-Posts (zusätzlicher Pfad in Make.com)

**Mit kleinem Budget (ab 29 USD/Monat):**
- Creatomate: automatische Untertitel + Hintergrundmusik auf jedem Video
- ElevenLabs: KI-Stimme als Voiceover

**Mit größerem Budget:**
- HeyGen: eigener Avatar spricht im Video
- Mehrere Plattformen parallel (TikTok, YouTube Shorts, Facebook)

---

## Für wen ist das System?

Coaches, Berater, Unternehmer und Content Creator die:
- täglich auf Instagram posten wollen ohne es täglich zu tun
- faceless Content mit KI-Video bevorzugen
- keine technische Erfahrung mit APIs haben
- ihre Zeit für echte Arbeit nutzen wollen

---

## Einrichtungszeit

Ca. 2–4 Stunden für die komplette Ersteinrichtung.
Danach: nur noch Contentplan befüllen, alles andere läuft von selbst.

---

## Der Claude Code Setup-Prompt

Den folgenden Prompt einfach in Claude Code einfügen — Claude baut das System dann Schritt für Schritt auf:

---

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

Befülle den Plan mit Posts für die nächsten 4 Wochen passend zu meiner Nische.
(Ich gebe dir meine Nische, Zielgruppe und Tonalität im nächsten Schritt.)

SCHRITT 3 - POWERSHELL SKRIPT:
Erstelle scripts/post-trigger.ps1 das:
- Den Contentplan CSV liest (UTF-8)
- Den heutigen Post findet (nach Datum)
- Den Post als JSON-Payload an einen Make.com Webhook sendet (UTF-8 encoded)
- Alles in outputs/post-trigger-log.txt protokolliert
- Facebook-Posts und Karussell-Posts überspringt mit Hinweis (noch nicht implementiert)

Das JSON-Payload soll folgende Felder enthalten:
post_typ, datum, plattform, text, link, bildprompt, videoprompt, textoverlay

SCHRITT 4 - WINDOWS TASK SCHEDULER:
Erstelle einen Windows Task der das Skript täglich um 17:55 Uhr ausführt.
Erkläre mir wie ich das einrichte (Claude Code kann keinen Task direkt anlegen,
aber soll mir den genauen Weg zeigen).

SCHRITT 5 - MAKE.COM BLUEPRINT:
Erstelle eine JSON-Datei scripts/make-blueprint.json mit einem Make.com Szenario das:
- Einen Custom Webhook als Trigger hat
- Bei Post-Typ "Reel": fal.ai Kling v3 aufruft (https://fal.run/fal-ai/kling-video/v3/standard/text-to-video)
  mit Prompt aus dem Webhook-Payload, Duration 5, Aspect Ratio 9:16
- Bei Post-Typ "Foto": fal.ai FLUX aufruft (https://fal.run/fal-ai/flux/dev)
  mit Prompt aus dem Webhook-Payload
- Das generierte Video/Bild automatisch auf Instagram postet
  (über Instagram for Business Modul in Make.com)
- Filter verwendet um Reel-Pfad und Foto-Pfad zu trennen

Erkläre mir danach wie ich:
1. Das Blueprint in Make.com importiere
2. Meine Instagram-Verbindung einrichte
3. Meinen fal.ai API Key eintrage
4. Den Webhook-URL aus Make.com in das PowerShell-Skript eintrage

WICHTIG:
- Alle Texte in UTF-8 (Umlaute müssen korrekt übertragen werden)
- Logs bei jedem Lauf
- Fehler werden geloggt, das Skript bricht nicht ab
- Das System soll täglich ohne mein Zutun laufen

Bitte fang mit Schritt 1 an und warte auf meine Bestätigung bevor du weitergehst.
Wenn du Fragen zu meiner Nische oder Zielgruppe hast — frag jetzt.
```

---

## Hinweise für die Weitergabe

Dieses System funktioniert für jeden Instagram Business Account.
Die Videoprompts und Captions werden von Claude Code individuell für jede Nische erstellt.
Der technische Kern bleibt gleich — nur der Content ändert sich.

Bei Fragen oder Problemen beim Setup: Die Community kann sich gegenseitig helfen,
da jeder die gleiche Basis hat.

---

*Erstellt im Mai 2026 | Claude Code + Make.com + fal.ai*
*Pionier-System für vollautomatisches Instagram-Posting mit KI*
