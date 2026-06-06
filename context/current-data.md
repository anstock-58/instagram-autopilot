# Aktuelle Projekte und Daten

## Aktive Projekte

| Projekt | Status | Nächster Schritt |
| --- | --- | --- |
| ALFIMA Kurs "Nein aus Überzeugung" | Live ✅ | 37€ — Cross-sell Kopfklar 7€ — Upsell Kopf abschaltet 27€ — Link: https://sicher-weiterlesen.com/nein-aus-überzeugung — Lektionsbilder lokal bereit zum Hochladen — Promotion: @andi.mentalgesund — Account noch nicht in Blotato, in separater Session einrichten + Contentplan mit Kurs-Posts anlegen |
| ALFIMA Kurs "Wenn dein Kopf nicht mehr abschaltet" | Bilder fertig ✅ | 30 Lektionsbilder + 6 Modul-Cover lokal generiert — manuell in ALFIMA hochladen |
| YouTube Autopilot System | Fertig ✅ (24.05.2026) | Vollständiger Käufer-Workspace unter `outputs/youtube-autopilot-system/` — 7 Skills, anonymisiertes Script, Setup-Anleitung — bereit für ALFIMA-Listing zu 297€ |
| YouTube InnerCode (@innercode.projekt) | Laufend | Vollautomatische Pipeline aktiv — alle 3 Tage neues Video — nächstes: "Erinnerung" (28.05.) in InProduktion |
| YouTube BusinessUndSpirit (@business.und.spirit) | NEU LIVE ✅ (24.05.2026) | Erstes Video "30 Jahre aufgebaut" produziert — Zielgruppe: Unternehmer/Führungskräfte 50+, Funktionsmodus-Thema — Google OAuth konfiguriert — in Pipeline integriert |
| YouTube Bewusst Einfach | **FOKUS-KANAL** ✅ | OAuth Token NEU 30.05.2026: siehe context/secrets.md (Refresh Token Bewusst Einfach) — Stimme: 2OcnG4mH3jIMtWz3vKus — Musik: cdn.pixabay.com/audio/2026/04/21/audio_076e2f430b.mp3 — Blotato: 36987 — Thema: Gesundheit+Langlebigkeit 60+ — CTR-Framework: context/ctr-framework.md |
| Produkt-Links Videobeschreibungen | Eingerichtet ✅ | Regeln in context/produkt-links.md — max 2-3 Links pro Video — thematisch passend — Standortcheck nur Unternehmer 50+ |
| ElevenLabs Plan | Creator ✅ | 121.000 Credits/Monat — erneuert am 17. Juni 2026 |
| Instagram Autopilot System | Live ✅ | Architektur: CSV → GitHub Actions → post-trigger-ACCOUNT.ps1 → Blotato /v2/videos/from-templates → AI Video mit Voiceover → Instagram — Template: ai-story-video (5903fe43) — 2 Scenes: Hauptbotschaft + CTA — **Stimme: Charlie (Australian, natural)** für ALLE 4 Accounts (geändert 25.05.2026) — Captions unten, gelb — cron-job.org triggert 07:55 UTC (Story) + 15:55 UTC (Reel) |
| Zuverlässigkeit Schedule | Verbessert ✅ (06.06.2026) | GitHub-Schedule feuerte chronisch zu spät/aus (mentalgesund Story 03.-06.06. Stunden verspätet oder ausgefallen) — Lösung: je 2 gestaffelte Backup-cron-Zeiten in story+reel Workflows von business/mentalgesund/mit-system, Skripte idempotent → spätere Läufe fangen Verspätungen ab — ki_support ausgenommen bis CSV-Neubau — fuller Fix wäre cron-job.org → workflow_dispatch (braucht cron-job.org Dashboard-Zugang) |
| Wording-Regeln Instagram | Umgesetzt ✅ (06.06.2026) | Verbindliche Regeln in reference/content-regeln-instagram.md — Gedankenstriche aus allen kommenden CTAs entfernt (business/mit-system/mentalgesund, je 60 Posts: „— schreib X" → „, schreib X") — ki_support noch offen (defekte CSV) |
| @business.und.spirit Autopilot | Live ✅ | Blotato ID 46248 — contentplan_business_und_spirit_juni_v2.csv (60 Posts, 01.06.–30.06.2026) — Stimme: Charlie — Emojis: max 2-3 pro Post (dezent/professionell) |
| @ki_support Autopilot | Live ✅ | Blotato ID 46341 — contentplan_ki_support_juni_v2.csv am 06.06.2026 neu gebaut (50 saubere Zeilen 06.–30.06., voll-zitiert, Phantomzeilen entfernt, 23.06 Reel repariert, Gedankenstriche raus) — Backup-Schedule-Zeiten aktiv — Stimme: Charlie — Emojis: 4-6 pro Post |
| @andi.mit.system Autopilot | Live ✅ | Blotato ID 46471 — contentplan_andi_mit_system_juni_v2.csv — Stimme: Charlie — Emojis: 4-6 pro Post — ACHTUNG: Reels liefen seit 20.05. nicht (Export-Csv \r-Bug, behoben 25.05.2026) |
| @andi.mentalgesund Autopilot | Live ✅ | Blotato ID aus Secret MENTALGESUND_ACCOUNT_ID — contentplan_andi_mentalgesund_juni_v1.csv — Stimme: Charlie — Emojis: 4-6 pro Post |
| Instagram Autopilot — Produkt | Live ✅ | Salespage + Komplettanleitung auf Single-Path umgestellt (nur Blotato 29$, kein Make.com+Creatomate mehr) — ALFIMA Willkommensmail aktiviert ✅ — ALFIMA Produktbeschreibung manuell eingetragen — Idee: als Videokurs ausbauen (5 Module, 247-297 EUR), nach aktuellen Projekten angehen |
| Content-Prompts Neustart im Kopf | Gespeichert ✅ | System Prompt + Contentplan Prompt für Instagram Reels → `reference/prompts-instagram-reels.md` |
| ALFIMA Funnel „Neustart im Kopf" | Live ✅ | Freebie-Landingpage fertig, Traffic läuft |
| Smart Profit KI Business (Sales Angels) | Aktiver Schwerpunkt | Digistore-Produkt bewerben |
| „Neustart im Kopf" Hauptkurs | In ALFIMA installiert | Landingpage fehlt noch |
| Minikurs „Raus dem Funktionsmodus" | In ALFIMA installiert | Landingpage fehlt noch |
| Juni-Contentplan | Fertig ✅ | contentplan_juni_v1.csv — 30 Reels (18:00) + 30 Stories (09:00) — alle mit KLARHEIT-CTA — wartet auf Blotato API-Automation |
| Blotato Direct-API-Automation | Live ✅ (16.05.2026) | Instagram + LinkedIn komplett auf Blotato umgestellt — post-trigger.ps1 postet direkt via Blotato REST API — 2 Windows-Tasks: 08:55 (Story) + 17:55 (Reel) — image-generator.ps1 generiert LinkedIn-Bilder ✅ — Telegram Pause Bot ✅ fertig (telegram-pause-bot.ps1, Windows Task alle 5 Min) — Make.com manuell deaktiviert ✅ — System vollständig unabhängig |
| LinkedIn Autopilot GitHub Actions | Live ✅ (21.05.2026) | Architektur: cron-job.org 17:50 → GitHub Actions linkedin-post.yml → post-trigger-linkedin.ps1 → Blotato → LinkedIn ID 21656 + automatischer erster Kommentar via LinkedIn API — Secrets: BLOTATO_API_KEY, LINKEDIN_ACCESS_TOKEN, LINKEDIN_PERSON_URN — Token laeuft ab ~18.07.2026 — Windows Task Scheduler abgeloest |
| LinkedIn Dropservice Autopilot | Eingerichtet ⬜ (29.05.2026) | Architektur identisch mit Neustart im Kopf — Account ID 21657 — Workflow: linkedin-dropservice-post.yml — Script: post-trigger-linkedin-dropservice.ps1 — CSV: contentplan_linkedin_dropservice_juni_v1.csv (9 Posts, 02.06.–30.06.2026) — cron-job.org noch einzurichten — Pause via pause_linkedin_dropservice.txt |
| AI Creatives Done-for-You Service | Aufgebaut ✅ (29.05.2026) | 60 Instagram Posts/Monat für 497€ — Positionierung auf Dropservice LinkedIn-Profil 21657 — Outreach-Templates (4 Nachrichten, Tim Krasenbrink) für Coaches+Handwerk in reference/linkedin-outreach-templates.md — Contentplan Juni fertig |
| ALFIMA API-Status | Geklärt ✅ | Ausgehende Webhooks möglich (ALFIMA → Make.com) — eingehende API/Webhooks noch nicht verfügbar — E-Mail-Automationen direkt in ALFIMA einrichten (Pro-Abo enthalten) |
| Telegram KI Agent (@AndiKIAgent_bot) | Live ✅ | Make.com Szenario 5699211 aktiv — Telegram → Claude Haiku 4.5 → Telegram — System Prompt aktualisiert (17.05.2026): Befehle /pause /resume /status, Facebook Posts Neustart im Kopf, alle Accounts, Zielgruppe 50+, kurze Befehlsantworten — Anleitung in `reference/telegram-ki-agent-setup.md` |
| Andi Ideen Bot (@AndiIdeenAgent_bot) | Bereit ⬜ | Make.com Szenario 5734031 — wartet auf freien Slot (nach Blotato-Umstieg) — speichert Ideen in Google Sheets Tab „Ideen" — Token: siehe context/secrets.md |
| Claude App Projekt | Eingerichtet ✅ | Projektanweisungen mit vollem Kontext hinterlegt — Zielgruppe Männer 50+, alle Accounts, Facebook Post Stil, YouTube Stil |
| Julia Trost Kooperation | Ausstehend | Instagram-DM gesendet (09.05.2026) — auf Antwort warten |
| Dropservice (Ersu Consulting / Leon Weidner) | Laufend | Leads generieren via Facebook/WhatsApp |
| InnerCode KI-Assistent | In Planung | Wissen von Osho, Tolle, Dispenza etc. bündeln, Videokurs folgt |
| InnerCode Logo | In Planung | Logo-Entwurf erstellen |
| Mentortools KI-Lizenz | Erworben | Präsentation und Canva-Folien mit Notizen erstellen |
| Mentortools Affiliate-Lizenzen (zwei) | In Vermarktung | Content für Bewerbung aufbauen |
| HeyGen Reel für Dropservice | In Planung | Cartoon-Avatar mit verschiedenen Mimiken und Hintergründen |
| Minikurs „Ruhe finden" | In Planung | Willkommensvideo-Skript, Canva-Intro mit Logo |
| Hater-Antworten-Bibliothek (InnerCode-Stil) | In Planung | Antworten von mitfühlend bis humorvoll ausarbeiten |
| Astria Avatar @andi.mentalgesund | Idee ⬜ | Konsistentes Gesicht für Posts — Astria Fine-Tuning auf echte Fotos → wiedererkennbarer Avatar statt generischer Editorial-Mann — erst angehen wenn Autopilot stabil läuft |
| Barnaje | Konzeptphase | Blockchain-Struktur definieren |
| TAC 3.0 Instagram-Umbau | In Planung | Profil auf Marek Rühl TAC 3.0 ausrichten |
| Guitar Master Plan | Gestartet | Passende E-Gitarren-Ausrüstung beschaffen |
| Video Empire Contentplan | Erstellt | Kajinga-Funnel Inhalte zu „Stressfrei im Alltag" umsetzen |
| Einstein-Interview-Skript | Vorhanden | Für Bewusst Einfach weiterführen |

