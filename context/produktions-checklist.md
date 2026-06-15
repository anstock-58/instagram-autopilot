# Produktions-Checklist — vor jedem Video

**Verbindlich. Kein Video ohne diese Checks.**

---

## Phase 1: Recherche (vor dem Skript)

### Wettbewerb analysieren
- [ ] 3-5 YouTube-Videos zum gleichen Thema suchen und ansehen
- [ ] Notieren: Welche Titel haben >10k Views? Was steckt dahinter?
- [ ] Notieren: Thumbnail-Stil der Wettbewerber (Farben, Text, Gesicht, Stimmung)
- [ ] Notieren: Was fehlt in deren Videos? Welche Fragen bleiben unbeantwortet?
- [ ] 1-2 Erkenntnisse aus Wettbewerbsvideos ins eigene Skript einbauen

### Thema validieren
- [ ] Suchtvolumen prüfen: Wer sucht das? Mit welchen Begriffen?
- [ ] Zielgruppe konkretisieren: Welches exakte Problem löst das Video?
- [ ] Winkel definieren: Was ist der überraschende Dreh, der uns von Wettbewerbern unterscheidet?

---

## Phase 2: Skript

### Pflicht-Struktur
- [ ] Hook: Erste 30 Sekunden — provokante Aussage oder überraschende Zahl
- [ ] Hook gegen die 4-Satz-Formel in youtube-qualitaet.md TEIL 3 geprüft: Hammer, Schraube, Wendung, offene Schleife — alle vier Elemente konkret vorhanden, keine Begrüßung/Einleitung davor
- [ ] Hook-Score: Selbstbewertung 1-10, Minimum 7 erforderlich
- [ ] Mindestlänge: 1200 Wörter (entspricht ca. 10 Min bei 120 Wörter/Min)
- [ ] Zielstärke: 1400-1700 Wörter (12-14 Min)
- [ ] Schluss: Klarer CTA — Kommentar, Abo, oder weiterführende Frage

### Sprache
- [ ] Keine Bindestriche (—) im Text
- [ ] Alle Umlaute korrekt: ä ö ü Ä Ö Ü ß (nie ae/oe/ue schreiben)
- [ ] Kein KI-Stil: keine "navigieren durch", "Erkunden Sie", "tauchen Sie ein"
- [ ] Kurze Sätze dominieren. Maximal 2 Füllwörter pro Absatz.
- [ ] Keine Aufzählungszeichen im gesprochenen Text

### Kapitel (4-5 Stück)
- [ ] 4-5 Kapitel definiert
- [ ] Jedes Kapitel hat einen klaren, griffigen Namen (2-4 Wörter)
- [ ] Kapitel im CSV-Feld eintragen: "Kapitel 1 | Kapitel 2 | Kapitel 3 | Kapitel 4"
- [ ] Zeitstempel werden automatisch vom Producer gesetzt

---

## Phase 3: Titel und Thumbnail

### Titel
- [ ] Max. 70 Zeichen
- [ ] Keine Satzzeichen am Anfang
- [ ] Enthält entweder: Zahl ODER Frage ODER provokante Aussage
- [ ] Umlaute korrekt eingebaut (ä ö ü ß)
- [ ] Getestet: Würde ich das anklicken?

**Bewährte Titel-Formeln:**
- "Warum [überraschende Behauptung]."
- "[Zahl] Dinge, die [Zielgruppe] [Problem] nicht wissen."
- "Du [machst Fehler]. Das ist der Grund."
- "[Jahrzehnte Erfahrung]. Was wirklich zählt."
- "Die meisten [Zielgruppe] machen [Fehler]. Ich auch."

### Thumbnail-Brief (im CSV: Thumbnail_Prompt)
- [ ] Mimik beschrieben: passend zum Thema (ernst, nachdenklich, entschlossen, überrascht)
- [ ] Kein Random-Ausdruck. Ausdruck muss Videoinhalt spiegeln.
- [ ] Text-Zeilen: max. 2 Zeilen, max. 4 Wörter je Zeile
- [ ] Thumbnail-Text ist nicht identisch mit Titel
- [ ] Thumbnail-Text griffig und lesbar bei 240px Vorschaugröße

**Thumbnail-Standard InnerCode / B&S:**
- FLUX portrait_4_3 → rembg Hintergrundentfernung → schwarzer Canvas 1280x720
- Person rechts (x=680), Text links (Impact, weiß + gelb)
- Schatten-Offset für Tiefe

---

## Phase 4: Beschreibung (CSV-Feld: Beschreibung)

Muss enthalten:
- [ ] Eröffnungssatz: Kernfrage oder Kernthese des Videos (1-2 Sätze)
- [ ] "Was du lernst:" Abschnitt mit 4-6 Bullet-Points mit Emojis
- [ ] Mindestens 8 relevante Hashtags am Ende
- [ ] Keine Bindestriche (—) in der Beschreibung
- [ ] Alle Umlaute korrekt
- [ ] Kapitel-Timestamps (werden automatisch eingebaut, wenn Kapitel-Feld gefüllt)
- [ ] Kanal-Footer (wird automatisch angehängt aus kanal-beschreibungen.md)

