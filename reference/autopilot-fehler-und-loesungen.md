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

## Schnell-Checkliste bei "kein Post erschienen"

1. GitHub Actions Log öffnen → Fehlermeldung lesen
2. Läuft der Job schnell durch (unter 20 Sek.)? → Zeitfenster-Problem (UTC/CEST)
3. "CSV nicht gefunden"? → Dateiname prüfen (accountspezifisch?)
4. "404 videos/..."? → Polling-Endpoint prüfen (muss `/v2/videos/creations/{id}` sein)
5. Status "Gepostet" obwohl nichts auf Instagram? → Write-Output Bug (Write-Host verwenden)
6. Zwei Workflows aktiv? → Alten Workflow cron deaktivieren
