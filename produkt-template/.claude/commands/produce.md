# Produce

> Startet die vollautomatische Video-Produktion. Audio, Bilder, Video-Schnitt und YouTube-Upload laufen automatisch. Der Kunde bestaetigt nur den Start.

## Anweisung

Pruefe den Status, zeige eine Zusammenfassung, frage einmal nach Bestaetigung — dann starte die Produktion.

Lies zuerst `context/setup-status.md` um zu pruefen ob Setup abgeschlossen ist.
Falls nicht: "Bitte zuerst /setup ausfuehren."

Lies `outputs/contentplan.csv` und finde alle Zeilen mit Status "Offen".

---

## Phase 1: Vorschau zeigen

Falls mehrere offene Videos vorhanden:
- Liste sie auf und frage welches produziert werden soll

Falls genau ein offenes Video:
- Zeige Zusammenfassung direkt:

```
=== Bereit fuer die Produktion ===

Titel:     [TITEL]
Kanal:     [KANAL]
Laenge:    ca. [X] Minuten (basierend auf Skript-Laenge)
Bilder:    [ANZAHL] Bilder + 1 Thumbnail
Stimme:    [STIMME]
Upload:    nicht gelistet (du schaust erst drauf)

Geschaetzte Dauer: 10-15 Minuten

Produktion starten? (ja/nein)
```

---

## Phase 2: Produktion starten

Nach Bestaetigung mit "ja":

Erklaere was jetzt passiert:
```
Starte Produktion...

Schritt 1/4 — Audio wird generiert (ElevenLabs)
Schritt 2/4 — Bilder werden generiert (fal.ai KI) 
Schritt 3/4 — Video wird zusammengebaut (FFmpeg)
Schritt 4/4 — Upload auf YouTube (nicht gelistet)

Das dauert ca. 10-15 Minuten. Du kannst den Fortschritt im sich oeffnenden Fenster verfolgen.
```

Starte das Script im Hintergrund:
```powershell
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"scripts/youtube-producer-v2.ps1`"" -WindowStyle Normal
```

---

## Phase 3: Ergebnis abfragen

Frage nach ca. 15 Minuten oder sobald der Kunde meldet dass es fertig ist:

"Ist die Produktion abgeschlossen? Was zeigt das Fenster?"

Falls erfolgreich (YouTube-URL sichtbar):
```
=== Video ist fertig! ===

Dein Video ist auf YouTube hochgeladen (nicht sichtbar fuer andere).

Naechste Schritte:
1. YouTube Studio oeffnen: https://studio.youtube.com
2. Video anschauen und pruefen
3. Thumbnail in Canva bearbeiten (Text draufschreiben)
4. Thumbnail hochladen
5. Video auf "Oeffentlich" schalten

Das war's. Zwei Entscheidungen — ein fertiges Video.
```

Falls Fehler aufgetreten:
- Fehlermeldung aus dem Fenster abfragen
- Erklaeren was das bedeutet
- Loesung vorschlagen
- Bei API-Fehler: pruefen ob Keys noch gueltig sind
- Bei FFmpeg-Fehler: Pfad in setup-status.md pruefen

---

## Hinweise fuer haeufige Fehler

**"401 Unauthorized" bei ElevenLabs**: API-Key abgelaufen oder falscher Key. /setup neu ausfuehren.

**"403 Forbidden" bei YouTube**: OAuth-Token abgelaufen. /setup → Phase 3c erneut ausfuehren.

**"FFmpeg not found"**: FFmpeg-Pfad stimmt nicht. Pruefen ob C:\ffmpeg\bin\ffmpeg.exe existiert.

**"fal.ai COMPLETED aber kein Bild"**: API-Auslastung. Skript erneut starten — es macht dort weiter wo es aufgehoert hat (Status bleibt "Offen").
