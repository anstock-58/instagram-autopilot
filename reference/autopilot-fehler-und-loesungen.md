# Instagram Autopilot — Bekannte Fehler und Lösungen

Alle Fehler die beim Aufbau des Systems aufgetreten sind.
Relevant für eigene Fehlersuche und als Grundlage für das Produkt.

---

## 1. UTC vs. CEST — Zeitfenster schlägt fehl

**Symptom:** GitHub Actions zeigt "Success" in 11-17 Sekunden, aber kein Post erscheint auf Instagram.

**Ursache:** Der Ubuntu-Runner läuft in UTC. PowerShell's `Get-Date` gibt UTC-Zeit zurück (z.B. 15:55). Das CSV hat Uhrzeiten in CEST (z.B. 18:00). Der Zeitfenster-Check berechnet eine Differenz von -125 Minuten → blockiert.

**Lösung:** In jeder Workflow-YML-Datei unter `env:` hinzufügen:
```yaml
TZ: Europe/Berlin
```

**Wo:** Alle `.github/workflows/*.yml` Dateien im `env:` Block des Posting-Steps.

---

## 2. CSV-Dateiname passt nicht zum Skript

**Symptom:** `FEHLER: Kein [Account]-CSV fuer Monat 'mai' gefunden.`

**Ursache:** Jedes Skript sucht nach einem accountspezifischen CSV-Namen:
- `contentplan_business_und_spirit_mai_v2.csv`
- `contentplan_ki_support_mai_v1.csv`
- `contentplan_andi_mit_system_mai_v1.csv`

Ein allgemeines `contentplan_mai_v2.csv` wird nicht gefunden.

**Lösung:** CSV immer mit vollem Account-Namen benennen. Schema:
```
contentplan_[account]_[monat]_v1.csv
```

---

## 3. Blotato Polling-Endpoint — 404

**Symptom:** `Route GET:/v2/videos/{id} not found` — Polling schlägt fehl, kein Video-URL.

**Ursache:** Falscher Endpoint. Das AI Story Video Template ist asynchron und gibt zuerst nur eine Job-ID zurück.

**Falsche Endpoints:**
- `GET /v2/videos/{id}` → 404
- `GET /v2/videos/from-templates/{id}` → 404

**Richtiger Endpoint:**
```
GET /v2/videos/creations/{id}
```

**Response-Feld für Video-URL:** `item.mediaUrl` (nicht `videoUrl` oder `url`)

---

## 4. Write-Output in PowerShell-Funktionen verschmutzt Rückgabewerte

**Symptom:** Funktion `Post-Instagram` gibt immer `$true` zurück, auch wenn der Post fehlschlägt. Status wird fälschlich auf "Gepostet" gesetzt.

**Ursache:** In PowerShell werden alle `Write-Output`-Ausgaben innerhalb einer Funktion Teil des Rückgabewerts. Log-Zeilen gelten dann als `$true`.

**Lösung:** In `Write-Log` niemals `Write-Output` verwenden, sondern:
```powershell
Write-Host $line   # nur Konsole, kein Rückgabewert
```

---

## 5. Join-Path mit 3 Argumenten — PS 5.1 Fehler

**Symptom:** PowerShell-Fehler beim Start des Skripts (rot blinkendes Fenster).

**Ursache:** PowerShell 5.1 (Windows Standard) akzeptiert nur 2 Positionsargumente bei `Join-Path`. PS 7 akzeptiert mehr.

**Falsch (PS 5.1 nicht kompatibel):**
```powershell
Join-Path $basePath "outputs" "logfile.txt"
```

**Richtig:**
```powershell
Join-Path $basePath "outputs\logfile.txt"
```

---

## 6. Zwei Workflows für denselben Account — Doppelposting

**Symptom:** Post erscheint doppelt, oder einer der Workflows schlägt fehl weil der andere schon gepostet hat.

**Ursache:** Beim Umbau auf accountspezifische Skripte laufen alter und neuer Workflow parallel.

**Lösung:** Alten Workflow deaktivieren — cron-Zeile entfernen, nur `workflow_dispatch` behalten:
```yaml
on:
  workflow_dispatch:   # Nur manuell — ersetzt durch [neuer-workflow].yml
```

---

## 7. Zeitfenster zu eng bei manuellem Re-run

**Symptom:** Manueller Re-run zeigt "Success" aber kein Post erscheint.

**Ursache:** Das Skript prüft ob der aktuelle Zeitpunkt innerhalb von -10 bis +45 Minuten der geplanten Uhrzeit liegt. Wenn der Re-run Stunden später läuft, schlägt der Check still fehl (exit code 0).

**Lösung für Notfall-Posts:** Skript lokal ausführen mit temporär erweitertem Zeitfenster:
```powershell
$zeitfensterSpaet = 480   # 8 Stunden — für manuelle Nachposts
```
Nach dem Post wieder auf 45 zurücksetzen.

---

## 8. Umlaute im Voiceover falsch gesprochen

**Symptom:** ElevenLabs spricht "ue", "ae", "oe" als einfache Vokale — klingt falsch.

