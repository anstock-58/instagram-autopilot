# Plan: Producer Pipeline Fixes — Thumbnail, Beschreibung, Encoding

**Erstellt:** 2026-05-30
**Status:** Implementiert
**Anforderung:** Fünf dauerhaft offene Fehler im youtube-producer.ps1 beheben, die bei jedem Video manuell nachgeholt werden müssen.

---

## Überblick

### Was dieser Plan erreicht

Nach der Umsetzung produziert der Producer bei jedem Durchlauf vollständige, publishfertige Videos: Thumbnail mit Text und Gradient, vollständige Videobeschreibung mit Emoji-Bullets, Kapitelmarken, Produkt-Links und korrekten Umlauten — ohne manuellen Nachaufwand. Der Upload hängt nicht mehr.

### Warum das wichtig ist

Jedes Video braucht aktuell drei bis fünf manuelle Nacharbeitsschritte nach dem Producer-Lauf. Das kostet Zeit, wird vergessen und führt zu unvollständigen Videos auf dem Kanal. Der Producer soll liefern — nicht einen Halbfertig-Stand der noch bearbeitet werden muss.

---

## Aktueller Zustand

### Relevante bestehende Struktur

- `scripts/youtube-producer.ps1` — Hauptskript, Version 1.2
- `outputs/youtube-produktion/video-contentplan.csv` — 22 Spalten, kein Thumbnail_Text, kein Kapitel, keine Bullets, kein Produkt_Thema
- `context/kanal-beschreibungen.md` — Footer-Texte pro Kanal, wird automatisch angehängt
- `context/produkt-links.md` — Produkt-Links nach Thema gruppiert

### Lücken und Probleme

**Problem 1 — CSV-Spalten fehlen:**
Der Producer greift auf `$Video.Thumbnail_Text`, `$Video.Kapitel`, `$Video.Beschreibung_Bullets` und `$Video.Produkt_Thema` zu — diese Spalten existieren nicht im CSV-Header. Alle vier Felder liefern `$null`, was zu Thumbnails ohne Text, Beschreibungen ohne Bullets/Kapitel und fehlenden Produkt-Links führt.

**Problem 2 — Thumbnail ohne Gradient und mit fixer Schriftgröße:**
Der Producer generiert Portrait-Thumbnails ohne Gradient-Overlay. Langer Thumbnail-Text (z.B. "DU FUNKTIONIERST") wird mit fixer Schriftgröße gerendert und am Rand abgeschnitten. Der Gradient-Ansatz (links dunkel → rechts transparent) wurde am 30.05.2026 manuell validiert und funktioniert.

**Problem 3 — Vollständige Beschreibung wird nicht gesetzt:**
Nach dem Upload setzt der Producer nur `$Video.Beschreibung` (kurzer Teaser) plus Footer. Emoji-Bullets, Inhaltsverzeichnis mit Zeitstempeln, Produkt-Links und Hashtags fehlen vollständig.

**Problem 4 — Kaputtes Encoding im Upload:**
Zeilen 566–569 im Producer versuchen, `\uXXXX`-Escapes aus ConvertTo-Json mittels `[char][int]("0x" + ...)` zurückzukonvertieren. Diese Konvertierung liefert in PS5.1 falsche Zeichen (ä → Ä, ö → Ö). Verifiziert am 30.05.2026: `[char]228` ergibt U+00C4 statt U+00E4.

**Problem 5 — Invoke-WebRequest hängt:**
Zeile 575 verwendet `Invoke-WebRequest` für die Upload-Session-Initialisierung. Bekannter PS5.1-Bug: hängt bei bestimmten HTTPS-Endpunkten. Bewährter Fix: `[System.Net.HttpWebRequest]::Create()`.

---

## Vorgeschlagene Änderungen

### Zusammenfassung

- CSV-Header um vier Spalten erweitern, alle bestehenden Zeilen anpassen
- Producer: Thumbnail-Generierung auf Gradient + auto-skalierte Schrift umstellen
- Producer: Nach Upload vollständige Beschreibung via zweitem API-PUT setzen
- Producer: Zeilen 566–569 entfernen (kaputtes Encoding-Fix)
- Producer: Invoke-WebRequest durch HttpWebRequest ersetzen
- Kanal-Beschreibungen: Bindestriche entfernen

### Neue Dateien erstellen

Keine.

### Zu ändernde Dateien

