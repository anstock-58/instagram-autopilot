# Kosten-Übersicht — YouTube Autopilot System

Stand: Mai 2026 — Preise können sich ändern.

---

## Monatliche Kosten

| Tool | Plan | Kosten/Monat | Wofür |
|---|---|---|---|
| Claude Code | Pro oder Max | ~20€ | Das KI-Gehirn — führt alle Commands aus, schreibt Skripte, analysiert Videos |
| ElevenLabs | Creator | ~22€ | Sprachausgabe — wandelt Skript in natürliche Sprecherstimme um |
| fal.ai | Pay-as-you-go | ~5€ | KI-Bilder für Szenen + Thumbnails (ca. 10–12 Bilder pro Video) |
| **Gesamt** | | **~47€/Monat** | |

---

## Einmalige Kosten

| Was | Kosten | Wo |
|---|---|---|
| FFmpeg | kostenlos | ffmpeg.org |
| Google Cloud (YouTube API) | kostenlos | console.cloud.google.com |
| YouTube Kanal erstellen | kostenlos | youtube.com |

---

## Kosten pro Video

| Komponente | Kosten |
|---|---|
| ElevenLabs Voiceover (ca. 8.000 Zeichen) | ~0,08€ |
| fal.ai Bilder (10 Szenenbilder + 1 Thumbnail) | ~1,50€ |
| Claude Code Tokens | im Abo enthalten |
| **Gesamt pro Video** | **~1,60€** |

---

## Rentabilitäts-Rechnung

Mit YouTube-Monetarisierung (ab 1.000 Abonnenten + 4.000 Stunden Watchtime):

| Videos/Monat | Produktionskosten | CPM Deutsch (Schätzung) | Break-Even bei |
|---|---|---|---|
| 4 Videos | ~6€ + ~47€ Abo = 53€ | 3–8€ | ~7.000 Views/Monat |
| 8 Videos | ~13€ + ~47€ Abo = 60€ | 3–8€ | ~8.000 Views/Monat |
| 16 Videos | ~26€ + ~47€ Abo = 73€ | 3–8€ | ~10.000 Views/Monat |

*CPM variiert stark nach Nische: Finance/Immobilien bis 15€, Lifestyle ~3€*

---

## Was du NICHT brauchst

- Kamera oder Mikrofon
- Videoschnittprogramm (Premiere, DaVinci etc.)
- Grafikprogramm (Photoshop, Canva etc.)
- Sprecherstudio oder Synchronsprecher
- Technische Vorkenntnisse

---

## Skalierung

Das System ist designed, mehrere Kanäle parallel zu betreiben:

- Jeder Kanal bekommt seine eigene `context/mein-kanal.md`
- Jeder Kanal hat seinen eigenen Ausgabeordner
- ElevenLabs Creator: 100.000 Zeichen/Monat → reicht für 8–12 Videos
- Bei mehr Videos: ElevenLabs auf "Independent" (~55€) upgraden → 500.000 Zeichen

---

## Hinweis zu Claude Code

Claude Code benötigt eine aktive Subscription (Pro oder Max).
Falls du Claude.ai bereits nutzt: Upgrade auf Pro reicht aus.
Das Abo deckt alle 7 Commands dieses Systems ab — kein separates Konto nötig.
