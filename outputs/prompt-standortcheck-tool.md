# Prompt für Claude.ai — Interaktiver Standortcheck "Neustart im Kopf"

Kopiere alles zwischen den Linien und füge es in einen neuen Claude.ai Chat ein:

---

Baue mir ein interaktives, voll funktionsfähiges HTML-Tool als Artifact (rechts anzeigen).

## Was das Tool tun soll:
Der Nutzer beschreibt in einem Textfeld seine aktuelle Situation als Unternehmer oder Führungskraft (Stress, Erschöpfung, das Gefühl nicht mehr richtig zu funktionieren). Das Tool analysiert die Eingabe und gibt einen personalisierten "Neustart-Check" zurück mit:
- Einer ehrlichen Einschätzung wo er gerade steht
- 3 konkreten Signalen die seine Situation beschreiben
- Einem klaren nächsten Schritt
- Einem Hinweis auf das kostenlose E-Book unter: https://sicher-weiterlesen.com/e-book-neustart-im-kopf

## Design:
- Hintergrundfarbe: #1a1a2e
- Akzentfarbe: #c9a84c
- Button-Farbe: #c9a84c
- Schriftart Überschrift: Playfair Display (serif, von Google Fonts)
- Schriftart Fließtext: DM Sans (von Google Fonts)
- Überschrift und Unterüberschrift zentriert
- Input-Bereich: dunkler, leicht transparenter Hintergrund (rgba(30,0,12,0.55)) mit weißer Schrift
- Result-Cards: leicht transparenter Hintergrund, passend zur Gesamtpalette
- Ton: ruhig, respektvoll, direkt — wie ein erfahrener Coach der ehrlich aber wohlwollend spricht

## Texte im Tool:
- Überschrift: "Neustart-Check"
- Unterüberschrift: "Wo stehst du gerade — wirklich?"
- Placeholder im Textfeld: "Beschreibe kurz deine aktuelle Situation. Was läuft nicht mehr rund? Was fühlt sich falsch an? Was beschäftigt dich gerade am meisten?"
- Button-Text: "Meinen Check starten"
- Abschluss-Text unter dem Ergebnis: "Klingt das nach dir? Dann ist dieses kostenlose E-Book dein nächster Schritt."
- Link-Button: "Jetzt kostenlos lesen →" → https://sicher-weiterlesen.com/e-book-neustart-im-kopf

## Technische Anforderungen – KRITISCH, alle Punkte einhalten:

1. **API-Call direkt im HTML** – rufe `https://api.anthropic.com/v1/messages` auf. KEIN x-api-key Header – Claude.ai übernimmt die Authentifizierung automatisch im Artifact-Kontext.

2. **Kein web_search Tool** – das verursacht einen "Failed to fetch" Fehler im Artifact. Nutze ausschließlich Claudes eigenes Wissen.

3. **Model**: `claude-sonnet-4-6`, max_tokens: 3000

4. **Retry-Logik** – fange HTTP 529 und 503 ab und versuche es automatisch bis zu 3x mit 2,5 Sekunden Pause. Zeige dem Nutzer "Versuch 2/3…" im Ladetext.

5. **JSON-Antwort** – der System-Prompt soll Claude anweisen, NUR ein valides JSON-Objekt zurückzugeben mit diesen Feldern:
   - einschaetzung (String, 2-3 Sätze ehrliche Lageeinschätzung)
   - signale (Array mit 3 Strings, konkrete Beschreibungen seiner Situation)
   - naechster_schritt (String, 1 klarer konkreter Schritt)
   - botschaft (String, 1 abschließender ermutigender Satz)
   Kein Markdown, keine Backticks, kein Text davor oder danach.

6. **Error Handling** – zeige Fehlermeldungen als lesbaren deutschen Text an.

7. **Enter-Key** – Textfeld soll bei Strg+Enter absenden (da mehrzeiliges Textfeld).

8. **Reset-Button** – nach dem Ergebnis erscheint ein "← Neuer Check" Button der alles zurücksetzt.

9. **Animationen** – Ergebnis-Cards mit animation-delay gestaffelt einblenden (fadeUp).

10. **Keine Netlify Function, kein Backend** – alles läuft im Frontend.

## Output-Format der KI-Antwort:
```json
{
  "einschaetzung": "...",
  "signale": ["...", "...", "..."],
  "naechster_schritt": "...",
  "botschaft": "..."
}
```

## System-Prompt für die KI-Antwort:
Du bist ein erfahrener Mentalcoach für Unternehmer und Führungskräfte ab 50. Deine Sprache ist direkt, ehrlich und respektvoll. Kein Coaching-Kauderwelsch. Keine leeren Floskeln. Du sprichst den Mann an der vor dir sitzt — nicht eine Zielgruppe. Gib NUR das JSON zurück, keinen Text davor oder danach.

## Wichtig:
- Zeige das fertige Tool sofort als HTML-Artifact an (rechts im Panel)
- Kein Netlify, kein ZIP, kein separater Code — direkt testbar
- Alle Texte auf Deutsch