| Dateipfad | Änderungen |
|-----------|-----------|
| `outputs/youtube-produktion/video-contentplan.csv` | Vier neue Spalten im Header + leere Felder in bestehenden Zeilen |
| `scripts/youtube-producer.ps1` | Fünf Fixes (Encoding, Upload-Init, Thumbnail, Beschreibung, CSV-Spalten) |
| `context/kanal-beschreibungen.md` | Bindestriche-Trennlinien entfernen |

---

## Design-Entscheidungen

### Schlüsselentscheidungen

**Gradient statt hartem Schnitt:** Der Gradient-Ansatz (links dunkel, rechts transparent) wurde am 30.05.2026 manuell getestet und von Andi bestätigt. Text fließt ins Motiv, kein harter Rand.

**Auto-Schriftgröße via MeasureString:** Statt fixer Schriftgröße wird in einer Schleife von 130pt nach unten gemessen bis der Text in 52% der Bildbreite passt. Kurze Zeilen (z.B. "NUR NOCH") werden automatisch riesig (106pt), lange Zeilen kleiner (58pt).

**Vollständige Beschreibung als zweiter API-PUT:** Direkt nach dem Thumbnail-Upload sendet der Producer einen PUT an `youtube/v3/videos?part=snippet` mit der vollständigen formatierten Beschreibung. Das ist derselbe Ansatz der manuell für IC-38 und das Funktionsmodus-Video genutzt wurde und funktioniert.

**Encoding ohne Regex-Konvertierung:** ConvertTo-Json produziert gültige `\uXXXX`-Escapes, die die YouTube API korrekt dekodiert. Die Rückkonvertierung ist überflüssig und kaputt. Einfach weglassen.

**Produkt-Links über Themen-Schlüssel:** Das CSV-Feld `Produkt_Thema` enthält einen von sechs Schlüsseln (Funktionsmodus, Kopf, Neustart, Grenzen, Instagram, Fokus). Der Producer liest `context/produkt-links.md` und baut anhand des Schlüssels den passenden Link-Block auf. Maximal zwei Links pro Video, Standortcheck nur bei Funktionsmodus.

**Beschreibung_Bullets als Pipe-getrennte Liste:** Fünf Emoji-Bullet-Zeilen im CSV-Feld `Beschreibung_Bullets`, getrennt durch ` | `. Jede Zeile enthält das Emoji bereits. Beispiel: `🔒 Warum Funktionieren keine Stärke ist | 💔 Was es mit dem Körper macht`.

---

## Schritt-für-Schritt-Aufgaben

### Schritt 1: CSV-Header um vier Spalten erweitern

Der aktuelle Header endet mit: `...,"Thumbnail_Prompt","Musik_URL","Ausgabeordner","Blotato_Account_ID","Status"`

Der neue Header soll lauten: `...,"Thumbnail_Prompt","Thumbnail_Text","Kapitel","Beschreibung_Bullets","Produkt_Thema","Musik_URL","Ausgabeordner","Blotato_Account_ID","Status"`

**Aktionen:**

- CSV-Datei einlesen als Rohtext
- Ersten Zeilenabschluss lokalisieren (Ende der Header-Zeile)
- `"Thumbnail_Prompt"` im Header durch `"Thumbnail_Prompt","Thumbnail_Text","Kapitel","Beschreibung_Bullets","Produkt_Thema"` ersetzen
- In allen Datenzeilen nach jedem Thumbnail_Prompt-Wert vier leere Felder `,"","","",""` einfügen
- Da das CSV Multiline-Skript-Felder hat: per PowerShell Import-Csv lesen, PSObject-Properties um vier neue Properties ergänzen (leerer String), Export-Csv schreiben
- Verifizieren: `(Import-Csv ...).Count` entspricht vorher, neue Spalten vorhanden

**Betroffene Dateien:**

- `outputs/youtube-produktion/video-contentplan.csv`

---

### Schritt 2: Bindestriche aus kanal-beschreibungen.md entfernen

Die Footer für BewusstEinfach und BusinessUndSpirit enthalten eine Zeile mit 49 Bindestrichen (`-------------------------------------------------`). Diese erscheint in jeder Videobeschreibung.

**Aktionen:**

- `context/kanal-beschreibungen.md` lesen
- Die Zeile `-------------------------------------------------` in allen drei Footer-Blöcken entfernen
- Prüfen ob weitere Bindestriche-Trennlinien vorhanden
- Datei speichern