---

## Geplante YouTube-Videos

### Kanal: Bewusst Einfach

| Titel | Status |
| --- | --- |
| Respektlosigkeit ist ein Spiegel | Skript vorhanden |
| Warum 95% der Menschen kein Selbstvertrauen haben | 45 Abschnitte zu langen Sprechertexten umschreiben |
| Japans ältester Arzt: Vergiss das nicht — Gehirn ab 60 | In Planung |
| Sechs stille Anzeichen, dass du außergewöhnlich gesund alterst | In Planung (Thumbnail: 10 Sekunden auf einem Bein stehen) |
| Sechs Früchte gegen Diabetes (Video 16) | Skript mit 46 Tonspuren vorhanden |
| Du nennst es Liebe … aber es ist nur Angst, allein zu sein | In Planung, Osho-Perspektive ohne Namensnennung |
| Ich wurde geboren — aber niemand hat mich gefragt! | Max. 50 Tonspuren, früher CTA |
| Dein mentales Schutzschild (nach Lebensphilosophie) | In Planung |
| Die ANDEREN leben — und DU funktionierst nur | Eigenständiges neues Video, altes nicht weiterführen |

### Kanal: InnerCode

| Titel | Status |
| --- | --- |
| Alter macht nicht weise. Warum Erfahrung allein nichts bewirkt. | Skript fertig (ic-36-skript.txt), im CSV als Offen — produzieren |
| Selbstsabotage & Ego | Ca. 10 bis 12 Min., viraler Stil, tiefgründig und humorvoll |
| Videoreihe zu „Das weise Herz" | Chronologisch, aufmerksamkeitsstarke Titel und Thumbnails |

