# YouTube Automation Workspace

Willkommen. Dieser Workspace automatisiert die komplette YouTube-Video-Produktion.
Du tippst zwei Befehle. Claude macht den Rest.

---

## Wie es funktioniert

```
/setup     Einmalige Einrichtung (20 Minuten, nur beim ersten Mal)
/research  Nische & Thema waehlen, Claude schreibt das Skript
/produce   Produktion starten, Video landet auf YouTube
```

**Das war's.** Dein Video ist fertig, nicht gelistet auf YouTube.
Du schaust drauf, farbst das Thumbnail in Canva, schaltest es auf Oeffentlich.

---

## Zwei Entscheidungen pro Video

1. Welches Thema? (du waehlst aus 5 Vorschlaegen)
2. Veroeffentlichen? (nach dem automatischen Upload)

Alles andere laeuft automatisch.

---

## Workspace-Struktur

```
.
├── CLAUDE.md                    Diese Datei
├── .claude/commands/
│   ├── setup.md                 /setup — Einrichtungs-Assistent
│   ├── research.md              /research — Recherche & Skript
│   └── produce.md               /produce — Produktions-Start
├── context/
│   ├── setup-status.md          API-Keys und Setup-Fortschritt
│   └── kanal-profil.md          Dein Kanal: Name, Nische, Stimme
├── scripts/
│   ├── youtube-producer-v2.ps1  Haupt-Automatisierungs-Script
│   └── youtube-oauth-run.ps1    Einmaliger YouTube-Login (laeuft via /setup)
├── outputs/
│   ├── contentplan.csv          Alle deine Videos (offen und produziert)
│   └── videos/                  Fertige Video-Dateien pro Produktion
└── reference/
    ├── thumbnail-prompt-guide.md  Wie gute Thumbnails aussehen
    └── nischen-guide.md           Welche Nischen gut monetarisieren
```

---

## Technische Voraussetzungen

- Windows 10 oder 11
- Claude Code (laeuft gerade — du bist drin)
- FFmpeg (wird bei /setup installiert)
- API-Keys fuer: ElevenLabs, fal.ai, Google YouTube API

Die API-Kosten pro Video liegen bei ca. 0.30 bis 0.80 Euro.

---

## Erste Schritte

**Noch nie gestartet?** Tippe: `/setup`

**Setup abgeschlossen?** Tippe: `/research`

**Video bereit zur Produktion?** Tippe: `/produce`

---

## Wichtige Hinweise

- `context/setup-status.md` enthaelt deine API-Keys — teile diese Datei niemals
- Videos werden immer zuerst als "nicht gelistet" hochgeladen — du hast immer die Kontrolle
- Das Thumbnail brauchst du noch in Canva bearbeiten (Text draufschreiben) — dauert 3 Minuten
- Bei Problemen einfach die Fehlermeldung in Claude Code einfuegen — ich erklaere was zu tun ist

---

## Support

Dieser Workspace wurde von Andreas Stock entwickelt.
Bei Fragen: [Kontakt eintragen]
