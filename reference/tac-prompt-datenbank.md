# TAC Prompt-Datenbank (Marek Rühl Kurs) — lokale Ablage

**Quelle:** Google Sheet aus Andis aktuellem Kurs bei Marek Rühl zu KI-Avataren in Social Media. Link: https://docs.google.com/spreadsheets/d/1K1A9vBL0ZwCnwOLRTIqKRRVW4o-eh7467rlTSQNyhEk

**Freigabe:** Marek Rühl hat die private Speicherung in einem eigenen, nicht-öffentlichen Repository am 26.07.2026 per E-Mail bestätigt („klar, kannst du machen, danke fürs Fragen!"), auf Andis Nachfrage hin ausdrücklich nur für die private Nutzung, keine Weitergabe an Dritte. Deshalb im Git-Repo eingecheckt.

---

## Aufbau des Sheets (drei Tabs)

1. **Anleitung** (gid 1025494030): Erklärt die beiden Workflows unten.
2. **Charakter-Tools** (gid 408316936): 106 Prompts für Tools mit gespeichertem Charakter (OpenArt, HeyGen). Lokal: `reference/tac-prompt-datenbank-charakter-tools.csv`.
3. **Referenzbilder (ChatGPT-Gemini)** (gid 774020590): Dieselben 106 Szenen, aber jeder Prompt verweist auf zwei bis drei angehängte Referenzbilder statt auf einen gespeicherten Charakter. Für Tools ohne Charakter-Speicher. Lokal: `reference/tac-prompt-datenbank-referenzbilder.csv`.

## Die zwei Workflows (aus dem Anleitung-Tab)

**Workflow 1, Charakter-Tools:** Prompts beschreiben nur Outfit, Pose und Szene, nie Aussehen, Haare oder Geschlecht, weil der Charakter im Tool selbst (OpenArt, HeyGen) bereits fest hinterlegt ist.

**Workflow 2, Referenzbilder:** Gleiche Prompts, aber jede Szene referenziert zwei bis drei angehängte Bilder als Identitätsanker. Für ChatGPT/Gemini, die keinen eigenen Charakter-Speicher haben.

**Spalte „Für":** kennzeichnet, für wen das Outfit passt (Mann, Frau, Beide), sagt nichts über das Aussehen des Charakters selbst aus.

**Technische Vorgaben für Videoprompts:** Image-to-Video, fünf Sekunden, Hochformat 9:16, maximal zwei bis drei dezente Bewegungen pro Video, eine Kamerabewegung pro Clip, Gesichtszüge müssen konsistent bleiben (kein Morphing), keine gesprochenen Dialoge.

**Regeln für neue Einträge:** Beschreibungen vermeiden Geschlecht und Aussehen, konzentrieren sich auf konkrete Outfit-Details (Farbe, Material), pro Szene nur eine Handlung.

## Kategorien (Charakter-Tools-Tab, 106 Zeilen)

Reise & Strand, Fashion & Editorial, Food & Café, Morgenroutine, Fitness & Gym, Business & Office, City & Nacht, Home & Cozy, Natur & Outdoor, Alltag & Candid.

---

## Verhältnis zur AI Avatar Factory

Ergänzt `reference/ai-avatar-factory-methode.md` (Stufe 7, Anhang B) um eine fertige Szenen-Bibliothek: statt für jeden Account eigene Szenen zu erfinden, können passende Zeilen aus dieser Datenbank als Ausgangspunkt dienen und mit dem festen Charakter-Prompt-Block des jeweiligen Accounts kombiniert werden (Workflow 1, wenn das Zieltool wie fal.ai/HeyGen einen festen Charakter nutzt).

---

*Hinterlegt: 25.07.2026.*