**Betroffene Dateien:**

- `context/kanal-beschreibungen.md`

---

### Schritt 3: Producer — Encoding-Fix entfernen (Zeilen 566–569)

Die vier Zeilen des kaputten `[regex]::Replace` werden ersatzlos gelöscht. ConvertTo-Json produziert gültige JSON-Escapes, die YouTube korrekt verarbeitet.

**Aktionen:**

- In `scripts/youtube-producer.ps1` Zeilen 565–569 entfernen:
  ```
  # ConvertTo-Json escapt Umlaute als \uXXXX — hier zurueck in echte Zeichen wandeln
  $VideoMeta = [regex]::Replace($VideoMeta, '\\u([0-9A-Fa-f]{4})', {
      param($m)
      [char][int]("0x" + $m.Groups[1].Value)
  })
  ```
- Kommentar in der Zeile davor ebenfalls entfernen

**Betroffene Dateien:**

- `scripts/youtube-producer.ps1`

---

### Schritt 4: Producer — Invoke-WebRequest durch HttpWebRequest ersetzen

Zeile 574–586 verwendet `Invoke-WebRequest` für die Upload-Session-Initialisierung. Ersetzen durch `[System.Net.HttpWebRequest]::Create()` wie in youtube-upload-only.ps1 bewährt.

**Aktionen:**

- Zeilen 574–586 (inkl. Kommentar) ersetzen durch:
  ```powershell
  # Resumable Upload Session starten (HttpWebRequest — Invoke-WebRequest haengt bei diesem Endpunkt)
  $amp = [char]38
  $InitUrl = "https://www.googleapis.com/upload/youtube/v3/videos?uploadType=resumable" + $amp + "part=snippet,status"
  $InitReq = [System.Net.HttpWebRequest]::Create($InitUrl)
  $InitReq.Method      = "POST"
  $InitReq.ContentType = "application/json; charset=UTF-8"
  $InitReq.Timeout     = 30000
  $InitReq.Headers.Add("Authorization", "Bearer $AccessToken")
  $InitReq.Headers.Add("X-Upload-Content-Type", "video/mp4")
  $InitReq.Headers.Add("X-Upload-Content-Length", "$VideoGroesse")
  $InitReq.ContentLength = $VideoMetaBytes.Length
  $InitStream = $InitReq.GetRequestStream()
  $InitStream.Write($VideoMetaBytes, 0, $VideoMetaBytes.Length)
  $InitStream.Close()
  $InitResp = $InitReq.GetResponse()
  $UploadUri = $InitResp.Headers["Location"]
  $InitResp.Close()
  if (-not $UploadUri) { throw "Upload-Session fehlgeschlagen: keine URI zurueckgegeben" }
  ```

**Betroffene Dateien:**

- `scripts/youtube-producer.ps1`

---

### Schritt 5: Producer — Thumbnail-Generierung auf Gradient + Auto-Schrift umstellen

Der bestehende Thumbnail-Block (Portrait-Modus, ab Zeile 220) wird um zwei Elemente erweitert: LinearGradientBrush von links nach rechts, und auto-skalierende Schriftgröße.

**Aktionen:**

Die Hilfsfunktion `Get-AutoFontSize` direkt vor dem Thumbnail-Block einfügen:

```powershell
function Get-AutoFontSize([System.Drawing.Graphics]$gr, [string]$text, [float]$maxBreite) {
    $size = 130
    while ($size -gt 36) {
        $f = New-Object System.Drawing.Font("Impact", $size, [System.Drawing.FontStyle]::Bold)
        $measured = $gr.MeasureString($text, $f)
        $f.Dispose()
        if ($measured.Width -le $maxBreite) { return $size }
        $size -= 4
    }
    return 36
}
```

Im Portrait-Modus-Block nach `$g.DrawImage($srcBmp, 0, 0)` und vor dem Text-Rendering:

```powershell
# Gradient-Overlay: links dunkel (Deckkraft 210/255), rechts transparent
$gradStart = [System.Drawing.Color]::FromArgb(210, 0, 0, 0)
$gradEnd   = [System.Drawing.Color]::FromArgb(0,   0, 0, 0)
$gradBreite = [int]($bmpW * 0.65)
$gradRect  = New-Object System.Drawing.RectangleF(0, 0, $gradBreite, $bmpH)
$grad      = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $gradRect, $gradStart, $gradEnd,
    [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal
)
$g.FillRectangle($grad, $gradRect)
$grad.Dispose()
```