**Ursache:** Wenn im CSV ue/ae/oe statt ü/ä/ö steht, liest die TTS-Engine die Ersetzung falsch vor.

**Lösung:** Im CSV-Feld `Text-Overlay` immer echte deutsche Umlaute verwenden: `ü ä ö ß`

---

## 9. Captions zweizeilig — visuell unruhig

**Ursache:** Blotato bricht lange Sätze in mehrere Zeilen um.

**Lösung:** Sätze im `Text-Overlay` auf maximal 8-10 Wörter begrenzen. Kürzere Sätze = einzeilige Captions.

---

## 10. Kein CTA im Text-Overlay

**Falsch:** CTA im Text-Overlay + nochmal in Scene 2 → doppelter CTA, wirkt unprofessionell.

**Richtig:** `Text-Overlay` enthält nur die Hauptbotschaft. Scene 2 im Skript ist fest verdrahtet mit dem Account-spezifischen CTA.

---

## 11. Blotato voiceName — vollständiger Name erforderlich

**Symptom:** `FEHLER AI-Video-Erstellung: voiceName: must be one of: ...`

**Ursache:** Die Blotato API erwartet den vollständigen Stimmen-String inklusive Beschreibung in Klammern. Kurzer Name allein wird abgelehnt.

**Falsch:**
```powershell
$voiceName = "George"
```

**Richtig:**
```powershell
$voiceName = "George (British, warm)"
```

**Alle gültigen Stimmen:** Alice (British, confident), Aria (American, expressive), Bill (American, trustworthy), Brian (American, deep), Callum (Transatlantic, intense), Charlie (Australian, natural), Charlotte (Swedish, seductive), Chris (American, casual), Daniel (British, authoritative), Eric (American, friendly), George (British, warm), Jessica (American, expressive), Laura (American, upbeat), Liam (American, articulate), Lily (British, warm), Matilda (American, friendly), River (American, confident), Roger (American, confident), Sarah (American, soft), Will (American, friendly)

---

## 12. Bildprompt als Fallback für Stories

**Symptom:** `FEHLER: Weder Videoprompt noch Bild-URL vorhanden. Post uebersprungen.`

**Ursache:** Das Posting-Skript prüft nur Videoprompt und Bild-URL. Stories nutzen jedoch Bildprompt statt Videoprompt.

**Lösung:** Im Skript nach Bild-URL noch Bildprompt als dritten Fallback prüfen:
```powershell
$imageSource = $row.Videoprompt.Trim()
if (-not $imageSource -or $imageSource -eq "") { $imageSource = $row.'Bild-URL'.Trim() }
if (-not $imageSource -or $imageSource -eq "") { $imageSource = $row.Bildprompt.Trim() }
```

**Regel für Contentpläne:**
- Reels → Videoprompt ausfüllen, Bildprompt leer
- Stories/Fotos → Bildprompt ausfüllen, Videoprompt leer

---

## 13. Doppelposting durch parallele Trigger

**Symptom:** Post erscheint zweimal — einmal um 09:00, einmal um 11:00.

**Ursache:** GitHub Actions Schedule-Cron (06:55 UTC = 08:55 CEST) und cron-job.org (09:00 CEST) triggern denselben Workflow parallel. Beide finden den Post als "Geplant" bevor der erste den Status auf "Gepostet" setzen konnte.

**Lösung:** Nur EINEN Trigger pro Workflow verwenden. Schedule-Cron aus Story-Workflows entfernen, ausschließlich cron-job.org nutzen:
```yaml
on:
  workflow_dispatch:   # Nur cron-job.org triggert — kein schedule!
```

**Regel:** Entweder GitHub Actions Cron ODER cron-job.org — niemals beides gleichzeitig für denselben Workflow.

---

## 14. CSV-Parsing bricht durch ASCII-Anführungszeichen in Texten

**Symptom:** PowerShell `Import-Csv` liest 3× mehr Zeilen als erwartet. Viele Zeilen haben Null-Datum, Link-Felder sind leer oder enthalten Videoprompt-Inhalte.

**Ursache:** Texte mit deutschen Dialog-Anführungszeichen wie `„text?"` wo die schließende `"` ein ASCII U+0022 ist (kein typographisches U+201D). PowerShell behandelt dieses `"` als CSV-Feldabschluss → Zeile bricht mittendrin ab.

**Falsch (CSV-Feldabschluss vorzeitig):**
```
„Warum bin ich so unzufrieden?" → endet mit U+0022
```

**Richtig (typographisches Anführungszeichen):**
```
„Warum bin ich so unzufrieden?" → endet mit U+201D
```

**Regel für Contentplan-Generatoren:**
- Dialog-Anführungszeichen im Text immer als `„text"` (U+201E + U+201D) schreiben
- Niemals ASCII `"` (U+0022) als schließendes Anführungszeichen in Texten verwenden
- In JavaScript: `“` für öffnendes, `”` für schließendes Anführungszeichen

---

## 15. Neuer Workflow — erster Cron-Run wird übersprungen

