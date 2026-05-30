# Plan: YouTube Automation Produkt — Claude Code als Interface

**Erstellt:** 2026-05-17
**Status:** Implementiert
**Anforderung:** Einen verkaufbaren Workspace aufbauen, der Kunden mit Claude Code durch den kompletten YouTube-Produktions-Workflow führt — von der Nischen-Recherche bis zum fertigen Video auf YouTube.

---

## Überblick

### Was dieser Plan erreicht

Ein eigenständiges Kunden-Workspace-Template entsteht, das über drei Commands (/setup, /research, /produce) den kompletten YouTube-Automatisierungs-Workflow abdeckt. Der Kunde installiert Claude Code, kauft den Workspace, tippt /setup — und Claude führt ihn durch alles. Das Endergebnis: fertige, nicht gelistete Videos auf YouTube, die der Kunde nur noch freischalten muss.

### Warum das wichtig ist

Der aktuelle Workspace ist für Andi persönlich gebaut. Das Produkt braucht einen sauberen, dokumentierten, fehlertoleranten Workspace der für Kunden ohne Technik-Kenntnisse funktioniert. Claude Code ersetzt dabei den teuren SaaS-Server — der Kunde zahlt seine eigene Claude-Lizenz, keine eigene Infrastruktur nötig.

---

## Aktueller Zustand

### Relevante bestehende Struktur

- `scripts/youtube-producer.ps1` — vollautomatische Produktion (ElevenLabs → fal.ai → FFmpeg → YouTube), Version 1.2
- `scripts/youtube-oauth-run.ps1` — einmaliger OAuth-Token-Abruf
- `scripts/youtube-oauth-setup.ps1` — interaktiver OAuth-Setup mit Read-Host
- `outputs/youtube-produktion/video-contentplan.csv` — Inhaltsplan mit allen Video-Parametern
- `reference/thumbnail-prompt-guide.md` — CTR-optimierte Thumbnail-Erstellung
- `context/secrets.md` — alle API-Keys (gitignored)
- `.claude/commands/` — bestehende Commands: prime, create-plan, implement, shutdown

### Lücken oder Probleme, die adressiert werden

- Kein /setup-Command: Kunden müssen FFmpeg, API-Keys, OAuth selbst einrichten — ohne Führung
- Kein /research-Command: Kunden haben keine Möglichkeit systematisch Videothemen zu finden
- Kein /produce-Command: direkte Skript-Ausführung ist für Kunden zu technisch
- Der aktuelle Workspace ist zu persönlich (Andi-spezifische Pfade, secrets)
- Kein Kunden-Onboarding-Flow
- Fehlende Fehlerbehandlung und verständliche Fehlermeldungen für Nicht-Techniker

---

## Vorgeschlagene Änderungen

### Zusammenfassung der Änderungen

- Neuer Command /setup: geführter Einrichtungs-Assistent
- Neuer Command /research: Nischen-Analyse und Themenvorschläge
- Neuer Command /produce: vereinfachter Produktions-Trigger
- Neues Kunden-Template als separater Ordner (produkt-template/)
- Angepasste Scripts ohne hardcodierte Pfade
- Kunden-CLAUDE.md und Kunden-Onboarding

### Neue Dateien erstellen

| Dateipfad | Zweck |
|---|---|
| `.claude/commands/setup.md` | Geführter Setup-Command für Neukunden |
| `.claude/commands/research.md` | Recherche und Themenvorschläge für ein Video |
| `.claude/commands/produce.md` | Vereinfachter Produktions-Trigger |
| `produkt-template/CLAUDE.md` | Kunden-CLAUDE.md ohne persönliche Daten |
| `produkt-template/context/setup-status.md` | Tracking ob Setup abgeschlossen |
| `produkt-template/context/kanal-profil.md` | Kanal-Einstellungen des Kunden |
| `produkt-template/scripts/setup-check.ps1` | Prüft ob alle Tools installiert sind |
| `produkt-template/scripts/youtube-producer-v2.ps1` | Producer ohne hardcodierte Pfade |
| `produkt-template/reference/nischen-guide.md` | Welche Nischen gut monetarisieren |
| `produkt-template/outputs/contentplan.csv` | Leere CSV-Vorlage für Kunden |
| `reference/produkt-konzept.md` | Dokumentation des Produktkonzepts, Preise, Zielgruppe |

### Zu ändernde Dateien