Schriftgrösse-Berechnung:

```powershell
$maxBreite = $bmpW * 0.52
$size1     = Get-AutoFontSize $g $TextZeile1 $maxBreite
$size2     = Get-AutoFontSize $g $TextZeile2 $maxBreite
$font1     = New-Object System.Drawing.Font("Impact", $size1, [System.Drawing.FontStyle]::Bold)
$font2     = New-Object System.Drawing.Font("Impact", $size2, [System.Drawing.FontStyle]::Bold)
```

Text vertikal zentrieren (statt fester Y-Koordinaten):

```powershell
$m1     = $g.MeasureString($TextZeile1, $font1)
$m2     = $g.MeasureString($TextZeile2, $font2)
$totalH = $m1.Height + $m2.Height + 20
$startY = ($bmpH - $totalH) / 2
$x      = 30
# Schatten + Zeile 1 (weiss)
$g.DrawString($TextZeile1, $font1, $shadowBrush, ($x + 3), ($startY + 3))
$g.DrawString($TextZeile1, $font1, $whiteBrush,   $x,      $startY)
# Schatten + Zeile 2 (gelb)
$y2 = $startY + $m1.Height + 10
$g.DrawString($TextZeile2, $font2, $shadowBrush, ($x + 3), ($y2 + 3))
$g.DrawString($TextZeile2, $font2, $yellowBrush,  $x,       $y2)
```

**Betroffene Dateien:**

- `scripts/youtube-producer.ps1`

---

### Schritt 6: Producer — Vollständige Beschreibung nach Upload setzen

Nach dem Thumbnail-Upload (aktuell Zeile 645) einen neuen Block einfügen der die vollständige Beschreibung per PUT setzt.

**Aktionen:**

Hilfsfunktion `Get-ProduktLinks` vor dem Upload-Block einfügen. Diese liest `context/produkt-links.md` und gibt anhand von `$Thema` (z.B. "Funktionsmodus") den passenden Link-Block als String zurück:

