# Thumbnail Prompt Guide - YouTube CTR Optimierung

## Warum ein Prompt mit Erfolgskriterien?

Ein YouTube-Thumbnail entscheidet ob jemand klickt oder scrollt.
Die Forschung zu hohen CTR-Werten zeigt immer dieselben Muster.
Dieser Guide baut diese Kriterien direkt in den fal.ai Prompt ein.

## Die 6 CTR-Kriterien im Prompt

### 1. Gesicht mit starker Emotion
Thumbnails mit menschlichem Gesicht und deutlichem Ausdruck haben
30 bis 40 Prozent hoehere CTR als Thumbnails ohne Gesicht.
Emotion: Schock, Staunen, Betroffenheit, Neugier - nie neutral.

Im Prompt: "eyes wide open in shock and fascination" oder
"warm expression mixed with astonishment"

### 2. Extreme Nahaufnahme
Das Gesicht soll den Frame dominieren - nicht ein kleines Element
unter vielem anderen. Grosses Gesicht = mehr emotionale Wirkung.

Im Prompt: "extreme close-up" oder "close-up, face fills the frame"

### 3. Hoher Kontrast
Helle Elemente auf dunklem Hintergrund (InnerCode) oder
warme Toene auf hellem Hintergrund (Bewusst Einfach).
Der Algorithmus zeigt Thumbnails in kleiner Vorschau - nur Kontrast faellt auf.

Im Prompt: "ultra high contrast" oder "high contrast, bold lighting"

### 4. Leerer Bereich fuer Text (links oder rechts)
Du fuerst spaeter Titel-Text ein. Der Hintergrund in einer Haelfte
des Bildes sollte daher nicht zu detailreich sein.

Im Prompt: "clean dark background on the left third" oder
"slightly blurred background, space for text overlay"

### 5. Kanalspezifische Farb- und Lichtatmosphaere
InnerCode: dunkel, blau/lila, dramatisch, geheimnisvoll
Bewusst Einfach: warm, golden, natuerlich, einladend

Im Prompt fuer InnerCode: "electric blue light from below, dark background,
cinematic dramatic side lighting"
Im Prompt fuer Bewusst Einfach: "soft golden natural light, warm tones,
slightly blurred natural background"

### 6. Kein Text, kein Wasserzeichen im Bild
fal.ai generiert manchmal unerwuenschten Text. Explizit ausschliessen.

Im Prompt immer: "no text, no watermark"

## Vorlage InnerCode

"Extreme close-up of an older European man age 60,
eyes wide open in shock and fascination, mouth slightly open,
soft electric blue light illuminating face from below,
dark background with faint [THEMENSPEZIFISCHES ELEMENT],
ultra high contrast, cinematic dramatic side lighting,
hyperrealistic editorial photography, no text, no watermark, 16:9"

Themenspezifische Elemente:
- Bewusstsein/Gedankenlesen: "neural network pattern"
- NDE/Nahtoderfahrung: "bright light tunnel in distance"
- Longevity/Alter: "clock or hourglass silhouette"
- Quantenphysik: "particle wave pattern"

## Vorlage Bewusst Einfach

"Close-up of a middle-aged European woman age 55,
[EMOTION] expression,
soft golden natural light, slightly blurred warm background,
high contrast, inviting and emotionally engaging,
hyperrealistic documentary photography, no text, no watermark, 16:9"

Emotionen je nach Thema:
- Erkenntnis: "one hand raised to temple in realization, astonished"
- Entspannung: "peaceful smile, eyes gently closed"
- Motivation: "determined, confident, slight smile"
- Trauer/Heilung: "compassionate, slightly tearful but hopeful"

## Wichtig: Thumbnail nachbessern in Canva

Das generierte thumbnail.jpg liegt im Ausgabeordner.
In Canva: YouTube Thumbnail Format (1280x720) oeffnen,
das Bild importieren, Titel-Text in Bold/Weiss oben drauf.
Fertig in 3 Minuten.

Die Bildqualitaet von FLUX Schnell ist fuer den Hintergrund gut genug.
Wenn du mehr Qualitaet willst (z.B. fuer A/B-Tests): FLUX Pro in der CSV
als separaten Schritt eintragen (kostet ca. 0.05 Dollar statt 0.003 Dollar).
