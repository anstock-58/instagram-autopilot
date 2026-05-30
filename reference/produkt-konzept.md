# YouTube Automation Produkt — Konzept & Strategie

Internes Dokument. Beschreibt das Produkt, die Zielgruppe, Preismodell und Vertrieb.

---

## Das Produkt

**Name (Arbeitstitel)**: "YouTube auf Autopilot"

**Was es ist**: Ein Claude Code Workspace der den kompletten YouTube-Produktions-Workflow automatisiert. Der Kunde trifft zwei Entscheidungen pro Video — alles andere laeuft automatisch.

**Kern-USP**: "Zwei Entscheidungen. Ein fertiges Video auf YouTube."

**Technologie**:
- Claude Code als Benutzer-Interface (Kunde braucht Claude-Abo ~20 EUR/Monat)
- ElevenLabs fuer KI-Stimme
- fal.ai FLUX fuer KI-Bilder
- FFmpeg fuer Video-Montage
- YouTube Data API v3 fuer automatischen Upload

**Kosten pro Video fuer den Kunden** (ca.):
- ElevenLabs: 0.10-0.30 EUR (abhaengig von Skriptlaenge)
- fal.ai: 0.03-0.05 EUR (10 Bilder + Thumbnail)
- Gesamt: ca. 0.15-0.35 EUR pro Video

---

## Zielgruppe

**Primaer**: Deutschsprachige Menschen die mit YouTube Geld verdienen wollen (Monetarisierung via AdSense), ohne Gesicht zu zeigen, ohne Technik-Kenntnisse und ohne viel Zeitaufwand.

**Profil**:
- 35-60 Jahre
- Berufstaetig oder kurz vor Rente
- Kein technisches Vorwissen
- Windows-Nutzer
- Moechte passives Einkommen aufbauen
- Hat kein Interesse an Videodreh, Schnitt, Kamera

**Nicht die Zielgruppe**:
- Coaches die ihre persoenliche Marke aufbauen (zu viel Wert auf Authentizitaet)
- Technikaffine Leute (die bauen sich das selbst)
- Menschen die bereits einen erfolgreichen Kanal haben

---

## Produktvarianten

### Variante 1: Self-Service Workspace
**Preis**: 297-497 EUR einmalig
**Was der Kunde bekommt**:
- Fertiger Workspace als ZIP-Download
- Alle Commands (/setup, /research, /produce)
- Schritt-fuer-Schritt via Claude Code gefuehrt
- Nischen-Guide, Thumbnail-Guide
- PDF-Kurzanleitung als Backup

**Was NICHT enthalten ist**:
- Support (ausser FAQ)
- API-Keys (Kunde richtet eigene ein)
- Claude-Abo (Kunde zahlt selbst)

### Variante 2: Done for You
**Preis**: 1.500-2.000 EUR/Monat
**Was der Kunde bekommt**:
- 4 fertige Videos pro Monat auf seinem Kanal
- Nischen-Recherche, Skript, Produktion, Upload — alles erledigt
- Monatliches Reporting
- Direkter Ansprechpartner

**Zielgruppe DFY**: Unternehmer und Selbststaendige die YouTube als Marketingkanal wollen aber keine Zeit haben.

---

## Vertrieb

**Plattform**: Alfima
- Digitales Produkt hochladen
- Automatische Lieferung per Download-Link nach Kauf
- Keine eigene Website noetig fuer den Start

**Verkaufsseite**:
Headline: "Dein YouTube-Kanal — vollautomatisch. Zwei Entscheidungen. Ein fertiges Video."
Subheadline: "Kein Gesicht. Kein Kamera. Keine Technik-Kenntnisse noetig."

**Preispunkt-Empfehlung**: 397 EUR einmalig
- Niedrig genug fuer Impulskauf
- Hoch genug fuer Serioesitaet
- Kein monatliches Abo (weniger Widerstand beim Kauf)

---

## Onboarding-Ablauf (Self-Service)

1. Kunde kauft auf Alfima
2. Erhaelt automatisch Download-Link zur Workspace-ZIP
3. Entpackt ZIP, oeffnet Ordner in Claude Code
4. Tippt /setup — Claude fuehrt durch die komplette Einrichtung
5. Tippt /research — erste Video-Ideen innerhalb von Minuten
6. Tippt /produce — erstes Video nach ca. 15 Minuten fertig

**Zeit bis erstes Video**: ca. 45-90 Minuten (inkl. Setup)

---

## Haeufige Einwaende & Antworten

**"Ich kenne mich mit Technik nicht aus."**
→ Claude fuehrt dich durch jeden Schritt. Du tippst Befehle, Claude erklaert was zu tun ist.

**"Ich brauche noch ein weiteres Abo?"**
→ Claude Code kostet ca. 20 EUR/Monat. Das verdienst du mit einem einzigen Video mit 10.000 Aufrufen.

**"Wird YouTube solche Videos nicht sperren?"**
→ Nein. KI-generierte Inhalte sind auf YouTube explizit erlaubt, solange sie echten Mehrwert bieten. Das Skript liefert echten Inhalt.

**"Wie lange bis ich Geld verdiene?"**
→ YouTube-Monetarisierung ab 1.000 Abonnenten und 4.000 Stunden Wiedergabezeit. Mit 2-4 Videos pro Woche realistisch in 3-6 Monaten erreichbar.

---

## Naechste Schritte zur Produktfertigung

- [ ] Workspace als ZIP exportieren (ohne persoenliche Keys aus secrets.md)
- [ ] Kurz-PDF erstellen (1-Seiter: Was ist das, wie starten, Support-Kontakt)
- [ ] Verkaufsseite auf Alfima erstellen
- [ ] Einen Testkunden den kompletten Flow durchlaufen lassen
- [ ] Preis und Launch-Datum festlegen
