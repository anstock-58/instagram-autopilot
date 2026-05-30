# Plan: YouTube Autopilot System — Verkaufbarer Claude Code Workspace

**Erstellt:** 2026-05-24
**Status:** Implementiert
**Anforderung:** Einen vollständigen, anonymisierten Claude Code Workspace als verkaufbares Produkt (297€) erstellen, der Käufer Schritt für Schritt vom leeren Kanal zum laufenden YouTube-Business führt — 7 Skills, Produktionsautomation, Setup-Anleitung.

---

## Überblick

### Was dieser Plan erreicht

Ein kompletter Käufer-Workspace wird unter `outputs/youtube-autopilot-system/` aufgebaut — als ZIP lieferbar, sofort einsetzbar. Der Workspace enthält 7 Claude Code Skills die den Käufer interaktiv führen: von der Nischen-Findung über Skript-Erstellung bis zum automatischen YouTube-Upload. Kein technisches Vorwissen nötig — Claude Code übernimmt die gesamte Technik.

### Warum das wichtig ist

Das Produkt monetarisiert das bestehende YouTube-Automation-System direkt. Es gibt kein vergleichbares Produkt auf dem Markt — ein KI-Assistent als vollständiges YouTube-Business-System ist einzigartig. Preis 297€ ist durch den Mehrwert klar gerechtfertigt (Social Media Manager kostet 500–2.000€/Monat).

---

## Aktueller Zustand

### Relevante bestehende Struktur

- `scripts/youtube-producer.ps1` — vollständige Produktions-Pipeline (ElevenLabs + fal.ai + FFmpeg + YouTube API)
- `context/` — Kanal-Infos, Strategie, Secrets (alle personalisiert auf Andi)
- `.claude/commands/prime.md`, `implement.md`, `create-plan.md` — bestehende Command-Patterns
- `outputs/instagram-autopilot-system-v1.md` — Referenz für Produkt-Dokumentations-Stil
- `outputs/youtube-produktion/video-contentplan.csv` — CSV-Format bereits definiert

### Lücken oder Probleme, die adressiert werden

- Kein anonymisierter Käufer-Workspace existiert
- Keine geführten Skills für Nische/Kanal/Recherche/Analyse
- youtube-producer.ps1 enthält persönliche API Keys und Pfade
- Kein Onboarding-System für neue Nutzer ohne Vorkenntnisse

---

## Vorgeschlagene Änderungen

### Zusammenfassung der Änderungen

- Neuen Produkt-Ordner `outputs/youtube-autopilot-system/` mit kompletter Workspace-Struktur erstellen
- 7 Skills als Markdown-Commands erstellen
- Anonymisierten youtube-producer.ps1 erstellen
- Käufer-CLAUDE.md schreiben
- Context-Templates für Käufer erstellen
- Setup-Anleitung (API Keys) schreiben
- contentplan-template.csv erstellen

### Neue Dateien erstellen

| Dateipfad | Zweck |
| --- | --- |
| `outputs/youtube-autopilot-system/CLAUDE.md` | Kern-Dokumentation für Käufer-Workspace |
| `outputs/youtube-autopilot-system/.claude/commands/prime.md` | /prime — Käufer-Onboarding beim Session-Start |
| `outputs/youtube-autopilot-system/.claude/commands/nische-finden.md` | /nische-finden — geführte Nischen-Analyse mit Web-Recherche |
| `outputs/youtube-autopilot-system/.claude/commands/kanal-aufbauen.md` | /kanal-aufbauen — Kanal-Namen, Beschreibung, Struktur generieren |
| `outputs/youtube-autopilot-system/.claude/commands/video-recherche.md` | /video-recherche — Top-Videos analysieren, 10 Ideen output |
| `outputs/youtube-autopilot-system/.claude/commands/content-plan.md` | /content-plan — 4-Wochen-Plan generieren und CSV befüllen |
| `outputs/youtube-autopilot-system/.claude/commands/skript-erstellen.md` | /skript-erstellen — vollständiges Video-Skript mit Qualitätsprüfung |
| `outputs/youtube-autopilot-system/.claude/commands/produzieren.md` | /produzieren — Produktions-Pipeline starten |
| `outputs/youtube-autopilot-system/.claude/commands/kanal-analyse.md` | /kanal-analyse — Kanal-Performance auswerten |
| `outputs/youtube-autopilot-system/context/mein-kanal.md` | Leer-Template: Käufer trägt Kanal-Infos ein |
| `outputs/youtube-autopilot-system/context/meine-nische.md` | Leer-Template: Nischen-Profil nach /nische-finden |
| `outputs/youtube-autopilot-system/context/setup-status.md` | Welche APIs eingerichtet sind (Checkliste) |
| `outputs/youtube-autopilot-system/context/kanal-stil.md` | Stil-Guide für Skripte und Thumbnails |
| `outputs/youtube-autopilot-system/scripts/youtube-producer.ps1` | Anonymisierte Produktions-Pipeline ohne persönliche Keys |
| `outputs/youtube-autopilot-system/reference/setup-anleitung.md` | Schritt-für-Schritt API-Key-Setup (ElevenLabs, fal.ai, YouTube, OAuth) |
| `outputs/youtube-autopilot-system/reference/kosten-uebersicht.md` | Monatliche Kosten pro Tool transparent erklärt |
| `outputs/youtube-autopilot-system/outputs/contentplan.csv` | Leere CSV-Vorlage mit allen Spalten |
| `outputs/youtube-autopilot-system/outputs/.gitkeep` | Videos-Ordner-Platzhalter |
| `outputs/youtube-autopilot-system/plans/.gitkeep` | Plans-Ordner-Platzhalter |

