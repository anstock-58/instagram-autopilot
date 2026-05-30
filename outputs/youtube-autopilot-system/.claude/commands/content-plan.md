# Content Plan

Lies context/mein-kanal.md, context/meine-nische.md und outputs/video-ideen.md.

Falls video-ideen.md nicht existiert:
"Bitte starte zuerst /video-recherche — die Video-Ideen werden für den Contentplan benötigt."

## Fragen

Stelle diese zwei Fragen:

1. "Wie oft pro Woche möchtest du ein Video veröffentlichen?
   Empfehlung für den Start: 1x pro Woche — besser regelmäßig als zu viel auf einmal."

2. "An welchem Wochentag soll das Video erscheinen?
   Tipp: Dienstag bis Donnerstag performen auf YouTube erfahrungsgemäß am besten."

## Contentplan erstellen

Erstelle einen 4-Wochen-Plan:

- Verteile die Video-Ideen aus video-ideen.md auf die gewählten Wochentage
- Wähle eine sinnvolle Reihenfolge: einsteigerfreundliche Themen zuerst, tiefere danach
- Plane je Datum: Datum, Titel und eine kurze Beschreibung (2–3 Sätze für die YouTube-Beschreibung)

Zeige den Plan dem Nutzer zuerst als Tabelle zur Bestätigung:

| Datum | Titel | Beschreibung (Vorschau) |
|---|---|---|
| [Datum] | [Titel] | [Kurz] |
...

Frage: "Passt dieser Plan? Soll ich etwas tauschen oder anpassen?"

## CSV erstellen

Nach Bestätigung — schreibe outputs/contentplan.csv mit exakt diesen Spalten:

```
"Datum","Kanal","Titel","Beschreibung","Tags","Stimme_ID","Skript","Bildprompt_1","Bildprompt_2","Bildprompt_3","Bildprompt_4","Bildprompt_5","Bildprompt_6","Bildprompt_7","Bildprompt_8","Bildprompt_9","Bildprompt_10","Thumbnail_Prompt","Thumbnail_Text","Kapitel","Musik_URL","Ausgabeordner","Status"
```

Fülle für jede Zeile aus:
- **Datum:** Im Format YYYY-MM-DD
- **Kanal:** Kanal-Name aus mein-kanal.md
- **Titel:** Der fertige Video-Titel
- **Beschreibung:** 2–3 Sätze Teaser mit passendem Emoji am Anfang
- **Tags:** 8–12 relevante Tags kommagetrennt
- **Alle anderen Felder:** leer lassen (werden von /skript-erstellen befüllt)
- **Status:** "Offen"

Bestätige: "Contentplan erstellt! [X] Videos geplant für die nächsten 4 Wochen.
Starte jetzt /skript-erstellen um das erste Video fertig zu machen."