**Symptom:** Neuer Story-Workflow triggert am ersten Tag nicht automatisch, obwohl cron korrekt konfiguriert.

**Ursache:** GitHub Actions führt Cron-Jobs für neu hinzugefügte Workflows manchmal erst ab dem nächsten Zyklus aus.

**Lösung:** Nach dem ersten Push eines neuen Workflows einmal manuell via GitHub API triggern:
```powershell
Invoke-RestMethod -Uri "https://api.github.com/repos/[USER]/[REPO]/actions/workflows/[WORKFLOW].yml/dispatches" `
  -Method POST -Headers @{ Authorization = "Bearer [PAT]"; Accept = "application/vnd.github+json" } `
  -Body '{"ref":"master"}'
```

---

## 16. PS5.1 Set-Content zerstört Emojis in Scripts — ParserError

**Symptom:** Scripts laufen plötzlich nicht mehr. GitHub Actions zeigt `ParserError` auf einer Zeile mit Emoji-Zeichen (z.B. Zeile 232, 268). Emojis im Log erscheinen als `âœ…`, `âŒ`, `â€"`.

**Ursache:** PowerShell 5.1 (`Set-Content -Encoding UTF8`) liest UTF-8-Dateien ohne BOM als Windows-1252 (Western European). Die Emoji-Bytes werden falsch interpretiert. Wenn die Datei dann wieder geschrieben wird, entstehen doppelt-kodierte UTF-8-Bytesequenzen — die PS5.1-Runtime kann sie nicht mehr parsen.

Konkret: `✅` (U+2705) wird als `â` + `œ` + `…` gelesen und dann als UTF-8 zurückgeschrieben → `âœ…` = ungültige Syntax.

**Betroffene Operationen:**
- `Set-Content -Encoding UTF8` nach `Get-Content` ohne `-Encoding UTF8`
- Das Claude Code Edit-Tool (konvertiert ASCII-Anführungszeichen zu typografischen)
- Jede manuelle Textbearbeitung über Windows-Text-Tools die als Windows-1252 speichern

**Lösung: Immer Node.js für Script-Änderungen verwenden**

```javascript
// Richtig: Node.js liest und schreibt UTF-8 korrekt
const fs = require('fs');
let content = fs.readFileSync('script.ps1', 'utf8');
if (content.charCodeAt(0) === 0xFEFF) content = content.slice(1);  // BOM entfernen
content = content.replace('alter Wert', 'neuer Wert');
fs.writeFileSync('script.ps1', content, { encoding: 'utf8' });
```

**Notfall-Restore:** Sauberen Stand aus Git holen und Änderung in einem Schritt anwenden:
```bash
git show COMMIT_HASH:scripts/post-trigger-ACCOUNT.ps1 | node -e "
const fs=require('fs');
let d='';
process.stdin.on('data',c=>d+=c);
process.stdin.on('end',()=>{
  d=d.replace('OLD_VALUE','NEW_VALUE');
  fs.writeFileSync('scripts/post-trigger-ACCOUNT.ps1',d,{encoding:'utf8'});
});
"
```

**Manuelle Trigger nach Script-Fixes:** Falls Scripts tagsüber gefixt werden und die Zeitfenster schon abgelaufen sind, kann über GitHub API manuell getriggert werden (workflow_dispatch bypassed Zeitfenster):
```bash
curl -X POST \
  -H "Authorization: token GITHUB_PAT" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/anstock-58/instagram-autopilot/actions/workflows/WORKFLOW.yml/dispatches \
  -d '{"ref":"master"}'
```

---

## Schnell-Checkliste bei "kein Post erschienen"

1. GitHub Actions Log öffnen → Fehlermeldung lesen
2. Läuft der Job schnell durch (unter 20 Sek.)? → Zeitfenster-Problem (UTC/CEST)
3. "CSV nicht gefunden"? → Dateiname prüfen (accountspezifisch?)
4. "404 videos/..."? → Polling-Endpoint prüfen (muss `/v2/videos/creations/{id}` sein)
5. Status "Gepostet" obwohl nichts auf Instagram? → Write-Output Bug (Write-Host verwenden)
6. Zwei Workflows aktiv? → Alten Workflow cron deaktivieren
7. "voiceName: must be one of"? → Vollständigen Stimmen-String mit Klammern verwenden (Fehler 11)
8. "Weder Videoprompt noch Bild-URL vorhanden"? → Bildprompt-Fallback im Skript ergänzen (Fehler 12)
9. Post erscheint doppelt? → Schedule-Cron aus Workflow entfernen, nur cron-job.org nutzen (Fehler 13)
10. CSV hat zu viele Zeilen, Links fehlen? → ASCII-Anführungszeichen in Texten prüfen (Fehler 14)
11. Neuer Account postet am ersten Tag nicht? → Workflow einmalig manuell triggern (Fehler 15)
12. Scripts kaputt nach Änderung (ParserError, Emojis korrupt)? → PS5.1-Encoding-Problem — immer Node.js verwenden (Fehler 16)
