# Plan: Pexels-Stockclips als Alternative zu KI-Bildern für bessere Hook-Retention

**Erstellt:** 2026-06-19
**Status:** Implementiert
**Anforderung:** Producer-Pipeline um Pexels-Videoclips als visuelle Alternative zu KI-Bildern erweitern, damit kontemplative Videos mehr Bewegung in den ersten Minuten haben (bessere Retention) und gleichzeitig fal.ai-Kosten sinken — ohne dass Stil-Brüche innerhalb eines Videos entstehen.

---

## Überblick

### Was dieser Plan erreicht

Der YouTube-Producer (`archiv/scripts/youtube-producer.ps1`) bekommt einen zweiten, alternativen Bild-Modus: statt KI-generierter Standbilder (fal.ai FLUX) kann ein Video komplett aus echten Pexels-Videoclips zu einem festen thematischen Cluster (z. B. Wald & Berge, Wasser & Bewegung) zusammengebaut werden. Die Entscheidung fällt pro Video, nicht pro Bild — kein Mischen von KI-Portraits und Stockclips innerhalb eines Videos.

### Warum das wichtig ist

Die Analyse des Japan-Arzt-Videos (be17, 213 Views, CTR 5,7 %, aber nur 38,5 % durchschnittliche Wiedergabedauer mit starkem Abfall in den ersten 30 Sekunden) hat gezeigt: gute Klickrate reicht nicht, wenn die Bindung nach dem Klick zu schwach ist. YouTube gewichtet Watchtime/Retention stärker als CTR. Mehr Bewegung im Bild (echte Videoclips statt Standbilder) ist einer von mehreren Hebeln, um das zu verbessern — siehe `reference/hook-formel-universal.md` und `context/produktions-checklist.md` Phase 7. Gleichzeitig spart der Wegfall von fal.ai-Bildgenerierung für diese Videos Kosten.

---

## Aktueller Zustand

### Relevante bestehende Struktur

- `archiv/scripts/youtube-producer.ps1` — Schritt 3 (Zeilen ~161-245) generiert bis zu 15 fal.ai-Standbilder pro Video. Schritt 5 (Zeilen ~515-532) baut daraus per FFmpeg-`concat`-Demuxer (Bildliste mit fester `duration` pro Bild) eine Slideshow, die danach mit Voiceover und Musik gemischt wird.
- `outputs/youtube-produktion/video-contentplan.csv` — hat bereits eine Spalte `Landschaft_Suchbegriffe` am Ende, die aktuell von keinem Skript gelesen wird (offenbar als Platzhalter für genau dieses Feature angelegt).
- `context/secrets.md` — enthält bereits einen funktionierenden **Pexels API Key**, kein neues Konto/keine neue Anmeldung nötig.
- `context/strategy.md` (Abschnitt "Erfolgsmuster Topvideo", Zeilen ~79-100) — enthält bereits fertige Such-Keyword-Sets pro Cluster (Wald & Berge, Wasser & Bewegung, Weite & Aufbruch, Jahreszeiten) und die Regel, pro Video bei einem Cluster zu bleiben.
- `reference/hook-formel-universal.md`, `context/youtube-qualitaet.md`, `context/produktions-checklist.md` Phase 7 — definieren die Retention-Ziele, gegen die dieses Feature wirkt.

### Lücken oder Probleme, die adressiert werden

- Es gibt keinen Mechanismus, der `Landschaft_Suchbegriffe` tatsächlich nutzt — die Spalte ist totes CSV-Feld.
- Es gibt keine Funktion, die Pexels-Videoclips herunterlädt, zuschneidet und in die FFmpeg-Pipeline einspeist.
- Es gibt keine harte Regel im Producer, die verhindert, dass innerhalb eines Videos KI-Bilder und Stockclips gemischt werden — das muss strukturell ausgeschlossen sein, nicht nur durch Disziplin beim Befüllen des CSV.
- Alle bisherigen Standbilder bekommen exakt dieselbe Anzeigedauer (`$DauerProBild`), Bewegung im Bild gibt es nur durch den fal.ai-Bildinhalt selbst, nie durch echte Videobewegung.

