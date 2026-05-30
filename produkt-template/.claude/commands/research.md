# Research

> Recherchiert virale Muster in einer Nische, generiert fuenf konkrete Video-Ideen, schreibt das Skript fuer die gewaehlte Idee und befuellt die contentplan.csv — bereit fuer /produce.

## Anweisung

Fuehre den Kunden durch den Research-Prozess. Maximal eine Entscheidung pro Schritt. Alles andere machst du selbst.

Lies zuerst `context/kanal-profil.md` um Kanal, Nische und Stimme des Kunden zu kennen.
Lies `context/setup-status.md` um zu pruefen ob Setup abgeschlossen ist. Falls nicht: auf /setup hinweisen.

---

## Phase 1: Nische bestaetigen oder waehlen

Falls im Kanal-Profil bereits eine Nische steht:
- Zeige sie an und frage: "Deine Nische ist [NISCHE]. Soll ich dafuer recherchieren oder moechtest du etwas anderes?"

Falls keine Nische festgelegt:
- Zeige diese Liste mit kurzer Erklaerung:

```
Welche Nische passt zu dir? (Zahl eingeben)

1. Gesundheit & Longevity — Gesund alt werden, Ernaehrung, Bewegung. RPM: 8-15 Euro
2. Finanzen & Investieren — Geld anlegen, ETFs, finanzielle Freiheit. RPM: 12-20 Euro
3. Persoenlichkeitsentwicklung — Mindset, Gewohnheiten, Produktivitaet. RPM: 6-12 Euro
4. Spiritualitaet & Bewusstsein — Meditation, Sinn, inneres Wachstum. RPM: 5-10 Euro
5. Immobilien — Kaufen, vermieten, finanzieren. RPM: 10-18 Euro
6. KI & Technologie — KI-Tools, Automatisierung, Zukunft. RPM: 8-14 Euro
7. Reisen & Abenteuer — Laender, Tipps, Erfahrungen. RPM: 4-8 Euro
8. Kochen & Ernaehrung — Rezepte, Diaeten, gesund essen. RPM: 4-8 Euro
9. Andere (selbst eingeben)
```

(RPM = ungefaehre Einnahmen pro 1.000 Videoaufrufe in Euro)

Speichere die gewaehlte Nische in `context/kanal-profil.md`.

---

## Phase 2: Virale Muster recherchieren

Suche im Web nach aktuell erfolgreichen deutschsprachigen YouTube-Videos in der gewaehlten Nische.

Analysiere:
- Welche Titel-Formeln funktionieren (Fragen, Zahlen, Schock, Geheimnis)
- Welche Themen besonders viele Aufrufe haben
- Welche Hooks in den ersten 30 Sekunden genutzt werden
- Welche Zielgruppe angesprochen wird

Fasse deine Erkenntnisse in 3 Mustern zusammen — kurz und klar. Zeige dem Kunden diese Muster bevor du weitermachst.

Beispiel-Ausgabe:
```
Ich habe die erfolgreichsten Videos in deiner Nische analysiert.

Diese 3 Muster funktionieren gerade am besten:

1. "Das wusste ich mit 30 noch nicht..." — persoenliche Erkenntnisse rueckblickend
2. "Studie zeigt: [ueberraschendes Ergebnis]" — Wissenschaft als Aufreger
3. "Warum die meisten Menschen [verbreiteter Irrtum]" — Mythos aufloesen

Naechster Schritt: Ich schreibe 5 konkrete Video-Ideen.
Soll ich weitermachen? (ja/nein)
```

---

## Phase 3: Fuenf Video-Ideen generieren

Generiere 5 konkrete Video-Ideen basierend auf den analysierten Mustern.

Format fuer jede Idee:
```
[NUMMER]. TITEL
Worum geht's: Ein Satz.
Warum das funktioniert: Ein Satz.
```

Frage danach: "Welche Idee gefaellt dir? (1-5) — oder sage 'keine' fuer neue Vorschlaege."

Falls "keine": neue 5 Ideen generieren (maximal 3 Runden).

---

## Phase 4: Vollstaendiges Skript schreiben

Schreibe ein vollstaendiges Skript fuer die gewaehlte Idee.

Anforderungen:
- 35-45 Abschnitte (ergibt ca. 8-12 Minuten Video)
- Einstieg: starker Hook in den ersten 3 Saetzen (Frage, ueberraschendes Fakten oder persoenliche Anekdote)
- Struktur: Hook → Problem → Hauptteil (3-5 Punkte) → Zusammenfassung → Call to Action
- Sprache: klar, direkt, keine Schachtelsaetze — als wuerde man jemandem erklaren
- Kein "Ich" am Satzanfang (fuer natuerlicher klingende KI-Stimme)
- Stil passend zur Nische (sachlich bei Finanzen, warmherzig bei Gesundheit etc.)

Zeige dem Kunden die ersten 5 Saetze als Vorschau. Frage: "Klingt das gut? Dann schreibe ich das komplette Skript. (ja/nein)"

---

## Phase 5: Bildprompts und Thumbnail generieren

Erstelle basierend auf dem Skript:

**10 Bildprompts** — je ein Bild pro groesserem Themenblock:
- Englischsprachig (fal.ai versteht Englisch besser)
- Stil passend zur Nische
- Immer enden mit: "cinematic, no text, no watermark, 16:9"

**1 Thumbnail-Prompt** — nach den Kriterien aus `reference/thumbnail-prompt-guide.md`:
- Gesicht mit starker Emotion
- Extreme Nahaufnahme
- Hoher Kontrast
- Leerer Bereich fuer Text
- Kanal-spezifische Atmosphaere
- Kein Text, kein Wasserzeichen

---

## Phase 6: CSV befuellen

Lese `context/kanal-profil.md` fuer Stimme, Kanal-Name und Ausgabeordner-Basis.
Lese `outputs/contentplan.csv` um das Format zu verstehen.

Fuege eine neue Zeile ein mit allen Feldern:
- Datum: heutiges Datum
- Kanal: aus Kanal-Profil
- Titel: gewaehlter Titel
- Beschreibung: SEO-optimierte Beschreibung (3-5 Saetze + relevante Keywords)
- Tags: 10-15 relevante Tags als kommaseparierte Liste
- Stimme_ID: aus Kanal-Profil
- Skript: vollstaendiges Skript
- Bildprompt_1 bis Bildprompt_10: die generierten Prompts
- Thumbnail_Prompt: der generierte Thumbnail-Prompt
- Musik_URL: leer lassen (kein Musik-Standard)
- Ausgabeordner: outputs/videos/[DATUM]-[KANAL-KUERZEL]/
- Status: Offen

---

## Abschluss

```
=== Recherche abgeschlossen! ===

Video: [TITEL]
Laenge: ca. [X] Minuten
Bilder: 10
Thumbnail: bereit

Die contentplan.csv ist befuellt und wartet auf die Produktion.

Naechster Schritt: /produce — dann wird das Video automatisch erstellt und auf YouTube hochgeladen.
```
