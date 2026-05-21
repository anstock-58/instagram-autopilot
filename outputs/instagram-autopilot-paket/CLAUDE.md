# Instagram Autopilot System

Diese Datei gibt Claude Code alle nötigen Informationen über diesen Workspace.
Lege diese Datei in deinen Claude-Workspace-Ordner — Claude liest sie automatisch beim Start.

---

## Was dieses System macht

Vollautomatisches Instagram-Posting:
1. Du trägst einmal im Monat Posts in die CSV ein (oder lässt sie per KI erstellen)
2. Täglich um 18 Uhr postet das System automatisch ein fertiges Reel auf Instagram
3. Das Video wird per KI generiert (fal.ai), mit Text und Musik versehen (Creatomate) und gepostet (Make.com)
4. Du drückst keinen Knopf

---

## Workspace-Struktur

```
├── CLAUDE.md                    # Diese Datei
├── post-trigger-VORLAGE.ps1     # Täglich ausgeführtes Skript
├── contentplan_vorlage.csv      # Contentplan — hier trägst du Posts ein
├── creatomate-template.json     # Video-Template für Creatomate
├── make-blueprint.json          # Make.com Automation Blueprint
├── setup-anleitung.html         # Detaillierte Setup-Anleitung
├── schritt-fuer-schritt.html    # Checkliste für die Einrichtung
├── contentplan-per-ki.html      # Anleitung: Contentplan per KI erstellen
├── onboarding-prompt.html       # Der Onboarding-Prompt für ChatGPT/Claude
└── pitch-sheet.html             # Produktbeschreibung zum Ausdrucken
```

---

## Die wichtigsten Dateien

**`post-trigger-VORLAGE.ps1`**
Das Herzstück. Liest täglich die CSV, findet den heutigen Post und sendet ihn an Make.com.
Muss einmalig angepasst werden: CSV-Pfad, Webhook-URL, Log-Pfad.

**`contentplan_vorlage.csv`**
Hier stehen alle geplanten Posts. Spalten:
Datum, Uhrzeit, Plattform, Post-Typ, Text, Link, Bild-URL, Bildprompt, Videoprompt, Text-Overlay, Karussell-Slides, Status, Musik-URL

**`creatomate-template.json`**
Das Video-Template. Muss einmalig in Creatomate Studio angelegt werden.
Musik-URL und Template-ID müssen angepasst werden.

---

## Tools und Accounts die du brauchst

| Tool | Zweck | Kosten |
|------|-------|--------|
| Make.com | Automation/Steuerung | Gratis bis 1.000 Ops |
| fal.ai | KI-Videogenerierung | ~0,25€ pro Video |
| Creatomate | Video-Rendering + Text | Ab 29$/Monat |
| Instagram Business | Posting | Kostenlos |
| GitHub | Musik-Hosting | Kostenlos |
| Windows PC | Skript ausführen | — |

---

## Was Claude Code für dich tun kann

- Contentplan per KI erstellen und direkt in die CSV eintragen
- Das Skript mit deinen eigenen Daten anpassen
- Neue Posts zur CSV hinzufügen
- Den Contentplan für neue Monate erstellen
- Fehler im System analysieren und beheben

---

## So startest du

1. Führe `/prime` aus — Claude liest alles ein und ist bereit
2. Sage Claude: "Erstelle mir einen Contentplan für Juni" — und beantworte die Fragen
3. Claude trägt alles direkt in die CSV ein
4. Fertig

---

## Wichtige technische Details

- CSV-Format: Komma-getrennt, UTF-8, Datum TT.MM.JJJJ
- Zeilenumbrüche im Text-Overlay: einfach Enter drücken im CSV
- Musik-URL muss von einem öffentlichen GitHub-Repo kommen
- Make.com Toggle muss aktiv (blau) sein
- Creatomate Template-ID steht in der Browser-URL nach dem Anlegen