**Beschreibungs-Template:**
```
[Einstieg: 2-3 Sätze die das Thema und den Mehrwert aufmachen]

Was du in diesem Video lernst:
✅ [Erkenntnis 1]
✅ [Erkenntnis 2]
✅ [Erkenntnis 3]
✅ [Erkenntnis 4]
✅ [Erkenntnis 5]

#Hashtag1 #Hashtag2 #Hashtag3 #Hashtag4 #Hashtag5 #Hashtag6 #Hashtag7 #Hashtag8
```

---

## Phase 5: Vor der Produktion (Producer-Aufruf)

- [ ] Skriptdatei gespeichert unter: `scripts/[kanalname]-[nr]-skript.txt`
- [ ] CSV-Zeile vollständig ausgefüllt (alle Pflichtfelder)
- [ ] Status in CSV: "Offen" (Producer setzt auf "Fertig" nach Abschluss)
- [ ] Ausgabeordner existiert oder wird automatisch erstellt
- [ ] Musikdatei-URL geprüft (oder leer lassen für kein Hintergrundmusik)

---

## Phase 6: Nach Produktion (vor Upload)

- [ ] Videolänge prüfen: unter 8 Minuten → Skript erweitern und neu produzieren
- [ ] Titel auf YouTube nochmals auf Umlaute prüfen (UTF-8)
- [ ] Beschreibung auf YouTube: Kapitel sichtbar?
- [ ] Thumbnail hochgeladen und ausgewählt?
- [ ] Zeitplan gesetzt (Veröffentlichungsdatum)?
- [ ] Status im CSV auf "Hochgeladen" gesetzt

---

## Phase 7: Retention-Check (48-72 Std. nach Veröffentlichung)

- [ ] Analytics → Übersicht → Zuschauerbindung-Graph prüfen
- [ ] Wert bei 0:30 ablesen: Ziel über 55 Prozent. Wiederkehrender Hauptabfall in den ersten 30 Sekunden ist das Hook-Problem, nicht Titel/Thumbnail
- [ ] Durchschnittliche Wiedergabedauer gesamt: Ziel über 40 Prozent
- [ ] Bei Wert unter Ziel: Lektion direkt hier oder in current-data.md festhalten und beim nächsten Skript den Hook (TEIL 3) noch konkreter/härter formulieren — CTR allein ist kein ausreichendes Erfolgssignal

---

## Wettbewerbs-Erkenntnisse (laufend aktualisieren)

### Was funktioniert in der Nische (50+ Unternehmer / Führungskräfte)

**Titel-Muster mit Wirkung:**
- Direkte Ansagen: "Warum Kontrolle erschöpft." / "Du hast Erfolg. Aber du bist nicht frei."
- Zahlen + Ehrlichkeit: "Nach 30 Jahren Unternehmertum" / "3 Fehler nach 50"
- Paradoxon: "Das Wachstum schadet dir." / "Weniger führen. Mehr erreichen."
- Tabuthemen: Erschöpfung, Sinnleere, Angst vor Bedeutungslosigkeit

**Thumbnail-Muster die klicken:**
- Ruhiges, ernstes Gesicht + 2-3 Wortzeilen
- Dunkler oder schwarzer Hintergrund (Ernsthaftigkeit)
- Helles Gelb oder Orange für Akzenttext
- Keine überfüllten Thumbnails

**Was die Zielgruppe wirklich will:**
- Bestätigung, dass Erschöpfung trotz Erfolg normal ist
- Erlaubnis, loszulassen und zu delegieren
- Konkrete Antworten auf "Was kommt nach dem Aufbau?"
- Gespräche auf Augenhöhe, kein Coaching-Guru-Ton

**Channels analysiert:**
- Bernd Geropp (@berndgeropp-d): Führung ohne Jargon, Selbstständige die sich vom Tagesgeschäft befreien wollen
- Stefan Frädrich: Motivation + Führung, "10 Gebote"-Formate funktionieren, konkreter Nutzen im Titel
- Moritz Neuhaus: Konfrontativer Stil, unvorbereitete Interviewfragen, hohe Glaubwürdigkeit
- Udo Gast: Expert-Talks, Leadership, Krisenmanagement

**Lücken in der Nische:**
- Kaum Content über innere Transformation nach Unternehmens-Erfolg
- Wenig über den Übergang von "Macher" zu "Gestalter"
- Kaum emotionale Ehrlichkeit über Sinnleere bei vollgefüllten Terminkalendern
- Spirituelle Tiefe + Business-Realität kaum kombiniert

---

*Letzte Aktualisierung: 2026-05-28*