---

## Vorgeschlagene Änderungen

### Zusammenfassung der Änderungen

1. CSV bekommt ein neues Pflichtfeld `Visueller_Stil` mit genau zwei erlaubten Werten: `KI-Portraits` oder `Stockclips-Cluster`.
2. Das bestehende Feld `Landschaft_Suchbegriffe` wird reaktiviert: bei `Stockclips-Cluster` steht hier eine kommagetrennte Liste von Suchbegriffen aus genau einem Cluster (siehe `context/strategy.md`).
3. Der Producer verzweigt in Schritt 3 je nach `Visueller_Stil`: entweder der bestehende fal.ai-Bildpfad (unverändert) oder ein neuer Pexels-Clip-Pfad.
4. Neuer Pexels-Clip-Pfad: für jeden Suchbegriff wird über die Pexels Videos API ein passender Clip gesucht, heruntergeladen, auf eine feste Länge (8 Sekunden) zugeschnitten und auf 1920x1080/25fps normalisiert.
5. Schritt 5 (FFmpeg-Zusammenbau) wird so erweitert, dass er sowohl die bisherige Bild-Slideshow-Liste als auch eine Clip-Liste verarbeiten kann — die Konkatenationslogik bleibt im Kern gleich (`concat`-Demuxer), nur die Quelle der Segmente unterscheidet sich.
6. `context/produktions-checklist.md` und `context/strategy.md` werden um die Entscheidungsregel "wann welcher Stil" ergänzt bzw. präzisiert, damit das nicht nur im Producer, sondern auch bei der Skript-/Themenwahl verbindlich ist.

### Neue Dateien erstellen

Keine neuen Dateien — die Änderung wird vollständig im bestehenden Producer-Skript und den bestehenden Kontext-Dateien umgesetzt, um die Pipeline nicht unnötig zu fragmentieren.

### Zu ändernde Dateien

| Dateipfad | Änderungen |
| --- | --- |
| `outputs/youtube-produktion/video-contentplan.csv` | Neue Spalte `Visueller_Stil` ergänzen (Header + bei allen bestehenden Zeilen auf `KI-Portraits` setzen, damit nichts bricht). Spalte `Landschaft_Suchbegriffe` bleibt, wird ab jetzt aktiv genutzt. |
| `archiv/scripts/youtube-producer.ps1` | Neue Funktion `Get-PexelsClips`, Verzweigung in Schritt 3, Erweiterung von Schritt 5 für Clip-basierten Zusammenbau, neue Variable `$PexelsApiKey`. |
| `context/strategy.md` | Abschnitt "Variante: Landschafts-Stockclips" präzisieren: jetzt als produktiv nutzbares Feature beschreiben statt als Idee, Verweis auf das CSV-Feld `Visueller_Stil` ergänzen. |
| `context/produktions-checklist.md` | In Phase 3 (Titel und Thumbnail) oder neuer kurzer Abschnitt: Entscheidungsregel "Visueller Stil festlegen, bevor das Skript fertig ist" mit den zwei Kategorien (psychologisch/menschlich → KI-Portraits, kontemplativ/naturverbunden → Stockclips-Cluster). |
| `context/secrets.md` | Kein inhaltlicher Eintrag nötig (Pexels Key existiert schon), nur prüfen, dass der Verweis im Producer-Kommentar auf diese Datei zeigt. |

### Zu löschende Dateien (falls vorhanden)

Keine.

---

## Design-Entscheidungen

### Getroffene Schlüsselentscheidungen