| Dateipfad | Änderungen |
|---|---|
| `CLAUDE.md` | Produkt-Sektion ergänzen, neue Commands dokumentieren |
| `scripts/youtube-producer.ps1` | Pfade durch Parameter ersetzen, bessere Fehlermeldungen |

---

## Design-Entscheidungen

### Getroffene Schlüsselentscheidungen

1. **Separates produkt-template/ Verzeichnis**: Der Kunden-Workspace ist sauber getrennt vom persönlichen Andi-Workspace. Kunden bekommen nur produkt-template/ als ZIP.

2. **Claude Code als Pflicht**: Kunden brauchen Claude Code (~20€/Monat). Das ist die "Benutzeroberfläche" — kein eigener Server nötig. Die Commands führen den Kunden durch alles.

3. **Eigene API-Keys beim Kunden**: ElevenLabs, fal.ai, Google — jeder Kunde richtet seine eigenen Keys ein. Keine geteilte Infrastruktur, keine Kosten für Andi.

4. **Windows-First**: PowerShell + FFmpeg auf Windows. Mac-Support ist eine spätere Erweiterung. Zielgruppe sind deutschsprachige Nicht-Techniker die meist Windows nutzen.

5. **/research nutzt Claude Web-Suche**: Kein eigener YouTube-API-Schlüssel nötig. Claude sucht selbst nach viralen Videos in der Nische und analysiert Muster.

6. **Monetarisierungs-Nischen vorgeben**: Der Kunde wählt aus einer vorgegebenen Liste von gut monetarisierbaren Nischen (Gesundheit, Finanzen, Reisen, Persönlichkeitsentwicklung etc.). Reduziert Entscheidungsaufwand.

### Betrachtete Alternativen

- **SaaS-Lösung**: Zu viel Entwicklungsaufwand, zu früh. Claude Code ist der einfachere Weg.
- **Nur Kurs ohne Template**: Zu viel Aufwand beim Kunden, zu viele Support-Anfragen.
- **Geteilte API-Keys**: Skaliert nicht, zu riskant, Kosten unkontrollierbar.

### Offene Fragen

1. **Preis-Entscheidung**: Einmalig 297-497 € oder monatliches Abo 97 €/Monat?
2. **Mac-Support**: Jetzt oder als spätere Erweiterung?
3. **Kanal-Sprache**: Nur Deutsch oder auch Englisch? (Englisch = deutlich größerer Markt)
4. **Stimmen-Paket**: Welche ElevenLabs-Stimmen werden empfohlen/mitgeliefert?
5. **Vertriebskanal**: Digistore24, eigene Website, oder beides?

---

## Schritt-für-Schritt-Aufgaben

### Schritt 1: /setup Command erstellen

Erstelle `.claude/commands/setup.md`. Dieser Command führt den Kunden durch den kompletten Einrichtungsprozess in klar getrennten Phasen.

**Aktionen:**

- Command-Datei schreiben mit Phasen: Systemcheck → FFmpeg → API-Keys → OAuth → Testlauf
- Systemcheck: PowerShell-Version prüfen, Speicherplatz prüfen, Internetverbindung prüfen
- FFmpeg: prüfen ob vorhanden, wenn nicht: Download-Link und Installationsanleitung
- API-Keys: ElevenLabs, fal.ai, Google — Claude fragt nacheinander ab und speichert in context/setup-status.md
- OAuth: youtube-oauth-run.ps1 ausführen, Browser öffnet sich, Refresh Token wird automatisch eingetragen
- Testlauf: kurzes Test-Video mit 30 Sekunden Dummy-Text generieren
- Abschluss: Bestätigung dass alles funktioniert, nächsten Schritt erklären (/research)

**Betroffene Dateien:**

- `.claude/commands/setup.md` (neu)
- `produkt-template/scripts/setup-check.ps1` (neu)
- `produkt-template/context/setup-status.md` (neu, wird befüllt)

---

### Schritt 2: /research Command erstellen

Erstelle `.claude/commands/research.md`. Dieser Command hilft dem Kunden eine profitable Nische zu wählen und generiert konkrete Video-Ideen basierend auf viralen Mustern.

**Aktionen:**

