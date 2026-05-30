# Plan: Ideogram V3 Thumbnail Automation

**Erstellt:** 2026-05-21
**Status:** Implementiert
**Anforderung:** Thumbnails vollautomatisch mit Text via fal.ai Ideogram V3 generieren, YouTube Upload und Archiv erhalten. Zusätzlich: automatische Kapitelmarken in der Videobeschreibung aus Audiodauer und Skriptstruktur berechnen.

---

## Überblick

### Was dieser Plan erreicht

Der youtube-producer.ps1 generiert Thumbnails künftig via Ideogram V3 statt FLUX schnell. Ideogram kann Text direkt ins Bild einbauen, lesbar und professionell. Das neue CSV-Feld `Thumbnail_Text` enthält den gewünschten Bildtext. Nach der Generierung wird das Thumbnail wie bisher direkt zu YouTube hochgeladen und ins Archiv kopiert. Zusätzlich berechnet der Producer automatisch Kapitelmarken aus Audiodauer und Skriptstruktur und fügt sie an den Anfang der Videobeschreibung ein. Canva ist für neue Videos nicht mehr nötig.

### Warum das wichtig ist

Thumbnails sind nach Thema und Titel der wichtigste Faktor für Klickrate. Bisher musste Andreas nach jedem automatischen Upload manuell Canva öffnen, Text hinzufügen und das Thumbnail tauschen. Dieser Schritt entfällt vollständig. Die Produktion ist dann zu 100% automatisiert.

---

## Aktueller Zustand

### Relevante bestehende Struktur

- `scripts/youtube-producer.ps1` — Thumbnail-Block ab Zeile 157, nutzt fal-ai/flux/schnell ohne Textfähigkeit
- `outputs/youtube-produktion/video-contentplan.csv` — Spalten: Datum, Kanal, Titel, Beschreibung, Tags, Stimme_ID, Skript, Bildprompt_1 bis Bildprompt_10, Thumbnail_Prompt, Musik_URL, Ausgabeordner, Blotato_Account_ID, Status
- `.claude/commands/research.md` — Befüllt die CSV, muss das neue Feld kennen

### Lücken oder Probleme, die adressiert werden

- FLUX schnell kann keinen lesbaren Text in Bilder einbetten
- Nach jedem Upload war ein manueller Canva-Schritt nötig
- Das neue Feld `Thumbnail_Text` fehlt noch in CSV-Header und research.md
- Videobeschreibungen haben keine Kapitelmarken, obwohl YouTube diese algorithmisch bevorzugt und Zuschauer damit gezielt navigieren können

---

## Vorgeschlagene Änderungen

### Zusammenfassung der Änderungen

- Neues Feld `Thumbnail_Text` in der CSV (nach `Thumbnail_Prompt`)
- Thumbnail-Block im Producer: Ideogram V3 wenn `Thumbnail_Text` vorhanden, sonst FLUX als Fallback
- Automatische Kapitelmarken: Producer liest Audiodauer via FFmpeg, teilt Skript in 5 Kapitelblöcke, berechnet Timestamps proportional und fügt sie an den Anfang der Beschreibung ein
- research.md: Anweisung zum Befüllen von `Thumbnail_Text` und `Kapitel`
- CSV-Header aktualisieren

### Neue Dateien erstellen

Keine neuen Dateien.

### Zu ändernde Dateien

| Dateipfad | Änderungen |
| --- | --- |
| `scripts/youtube-producer.ps1` | Thumbnail-Block ersetzt (Ideogram V3), plus neuer Kapitelmarken-Block nach Audiogenerierung |
| `outputs/youtube-produktion/video-contentplan.csv` | Spalten `Thumbnail_Text` und `Kapitel` einfügen |
| `.claude/commands/research.md` | Felder `Thumbnail_Text` und `Kapitel` in Phase 5 und Phase 6 ergänzen |

### Zu löschende Dateien

Keine.

---

## Design-Entscheidungen

### Getroffene Schlüsselentscheidungen

1. **Ideogram V3 nur wenn Thumbnail_Text gesetzt**: Rückwärtskompatibel. Videos ohne Text-Feld nutzen weiterhin FLUX.
2. **Prompt-Aufbau**: Visueller Prompt aus `Thumbnail_Prompt` wird mit Textanweisung kombiniert. Format: `[Thumbnail_Prompt]. Bold white text at top: [Zeile 1]. Bold yellow text at bottom: [Zeile 2].`
3. **Thumbnail_Text Format**: Zwei Zeilen getrennt durch ` / `. Beispiel: `Du bist nicht faul / Dein Gehirn lügt dich an`
4. **Aspect Ratio**: Ideogram V3 Parameter `aspect_ratio` mit Wert `"16:9"` (laut fal.ai Docs). Wird beim ersten Produktionslauf geprüft.
5. **Archiv und YouTube Upload**: Bleibt unverändert. Gleiches Archivierungsschema wie bisher.
6. **Dateiendung**: Ideogram liefert PNG. Producer speichert als thumbnail.png (statt .jpg) im Ausgabeordner. YouTube Upload und Archiv akzeptieren beide Formate.

