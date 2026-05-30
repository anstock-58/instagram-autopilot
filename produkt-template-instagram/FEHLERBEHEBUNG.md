# Fehlerbehebung — Was tun wenn kein Post erscheint

## Schnell-Checkliste

Öffne **Actions** in deinem GitHub Repo → klicke auf den letzten Run → lies den Log.

| Was siehst du? | Ursache | Lösung |
|---|---|---|
| Job läuft in unter 20 Sekunden durch, kein Post | Zeitfenster-Problem | Uhrzeit in CSV prüfen (passt sie zum Zeitpunkt des Runs?) |
| "Kein CSV gefunden" | Falscher Dateiname | Datei muss `contentplan_MONAT_v1.csv` heißen |
| "BLOTATO_API_KEY" Fehler | API Key fehlt | Secret in Repo Settings prüfen |
| "404 videos/..." | Falscher API Endpoint | Template neu holen (Bug in altem Skript) |
| Status "Gepostet" aber nichts auf Instagram | Write-Output Bug | Template neu holen (Bug in altem Skript) |

---

## Problem 1: Kein Post obwohl Action "Success" zeigt

**Typisches Symptom:** Der GitHub Actions Job ist grün (erfolgreich), aber auf Instagram erscheint nichts. Der Job läuft in unter 20 Sekunden durch.

**Ursache:** Das Zeitfenster schlägt fehl. Das Skript prüft ob der aktuelle Zeitpunkt innerhalb von -10 bis +45 Minuten der geplanten Uhrzeit liegt.

**Lösung:**
- Öffne deine CSV
- Prüfe die Uhrzeit-Spalte: stimmt sie mit dem geplanten Zeitpunkt überein?
- Beispiel: Story um 09:00, Reel um 18:00
- Der Timezone-Fix ist im Template bereits eingebaut (TZ: Europe/Berlin)

---

## Problem 2: "Kein CSV gefunden"

**Fehlermeldung:** `FEHLER: Kein CSV fuer Monat 'juni' gefunden.`

**Ursache:** Der Dateiname stimmt nicht.

**Richtig:** Das Skript sucht nach `outputs/contentplan_juni_v1.csv`

**Häufige Fehler:**
- Datei heißt `Contentplan_Juni_v1.csv` (falsche Groß/Kleinschreibung → auf Unix-Systemen problematisch)
- Datei heißt `contentplan_june_v1.csv` (Englisch statt Deutsch)
- Datei liegt nicht im `outputs/`-Ordner

**Monatsnamen die das Skript erwartet:**
```
januar, februar, maerz, april, mai, juni,
juli, august, september, oktober, november, dezember
```
Hinweis: März = `maerz` (kein ä, GitHub-Dateisystem)

---

## Problem 3: Voiceover klingt falsch

**Symptom:** ElevenLabs spricht "ue" statt "ü", oder "ae" statt "ä".

**Ursache:** Im Text-Overlay oder Caption-Text wurden ä/ö/ü als ae/oe/ue geschrieben.

**Lösung:** Immer echte deutsche Umlaute verwenden: `ä ö ü ß`

Wenn du in Excel arbeitest und Umlaute fehlen: Datei als UTF-8 mit BOM speichern.

---

## Problem 4: Captions sind zweizeilig

**Symptom:** Die animierten Untertitel brechen in der Mitte um, wirken unruhig.

**Ursache:** Der Text im `Text-Overlay`-Feld ist zu lang.

**Lösung:** Maximal 8 Wörter pro Eintrag in der Text-Overlay-Spalte.

Statt: `Die einzige Entscheidung die wirklich alles verändern kann` (zu lang)
Besser: `Eine Entscheidung verändert alles`

---

## Problem 5: Manueller Test-Run zeigt keinen Post

**Ursache:** Du machst einen manuellen Run, aber die Uhrzeit in der CSV ist z.B. 18:00 und es ist jetzt 14:00 — der Zeitfenster-Check (-10 bis +45 Minuten) schlägt fehl.

**Lösung für Tests:**
Setze einen Eintrag in der CSV auf die aktuelle Uhrzeit (z.B. 14:30), Status auf "Geplant", und starte dann den manuellen Run.

---

## Problem 6: Autopilot postet doppelt

**Ursache:** Zwei Workflows sind für denselben Account aktiv.

**Lösung:** Öffne **Actions** → prüfe welche Workflows es gibt → alte/doppelte Workflows deaktivieren.

---

## Wichtige Links

- Blotato Dashboard: [blotato.com](https://blotato.com)
- GitHub Actions Logs: Dein Repo → Actions → letzter Run → Job-Log
- Support: [Dein Support-Kanal]