### Kanal: Business & Spirit (bis 29.06.2026)

| Datum | Titel | Status |
| --- | --- | --- |
| 02.06. | Für wen baust du das hier eigentlich auf? | Skript fertig (bs-01-skript.txt), im CSV |
| 07.06. | Warum Kontrolle erschöpft. | Skript fertig (bs-02-skript.txt), im CSV |
| 10.06. | Du hast Erfolg. Aber du bist nicht frei. | Skript fertig (bs-03-skript.txt), im CSV |
| 14.06. | Mit 55 denselben Fehler wie mit 35. | Skript fertig (bs-04-skript.txt), im CSV |
| 21.06. | Energie nach 50. | Skript fertig (bs-05-skript.txt), im CSV |
| 28.06. | Was bleibt, wenn du gehst? | Skript fertig (bs-06-skript.txt), im CSV |

---

## Social Media Accounts

### Instagram
- @business.und.spirit
- @andi.mit.system
- @andi.mentalgesund
- @song.geschenke
- @stock.und.partner
- @ki_support

### TikTok
- @andi_digital58
- @song.geschenke
- @business.und.spirit


### YouTube
- @bewussteinfach (Bewusst Einfach)
- @innercode.projekt (InnerCode)
- @business.und.spirit
- @andi.mentalgesund
- @velvetvoltage.official

---

## Content-Regeln Instagram (verbindlich ab 25.05.2026)

Vollständige Regeln: `reference/content-regeln-instagram.md`

- **Homographen vermeiden** — Wörter die je nach Betonung eine andere Bedeutung haben klingen im KI-Voiceover falsch (z.B. *übersetzen, umfahren, modern*). Durch eindeutige Synonyme ersetzen.
- **Emojis**: @business.und.spirit max 2-3 — alle anderen Accounts 4-6
- **Keine ASCII-Anführungszeichen** (`"`) in Dialogen — immer typografische (`„..."`)

## Avatar-Standard für Bildprompts

Editorial-Zeitungsillustrations-Stil. Immer derselbe Avatar: mittelalter bis älterer europäischer Mann, graues oder salt-and-pepper-Haar, kurzer grauer Bart, leicht müdes Gesicht, ruhiger und ernster Ausdruck.