### Betrachtete Alternativen

- **FFmpeg Text-Overlay**: Weniger professionell, schlechtere Schriftqualität, kein KI-Stil
- **Canva API**: Komplex, eigene Authentifizierung, unverhältnismäßiger Aufwand
- **Direkte Ideogram API** (ohne fal.ai): Eigener API Key nötig, fal.ai hat Ideogram bereits integriert

### Offene Fragen

Keine. Alle Parameter aus dem erfolgreichen Test bekannt.

---

## Schritt-für-Schritt-Aufgaben

### Schritt 1: CSV-Header aktualisieren

Die erste Zeile der CSV bekommt die neue Spalte `Thumbnail_Text` nach `Thumbnail_Prompt` eingefügt.

**Aktionen:**

- CSV-Datei lesen
- In der Header-Zeile nach `"Thumbnail_Prompt"` suchen
- `"Thumbnail_Text"` direkt danach einfügen
- Alle bestehenden Datenzeilen ebenfalls um eine leere Spalte an dieser Position ergänzen (damit das CSV valide bleibt)
- Datei zurückschreiben

**Betroffene Dateien:**

- `outputs/youtube-produktion/video-contentplan.csv`

---

### Schritt 2: Producer-Skript anpassen

Den Thumbnail-Block in `youtube-producer.ps1` (ab Zeile 157) ersetzen. Neue Logik:

```
Wenn Thumbnail_Text nicht leer:
    Prompt = Thumbnail_Prompt + Textanweisung aus Thumbnail_Text
    API-Aufruf: fal-ai/ideogram/v3
    Parameter: aspect_ratio "16:9", rendering_speed "QUALITY", style_type "REALISTIC"
    Datei: thumbnail.png (Ideogram liefert PNG)
Sonst wenn Thumbnail_Prompt nicht leer:
    Bisheriger FLUX-Code (unveraendert als Fallback)
    Datei: thumbnail.jpg
```

Prompt-Aufbau für Ideogram wenn `Thumbnail_Text` gesetzt:

```powershell
$TextZeilen = $Video.Thumbnail_Text -split " / "
$TextZeile1 = if ($TextZeilen.Count -ge 1) { $TextZeilen[0].Trim() } else { "" }
$TextZeile2 = if ($TextZeilen.Count -ge 2) { $TextZeilen[1].Trim() } else { "" }

$IdeogramPrompt = $Video.Thumbnail_Prompt
if ($TextZeile1 -ne "") { $IdeogramPrompt += ". Large bold white text at top reads: $TextZeile1" }
if ($TextZeile2 -ne "") { $IdeogramPrompt += ". Large bold yellow text at bottom reads: $TextZeile2" }
$IdeogramPrompt += ". YouTube thumbnail style, no watermark, cinematic"
```

API-Aufruf (gleiche Queue-Methode wie FLUX):

```powershell
$ThumbBody = @{
    prompt          = $IdeogramPrompt
    aspect_ratio    = "16:9"
    rendering_speed = "QUALITY"
    style_type      = "REALISTIC"
} | ConvertTo-Json

$ThumbStart = Invoke-RestMethod `
    -Uri "https://queue.fal.run/fal-ai/ideogram/v3" `
    -Method POST `
    -Headers @{ "Authorization" = "Key $FalApiKey"; "Content-Type" = "application/json" } `
    -Body $ThumbBody

$ThumbStatusUrl = $ThumbStart.status_url
$ThumbResultUrl = $ThumbStart.response_url
```

Warte-Schleife und Result-Abruf: identisch wie bei FLUX (status_url pollen, bei COMPLETED response_url abrufen).

Datei speichern als `thumbnail.png` statt `thumbnail.jpg` wenn Ideogram genutzt wird. Variable `$ThumbnailPfad` entsprechend setzen.

Archivkopie und YouTube-Upload-Block bleiben unverändert. Der Upload-Block prüft bereits via `Test-Path $ThumbnailPfad` ob eine Datei vorhanden ist, unabhängig von der Endung.

**Aktionen:**

- Zeile 160 bis 218 lesen (gesamter Thumbnail-Block)
- Block ersetzen durch neue If/Else Struktur wie beschrieben
- Variable `$ThumbnailPfad` korrekt setzen je nach genutztem Modell
- Kommentare auf Deutsch und ohne Gedankenstriche schreiben

**Betroffene Dateien:**

- `scripts/youtube-producer.ps1`

---

