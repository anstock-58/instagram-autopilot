# Setup

> Einmaliger Einrichtungs-Assistent. Fuehrt durch alle noetigen Schritte um den YouTube Automation Workspace startklar zu machen.

## Anweisung

Fuehre den Kunden Schritt fuer Schritt durch die komplette Einrichtung. Gehe NIE zwei Schritte gleichzeitig. Frage nach jedem Schritt ob er abgeschlossen ist, bevor du weitermachst. Schreibe klar und einfach — kein Fachjargon.

Lies zuerst `context/setup-status.md` um zu sehen welche Schritte bereits erledigt sind.

---

## Phase 1: Systemcheck

Pruefe folgende Punkte und berichte dem Kunden klar was vorhanden ist und was fehlt:

1. **PowerShell-Version**: Fuehre `$PSVersionTable.PSVersion` aus. Mindestens Version 5.1 noetig.
2. **Speicherplatz**: Mindestens 5 GB frei empfohlen (Videos brauchen Platz).
3. **Betriebssystem**: Windows 10 oder 11 (dieser Workspace ist Windows-only).

Falls etwas fehlt: erklaere genau was zu tun ist. Falls alles passt: kurz bestaetigen und zu Phase 2.

---

## Phase 2: FFmpeg installieren

FFmpeg ist das Programm das Bilder und Audio zu einem Video zusammenbaut.

1. Pruefe ob FFmpeg bereits vorhanden ist: `& "C:\ffmpeg\bin\ffmpeg.exe" -version`
2. Falls vorhanden: bestaetigen, weiter zu Phase 3.
3. Falls nicht vorhanden:
   - Erklaere: "FFmpeg ist ein kostenloses Video-Tool. Installation dauert 3 Minuten."
   - Anleitung ausgeben:
     ```
     1. https://www.gyan.dev/ffmpeg/builds/ aufrufen
     2. "ffmpeg-release-essentials.zip" herunterladen
     3. ZIP entpacken nach C:\ffmpeg\
     4. Sicherstellen dass C:\ffmpeg\bin\ffmpeg.exe existiert
     ```
   - Frage: "Hast du FFmpeg installiert? (ja/nein)"
   - Bei Ja: testen ob es funktioniert, dann weiter.

---

## Phase 3: API-Keys einrichten

Die Automation braucht Zugangsdaten zu drei Diensten. Frage nacheinander ab — nicht alle auf einmal.

### 3a: ElevenLabs (Text zu Sprache)

Erklaere: "ElevenLabs verwandelt deinen Text in eine natuerliche Stimme. Kostet ab 6 Dollar pro Monat."

- Link: https://elevenlabs.io
- Anleitung: Konto erstellen → Profile → API Key kopieren
- Frage: "Bitte gib deinen ElevenLabs API Key ein:"
- Key in `context/setup-status.md` unter `ElevenLabsKey` speichern
- Schreibe den Key auch direkt in `scripts/youtube-producer-v2.ps1` an die richtige Stelle

### 3b: fal.ai (KI-Bildgenerierung)

Erklaere: "fal.ai erstellt automatisch Bilder fuer deine Videos. Kostet ca. 0.003 Dollar pro Bild — also etwa 3 Cent fuer 10 Bilder."

- Link: https://fal.ai
- Anleitung: Konto erstellen → API Keys → Key erstellen und kopieren
- Frage: "Bitte gib deinen fal.ai API Key ein:"
- Key in `context/setup-status.md` und `scripts/youtube-producer-v2.ps1` speichern

### 3c: Google YouTube API

Erklaere: "Damit werden Videos automatisch auf deinen YouTube-Kanal hochgeladen. Kostenlos."

Schritt fuer Schritt:
1. https://console.cloud.google.com aufrufen
2. Neues Projekt erstellen — Name z.B. "YouTubeProducer"
3. APIs & Services → Bibliothek → "YouTube Data API v3" suchen → Aktivieren
4. APIs & Services → Zugangsdaten → "+ Zugangsdaten erstellen" → "OAuth-Client-ID"
5. Anwendungstyp: "Desktopanwendung" → Name egal → Erstellen
6. Client-ID und Client-Secret kopieren

Frage nacheinander:
- "Bitte gib deine Google Client-ID ein:"
- "Bitte gib dein Google Client-Secret ein:"

Beide in `context/setup-status.md` und `scripts/youtube-producer-v2.ps1` speichern.

Dann erklaeren: "Jetzt oeffnet sich ein Browser-Fenster. Melde dich mit dem Google-Konto an das mit deinem YouTube-Kanal verknuepft ist und klicke auf 'Zulassen'."

Fuehre aus: `powershell -ExecutionPolicy Bypass -File "scripts/youtube-oauth-run.ps1"`

Warte auf Abschluss, lese den Refresh Token aus der Ausgabe, trage ihn in `context/setup-status.md` und `scripts/youtube-producer-v2.ps1` ein.

---

## Phase 4: Kanal-Profil anlegen

Frage den Kunden:

1. "Wie heisst dein YouTube-Kanal?"
2. "In welcher Sprache sollen die Videos sein?" (Standard: Deutsch)
3. "Welche Nische/Thema soll dein Kanal abdecken?" (oder: "Noch nicht sicher — tippe 'offen'")
4. "Mochtest du lieber eine maennliche oder weibliche Stimme?"

Speichere die Antworten in `context/kanal-profil.md`.

---

## Phase 5: Abschluss-Test

Erklaere: "Wir machen jetzt einen kurzen Test um sicherzustellen dass alles funktioniert."

Erstelle eine minimale Test-Zeile in `outputs/contentplan.csv`:
- Titel: "Test-Video (bitte nicht veroeffentlichen)"
- Skript: "Das ist ein Testlauf. Die Automation funktioniert korrekt."
- Status: "Offen"
- Alle anderen Felder mit Platzhaltern

Fuehre aus: `powershell -ExecutionPolicy Bypass -File "scripts/youtube-producer-v2.ps1"`

Falls erfolgreich: Setup abgeschlossen, Status in `context/setup-status.md` auf "Abgeschlossen" setzen.
Falls Fehler: Fehlermeldung erklaeren, Loesung vorschlagen, erneut versuchen.

---

## Abschluss

Nach erfolgreichem Setup:

```
=== Setup abgeschlossen! ===

Dein YouTube Automation Workspace ist bereit.

Naechste Schritte:
1. /research — lass Claude eine Nische recherchieren und Themen vorschlagen
2. Du waehlst ein Thema
3. /produce — Video wird automatisch produziert und hochgeladen
4. Du schaltest es auf "Oeffentlich"

Zwei Entscheidungen. Ein fertiges Video.
```

Aktualisiere `context/setup-status.md` mit Status "Abgeschlossen" und Datum.