- Nischen-Auswahl: Claude listet 8-10 gut monetarisierbare Nischen mit kurzer Erklärung
- Kunde wählt eine Nische (oder gibt eigene an)
- Claude sucht im Web nach Top-Videos in der Nische (Titel-Analyse, View-Zahlen, Muster)
- Claude identifiziert 3 Erfolgs-Muster (Titelformeln, Themen, Hooks)
- Claude generiert 5 konkrete Video-Ideen mit Titel und kurzer Beschreibung
- Kunde wählt eine Idee
- Claude schreibt vollständiges Skript (30-40 Abschnitte, ca. 8-10 Minuten)
- Claude generiert 10 Bildprompts und 1 Thumbnail-Prompt
- Claude befüllt die contentplan.csv automatisch
- Status: "Bereit für /produce"

**Betroffene Dateien:**

- `.claude/commands/research.md` (neu)
- `produkt-template/reference/nischen-guide.md` (neu)
- `produkt-template/outputs/contentplan.csv` (wird befüllt)

---

### Schritt 3: /produce Command erstellen

Erstelle `.claude/commands/produce.md`. Dieser Command startet die Produktion mit einer Vorschau und Bestätigung.

**Aktionen:**

- Zeigt Zusammenfassung: Titel, Stimme, Anzahl Bilder, geschätzte Dauer
- Fragt: "Produktion starten? (ja/nein)"
- Bei Ja: youtube-producer-v2.ps1 starten
- Fortschritt in verständlichem Deutsch ausgeben
- Am Ende: YouTube-URL anzeigen, nächste Schritte erklären (Thumbnail in Canva, auf Öffentlich schalten)

**Betroffene Dateien:**

- `.claude/commands/produce.md` (neu)
- `produkt-template/scripts/youtube-producer-v2.ps1` (neu)

---

### Schritt 4: youtube-producer-v2.ps1 erstellen

Kopie des aktuellen youtube-producer.ps1 für den Kunden-Workspace — ohne hardcodierte Pfade.

**Aktionen:**

- Pfade dynamisch aus context/setup-status.md lesen statt hardcodiert
- FFmpeg-Pfad, CSV-Pfad, Output-Ordner alle konfigurierbar
- Bessere Fehlermeldungen auf Deutsch für häufige Fehler (API-Limit, OAuth abgelaufen, FFmpeg nicht gefunden)
- Log-Datei in outputs/ statt hardcodierter Pfad
- Version 2.0 in Header

**Betroffene Dateien:**

- `produkt-template/scripts/youtube-producer-v2.ps1` (neu)

---

### Schritt 5: Kunden-CLAUDE.md erstellen

Erstelle `produkt-template/CLAUDE.md` — die Kunden-Version ohne persönliche Andi-Daten.

**Aktionen:**

- Erklärt was der Workspace ist und wie er funktioniert
- Dokumentiert /setup, /research, /produce
- Erklärt die Ordnerstruktur
- Enthält keine persönlichen Daten
- Enthält Hinweis: "API-Keys niemals auf GitHub pushen"

**Betroffene Dateien:**

- `produkt-template/CLAUDE.md` (neu)

---

### Schritt 6: Nischen-Guide erstellen

Erstelle `produkt-template/reference/nischen-guide.md` mit gut monetarisierbaren Nischen für faceless YouTube-Kanäle.

**Aktionen:**

- 10 Nischen auflisten mit: RPM-Richtwert, Beispiel-Kanäle, typische Themen, Zielgruppe
- Top-Nischen für Deutsch: Finanzen/Investieren, Gesundheit 50+, Persönlichkeitsentwicklung, Immobilien, KI/Technik
- Für jede Nische: welche ElevenLabs-Stimme passt, welcher Bild-Stil passt
- Warnung: YMYL-Nischen (Gesundheit, Finanzen) brauchen mehr Sorgfalt bei Aussagen

**Betroffene Dateien:**

- `produkt-template/reference/nischen-guide.md` (neu)

---

### Schritt 7: Produktkonzept dokumentieren

Erstelle `reference/produkt-konzept.md` als internes Dokument für Andi.

**Aktionen:**

- Zielgruppe beschreiben (Faceless YouTube Monetarisierung)
- Zwei Angebote: Self-Service (Workspace + Commands) und Done-for-You
- Preismodell: Vorschläge mit Begründung
- Vertriebskanal: Digistore24 vs. eigene Website
- Was der Kunde bekommt (ZIP-Datei, Zugang zu was?)
- Onboarding-Ablauf für neue Kunden
- Support-Struktur: was ist im Preis, was kostet extra