### Schritt 3: research.md aktualisieren

In Phase 5 (Bildprompts und Thumbnail) die Anweisung für `Thumbnail_Text` ergänzen.

**Aktionen:**

- In Phase 5 nach dem Thumbnail-Prompt-Abschnitt ergänzen:

```
**Thumbnail_Text** — zwei Zeilen getrennt durch ` / `:
- Zeile 1: kurze Kernbotschaft (3 bis 5 Wörter, Großschreibung)
- Zeile 2: ergänzende Aussage (3 bis 5 Wörter, Großschreibung)
- Beispiel: `Du bist nicht faul / Dein Gehirn lügt dich an`
- Keine Satzzeichen, keine Bindestriche
```

- In Phase 6 (CSV befüllen) das Feld `Thumbnail_Text` in der Feldliste nach `Thumbnail_Prompt` ergänzen

**Betroffene Dateien:**

- `.claude/commands/research.md`

---

### Schritt 4: Kapitelmarken automatisch generieren

Nach der Audiogenerierung (ElevenLabs) kennt der Producer den fertigen Audiodateipfad. Mit FFmpeg wird die Gesamtdauer ausgelesen. Das CSV-Feld `Kapitel` enthält 5 Kapitelnamen, getrennt durch ` | `. Der Producer berechnet die Timestamps proportional und setzt sie an den Anfang der Beschreibung.

**Format des CSV-Felds `Kapitel`:**

```
Einleitung | Warum dein Gehirn bremst | Dopamin und Ablenkung | Was wirklich hilft | Zusammenfassung
```

**Powershell-Logik:**