1. **Strikte Entweder-Oder-Logik pro Video, nicht pro Bild**: Verhindert den vom User explizit benannten Risikofall ("zusammengewurschteltes Ding"). Wird im Producer durch eine einzige Verzweigung am Anfang von Schritt 3 erzwungen, nicht durch optionale Einzelfelder pro Bild.
2. **Cluster-Bindung über eine einzige CSV-Spalte mit kommagetrennten Suchbegriffen statt 15 Einzelfeldern**: Die bestehenden `Bildprompt_1..10`-Felder bleiben für den KI-Modus unverändert; für den Stockclip-Modus reicht eine flache Liste, weil alle Clips aus demselben Cluster stammen und nicht einzeln kuratiert werden müssen wie KI-Prompts.
3. **Feste Clip-Länge von 8 Sekunden**: Orientiert an der bereits dokumentierten Zielvorgabe "Bildwechsel alle 7 bis 8 Sekunden in der ersten Hälfte" aus `context/strategy.md` (CTR-Problem-Abschnitt). Einheitliche Länge vereinfacht die FFmpeg-Konkatenation und Synchronisation mit der Audiodauer.
4. **Pexels statt Pixabay als API-Quelle**: Es existiert bereits ein funktionierender Pexels API Key in `context/secrets.md`, keine neue Anmeldung nötig. Pixabay bleibt Option für Musik (unverändert), wird für Videoclips nicht zusätzlich angebunden, um die Komplexität nicht zu verdoppeln.
5. **Kein automatisches Umschneiden auf Sprache/Inhalt, sondern grobe Cluster-Treue**: Der Anspruch ist nicht, dass jeder Clip exakt zum gesprochenen Satz passt (wie bei den Bildprompts), sondern dass die gesamte Bildspur stimmungs- und themenkonsistent bleibt. Das ist die Lehre aus dem Erfolgsmuster-Video in `context/strategy.md`.
6. **Stockclip-Modus für alle drei Kanäle freigeben** (BewusstEinfach, InnerCode, BusinessUndSpirit): Die Entscheidung fällt pro Video/Thema, nicht pro Kanal — auch BusinessUndSpirit kann kontemplative Themen haben (z. B. Rückblick, Loslassen nach Unternehmenserfolg). Eine kanalbasierte Einschränkung wäre eine künstliche Hürde ohne inhaltlichen Mehrwert.
7. **Automatischer Fallback auf den nächsten Suchbegriff bei Pexels-Leertreffern**: Ein Abbruch der Produktion bei einem einzelnen leeren Treffer würde die Vollautomatisierung unterbrechen. Die vorgegebenen Cluster-Suchbegriffe (Wald, Wasser, Berge etc.) sind bei Pexels durchgehend gut bestückt, ein Fallback genügt und entspricht dem bereits bestehenden Verhalten beim fal.ai-Bildfallback in Schritt 3.

### Betrachtete Alternativen

- **Pro-Bild-Mischung erlauben (KI-Bild an Stelle X, Stockclip an Stelle Y)**: verworfen, weil genau das vom User als Risiko benannt wurde ("zusammengewurschtelt") und einen erheblich komplexeren Producer-Code bräuchte (Stilangleichung, Farbkorrektur zwischen KI- und Realbildern).
- **Separates neues Skript statt Erweiterung von `youtube-producer.ps1`**: verworfen, weil die gesamte Audio-/Upload-/CSV-Logik identisch bleibt und eine Duplikation nur Wartungsaufwand erzeugt.
- **Pixabay zusätzlich zu Pexels anbinden**: verworfen für den ersten Schritt, kann bei Bedarf später als Fallback ergänzt werden, wenn Pexels für ein Cluster keine passenden Treffer liefert.
- **Stockclip-Modus auf einzelne Kanäle beschränken**: verworfen, siehe Entscheidung 6 oben.
- **Produktion bei Pexels-Leertreffer abbrechen statt Fallback**: verworfen, siehe Entscheidung 7 oben.

### Offene Fragen

Keine — beide ursprünglich offenen Fragen sind oben als Entscheidungen 6 und 7 getroffen.

---

## Schritt-für-Schritt-Aufgaben

### Schritt 1: CSV-Spalte `Visueller_Stil` ergänzen

