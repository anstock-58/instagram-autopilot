# YouTube Autopilot System

Willkommen. Dieses System führt dich Schritt für Schritt vom leeren Kanal
zum automatisch produzierenden YouTube-Business — komplett über Claude Code.

---

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

Kein Schnittproramm. Kein Gesicht vor der Kamera. Kein technisches Vorwissen.

---

## Voraussetzungen

Einmalig einrichten (ca. 45 Min.) — danach läuft alles automatisch:

| Tool | Zweck | Kosten |
|---|---|---|
| Claude Code (Anthropic) | Das KI-Gehirn — führt alles | ~20€/Monat |
| ElevenLabs | Voiceover für deine Videos | ~22€/Monat |
| fal.ai | KI-Bilder + Thumbnails | ~5€/Monat |
| YouTube API | Automatischer Upload | kostenlos |
| FFmpeg | Video-Zusammenschnitt | kostenlos |

Anleitung für alle Einrichtungen: `reference/setup-anleitung.md`

---

## Der Workflow — Schritt für Schritt

```
/prime → /nische-finden → /kanal-aufbauen → /video-recherche
      → /content-plan → /skript-erstellen → /produzieren → /kanal-analyse
```

**Beim ersten Start:** /prime ausführen — Claude erklärt was als nächstes zu tun ist.

**Im laufenden Betrieb:** /prime → /skript-erstellen → /produzieren

---

## Commands

| Command | Was er tut | Wann nutzen |
|---|---|---|
| `/prime` | Lädt Kanal-Kontext, bereitet Session vor | Jeden Session-Start |
| `/nische-finden` | Analysiert Markt, findet deine beste Nische | Einmalig zu Beginn |
| `/kanal-aufbauen` | Generiert Kanal-Name, Beschreibung, Struktur | Einmalig zu Beginn |
| `/video-recherche` | Findet was in deiner Nische funktioniert | Alle 4–8 Wochen |
| `/content-plan` | Erstellt Contentplan als CSV | Alle 4 Wochen |
| `/skript-erstellen` | Schreibt vollständiges Video-Skript | Pro Video |
| `/produzieren` | Produziert und lädt Video hoch | Pro Video |
| `/kanal-analyse` | Analysiert Kanal-Performance | Monatlich |

---

## Workspace-Struktur

```
.
├── CLAUDE.md                    ← Diese Datei
├── .claude/commands/            ← Alle Commands (automatisch geladen)
├── context/                     ← Dein Kanal-Profil (wird von Skills befüllt)
│   ├── mein-kanal.md
│   ├── meine-nische.md
│   ├── setup-status.md
│   └── kanal-stil.md
├── scripts/
│   └── youtube-producer.ps1    ← Produktions-Pipeline
├── reference/
│   ├── setup-anleitung.md      ← API Keys einrichten
│   └── kosten-uebersicht.md    ← Kosten transparent
└── outputs/
    └── contentplan.csv         ← Dein Video-Contentplan
```

---

## Monatliche Kosten

| Tool | Kosten/Monat |
|---|---|
| Claude Code | ~20€ |
| ElevenLabs Creator | ~22€ |
| fal.ai (4 Videos) | ~5€ |
| YouTube API | kostenlos |
| **Gesamt** | **~47€** |

Zum Vergleich: Ein Social Media Manager kostet 500–2.000€/Monat.
Bei 4 Videos/Monat und realistisch 1.000 Views/Video ab Monat 3:
CPM im Bewusstseins-/Gesundheits-Bereich: 3–8€ → 12–32€ AdSense/Monat.
Das System amortisiert sich sobald der Kanal wächst — und bleibt dann profitabel.

---

## Wichtige Hinweise

- **Windows-PC erforderlich** für die Produktions-Pipeline (PowerShell + FFmpeg)
- **Claude Code Subscription** (claude.ai/code) — separat von diesem Workspace
- **Alle API Keys** werden nur lokal auf deinem Rechner gespeichert — niemals weitergegeben
- Bei Fragen: Die Setup-Anleitung in `reference/setup-anleitung.md` deckt alles ab