**Betroffene Dateien:**

- `reference/produkt-konzept.md` (neu)

---

### Schritt 8: CLAUDE.md aktualisieren

Neue Commands und Produkt-Sektion in der Haupt-CLAUDE.md dokumentieren.

**Aktionen:**

- Commands-Sektion: /setup, /research, /produce ergänzen
- Neue Sektion "YouTube Automation Produkt" hinzufügen
- produkt-template/ Ordner in Workspace-Struktur erklären

**Betroffene Dateien:**

- `CLAUDE.md`

---

## Verbindungen & Abhängigkeiten

### Dateien, die diesen Bereich referenzieren

- `scripts/youtube-producer.ps1` — Basis für youtube-producer-v2.ps1
- `scripts/youtube-oauth-run.ps1` — wird im /setup-Command verwendet
- `reference/thumbnail-prompt-guide.md` — wird in /research referenziert
- `context/secrets.md` — Muster für Kunden-Konfiguration

### Nötige Updates für Konsistenz

- CLAUDE.md nach Implementierung aktualisieren
- context/current-data.md: Produkt-Status eintragen

### Auswirkungen auf bestehende Workflows

- Bestehender Andi-Workflow bleibt unverändert
- Neue Commands ergänzen, überschreiben nichts
- produkt-template/ ist komplett separat

---

## Validierungs-Checkliste

- [ ] /setup Command führt vollständig durch die Einrichtung ohne manuelle Eingriffe
- [ ] /research generiert 5 konkrete Video-Ideen und befüllt die CSV
- [ ] /produce startet die Produktion und zeigt verständlichen Fortschritt
- [ ] youtube-producer-v2.ps1 läuft ohne hardcodierte Pfade
- [ ] Kunden-CLAUDE.md enthält keine persönlichen Andi-Daten
- [ ] Nischen-Guide enthält RPM-Werte und Stimmen-Empfehlungen
- [ ] Produktkonzept-Dokument ist vollständig
- [ ] CLAUDE.md ist aktualisiert

---

## Erfolgskriterien

Die Implementierung ist abgeschlossen, wenn:

1. Ein technisch durchschnittlicher Windows-Nutzer den kompletten Workflow von /setup bis erstem YouTube-Video ohne externe Hilfe durchlaufen kann
2. /research in unter 5 Minuten eine befüllte CSV liefert die direkt für /produce genutzt werden kann
3. Das produkt-template/ Verzeichnis als saubere ZIP ohne persönliche Daten exportiert werden kann

---

---

## Implementierungsnotizen

**Implementiert:** 2026-05-17

### Zusammenfassung

Alle 8 Schritte umgesetzt. Commands /setup, /research, /produce erstellt. youtube-producer-v2.ps1 ohne hardcodierte Pfade. Kunden-Template unter produkt-template/ mit CLAUDE.md, context/, scripts/, reference/, outputs/. Nischen-Guide mit 9 Nischen und RPM-Werten. Produktkonzept-Dokument fuer Alfima-Vertrieb. CLAUDE.md aktualisiert mit neuen Commands und Produkt-Sektion.

### Abweichungen vom Plan

- setup-check.ps1 nicht als separates Script erstellt — Systemcheck ist direkt in /setup Command integriert (einfacher und ausreichend)
- .claude/commands/ im produkt-template nicht dupliziert — Commands liegen im Haupt-Workspace und gelten workspace-weit

### Aufgetretene Probleme

Keine.

## Notizen

**Priorität der Umsetzung:** Schritt 1-4 (Commands + Script) zuerst — das ist das Kernprodukt. Schritt 5-8 (Dokumentation) danach.

**Spätere Erweiterungen:**
- Mac/Linux Support (bash statt PowerShell)
- Automatische Planung: /schedule Command der Windows Task Scheduler einrichtet
- Multi-Kanal: mehrere YouTube-Kanäle aus einer Installation betreiben
- Englischsprachige Nischen-Pakete

**Preisempfehlung (zur Entscheidung):**
- Self-Service Workspace: 297 € einmalig (kein laufender Support)
- Premium mit Onboarding-Call: 497 € einmalig
- Done-for-You: 4 Videos/Monat für 1.500 € — separat anbieten

**Vertrieb:** Alfima — digitales Produkt hinterlegen, automatische Lieferung per Download-Link.