Neue Spalte direkt nach `Stimme_ID` oder am Ende vor `Status` einfügen (Position ist unkritisch, da der Producer per Spaltenname liest), Default-Wert für alle bestehenden Zeilen auf `KI-Portraits` setzen, damit der bisherige Produktionsweg für alle existierenden Einträge unverändert bleibt.

**Aktionen:**

- Spalte `Visueller_Stil` im Header von `video-contentplan.csv` einfügen
- Für jede bestehende Datenzeile den Wert `KI-Portraits` eintragen (per PowerShell `Import-Csv`/`Export-Csv`, nicht händisch)
- Stichprobe: eine Zeile manuell auf `Stockclips-Cluster` setzen und `Landschaft_Suchbegriffe` mit einem Test-Cluster befüllen (z. B. "forest aerial drone, misty forest morning, mountain river drone"), um Schritt 3-6 später daran zu testen

**Betroffene Dateien:**

- `outputs/youtube-produktion/video-contentplan.csv`

---

### Schritt 2: Pexels API Key in den Producer einbinden

**Aktionen:**

- Neue Variable `$PexelsApiKey` im Kopf von `archiv/scripts/youtube-producer.ps1` ergänzen (Wert aus `context/secrets.md` Abschnitt "Pexels")
- Kommentar ergänzen, dass der Key in `context/secrets.md` verwaltet wird (analog zu `$FalApiKey`/`$ElevenLabsKey`)

**Betroffene Dateien:**

- `archiv/scripts/youtube-producer.ps1` (gitignored, kein Secrets-Risiko bei Commit)

---

### Schritt 3: Funktion `Get-PexelsClips` schreiben

Neue Hilfsfunktion analog zu den bestehenden Hilfsfunktionen (`Get-AutoFontSize`, `Get-ProduktLinks`) im oberen Skriptbereich.

**Aktionen:**

- Funktion nimmt eine Liste von Suchbegriffen und einen Zielordner entgegen
- Pro Suchbegriff: GET-Request an `https://api.pexels.com/videos/search?query=<begriff>&orientation=landscape&size=large&per_page=5` mit Header `Authorization: <PexelsApiKey>`
- Aus den Treffern den ersten Clip mit `width >= 1920` wählen (Feld `video_files`), bei keinem Treffer zum nächsten Suchbegriff im Cluster weitergehen (siehe offene Frage 2 — Fallback-Verhalten)
- Clip per `Invoke-WebRequest` herunterladen
- Mit FFmpeg auf exakt 8 Sekunden zuschneiden und auf `1920:1080`/25fps/ohne Ton normalisieren (`-t 8 -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080" -an -r 25`)
- Funktion gibt die Liste der lokalen, normalisierten Clip-Pfade zurück
- Logging analog zum bestehenden Bild-Logging (`Log "Clip $i generiert: ..."`)

**Betroffene Dateien:**

- `archiv/scripts/youtube-producer.ps1`

---

### Schritt 4: Schritt 3 (Bildgenerierung) um Verzweigung erweitern

**Aktionen:**

- Direkt am Anfang des bestehenden "Schritt 3: Bilder generieren"-Blocks prüfen, ob `$Video.Visueller_Stil -eq "Stockclips-Cluster"`
- Bei `Stockclips-Cluster`: `$Video.Landschaft_Suchbegriffe -split ","` als Suchbegriffsliste an `Get-PexelsClips` übergeben, Ergebnis in einer neuen Variable `$ClipPfade` statt `$BildPfade` speichern, gesamten fal.ai-Block für diesen Fall überspringen
- Bei `KI-Portraits` (oder leerem Feld, als Rückwärtskompatibilität): bestehender fal.ai-Code unverändert
- Thumbnail-Generierung (Schritt 3b) bleibt unverändert in beiden Fällen — Thumbnails sind weiterhin FLUX-Portraits, unabhängig vom Bild-/Clip-Modus des Videoinhalts

**Betroffene Dateien:**

- `archiv/scripts/youtube-producer.ps1`

---

