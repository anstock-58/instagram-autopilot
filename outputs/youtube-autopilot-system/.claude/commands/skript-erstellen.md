# Skript Erstellen

Lies context/mein-kanal.md, context/kanal-stil.md und outputs/contentplan.csv.

Wähle die erste Zeile mit Status "Offen" und leerem Skript-Feld.

Falls keine solche Zeile existiert:
"Alle Videos haben bereits ein Skript — oder der Contentplan ist noch nicht erstellt. Starte /content-plan zuerst."

---

## Qualitätsprüfung: Titel bewerten

Bevor du schreibst, bewerte den Titel:

**Hook-Score (1–10):** Wie stark zieht der Titel an? Würde jemand darauf klicken?
**Nischen-Relevanz (1–10):** Passt er zur Zielgruppe in context/meine-nische.md?

Nur weitermachen wenn beide Werte ≥ 7.

Falls ein Wert unter 7: Schlage 3 verbesserte Titel-Varianten vor und frage welche verwendet werden soll. Erst dann weitermachen.

---

## Skript schreiben

Schreibe ein vollständiges Skript nach diesen Regeln:

**Struktur:**
- Genau 40 Textabschnitte
- Jeder Abschnitt: 2–3 lange, fließende Sätze
- Nur eine Leerzeile zwischen Abschnitten — keine Überschriften, keine Nummerierungen

**Einstieg (Abschnitte 1–4):**
- Abschnitt 1: Harter Einstieg — ein Satz der direkt trifft
- Abschnitt 2: Schmerz verschärfen oder Neugier öffnen
- Abschnitt 3: Sichtweise drehen oder überraschende Aussage
- Abschnitt 4: Schleife öffnen — "Gleich wirst du verstehen..."

**Hauptteil (Abschnitte 5–35):**
- Inhalt mit Spannungsbögen, echten Beispielen, Studien oder Geschichten
- Immer wieder kleine Hooks einbauen: "Und jetzt kommt das Überraschende..."
- Zielgruppe direkt ansprechen ("Du kennst das...")
- Früher CTA um Abschnitt 15–20: "Schreib es kurz in die Kommentare..."

**Schluss (Abschnitte 36–40):**
- Zusammenfassung der wichtigsten Punkte
- Bedeutung für den Alltag des Zuschauers
- CTA: "Schreib es in die Kommentare, ein Satz reicht."
- Optional: Hinweis auf nächstes Video

---

## 10 Bildprompts erstellen

Erstelle 10 Bildprompts für die Szenenbilder:

- Jeder Prompt beschreibt eine konkrete Person oder Situation die zum Video-Inhalt passt
- Zielgruppe: Europäer/innen 50–65 Jahre (mitteleuropäisches Aussehen)
- Stil: dokumentarisch, realistisch, warm beleuchtet, keine Stockfoto-Optik
- Kein Text im Bild, keine Schriften, keine Logos
- Format: 16:9
- Vielfalt: verschiedene Situationen, nicht alle ähnlich

Beispiel-Format:
"Middle-aged European man sitting alone at a kitchen table at night, warm lamplight, contemplative expression, documentary photography, no text, 16:9"

---

## Thumbnail-Prompt und Text erstellen

**Thumbnail_Prompt:**
Extreme Close-up einer Person (50–65 Jahre, europäisch) die die Kernemotion des Videos verkörpert.
Dramatische Beleuchtung, dunkler Hintergrund, hyperrealistisch, kein Text, kein Wasserzeichen, 16:9.

**Thumbnail_Text:**
Maximal 5 Wörter, 2 Zeilen, Zeilenumbruch mit " / "
Beispiel: "Dein Gehirn / lügt dich an"

---

## Kapitel generieren

Format: "Einleitung | [Kapitel 2] | [Kapitel 3] | [Kapitel 4] | Zusammenfassung"

---

## CSV aktualisieren

Aktualisiere die entsprechende Zeile in outputs/contentplan.csv:

- **Skript:** vollständiger Skript-Text (alle 40 Abschnitte)
- **Bildprompt_1 bis Bildprompt_10:** die 10 Bildprompts
- **Thumbnail_Prompt:** der Thumbnail-Prompt
- **Thumbnail_Text:** der Thumbnail-Text
- **Kapitel:** die Kapitel-Liste
- **Stimme_ID:** Wert aus context/mein-kanal.md — falls noch leer, frage einmalig nach der ElevenLabs Voice ID und trage sie in mein-kanal.md ein
- **Ausgabeordner:** Wert aus context/mein-kanal.md — falls noch leer, frage einmalig nach dem Pfad zum Ausgabeordner
- **Status:** bleibt "Offen" (wird von /produzieren auf "Produziert" gesetzt)

---

Sage danach:
"Skript fertig! Hook-Score [X]/10, Nischen-Relevanz [X]/10.
Das Video ist bereit zur Produktion. Starte /produzieren um es zu erstellen und hochzuladen."
