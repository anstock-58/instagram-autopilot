# Instagram Autopilot — Setup in 5 Schritten

Dein Instagram postet täglich automatisch — ohne dass du etwas tun musst.

**Was danach läuft:**
- Täglich um 09:00 Uhr: Story
- Täglich um 18:00 Uhr: Reel
- KI-generiertes Bild + Voiceover + animierte Captions
- Vollautomatisch — auch wenn dein PC aus ist

---

## Zwei Wege — such dir einen aus

### Weg 1 — Self-Service (197 €, einmalig)

Du richtest alles selbst ein. Diese Anleitung führt dich Schritt für Schritt durch. Dauert ca. 30 Minuten. Danach läuft alles alleine.

**Was du brauchst:**
- GitHub Account (kostenlos)
- Blotato Account (ca. 49 $/Monat)
- 30 Minuten einmalig für das Setup

→ Lies einfach weiter unten.

---

### Weg 2 — Done-for-You (Preis auf Anfrage)

Du willst dich um nichts kümmern. Ich richte dir alles ein, schreibe den ersten Contentplan und du startest sofort. Du lieferst nur deinen Instagram-Account und ein paar Infos zu deinem Thema.

→ Schreib mir auf Instagram: **@ki_support**

---

## Schritt 1 — Blotato Account-ID herausfinden

1. Öffne [blotato.com](https://blotato.com) und melde dich an
2. Klicke oben rechts auf dein Profil → **Accounts**
3. Suche deinen Instagram-Account
4. Die **Account-ID** steht in der URL oder neben dem Account-Namen (5-stellige Zahl, z.B. `46341`)

**Notiere dir diese Zahl — du brauchst sie in Schritt 3.**

---

## Schritt 2 — Diesen Repo forken

1. Öffne [github.com/anstock-58/instagram-autopilot-template](https://github.com/anstock-58/instagram-autopilot-template)
2. Klicke oben rechts auf **Fork**
3. Repo-Name: `instagram-autopilot` (oder beliebig)
4. Klicke **Create fork**

---

## Schritt 3 — API Key als Secret hinterlegen

1. Öffne in deinem geforkten Repo: **Settings → Secrets and variables → Actions**
2. Klicke **New repository secret**
3. Name: `BLOTATO_API_KEY`
4. Value: Deinen Blotato API Key (findest du in Blotato unter Settings → API)
5. Klicke **Add secret**

---

## Schritt 4 — Skript mit deiner Account-ID anpassen

Öffne die Datei `scripts/post-trigger.ps1` in deinem Repo.

Suche diese Zeile:
```
$accountIdIG = "DEINE_BLOTATO_ID"
```

Ersetze `DEINE_BLOTATO_ID` durch deine Account-ID aus Schritt 1.

Beispiel:
```
$accountIdIG = "46341"
```

Speichern (Commit).

---

## Schritt 5 — Contentplan befüllen

Öffne `outputs/contentplan_MONAT_v1.csv` in Excel oder Google Sheets.

**Benenne die Datei um** — exakt nach diesem Schema:
```
contentplan_MONAT_v1.csv
```

Beispiele: `contentplan_juni_v1.csv`, `contentplan_juli_v1.csv`

**Befülle die Spalten:**

| Spalte | Was du einträgst |
|--------|-----------------|
| Datum | TT.MM.JJJJ (z.B. 15.06.2026) |
| Uhrzeit | 09:00 für Story, 18:00 für Reel |
| Plattform | Instagram |
| Post-Typ | Story oder Reel |
| Text | Dein Instagram-Caption-Text mit Emojis und Hashtags |
| Videoprompt | Beschreibung des KI-Bilds (Englisch empfohlen, Editorial-Stil) |
| Text-Overlay | Kurze Hauptbotschaft, max. 8 Wörter, KEINE CTAs hier |
| Status | Geplant |

**Wichtige Regeln für den Contentplan:**

1. **Echte Umlaute verwenden** — immer `ü ä ö ß`, nie `ue ae oe ss`
2. **Text-Overlay max. 8 Wörter** — sonst werden Captions zweizeilig
3. **Kein CTA im Text-Overlay** — der CTA kommt automatisch am Ende des Videos
4. **Status immer "Geplant"** — das Skript ändert ihn nach dem Posting auf "Gepostet"

Lade die CSV-Datei in den `outputs/`-Ordner deines Repos hoch (ersetze die Vorlage-Datei).

---

## Das war's — der Autopilot läuft

Ab jetzt postet GitHub Actions täglich um 08:55 UTC (= 10:55 CEST) und 15:55 UTC (= 17:55 CEST).

**Ersten Test machen:**
1. Öffne in deinem Repo: **Actions → [Account] Autopilot - Reel**
2. Klicke **Run workflow** (oben rechts)
3. Warte 2-3 Minuten
4. Schau auf deinem Instagram — das Reel sollte erscheinen

---

## Häufige Fragen

**Kein Post erschienen nach dem Test-Run?**

1. Öffne **Actions** → klicke auf den letzten Run → lies den Log
2. Läuft der Job in unter 20 Sekunden durch? → Zeitfenster-Problem, lies unten
3. "CSV nicht gefunden"? → Dateiname prüfen (muss `contentplan_MONAT_v1.csv` sein)
4. "404 videos/..."? → Blotato API Key prüfen

**Zeitfenster-Problem beim manuellen Test:**
Das Skript prüft ob der aktuelle Zeitpunkt zur geplanten Uhrzeit passt. Beim manuellen Test-Run einfach einen Eintrag in der CSV auf die aktuelle Uhrzeit setzen (z.B. 14:30), dann klappt der Test.

**Post erscheint, aber Voiceover klingt komisch?**
Prüfe den Text-Overlay: enthält er echte Umlaute (ü, ä, ö) oder Ersetzungen (ue, ae, oe)? Immer echte Umlaute verwenden.

---

## Autopilot pausieren

Erstelle im Repo eine leere Datei namens `PAUSED` → alle Posts werden übersprungen.
Datei löschen → Autopilot läuft wieder.

---

## Du willst keinen Aufwand — Done-for-You

Wenn du das Setup nicht selbst machen willst oder einfach sofort starten möchtest: Ich richte dir den kompletten Autopiloten ein.

- Technisches Setup (GitHub, Blotato, Workflows)
- Erster Contentplan für 4 Wochen
- Dein Account postet ab Tag 1

Schreib mir auf Instagram **@ki_support** mit dem Stichwort **AUTOPILOT**.

---

## Support

Bei technischen Fragen: **@ki_support** auf Instagram