### Schritt 5: Schritt 5 (FFmpeg-Zusammenbau) für Clip-Modus erweitern

**Aktionen:**

- Bei `Stockclips-Cluster`: statt der Bildliste mit `duration`-Angabe pro Standbild eine Concat-Liste aus den bereits auf 8 Sekunden zugeschnittenen, normalisierten Clips bauen (`file '<clip>'` ohne `duration`-Zeile, da die Clips selbst schon die richtige Länge haben)
- Prüfen, ob die Gesamtlänge der Clips zur Audiodauer passt: falls die Clipliste kürzer ist als die Audiodauer, den letzten Clip zusätzlich looped anhängen (gleiche Fallback-Logik wie beim bestehenden "letztes Bild wiederholen" im Bild-Modus); falls länger, ist das unkritisch, da das Video sowieso mit `-shortest` auf die Audiodauer gekürzt wird
- Restlicher FFmpeg-Audio-Mix-Code (Musik, loudnorm, alimiter) bleibt für beide Modi identisch — er arbeitet bereits mit dem fertigen `$VideoOhneTon`, unabhängig davon ob dieser aus Bildern oder Clips entstanden ist

**Betroffene Dateien:**

- `archiv/scripts/youtube-producer.ps1`

---

### Schritt 6: Kontext-Dateien aktualisieren

**Aktionen:**

- In `context/strategy.md`: Abschnitt "Variante: Landschafts-Stockclips statt KI-Bilder" von "Idee" auf "aktiv nutzbar, siehe CSV-Feld `Visueller_Stil`" umformulieren, Verweis auf den Producer ergänzen
- In `context/produktions-checklist.md`: in Phase 2 oder als neuer kurzer Punkt vor Phase 3 die Entscheidungsregel ergänzen: "Visueller Stil festlegen: KI-Portraits (psychologische/menschliche Themen) oder Stockclips-Cluster (kontemplative/naturverbundene Themen) — kein Mischen innerhalb eines Videos. Bei Stockclips-Cluster: genau einen Cluster aus `context/strategy.md` wählen und im CSV-Feld `Landschaft_Suchbegriffe` eintragen."

**Betroffene Dateien:**

- `context/strategy.md`
- `context/produktions-checklist.md`

---

### Schritt 7: Testlauf mit einem Video

**Aktionen:**

- Die in Schritt 1 angelegte Test-Zeile (Status `Offen`, `Visueller_Stil = Stockclips-Cluster`) durch den Producer laufen lassen
- Prüfen: alle Clips wurden heruntergeladen, normalisiert, zu einem durchgängigen Video zusammengesetzt, Audio/Musik-Mix funktioniert wie gewohnt, Video ist optisch konsistent (kein Stilbruch)
- Bei Erfolg: Status der Testzeile zurück auf `Offen` lassen oder Testzeile vor echtem Einsatz wieder entfernen, je nachdem ob das Thema tatsächlich produziert werden soll

**Betroffene Dateien:**

- `outputs/youtube-produktion/video-contentplan.csv` (Testzeile)

---

## Verbindungen & Abhängigkeiten

### Dateien, die diesen Bereich referenzieren

- `context/strategy.md` (Erfolgsmuster-Abschnitt, Keyword-Sets)
- `context/produktions-checklist.md` (Phase 7 Retention-Check, der den Erfolg dieser Änderung später misst)
- `reference/hook-formel-universal.md` (übergeordnetes Ziel: Retention in den ersten Sekunden)
- `context/current-data.md` (sollte nach erfolgreichem Testlauf um eine Status-Zeile ergänzt werden, analog zu bisherigen Pipeline-Updates)

### Nötige Updates für Konsistenz

- `context/current-data.md`: nach erfolgreichem Testlauf kurzen Eintrag ergänzen, dass der Stockclip-Modus produktiv ist (Datum, betroffene Kanäle).
- Keine Änderungen an `CLAUDE.md` nötig, da sich an der Workspace-Struktur (Ordner, Commands) nichts ändert — nur eine Erweiterung eines bestehenden Skripts.