### Zu ändernde Dateien

Keine bestehenden Dateien werden geändert. Alles neu im Produkt-Unterordner.

---

## Design-Entscheidungen

### Getroffene Schlüsselentscheidungen

1. **Produkt-Ordner in outputs/**: Das fertige Produkt lebt in `outputs/youtube-autopilot-system/` — kann direkt als ZIP exportiert werden ohne den persönlichen Workspace zu berühren.

2. **7 Skills als sequentieller Workflow**: Die Skills bauen aufeinander auf. /prime → /nische-finden → /kanal-aufbauen → /video-recherche → /content-plan → /skript-erstellen → /produzieren → /kanal-analyse. Jeder Skill speichert seinen Output in context/ damit der nächste Skill darauf aufbauen kann.

3. **Kein PowerShell-Wissen nötig**: Der Käufer ruft nur `/produzieren` auf — Claude Code führt das Script aus. Die technischen Details sind vollständig verborgen.

4. **Context-Dateien als Gedächtnis**: Statt dass der Käufer alles jedes Mal neu erklärt, schreiben Skills ihre Erkenntnisse in context/. /prime lädt diesen Kontext beim Session-Start.

5. **WebSearch für Recherche-Skills**: /nische-finden und /video-recherche nutzen WebSearch um echte Daten zu liefern — kein Raten, sondern Marktforschung in Echtzeit.

6. **Anonymisierter Script**: youtube-producer.ps1 verwendet Platzhalter-Variablen ($env:ELEVENLABS_API_KEY etc.) statt hardcodierter Keys — Käufer setzt Keys als Umgebungsvariablen oder trägt sie in context/secrets.md ein.

### Betrachtete Alternativen

- **Videokurs statt Workspace**: Verworfen — ein interaktiver Workspace ist wertvoller und einzigartiger als ein Kurs.
- **Skills als separate .ps1 Scripts**: Verworfen — Markdown-Commands sind einfacher zu warten und benötigen keine zusätzliche Ausführungsumgebung.

### Offene Fragen

Keine — alle Entscheidungen getroffen.

---

## Schritt-für-Schritt-Aufgaben

### Schritt 1: Ordnerstruktur anlegen

Alle notwendigen Ordner im Produkt-Workspace erstellen.

**Aktionen:**
- `outputs/youtube-autopilot-system/` anlegen
- `outputs/youtube-autopilot-system/.claude/commands/` anlegen
- `outputs/youtube-autopilot-system/context/` anlegen
- `outputs/youtube-autopilot-system/scripts/` anlegen
- `outputs/youtube-autopilot-system/reference/` anlegen
- `outputs/youtube-autopilot-system/outputs/` anlegen
- `outputs/youtube-autopilot-system/plans/` anlegen
- Platzhalter `.gitkeep` in leere Ordner

**Betroffene Dateien:**
- Gesamte Ordnerstruktur unter `outputs/youtube-autopilot-system/`

---

### Schritt 2: CLAUDE.md für Käufer schreiben

Die Kern-Dokumentation des Käufer-Workspace — erklärt was das System ist, wie es funktioniert und welche Commands verfügbar sind.

**Aktionen:**
- CLAUDE.md schreiben mit folgenden Abschnitten:
  - Was dieses System ist und macht
  - Voraussetzungen (Claude Code Abo, API Keys)
  - Der 7-Schritte-Workflow (prime → nische → kanal → recherche → plan → skript → produzieren → analyse)
  - Commands-Übersicht mit kurzer Erklärung jedes Skills
  - Monatliche Kosten-Übersicht
  - Hinweis auf reference/setup-anleitung.md für ersten Start

**Inhalt CLAUDE.md:**
```markdown
# YouTube Autopilot System

Willkommen. Dieses System führt dich Schritt für Schritt vom leeren Kanal 
zum automatisch produzierenden YouTube-Business — komplett über Claude Code.

## Was dieses System macht

Du chattest. Claude erledigt den Rest.
- Findet deine profitable Nische per KI-Recherche
- Baut deinen Kanal auf (Name, Beschreibung, Struktur)
- Recherchiert welche Videos in deiner Nische wirklich performen
- Erstellt einen 4-Wochen-Contentplan
- Schreibt professionelle Video-Skripte (10–15 Min.)
- Produziert Videos vollautomatisch (Voiceover + Bilder + Schnitt)
- Lädt direkt auf YouTube hoch
- Analysiert was gut läuft und was optimiert werden soll

## Voraussetzungen

Einmalig einrichten (ca. 45 Min.) — danach läuft alles automatisch:
- Claude Code Subscription (Anthropic) — ~20€/Monat
- ElevenLabs Account (Stimme) — ~22€/Monat
- fal.ai Account (Bilder + Thumbnails) — ~5€/Monat
- YouTube Kanal + Google API Zugang — kostenlos
→ Anleitung: reference/setup-anleitung.md

## Der Workflow

1. /prime — System initialisieren (jeden Session-Start)
2. /nische-finden — Profitable Nische per KI-Recherche finden
3. /kanal-aufbauen — Kanal-Namen, Beschreibung, Struktur erstellen
4. /video-recherche — Top-Videos analysieren, 10 Ideen generieren
5. /content-plan — 4-Wochen-Contentplan erstellen
6. /skript-erstellen — Video-Skript schreiben (ein Video pro Aufruf)
7. /produzieren — Video vollautomatisch produzieren und hochladen
8. /kanal-analyse — Performance auswerten, optimieren

## Commands

| Command | Was er tut |
|---|---|
| /prime | Lädt deinen Kanal-Kontext, bereitet Session vor |
| /nische-finden | Analysiert Markt, findet deine beste Nische |
| /kanal-aufbauen | Generiert Kanal-Name, Beschreibung, Struktur |
| /video-recherche | Findet was in deiner Nische funktioniert |
| /content-plan | Erstellt Contentplan als CSV |
| /skript-erstellen | Schreibt vollständiges Video-Skript |
| /produzieren | Produziert und lädt Video hoch |
| /kanal-analyse | Analysiert Kanal-Performance |

## Monatliche Kosten

| Tool | Kosten |
|---|---|
| Claude Code | ~20€ |
| ElevenLabs | ~22€ |
| fal.ai | ~5€ |
| YouTube API | kostenlos |
| **Gesamt** | **~47€/Monat** |

Zum Vergleich: Ein Social Media Manager kostet 500–2.000€/Monat.
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/CLAUDE.md`

---

### Schritt 3: /prime Skill für Käufer erstellen

Der erste Command beim Session-Start — lädt Kanal-Kontext und bestätigt Bereitschaft.

**Inhalt:**
```markdown
# Prime — YouTube Autopilot System

Führe diese Schritte aus um die Session vorzubereiten.

## Lesen
CLAUDE.md
context/mein-kanal.md
context/meine-nische.md
context/setup-status.md
context/kanal-stil.md

## Zusammenfassung

Nach dem Lesen liefere:
1. Wer du bist (Kanal-Name, Nische, aktueller Stand)
2. Welche APIs eingerichtet sind
3. Wie viele Videos bereits produziert wurden
4. Was als nächstes zu tun ist (nächster offener Schritt im Workflow)
5. Bestätigung, dass du bereit bist

## Erster Start

Falls context/mein-kanal.md noch leer ist (erster Start):
- Begrüße den Nutzer herzlich
- Erkläre: "Lass uns mit /nische-finden beginnen — das ist der erste Schritt"
- Gib einen kurzen Überblick über den gesamten Workflow
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/.claude/commands/prime.md`

---

### Schritt 4: /nische-finden Skill erstellen

Führt den Käufer durch eine Nischen-Analyse — Fragen + Web-Recherche → Top 3 Empfehlungen.

**Inhalt:**
```markdown
# Nische Finden

Führe den Nutzer durch eine vollständige Nischen-Analyse für seinen YouTube-Kanal.

## Phase 1: Fragen stellen

Stelle diese Fragen nacheinander (eine nach der anderen, nicht alle auf einmal):

1. "Was interessiert dich wirklich — womit beschäftigst du dich gerne, auch wenn du nicht dafür bezahlt wirst?"
2. "Was weißt du besser als die meisten Menschen in deinem Umfeld?"
3. "Welche Altersgruppe soll dein Kanal hauptsächlich ansprechen?"
4. "Wie viel Zeit kannst du pro Woche für den Kanal aufwenden? (Skript lesen reicht — die Produktion läuft automatisch)"
5. "Hast du ein Thema im Kopf, oder bist du noch völlig offen?"

Warte auf jede Antwort bevor du die nächste Frage stellst.

## Phase 2: Web-Recherche

Nach den Antworten — recherchiere mit WebSearch:
- "[Thema] YouTube Kanal Deutschland 2025 Abonnenten"
- "YouTube Nische [Thema] Monetarisierung CPM"
- "gesichtsloser YouTube Kanal [Thema] erfolgreich"

Analysiere für jede potenzielle Nische:
- Wie groß ist das Publikum (Suchvolumen, Konkurrenz)?
- Was ist der typische CPM (Werbewert pro 1000 Views)?
- Gibt es bereits gesichtslose Kanäle die damit erfolgreich sind?
- Wie groß ist die Konkurrenz wirklich?

## Phase 3: Empfehlungen

Gib 3 konkrete Nischen-Empfehlungen mit je:
- Nischen-Name und kurze Beschreibung
- Zielgruppe (Alter, Interessen)
- Geschätzter CPM in Euro
- Schwierigkeitsgrad (Konkurrenz)
- 2-3 Beispiel-Video-Ideen für diese Nische
- Empfehlung: warum diese Nische zu den Antworten des Nutzers passt

## Phase 4: Entscheidung und Speichern

Frage: "Welche dieser Nischen spricht dich am meisten an?"

Nach der Entscheidung — schreibe die Ergebnisse in context/meine-nische.md:

```markdown
# Meine Nische

**Gewählte Nische:** [Name]
**Zielgruppe:** [Beschreibung]
**CPM Schätzung:** [Betrag] €
**Kanal-Sprache:** Deutsch
**Video-Länge:** 10–15 Minuten (Longform)
**Stil:** [sachlich/philosophisch/humorvoll/etc.]

## Warum diese Nische
[Begründung basierend auf Nutzerprofil]

## Konkurrenz-Analyse
[Was gut läuft, wo Lücken sind]

## Nächster Schritt
/kanal-aufbauen ausführen
```

Sage dem Nutzer danach: "Perfekt! Jetzt bauen wir deinen Kanal auf. Starte /kanal-aufbauen"
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/.claude/commands/nische-finden.md`

---

### Schritt 5: /kanal-aufbauen Skill erstellen

Generiert alle nötigen Texte und Strukturen für den YouTube-Kanal.

**Inhalt:**
```markdown
# Kanal Aufbauen

Lies zuerst context/meine-nische.md. Falls diese Datei leer ist, sage: 
"Bitte starte zuerst /nische-finden um deine Nische festzulegen."

## Was dieser Skill generiert

### 1. Kanal-Namen (5 Vorschläge)
Erstelle 5 Kanal-Namen die:
- Prägnant und merkbar sind (max. 2-3 Wörter)
- Die Nische klar kommunizieren
- Als YouTube-Handle verfügbar sein könnten (@name)
- Professionell wirken ohne austauschbar zu sein

### 2. Kanal-Beschreibung (für YouTube "Über"-Seite)
Schreibe eine Kanal-Beschreibung (max. 1000 Zeichen) die:
- In Satz 1 sofort klar macht worum es geht
- Die Zielgruppe direkt anspricht
- Erklärt was der Zuschauer regelmäßig bekommt
- Mit einem CTA endet ("Abonniere für wöchentliche Videos")

### 3. Banner-Briefing für Canva
Beschreibe präzise wie das Kanal-Banner aussehen soll:
- Hintergrundfarbe/Design
- Text der drauf stehen soll
- Welche Canva-Vorlage gesucht werden soll (Stichwörter)
- Farbschema (2-3 Farben)

### 4. Erste 3 Playlists
Schlage 3 Playlist-Namen vor die thematisch zusammenpassen und den Kanal strukturieren.

### 5. Kanal-Stil festlegen
Frage den Nutzer:
- "Soll der Stil eher sachlich-informativ oder emotional-tiefgründig sein?"
- "Welche Stimme soll das Video haben? (ruhig und klar / energetisch / nachdenklich)"

## Speichern

Schreibe alles in context/mein-kanal.md:

```markdown
# Mein Kanal

**Kanal-Name:** [gewählter Name]
**YouTube Handle:** @[handle]
**Nische:** [aus meine-nische.md]
**Stil:** [sachlich/tiefgründig/etc.]

## Kanal-Beschreibung
[vollständiger Text]

## Banner-Briefing
[Canva-Anleitung]

## Playlists
1. [Name]
2. [Name]  
3. [Name]

## Stimmprofil
[Beschreibung der gewählten Stimme]
```

Schreibe auch context/kanal-stil.md mit Skript-Stil-Vorgaben:

```markdown
# Kanal-Stil

**Einstiegs-Muster:** Satz 1 trifft hart. Satz 2 verschärft. Satz 3 dreht Sichtweise. Satz 4 öffnet Schleife.
**Länge:** 10–15 Minuten (ca. 40 Textabschnitte)
**Ton:** [gewählter Stil]
**CTA:** "Schreib es in die Kommentare, ein Satz reicht."
**Tabu:** Keine Überschriften im Skript, keine Nummerierungen, nur Fließtext mit Leerzeilen
```

Sage danach: "Kanal ist aufgebaut! Nächster Schritt: /video-recherche — damit findest du heraus, welche Videos in deiner Nische wirklich funktionieren."
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/.claude/commands/kanal-aufbauen.md`

---

### Schritt 6: /video-recherche Skill erstellen

Analysiert Top-Videos in der Nische und generiert 10 Video-Ideen mit nachgewiesenem Potenzial.

**Inhalt:**
```markdown
# Video Recherche

Lies zuerst context/meine-nische.md und context/mein-kanal.md.

## Phase 1: Markt-Recherche per Web-Suche

Führe folgende Suchen durch und notiere die Ergebnisse:

Suche 1: "[Nische] YouTube meistgesehen deutsch"
Suche 2: "[Nische] YouTube viral 2024 2025"  
Suche 3: "youtube [Nische] millionen aufrufe faceless"
Suche 4: "[spezifisches Thema aus Nische] erklärt YouTube"

## Phase 2: Analyse

Analysiere die gefundenen Videos:
- Welche Titel-Muster kommen immer wieder vor?
- Welche Themen haben die meisten Views bekommen?
- Wo sind Lücken (welche Fragen werden noch nicht beantwortet)?
- Welche Thumbnails scheinen am besten zu performen?
- Wie lang sind die erfolgreichsten Videos?

## Phase 3: 10 Video-Ideen

Erstelle eine Liste von 10 Video-Ideen die:
- Auf nachweislich funktionierenden Themen basieren
- Für den spezifischen Kanal-Stil passen
- Unterschiedliche Aspekte der Nische abdecken
- Als starken Titel formuliert sind (nicht nur Thema, sondern Hook)

Format für jede Idee:
**Titel:** [fertiger YouTube-Titel]
**Warum:** [1 Satz warum das funktioniert]
**Hook-Idee:** [Eröffnungssatz für das Skript]

## Phase 4: Speichern

Frage: "Welche dieser Ideen gefallen dir am besten? Alle 10 kommen in deinen Contentplan."

Schreibe die Liste in outputs/video-ideen.md und sage:
"Perfekt! Starte jetzt /content-plan um daraus einen 4-Wochen-Plan zu erstellen."
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/.claude/commands/video-recherche.md`

---

### Schritt 7: /content-plan Skill erstellen

Erstellt einen 4-Wochen-Contentplan und befüllt die CSV automatisch.

**Inhalt:**
```markdown
# Content Plan

Lies context/mein-kanal.md, context/meine-nische.md und outputs/video-ideen.md.

Falls video-ideen.md nicht existiert: "Bitte starte zuerst /video-recherche."

## Fragen

Stelle kurz diese Fragen:
1. "Wie oft pro Woche möchtest du ein Video veröffentlichen? (1x empfohlen zum Start, max. 3x)"
2. "An welchem Wochentag soll das Video erscheinen?"

## Contentplan erstellen

Erstelle einen 4-Wochen-Plan:
- Verteile die Video-Ideen auf die gewählten Wochentage
- Wähle eine logische Reihenfolge (einsteigerfreundlich → fortgeschritten)
- Plane Datum, Titel, kurze Beschreibung für jedes Video

## CSV befüllen

Schreibe outputs/contentplan.csv mit diesen Spalten (exaktes Format):
"Datum","Kanal","Titel","Beschreibung","Tags","Stimme_ID","Skript","Bildprompt_1","Bildprompt_2","Bildprompt_3","Bildprompt_4","Bildprompt_5","Bildprompt_6","Bildprompt_7","Bildprompt_8","Bildprompt_9","Bildprompt_10","Thumbnail_Prompt","Thumbnail_Text","Kapitel","Musik_URL","Ausgabeordner","Status"

Fülle Datum, Kanal, Titel und Beschreibung aus. Die anderen Felder bleiben leer — sie werden von /skript-erstellen befüllt.

Status für alle Zeilen: "Offen"

Zeige dem Nutzer den fertigen Plan als Tabelle und sage:
"Dein 4-Wochen-Plan steht! Starte jetzt /skript-erstellen um das erste Video zu schreiben."
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/.claude/commands/content-plan.md`

---

### Schritt 8: /skript-erstellen Skill erstellen

Schreibt ein vollständiges 10–15 Minuten Video-Skript für das nächste offene Video im Contentplan.

**Inhalt:**
```markdown
# Skript Erstellen

Lies context/mein-kanal.md, context/kanal-stil.md und outputs/contentplan.csv.

Wähle das erste Video mit Status "Offen". Falls keines offen ist: "Alle Videos haben bereits ein Skript. Starte /produzieren oder /content-plan für neue Videos."

## Qualitätsprüfung vor dem Schreiben

Prüfe den Titel auf:
- Hook-Score (1–10): Wie sehr zieht der Titel an?
- Nischen-Relevanz (1–10): Passt er zur Nische?

Nur weitermachen wenn beide Werte ≥ 7. Sonst: Titel optimieren und erneut prüfen.

## Skript schreiben

Schreibe ein vollständiges Skript mit diesen Regeln:
- Genau 40 Textabschnitte
- Jeder Abschnitt: 2–3 lange, fließende Sätze
- Nur Leerzeile zwischen Abschnitten — keine Überschriften, keine Nummerierungen
- Einstieg (Abschnitte 1–4): Hook → Schmerz → Wendung → offene Schleife
- Hauptteil (Abschnitte 5–35): Inhalt mit Spannungsbögen, Beispielen, Studien
- Schluss (Abschnitte 36–40): Zusammenfassung → Bedeutung → CTA
- CTA: "Schreib es in die Kommentare, ein Satz reicht."

## 10 Bildprompts erstellen

Erstelle 10 Bildprompts für die Szenenbilder:
- Jeder Prompt beschreibt eine Person oder Situation die zum Video-Inhalt passt
- Keine Text im Bild, kein Schriften
- Zielgruppe: Europäer/innen 50–65 Jahre
- Stil: dokumentarisch, realistisch, warm beleuchtet
- Format: 16:9

## Thumbnail-Prompt und Text

Erstelle:
- Thumbnail_Prompt: Extreme Close-up einer Person die die Kernemotion des Videos verkörpert
- Thumbnail_Text: 2-zeilig, max. 5 Wörter gesamt, Zeilenumbruch mit " / "

## Kapitel generieren

Format: "Einleitung | [Kapitel 2] | [Kapitel 3] | [Kapitel 4] | Zusammenfassung"

## CSV aktualisieren

Aktualisiere die entsprechende Zeile in outputs/contentplan.csv:
- Skript: vollständiger Skript-Text
- Bildprompt_1 bis Bildprompt_10: die 10 Bildprompts
- Thumbnail_Prompt: der Thumbnail-Prompt
- Thumbnail_Text: der Thumbnail-Text
- Kapitel: die Kapitel-Liste
- Stimme_ID: Wert aus context/mein-kanal.md (oder frage einmalig nach)
- Ausgabeordner: Wert aus context/mein-kanal.md (oder frage einmalig nach)
- Status: bleibt "Offen" (wird von /produzieren auf "Produziert" gesetzt)

Sage danach: "Skript ist fertig und im Contentplan gespeichert! Starte /produzieren um das Video zu erstellen und hochzuladen."
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/.claude/commands/skript-erstellen.md`

---

### Schritt 9: /produzieren Skill erstellen

Startet die Produktions-Pipeline für das nächste fertige Video im Contentplan.

**Inhalt:**
```markdown
# Produzieren

Lies outputs/contentplan.csv und finde die erste Zeile mit Status "Offen" die ein vollständiges Skript hat (Skript-Spalte nicht leer).

Falls keine solche Zeile existiert: "Kein Video bereit. Starte /skript-erstellen zuerst."

## Voraussetzungs-Check

Prüfe context/setup-status.md:
- Sind alle API Keys eingerichtet? (ElevenLabs, fal.ai, YouTube)
- Ist FFmpeg installiert?
- Ist der Ausgabeordner konfiguriert?

Falls etwas fehlt: Weise den Nutzer an die entsprechende Stelle in reference/setup-anleitung.md.

## Produktion starten

Informiere den Nutzer:
"Ich starte jetzt die Produktion für: [Titel]
Das dauert ca. 15–25 Minuten. Dein Rechner muss an bleiben.

Ablauf:
✓ Voiceover wird generiert (ElevenLabs)
✓ 10 Szenenbilder werden generiert (fal.ai)
✓ Thumbnail wird generiert (fal.ai)
✓ Video wird zusammengeschnitten (FFmpeg)
✓ Video wird auf YouTube hochgeladen
✓ Thumbnail wird gesetzt
✓ Beschreibung und Tags werden eingetragen

Starte ich?"

Nach Bestätigung — führe aus:
```powershell
.\scripts\youtube-producer.ps1
```

Das Script liest selbstständig die CSV und produziert das nächste offene Video.

## Nach der Produktion

Bestätige dem Nutzer:
- Video-URL auf YouTube
- Thumbnail hochgeladen ✓
- Status in CSV auf "Produziert" gesetzt ✓

Sage: "Video ist live! Du kannst es in YouTube Studio öffnen und manuell auf Öffentlich stellen oder einen geplanten Veröffentlichungszeitpunkt setzen."
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/.claude/commands/produzieren.md`

---

### Schritt 10: /kanal-analyse Skill erstellen

Analysiert Kanal-Performance über YouTube API und gibt konkrete Optimierungsempfehlungen.

**Inhalt:**
```markdown
# Kanal Analyse

Lies context/mein-kanal.md und context/setup-status.md.

## Was dieser Skill analysiert

Führe einen API-Call zur YouTube Analytics API aus um aktuelle Daten zu holen.
Falls API nicht eingerichtet: Leite zu reference/setup-anleitung.md Abschnitt "YouTube Analytics API".

Alternativ: Frage den Nutzer die Daten manuell einzugeben:
"Öffne YouTube Studio → Analytics und gib mir diese Zahlen:
- Gesamt-Views letzte 28 Tage
- Abonnenten (aktuell + Zuwachs letzte 28 Tage)
- Durchschnittliche Wiedergabedauer
- Deine Top 3 Videos nach Views
- Deine Top 3 Videos nach Watchtime"

## Analyse und Empfehlungen

Nach den Daten — analysiere:

**Was läuft gut:**
- Welche Themen performen über dem Kanal-Durchschnitt?
- Welche Thumbnail/Titel-Muster haben höhere CTR?

**Was verbessert werden kann:**
- Videos mit niedrigerer Watchtime → Skript-Einstieg zu schwach?
- Videos mit niedrigerer CTR → Thumbnail oder Titel optimieren?

**Konkrete nächste Schritte:**
- Empfehle die nächsten 3 Themen basierend auf den Daten
- Gib 2-3 spezifische Optimierungen für bestehende Videos (Titel, Thumbnail, Beschreibung)

## Handlungsempfehlung

Schließe immer ab mit:
"Basierend auf diesen Daten empfehle ich als nächstes: [konkrete Aktion]"
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/.claude/commands/kanal-analyse.md`

---

### Schritt 11: Context-Templates erstellen

Leere Vorlagen die der Käufer beim Setup befüllt (oder die von Skills automatisch befüllt werden).

**context/mein-kanal.md (leer):**
```markdown
# Mein Kanal

*Diese Datei wird von /kanal-aufbauen automatisch befüllt.*
*Beim ersten Start: /prime → /nische-finden → /kanal-aufbauen ausführen*

**Kanal-Name:** 
**YouTube Handle:** 
**Nische:** 
**Stil:** 

## Kanal-Beschreibung


## Stimme ElevenLabs Voice ID


## Ausgabeordner für Videos


## Playlists

```

**context/meine-nische.md (leer):**
```markdown
# Meine Nische

*Diese Datei wird von /nische-finden automatisch befüllt.*

**Gewählte Nische:** 
**Zielgruppe:** 
**CPM Schätzung:** 
**Stil:** 
```

**context/setup-status.md:**
```markdown
# Setup Status

Trage hier ein was du bereits eingerichtet hast.
Anleitung: reference/setup-anleitung.md

## API Keys

- [ ] ElevenLabs API Key eingetragen
- [ ] fal.ai API Key eingetragen  
- [ ] YouTube Data API aktiviert
- [ ] Google OAuth Refresh Token erstellt
- [ ] FFmpeg installiert

## Konfiguration

- [ ] Ausgabeordner für Videos festgelegt
- [ ] ElevenLabs Stimme gewählt und Voice ID notiert
- [ ] YouTube Kanal erstellt und verifiziert

## Status: 
*Schreibe hier "Bereit" wenn alle Punkte abgehakt sind*
```

**context/kanal-stil.md (leer):**
```markdown
# Kanal Stil

*Diese Datei wird von /kanal-aufbauen automatisch befüllt.*

**Ton:** 
**Einstiegs-Muster:** Satz 1 trifft hart. Satz 2 verschärft. Satz 3 dreht Sichtweise. Satz 4 öffnet Schleife.
**Länge:** 10–15 Minuten
**Tabu:** Keine Überschriften, keine Nummerierungen im Skript
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/context/mein-kanal.md`
- `outputs/youtube-autopilot-system/context/meine-nische.md`
- `outputs/youtube-autopilot-system/context/setup-status.md`
- `outputs/youtube-autopilot-system/context/kanal-stil.md`

---

### Schritt 12: Setup-Anleitung schreiben

Schritt-für-Schritt-Anleitung für alle API Keys — für absolute Einsteiger geschrieben.

**Abschnitte der Anleitung:**

1. **Übersicht** — Was du brauchst, wie lange es dauert, was es kostet
2. **Claude Code installieren** — Download, Subscription, ersten Start
3. **ElevenLabs einrichten** — Account, Stimme wählen, Voice ID kopieren, API Key
4. **fal.ai einrichten** — Account, API Key erstellen, Guthaben aufladen
5. **YouTube API einrichten** — Google Cloud Console, Projekt, Data API aktivieren, OAuth Client erstellen, Refresh Token generieren (mit Schritt-für-Schritt PowerShell-Befehl)
6. **FFmpeg installieren** — Download, Pfad eintragen
7. **Scripts konfigurieren** — Wo die Keys eingetragen werden (scripts/youtube-producer.ps1 Zeilen 1–20)
8. **Erster Test** — /prime starten, Setup-Status prüfen, erstes Testlauf

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/reference/setup-anleitung.md`

---

### Schritt 13: Kosten-Übersicht schreiben

Transparente Aufstellung aller laufenden Kosten für den Käufer.

**Inhalt:**
- Tabelle mit allen Tools, Kosten/Monat, wofür verwendet
- Beispielrechnung: 4 Videos/Monat = X Euro
- Vergleich: Was kostet eine Content-Agentur?
- ROI-Rechnung: Ab wie vielen Views amortisiert sich das System?

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/reference/kosten-uebersicht.md`

---

### Schritt 14: Anonymisierten youtube-producer.ps1 erstellen

Eine Version des Produktions-Scripts ohne persönliche Daten — Variablen statt hardcodierter Werte.

**Anonymisierungsregeln:**
- Alle API Keys ersetzen durch: `"DEIN_API_KEY_HIER_EINTRAGEN"`
- Alle persönlichen Pfade ersetzen durch: `"C:\Dein\Ausgabeordner\"`
- Google OAuth Token ersetzen durch: `"DEIN_REFRESH_TOKEN_HIER"`
- Client ID/Secret ersetzen durch Platzhalter
- Blotato Account IDs entfernen
- Kanal-spezifische Stimmen-IDs als Beispiele kommentieren
- Kommentare auf Deutsch, klar für Einsteiger

**Kopiere scripts/youtube-producer.ps1 und anonymisiere alle persönlichen Werte.**

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/scripts/youtube-producer.ps1`

---

### Schritt 15: Leere contentplan.csv erstellen

Die Vorlage die der Käufer mit /content-plan befüllt.

**Inhalt:** Nur die Kopfzeile, keine Daten:
```
"Datum","Kanal","Titel","Beschreibung","Tags","Stimme_ID","Skript","Bildprompt_1","Bildprompt_2","Bildprompt_3","Bildprompt_4","Bildprompt_5","Bildprompt_6","Bildprompt_7","Bildprompt_8","Bildprompt_9","Bildprompt_10","Thumbnail_Prompt","Thumbnail_Text","Kapitel","Musik_URL","Ausgabeordner","Status"
```

**Betroffene Dateien:**
- `outputs/youtube-autopilot-system/outputs/contentplan.csv`

---

### Schritt 16: Validierung

Prüfe ob alle Dateien erstellt wurden und der Workspace funktioniert.

**Aktionen:**
- Alle Dateipfade aus "Neue Dateien erstellen" prüfen
- CLAUDE.md auf Vollständigkeit prüfen
- Alle 7 Commands auf Vollständigkeit prüfen
- Setup-Anleitung auf Verständlichkeit prüfen
- CSV-Format mit Haupt-Contentplan vergleichen (Spalten identisch?)
- Anonymisierung des Scripts prüfen (keine persönlichen Keys?)

**Betroffene Dateien:**
- Alle unter `outputs/youtube-autopilot-system/`

---

## Verbindungen & Abhängigkeiten

### Dateien, die diesen Bereich referenzieren

- `scripts/youtube-producer.ps1` — wird anonymisiert kopiert, Original bleibt unverändert
- `outputs/youtube-produktion/video-contentplan.csv` — CSV-Format wird als Vorlage genutzt
- `outputs/instagram-autopilot-system-v1.md` — Stil-Referenz für Produkt-Dokumentation

### Nötige Updates für Konsistenz

- `CLAUDE.md` (Haupt-Workspace): Nach Abschluss Eintrag hinzufügen: "YouTube Autopilot System Produkt: `outputs/youtube-autopilot-system/`"
- `context/current-data.md`: Status des Produkts auf "In Entwicklung" → "Fertig" aktualisieren

### Auswirkungen auf bestehende Workflows

Keine — alles wird in einem separaten Unterordner angelegt. Der persönliche Workspace bleibt vollständig unverändert.

---

## Validierungs-Checkliste

- [ ] `outputs/youtube-autopilot-system/` Ordner existiert mit korrekter Unterstruktur
- [ ] CLAUDE.md ist vollständig und klar verständlich für Einsteiger
- [ ] Alle 7 Commands existieren in `.claude/commands/`
- [ ] /prime lädt die richtigen context-Dateien
- [ ] /nische-finden stellt alle 5 Fragen und führt WebSearch durch
- [ ] /kanal-aufbauen generiert alle 5 Elemente und schreibt context/mein-kanal.md
- [ ] /video-recherche führt 4 WebSearches durch und generiert 10 Ideen
- [ ] /content-plan schreibt korrekte CSV mit allen Spalten
- [ ] /skript-erstellen schreibt 40-Abschnitte-Skript + alle Prompts in CSV
- [ ] /produzieren ruft youtube-producer.ps1 korrekt auf
- [ ] /kanal-analyse gibt konkrete Empfehlungen
- [ ] youtube-producer.ps1 enthält keine persönlichen Keys
- [ ] Setup-Anleitung deckt alle 8 Abschnitte ab
- [ ] contentplan.csv hat korrekte Kopfzeile (identisch mit Haupt-CSV)
- [ ] Haupt-CLAUDE.md wurde mit Produktverweis aktualisiert

---

## Erfolgskriterien

Die Implementierung ist abgeschlossen, wenn:

1. Ein frischer Nutzer den Workspace herunterlädt, /prime startet und ohne Rückfragen durch den kompletten Workflow geführt wird — von /nische-finden bis /produzieren
2. Das youtube-producer.ps1 Script im Käufer-Workspace keine einzige persönliche Information von Andi enthält
3. Die Setup-Anleitung so klar ist, dass jemand ohne technische Vorkenntnisse alle API Keys in unter 60 Minuten einrichten kann

---

## Notizen

**Nächste Phase nach diesem Plan:**
- ALFIMA Salespage schreiben (5 Blöcke wie vorgeschlagen)
- Preis auf 297€ festlegen
- Liefermechanismus klären: ZIP-Download direkt nach Kauf? oder GitHub-Link?
- Ggf. Onboarding-Video (15 Min.) als Bonus aufnehmen

**Erweiterungsideen für spätere Version:**
- /kanal-analyse mit echter YouTube Analytics API (nicht nur manuell)
- /thumbnail-erstellen als separater Skill (Canva-Integration)
- /shorts-erstellen für YouTube Shorts aus bestehenden Langform-Videos
- Mehrsprachigkeit (englischer Kanal-Support)

**Wichtig für Käufer-Kommunikation:**
- Claude Code benötigt eigene Subscription — klar kommunizieren
- Windows-Voraussetzung für youtube-producer.ps1 (PowerShell + FFmpeg)
- Mac-User brauchen alternative Script-Version (zukünftige Version)

---

## Implementierungsnotizen

**Implementiert:** 2026-05-24

### Zusammenfassung

Vollständiger Käufer-Workspace unter `outputs/youtube-autopilot-system/` erstellt. 19 Dateien: CLAUDE.md, 7 Skills (.claude/commands/), 4 Context-Templates, 2 Reference-Dokumente, anonymisiertes PS1-Script, leere contentplan.csv, plus .gitkeep-Dateien für leere Ordner.

### Abweichungen vom Plan

- Thumbnail-Archivordner-Logik aus dem anonymisierten Script entfernt (war kanal-spezifisch für InnerCode/BewusstEinfach, nicht für generischen Käufer relevant)
- Footer-Logik (kanal-beschreibungen.md) entfernt — im Käufer-Workspace nicht vorhanden
- Script identifiziert Zeilen jetzt via Datum+Titel statt Datum+Kanal (robuster für Single-Kanal-Setup)
- Startup-Validierung im Script hinzugefügt: prüft alle Platzhalter vor dem Start

### Aufgetretene Probleme

- Erste Dateien wurden in Worktree geschrieben, spätere in Haupt-Workspace — alle finalen Dateien wurden in Haupt-Workspace konsolidiert