```powershell
if ($Video.Kapitel -ne "") {
    # Audiodauer ermitteln
    $FfprobeOutput = & "C:\ffmpeg\bin\ffprobe.exe" -v quiet -show_entries format=duration -of csv=p=0 $AudioPfad
    $GesamtSekunden = [double]$FfprobeOutput

    $KapitelNamen = $Video.Kapitel -split " \| "
    $AnzahlKapitel = $KapitelNamen.Count
    $KapitelZeilen = @("00:00 $($KapitelNamen[0].Trim())")

    for ($i = 1; $i -lt $AnzahlKapitel; $i++) {
        $Sekunden = [int]($GesamtSekunden * $i / $AnzahlKapitel)
        $Min = [int]($Sekunden / 60)
        $Sek = $Sekunden % 60
        $Timestamp = "{0:D2}:{1:D2}" -f $Min, $Sek
        $KapitelZeilen += "$Timestamp $($KapitelNamen[$i].Trim())"
    }

    $KapitelBlock = $KapitelZeilen -join "`n"
    $Beschreibung = $KapitelBlock + "`n`n" + $Video.Beschreibung
} else {
    $Beschreibung = $Video.Beschreibung
}
```

Die so zusammengesetzte `$Beschreibung` wird beim YouTube-Upload verwendet statt `$Video.Beschreibung` direkt.

**Aktionen:**

- Audiodauer-Abfrage via ffprobe nach ElevenLabs-Generierung einfügen
- Kapitelberechnung als PowerShell-Block einbauen
- `$Beschreibung` Variable setzen und beim YouTube-API-Aufruf verwenden
- Wenn `Kapitel` leer: `$Beschreibung = $Video.Beschreibung` (kein Kapitelblock)

**Betroffene Dateien:**

- `scripts/youtube-producer.ps1`

---

### Schritt 5: CSV-Feld `Kapitel` ergänzen

Neues Feld `Kapitel` nach `Thumbnail_Text` in CSV-Header und Datenzeilen einfügen.

**Aktionen:**

- CSV-Header: `"Kapitel"` nach `"Thumbnail_Text"` einfügen
- Bestehende Datenzeilen: leere Spalte an dieser Position ergänzen
- Prokrastinations-Zeile: `Kapitel` mit sinnvollen Kapitelnamen befüllen:
  `Einleitung | Warum dein Gehirn bremst | Dopamin und Ablenkung | Was wirklich hilft | Zusammenfassung`

**Betroffene Dateien:**

- `outputs/youtube-produktion/video-contentplan.csv`

---

### Schritt 6: research.md um Kapitel ergänzen

In Phase 5 und Phase 6 das neue Feld dokumentieren.

**Aktionen:**

- Phase 5: Anweisung ergänzen, dass 5 Kapitelnamen passend zur Skriptstruktur generiert werden, getrennt durch ` | `
- Phase 6: Feld `Kapitel` in der Feldliste nach `Thumbnail_Text` aufführen

**Betroffene Dateien:**

- `.claude/commands/research.md`

---

### Schritt 7: Validierung

Manueller Testlauf nach Implementierung.

**Aktionen:**

- Eine Test-Zeile in die CSV eintragen mit befülltem `Thumbnail_Text`
- Producer starten und prüfen ob Ideogram aufgerufen wird
- Prüfen ob das generierte Thumbnail 16:9 Format hat
- Prüfen ob Text korrekt eingebettet ist (Umlaute, Lesbarkeit)
- Prüfen ob Thumbnail zu YouTube hochgeladen wird
- Prüfen ob Archivkopie angelegt wird
- Bei Formatproblem (nicht 16:9): Ideogram V3 Parametername in fal.ai Doku prüfen und anpassen

**Betroffene Dateien:**

- `outputs/youtube-produktion/producer-log.txt` (Laufprotokoll prüfen)

---

## Verbindungen & Abhängigkeiten

### Dateien, die diesen Bereich referenzieren

- `.claude/commands/research.md` befüllt die CSV und muss das neue Feld kennen
- `scripts/youtube-producer.ps1` liest alle CSV-Felder

### Nötige Updates für Konsistenz

- CLAUDE.md muss nicht angepasst werden (keine strukturelle Workspace-Änderung)
- context/current-data.md nach Abschluss mit Stand "Ideogram V3 integriert" aktualisieren

### Auswirkungen auf bestehende Workflows

- Bestehende CSV-Zeilen ohne `Thumbnail_Text` laufen weiterhin mit FLUX (Fallback)
- Kein Breaking Change für bereits produzierte Videos
- Manueller Canva-Schritt entfällt für alle neuen Videos mit befülltem `Thumbnail_Text`

---

## Validierungs-Checkliste

- [ ] CSV-Header enthält `Thumbnail_Text` nach `Thumbnail_Prompt`
- [ ] Bestehende Datenzeilen sind durch leere Spalte korrekt verschoben
- [ ] Producer nutzt Ideogram V3 wenn `Thumbnail_Text` gesetzt
- [ ] Producer nutzt FLUX als Fallback wenn `Thumbnail_Text` leer
- [ ] Generiertes Thumbnail ist 16:9 Format
- [ ] Text im Thumbnail ist lesbar und enthält korrekte Umlaute
- [ ] Thumbnail wird zu YouTube hochgeladen
- [ ] Archivkopie wird angelegt
- [ ] research.md enthält Anweisung für `Thumbnail_Text` und `Kapitel`
- [ ] CSV enthält Spalte `Kapitel` nach `Thumbnail_Text`
- [ ] Producer liest Audiodauer via ffprobe korrekt aus
- [ ] Kapitelmarken werden korrekt berechnet und an Beschreibung vorangestellt
- [ ] Erstes Kapitel beginnt immer mit 00:00
- [ ] Bei leerem `Kapitel`-Feld läuft Producer ohne Fehler durch

---

## Erfolgskriterien

Die Implementierung ist abgeschlossen, wenn:

1. Ein neues Video mit befülltem `Thumbnail_Text` vollautomatisch ein Thumbnail mit lesbarem Text erhält, ohne manuellen Canva-Schritt
2. Das Thumbnail direkt auf YouTube hochgeladen und im Archivordner gespeichert wird
3. Videos ohne `Thumbnail_Text` weiterhin mit FLUX-Thumbnail funktionieren
4. Die Videobeschreibung auf YouTube enthält klickbare Kapitelmarken mit korrekten Timestamps

---

## Notizen

- Ideogram V3 kostet ca. 0,09 USD pro Bild (Quality-Modus) über fal.ai
- Umlaute (ä, ö, ü, ß) funktionieren im Prompt direkt, kein Workaround nötig
- Die Archivdatei bekommt künftig .png Endung statt .jpg wenn Ideogram genutzt wird, das ist korrekt so
- Für spätere Optimierung: A/B Test zwischen verschiedenen Textfarben (weiß/gelb vs. weiß/rot)

---

## Implementierungsnotizen

**Implementiert:** 2026-05-21

### Zusammenfassung

- CSV-Felder `Thumbnail_Text` und `Kapitel` nach `Thumbnail_Prompt` eingefügt
- Prokrastination-Zeile mit beiden Feldern befüllt
- Producer: Ideogram V3 Block wenn `Thumbnail_Text` gesetzt, FLUX als Fallback
- Producer: Kapitelmarken-Block nach Audiogenerierung eingefügt
- Producer: YouTube-Upload nutzt `$Beschreibung` statt `$Video.Beschreibung` direkt
- research.md: Beide neuen Felder in Phase 5 und Phase 6 dokumentiert

### Abweichungen vom Plan

Keine.

### Aufgetretene Probleme

- Prokrastinations-Zeile war nicht via `*Prokrastination*` in Titel auffindbar (Titel enthält das Wort nicht). Gelöst: Identifikation über `Datum=2026-05-26` und `Kanal=BewusstEinfach`.