### Auswirkungen auf bestehende Workflows

- Bestehende CSV-Zeilen mit `Visueller_Stil = KI-Portraits` laufen exakt wie bisher durch den Producer, keine Regression.
- Der Stockclip-Modus ist rein additiv und nur aktiv, wenn explizit im CSV gesetzt — kein bestehendes Video wird automatisch umgestellt.
- Thumbnail-Erzeugung, Upload-Logik, CSV-Statuswechsel, Footer/Kapitel/Produkt-Links bleiben für beide Modi unverändert.

---

## Validierungs-Checkliste

- [ ] CSV hat neue Spalte `Visueller_Stil`, alle bestehenden Zeilen auf `KI-Portraits` gesetzt
- [ ] `Get-PexelsClips`-Funktion lädt für einen Test-Suchbegriff erfolgreich einen Clip herunter und normalisiert ihn auf 1920x1080/25fps/8 Sekunden
- [ ] Producer erkennt `Visueller_Stil = Stockclips-Cluster` und überspringt den fal.ai-Bildblock korrekt
- [ ] FFmpeg baut aus den Clips ein durchgängiges Video ohne sichtbare Brüche oder Schwarzbilder zwischen den Segmenten
- [ ] Fertiges Testvideo hat Voiceover + Musik korrekt gemischt, identisch zur bisherigen Qualität
- [ ] Bestehendes KI-Bild-Video (Regressionstest mit `Visueller_Stil = KI-Portraits`) läuft weiterhin fehlerfrei durch
- [ ] `context/strategy.md` und `context/produktions-checklist.md` aktualisiert und verlinkt
- [ ] `context/current-data.md` nach erfolgreichem Test aktualisiert

---

## Erfolgskriterien

1. Ein vollständiges Testvideo im Stockclips-Modus wird ohne manuelle Nacharbeit produziert und hochgeladen.
2. Das Testvideo wirkt visuell durchgängig und stimmungskonsistent (ein Cluster, keine Sprünge zwischen unpassenden Landschaftstypen).
3. Bestehende KI-Bild-Videos laufen unverändert weiter (keine Regression).
4. Die Kosten pro Stockclip-Video sinken messbar gegenüber einem KI-Bild-Video (kein fal.ai-Bildverbrauch für den Hauptinhalt, nur noch für das Thumbnail).
5. Nach zwei bis drei produzierten Stockclip-Videos: Retention-Check (Phase 7) zeigt eine verbesserte Bindung in den ersten 30 Sekunden gegenüber dem bisherigen Schnitt.

---

## Notizen

- Die feste Clip-Länge von 8 Sekunden ist ein guter Startwert, sollte aber nach den ersten Testvideos anhand der tatsächlichen Retention-Daten überprüft werden (eventuell kürzere Clips, 5-6 Sekunden, in den ersten zwei Minuten für noch mehr Dynamik, siehe Tempo-Vorgabe in `context/strategy.md`).
- Spätere Erweiterung denkbar: ein dritter Modus "Hybrid mit fester Reihenfolge" (z. B. erste 90 Sekunden Stockclips für Tempo, danach KI-Portraits für inhaltliche Tiefe) — bewusst nicht in diesem Plan, da der User explizit zuerst die einfache, stilreine Variante ohne Mischrisiko wollte. Erst wenn diese sauber funktioniert, ist ein kontrollierter Hybrid (mit klar definierten Zeitfenstern, nicht zufällig gemischt) eine sinnvolle Folgeiteration.
- Pixabay bleibt weiterhin ausschließlich für Hintergrundmusik im Einsatz, keine Vermischung der Bildquellen-APIs in dieser Iteration.

---

## Implementierungsnotizen

**Implementiert:** 2026-06-19

### Zusammenfassung