```powershell
function Get-ProduktLinks([string]$Thema) {
    $pfad = "C:\Users\andre\claude-workspace-vorlage\context\produkt-links.md"
    if (-not (Test-Path $pfad)) { return "" }
    $inhalt = Get-Content $pfad -Raw -Encoding UTF8
    $mapping = @{
        "Funktionsmodus" = "## Thema: Funktionsmodus"
        "Kopf"           = "## Thema: Kopf abschalten"
        "Neustart"       = "## Thema: Neustart"
        "Grenzen"        = "## Thema: Grenzen setzen"
        "Instagram"      = "## Thema: Instagram"
        "Fokus"          = "## Thema: Fokus"
    }
    $suchBegriff = $mapping[$Thema]
    if (-not $suchBegriff) { return "" }
    if ($inhalt -match [regex]::Escape($suchBegriff) + "([\s\S]*?)(?=\n---|\n## |$)") {
        $block = $Matches[1].Trim()
        # Nur Zeilen die mit * beginnen (die eigentlichen Links)
        $zeilen = ($block -split "`n") | Where-Object { $_ -match "^\*\s+https://" }
        return ($zeilen -join "`n") -replace "^\* ", ""
    }
    return ""
}
```

Vollständige Beschreibung aufbauen und per HttpWebRequest senden. Direkt nach dem Thumbnail-Upload-Block:

```powershell
# Vollstaendige Beschreibung setzen
if ($VideoId) {
    Log "Setze vollstaendige Beschreibung..."

    # Bullets aufbauen
    $bulletBlock = ""
    if ($Video.Beschreibung_Bullets -and $Video.Beschreibung_Bullets.Trim() -ne "") {
        $bullets = $Video.Beschreibung_Bullets -split " \| "
        $bulletBlock = ($bullets | ForEach-Object { $_.Trim() }) -join "`n"
    }

    # Kapitelmarken aufbauen (aus $KapitelBlock der weiter oben berechnet wurde)
    $kapitelBlock = ""
    if ($Video.Kapitel -and $Video.Kapitel.Trim() -ne "") {
        # $KapitelBlock wurde bereits in Schritt Kapitelmarken-Berechnung gebaut
        $kapitelBlock = "Inhaltsverzeichnis:`n" + $KapitelBlock
    }

    # Produkt-Links aufbauen
    $linkBlock = ""
    if ($Video.Produkt_Thema -and $Video.Produkt_Thema.Trim() -ne "") {
        $links = Get-ProduktLinks $Video.Produkt_Thema
        if ($links -ne "") {
            $linkBlock = $links
        }
    }

    # Vollstaendige Beschreibung zusammensetzen
    $vollBeschr = $Video.Beschreibung
    if ($bulletBlock -ne "") { $vollBeschr += "`n`n" + $bulletBlock }
    $vollBeschr += "`n`nSchreib es in die Kommentare - ein Satz reicht."
    $tagsStr = ($Video.Tags -split ",")[0..2] | ForEach-Object { "#" + $_.Trim() -replace " ","" }
    $vollBeschr += "`n`n" + ($tagsStr -join " ")
    if ($kapitelBlock -ne "") { $vollBeschr += "`n`n" + $kapitelBlock }
    if ($linkBlock -ne "") { $vollBeschr += "`n`n---`n`n" + $linkBlock }
    if ($FooterText -ne "") { $vollBeschr += "`n`n________________________________________`n`n" + $FooterText }

    # JSON-Body aufbauen und per HttpWebRequest senden
    # Feld-Werte per ConvertTo-Json escapen dann direkt senden (kein [char]-Bugfix noetig)
    $descBody = [ordered]@{
        id      = $VideoId
        snippet = [ordered]@{
            title       = $Video.Titel
            description = $vollBeschr
            categoryId  = "27"
            tags        = ($Video.Tags -split ",") | ForEach-Object { $_.Trim() }
        }
    } | ConvertTo-Json -Depth 5
    $descBytes = [System.Text.Encoding]::UTF8.GetBytes($descBody)

    $descReq = [System.Net.HttpWebRequest]::Create("https://www.googleapis.com/youtube/v3/videos?part=snippet")
    $descReq.Method        = "PUT"
    $descReq.ContentType   = "application/json; charset=UTF-8"
    $descReq.ContentLength = $descBytes.Length
    $descReq.Timeout       = 30000
    $descReq.Headers.Add("Authorization", "Bearer $AccessToken")
    $ds = $descReq.GetRequestStream()
    $ds.Write($descBytes, 0, $descBytes.Length)
    $ds.Close()
    try {
        $descResp = $descReq.GetResponse()
        $descResp.Close()
        Log "Vollstaendige Beschreibung gesetzt."
    } catch {
        Log "WARNUNG: Beschreibung-Update fehlgeschlagen: $($_.Exception.Message)"
    }
}
```

**Betroffene Dateien:**

- `scripts/youtube-producer.ps1`

---

### Schritt 7: Funktionsmodus-Video-Zeile im CSV mit neuen Feldern befüllen

Nachdem die CSV-Spalten angelegt sind, den bestehenden Funktionsmodus-Eintrag (Datum 2026-06-01) mit den richtigen Werten befüllen.

**Aktionen:**

Per Import-Csv die Zeile lokalisieren und folgende Felder setzen:

- `Thumbnail_Text` = `DU FUNKTIONIERST / NUR NOCH`
- `Kapitel` = `Einleitung | Woher das Funktionieren kommt | Was es mit dem Koerper macht | Wenn der Koerper aufhoert mitzuspielen | Der Weg zurueck`
- `Beschreibung_Bullets` = `🔒 Warum Funktionieren kein Zeichen von Staerke ist — sondern oft das Gegenteil | 💔 Was es mit dem Koerper macht, wenn man nie wirklich anwesend ist | 🔗 Wie das Beziehungen veraendert, ohne dass man es merkt | 🌱 Was unter dem Funktionieren liegt — und wie man dahin kommt | ✨ Wie der Weg zurueck aussieht — ohne Drama, ohne Programm`
- `Produkt_Thema` = `Funktionsmodus`

Export-Csv speichern, verifizieren.

**Betroffene Dateien:**

- `outputs/youtube-produktion/video-contentplan.csv`

---

### Schritt 8: Validierung

**Aktionen:**

- CSV einlesen: alle vier neuen Spalten vorhanden, Zeilen-Count unverändert
- Producer-Script syntaktisch prüfen: `powershell -Command "& { . 'scripts\youtube-producer.ps1' } 2>&1" | Select-Object -First 3` — darf keinen Parse-Fehler zeigen
- kanal-beschreibungen.md prüfen: keine Bindestriche-Trennlinien mehr
- `Get-AutoFontSize`-Funktion manuell testen mit einem kurzen und einem langen Text

**Betroffene Dateien:**

- alle geänderten Dateien

---

## Verbindungen und Abhängigkeiten

### Dateien, die diesen Bereich referenzieren

- `scripts/youtube-upload-only.ps1` — separates Upload-Skript, hat die HttpWebRequest-Fixes bereits
- `context/produkt-links.md` — wird von der neuen Get-ProduktLinks-Funktion gelesen
- `context/kanal-beschreibungen.md` — wird weiterhin für Footer genutzt

### Auswirkungen auf bestehende Workflows

- Alle zukünftigen CSV-Einträge brauchen vier neue Felder (können leer sein — Producer behandelt leere Felder graceful)
- Der erste Producer-Lauf nach dieser Änderung schreibt die CSV per Export-Csv neu — dabei gehen eventuell noch nicht befüllte neue Felder nicht verloren (leere Strings bleiben leer)
- Bestehende Videos auf YouTube sind nicht betroffen

---

## Validierungs-Checkliste

- [ ] CSV hat 26 Spalten (vorher 22) und dieselbe Zeilen-Anzahl
- [ ] `$Video.Thumbnail_Text` liefert bei Import-Csv einen Wert (kein $null mehr)
- [ ] `$Video.Kapitel` liefert bei Import-Csv einen Wert
- [ ] Producer-Script parsed ohne Fehler
- [ ] kanal-beschreibungen.md enthält keine `-----------`-Zeilen mehr
- [ ] Zeilen 565–569 (Encoding-Fix) nicht mehr im Script vorhanden
- [ ] Zeile 575 (`Invoke-WebRequest`) nicht mehr im Script vorhanden, ersetzt durch HttpWebRequest-Block
- [ ] Thumbnail-Funktion enthält `Get-AutoFontSize` und `LinearGradientBrush`
- [ ] Nach Upload wird ein zweiter API-PUT für die vollständige Beschreibung gesendet

---

## Erfolgskriterien

Die Implementierung ist abgeschlossen, wenn:

1. Ein Testlauf mit Status "Offen" produziert ein Video dessen Thumbnail Text hat — ohne manuelles Nacharbeiten
2. Die YouTube-Videobeschreibung nach dem Upload Bullets, Kapitelmarken und Produkt-Links enthält
3. Titel und Tags erscheinen im YouTube Studio mit korrekten Umlauten

---

## Notizen

---

## Implementierungsnotizen

**Implementiert:** 2026-05-30

### Zusammenfassung

Alle fünf Fixes umgesetzt: CSV um vier Spalten erweitert, Encoding-Fix entfernt, Invoke-WebRequest durch HttpWebRequest ersetzt, Thumbnail-Portrait-Modus auf Gradient plus auto-skalierte Schrift umgestellt, vollständige Beschreibung nach Upload implementiert. Funktionsmodus-CSV-Zeile mit neuen Feldern befüllt.

### Abweichungen vom Plan

Em-Dash in der CTA-Zeile ("Schreib es in die Kommentare — ein Satz reicht.") durch einfachen Bindestrich ersetzt, da PS5.1 das UTF-8 gespeicherte Em-Dash als Windows-1252 misinterpretiert und einen Parse-Fehler auslöst.

### Aufgetretene Probleme

Parser-Fehler in Zeile 740 wegen Em-Dash im Script-File. Behoben durch Ersatz mit einfachem Bindestrich.

---

Der Gradient-Wert 210/255 Deckkraft (links) wurde am 30.05.2026 validiert. Dieser Wert kann bei Bedarf über eine CSV-Spalte `Thumbnail_Gradient` konfigurierbar gemacht werden — für diesen Plan nicht nötig, aber als Erweiterungspunkt notiert.

Die Funktion `Get-ProduktLinks` parst Markdown. Falls `context/produkt-links.md` umgebaut wird muss die Regex angepasst werden.

Emojis in `Beschreibung_Bullets` werden im CSV gespeichert. Da der Producer die CSV mit `Import-Csv -Encoding UTF8` liest, landen Emojis korrekt als .NET-Strings. ConvertTo-Json escapt sie als `\uXXXX` — was YouTube korrekt dekodiert. Kein Problem.
