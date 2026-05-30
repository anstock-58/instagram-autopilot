# Contentplan Guide — So füllst du dein CSV richtig aus

## Die 6 wichtigsten Felder

### 1. Datum
Format: `TT.MM.JJJJ`
Beispiel: `15.06.2026`

### 2. Uhrzeit
- Story: `09:00`
- Reel: `18:00`

### 3. Post-Typ
Entweder `Story` oder `Reel`

### 4. Text (Instagram Caption)
Der vollständige Text der unter deinem Post erscheint.
- Emojis erlaubt und empfohlen
- Hashtags ans Ende
- Kann länger sein (wird im Post vollständig angezeigt)
- **Echte Umlaute verwenden: ä ö ü ß** — nie ae oe ue ss

Beispiel:
```
Drei Jahre hab ich gewartet bis es perfekt ist. Dabei war die einzige Aktion die fehlte: anfangen. ✅

Was hält dich zurück? Schreib es in die Kommentare.

#anfangen #selbstentwicklung #mindset #erfolg
```

### 5. Videoprompt
Beschreibung des KI-generierten Bilds. Englisch empfohlen.

**Empfohlener Stil:** `Editorial newspaper style, [Szene], [Atmosphäre], [Licht]`

Beispiele:
- `Editorial newspaper style, person waking up before sunrise, golden morning light, determined expression`
- `Editorial newspaper style, entrepreneur writing in journal at modern desk, soft ambient lighting, focused mood`
- `Editorial newspaper style, person standing at crossroads making a decision, dramatic cinematic lighting`

**Vermeide:**
- Gesichter von echten Personen
- Markenlogos
- Zu spezifische Beschreibungen die KI oft falsch umsetzt

### 6. Text-Overlay
Kurze Botschaft die als animierter Text im Video erscheint.

**Regeln:**
- Maximal 8 Wörter (sonst wird es zweizeilig)
- Keine CTAs hier ("Kommentiere X", "Link in Bio") — das kommt automatisch am Ende
- Die Kernaussage des Posts in einem Satz

Beispiele:
- `Anfangen schlägt Warten immer` ✅
- `Dein System entscheidet über deinen Erfolg` ✅
- `Kommentiere KLARHEIT für mehr Infos` ❌ (CTA gehört nicht hierhin)

---

## Was automatisch generiert wird

Du musst das **nicht** in dein CSV schreiben — das macht das Skript automatisch:

- **Scene 1:** KI-Bild aus deinem Videoprompt + Voiceover aus deinem Caption-Text
- **Scene 2:** Dein Account-spezifischer CTA
- **Voiceover-Abschluss:** Passend zum Link in der Link-Spalte

---

## Komplettes Beispiel — eine Reel-Zeile

```
01.06.2026,18:00,Instagram,Reel,"Drei Jahre hab ich gewartet bis es perfekt ist. Dabei war die einzige Aktion die fehlte: anfangen. ✅ Was hält dich zurück? #anfangen #mindset","https://dein-link.de","","","Editorial newspaper style, person taking the first step on a long road, motivational atmosphere","Warten bringt nichts","",Geplant,""
```

---

## CSV in Excel öffnen und speichern

**Öffnen:**
1. Excel → Datei → Öffnen → Durchsuchen → Dateityp "Alle Dateien" wählen → CSV auswählen
2. Text-Import-Assistent: Trennzeichen = Komma, Textbegrenzungszeichen = Anführungszeichen
3. Kodierung: UTF-8 wählen

**Speichern:**
1. Datei → Speichern unter → Dateiformat: CSV UTF-8 (mit BOM)
2. Dateiname: `contentplan_MONAT_v1.csv` (z.B. `contentplan_juni_v1.csv`)

**Wichtig:** Der Monatsname muss Deutsch und kleingeschrieben sein:
`januar, februar, maerz, april, mai, juni, juli, august, september, oktober, november, dezember`

---

## Wie viele Posts brauchst du?

Pro Monat mit täglich Story + Reel:
- Story: 30 Einträge
- Reel: 30 Einträge
- Gesamt: 60 Zeilen

Tipp: Starte mit 2 Wochen (28 Zeilen) und fülle monatlich nach.