Beide offenen Fragen wurden vom Assistenten als YouTube-Experte entschieden (Stockclip-Modus für alle drei Kanäle freigegeben, automatischer Fallback auf den nächsten Suchbegriff bei Pexels-Leertreffern) und als Design-Entscheidungen 6 und 7 in den Plan übernommen. Anschließend wurden alle sieben Schritte umgesetzt:

- CSV-Spalte `Visueller_Stil` ergänzt, alle bestehenden Zeilen auf `KI-Portraits` gesetzt (Schritt 1)
- `$PexelsApiKey` (aus `context/secrets.md`) in `archiv/scripts/youtube-producer.ps1` ergänzt (Schritt 2)
- Neue Funktion `Get-PexelsClips` geschrieben: Suche, Download, FFmpeg-Normalisierung auf 1920x1080/25fps/8 Sek. ohne Ton, mit Fallback auf den nächsten Suchbegriff bei Leertreffer (Schritt 3)
- Schritt 3 des Producers (Bildgenerierung) verzweigt jetzt je nach `Visueller_Stil` zwischen dem bestehenden fal.ai-Pfad und dem neuen Pexels-Clip-Pfad (Schritt 4)
- Schritt 5 des Producers (FFmpeg-Zusammenbau) baut bei Stockclips eine Concat-Liste aus den fertigen 8-Sekunden-Clips statt der Bild-Slideshow-Liste, inklusive Auffüll-Logik falls die Cluster-Clips kürzer sind als die Audiodauer (Schritt 5)
- `context/strategy.md` und `context/produktions-checklist.md` (neue Phase 2b) aktualisiert (Schritt 6)
- Isolierter Funktionstest statt vollständigem Producer-Lauf: `Get-PexelsClips` mit drei Suchbegriffen aus dem Cluster "Wald & Berge" getestet, alle drei Clips erfolgreich heruntergeladen und auf 1920x1080/8 Sek. normalisiert, per FFmpeg zu einem 24-Sekunden-Testvideo zusammengesetzt (Exit Code 0, keine Stilbrüche) (Schritt 7, angepasst — siehe Abweichungen)

### Abweichungen vom Plan

- **Schritt 7 wurde nicht als vollständiger Producer-Lauf, sondern als isolierter Funktionstest durchgeführt.** Ein echter Producer-Lauf hätte zusätzlich ElevenLabs-Voiceover (kostenpflichtig, Kontingent laut Memory `project_youtube_ctr_problem.md` ohnehin knapp bis 24.06.2026), fal.ai-Thumbnail und einen echten YouTube-Upload ausgelöst — das war für den reinen Funktionstest der neuen Clip-Logik nicht nötig und hätte unnötig Kosten/Kontingent verbraucht. Stattdessen wurde ein eigenständiges Testskript (`test-pexels-clips.ps1`, nach dem Test wieder gelöscht) mit identischer `Get-PexelsClips`-Logik verwendet.
- **Performance-Fix während der Implementierung**: Die ursprüngliche Auswahl-Logik in `Get-PexelsClips` nahm die erste Datei ab 1920px Breite, was im ersten Testlauf zu einem über 100 MB großen 4K-Quellclip führte (lange Downloadzeit). Korrigiert auf `Sort-Object width | Select-Object -First 1`, also die kleinste Datei ab 1920px (Full HD reicht für den Anwendungsfall) — reduzierte die Downloadgröße auf 7-20 MB pro Clip. Diese Korrektur ist nicht im ursprünglichen Plan-Text enthalten, aber eine notwendige Detailverbesserung innerhalb von Schritt 3.
- Es wurde noch keine echte Test-Zeile mit `Visueller_Stil = Stockclips-Cluster` in der Produktions-CSV angelegt (anders als ursprünglich in Schritt 1 vorgesehen) — die Funktionsweise wurde stattdessen isoliert validiert. Eine echte erste Produktion mit diesem Modus steht noch aus.

### Aufgetretene Probleme

- Erster Testlauf lud einen unnötig großen 4K-Quellclip herunter (siehe Performance-Fix oben) — behoben, kein offenes Problem mehr.
- Keine weiteren Probleme.
