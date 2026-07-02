# Instagram Accounts — Übersicht

Alle aktiven Instagram-Accounts mit Automation, Thema und Zuordnung auf einen Blick.

---

## Accounts im Autopiloten

| Account | Blotato ID | Thema | Skript | Story-Workflow | Reel-Workflow |
|---|---|---|---|---|---|
| @business.und.spirit | 46248 | Business, Mindset, Freiheit, Spirit | post-trigger-business-und-spirit.ps1 | bus-story.yml | bus-reel.yml |
| @ki_support | 46341 | KI-Tipps, KI-Tools, Produktempfehlungen | post-trigger-ki-support.ps1 | ki-support-story.yml | ki-support-reel.yml |
| @andi.mit.system | 46471 | Systeme, Effizienz, TAC 3.0 Workshop | post-trigger-andi-mit-system.ps1 | andi-mit-system-story.yml | andi-mit-system-reel.yml |
| @andi.mentalgesund | 48968 | Mental Health, Resilienz, Grenzen, Selbstwert | post-trigger-andi-mentalgesund.ps1 | andi-mentalgesund-story.yml | andi-mentalgesund-reel.yml |
| @song.geschenke | 48969 | Personalisierte Songs und Vereinshymnen | post-trigger-song-geschenke.ps1 | song-geschenke-story.yml | song-geschenke-reel.yml |

---

## Keyword-CTAs pro Account

| Account | Scene-2-Keyword | Was passiert bei Kommentar |
|---|---|---|
| @business.und.spirit | CHECK | Details zum Standortcheck |
| @ki_support | START | Kostenloses KI-Starter-Paket |
| @andi.mit.system | INFO | Details zum TAC 3.0 Workshop |
| @andi.mentalgesund | KLARHEIT | Details zum Standortcheck / Minikurs |
| @song.geschenke | SONG / HYMNE | SONG → Link zum Songgeschenke-Angebot; HYMNE → persönliche Kontaktaufnahme für Vereins-/Firmenhymne |

---

## Produkte pro Account

| Account | Beworbene Produkte | Keyword |
|---|---|---|
| @business.und.spirit | NUR Standortcheck (kostenlos) — seit 22.06.2026 keine bezahlten Produkte mehr (Minikurs/Neustart-Kurs raus, siehe content-regeln-instagram.md) | CHECK |
| @ki_support | KI-Starter-Paket (kostenlos), Instagram Autopilot (197 Euro), KI-Prompt-Paket | START, AUTOPILOT, PROMPTS |
| @andi.mit.system | TAC 3.0 Workshop | INFO |
| @andi.mentalgesund | Standortcheck, Minikurs, Kopf abschalten, Nein aus Überzeugung | KLARHEIT |
| @song.geschenke | Songgeschenke (persönlicher Song, ab 29 Euro, schnell, für private Anlässe) + Hymnenschmiede (Vereins-/Firmenhymne, ab 59 Euro, aufwendiger) — beide via https://sicher-weiterlesen.com/song | SONG / HYMNE |

---

## Contentplan-Dateien

| Account | CSV-Namensschema | Beispiel |
|---|---|---|
| @business.und.spirit | contentplan_business_und_spirit_[monat]_v1.csv | outputs/contentplan_business_und_spirit_juli_v2.csv |
| @ki_support | contentplan_ki_support_[monat]_v1.csv | outputs/contentplan_ki_support_juli_v2.csv |
| @andi.mit.system | contentplan_andi_mit_system_[monat]_v1.csv | outputs/contentplan_andi_mit_system_juli_v2.csv |
| @andi.mentalgesund | contentplan_andi_mentalgesund_[monat]_v1.csv | outputs/contentplan_andi_mentalgesund_juli_v2.csv |
| @song.geschenke | contentplan_song_geschenke_[monat]_v1.csv | outputs/contentplan_song_geschenke_juli_v1.csv |

---

## Karussell-Status

`post-trigger-business-und-spirit.ps1` hat eine fertige `Post-Instagram-Karussell`-Funktion, die die Spalte `Karussell-Slides` (kommagetrennte Bild-URLs) ausliest und als Karussell postet. Technisch einsatzbereit, aber aktuell stehen keine Karussell-Posts im Plan (Stand 12.06.2026). Vorschlag: ab Juli alle drei bis vier Tage einen Karussell-Post nach dem Acht-Slide-Schema einplanen (siehe `reference/content-regeln-instagram.md`).

Bei den anderen drei Accounts (@ki_support, @andi.mit.system, @andi.mentalgesund) ist Karussell in den jeweiligen Skripten noch nicht implementiert.

---

## Voiceover-Logik

Alle drei Accounts nutzen dasselbe Prinzip:

- **Scene 1**: Caption-Text bereinigt (keine Emojis, keine Hashtags) plus produktspezifischer Abschluss-Satz mit Keyword
- **Scene 2**: Fester CTA-Text mit dem Account-Keyword (CHECK / KLARHEIT / START / INFO)
- **Stimme** (Stand 06.06.2026): Charlie (Australian, natural) für @business.und.spirit + @andi.mentalgesund + @song.geschenke — Daniel (British, authoritative) für @ki_support + @andi.mit.system — via ElevenLabs
- **Captions**: unten, gelb (#FFFF00), Fade-Übergang, 9:16

Regel: Kein Tool-Name im Voiceover, kein Preis, nur Produktnutzen und Keyword.

---

## Zielgruppe pro Account

| Account | Zielgruppe |
|---|---|
| @business.und.spirit | Unternehmer und Führungskräfte 50+, im Funktionsmodus feststeckend, suchen Klarheit und Freiheit |
| @ki_support | Menschen 40+, die KI im Alltag und Business nutzen wollen, ohne technischen Hintergrund |
| @andi.mit.system | Angestellte im Nine to Five die nebenher durch TAC 3.0 und Affiliate Marketing ein zweites Einkommen aufbauen wollen |
| @andi.mentalgesund | Menschen 35-55, die unter Dauerstress, Burnout-Nähe oder fehlender Selbstfürsorge leiden |
| @song.geschenke | Menschen die nach persönlichem, unvergesslichem Geschenk suchen (Geburtstag, Hochzeit, Jahrestag, Abschied) und Vereine/Unternehmen die eine Hymne wollen |

---

## Weitere Instagram-Accounts (kein Autopilot aktiv)

| Account | Thema | Status |
|---|---|---|
| @stock.und.partner | Business/Beratung | Manuell |

---

## Technische Rahmendaten (alle Accounts gleich)

- **Posting-Zeiten**: Story 09:00 CEST (06:55 UTC) / Reel 18:00 CEST (15:55 UTC)
- **GitHub Actions**: 3 Retry-Versuche bei Push-Konflikt (10s Pause)
- **PAUSED-Datei**: Im Repo-Root ablegen, um alle Workflows zu stoppen
- **AI-Bildmodell**: fal-ai/imagen4/preview/fast
- **Video-Template**: ai-story-video (5903fe43-514d-40ee-a060-0d6628c5f8fd)
- **Repo**: https://github.com/anstock-58/instagram-autopilot
