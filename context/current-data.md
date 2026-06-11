# Aktuelle Projekte und Daten

## Aktive Projekte

> Ruhende und abgeschlossene Projekte ausgelagert nach `context/archiv-projekte.md` (Stand 11.06.2026) — bei Bedarf von dort zurückholen.

| Projekt | Status | Nächster Schritt |
| --- | --- | --- |
| KDP Buch „Das Seil loslassen" | eBook live ✅ / Taschenbuch in Prüfung ⏳ (08.06.2026) | eBook live unter amazon.de/dp/B0GZMZDK5Q (4,99€, KDP Select aktiv) — Taschenbuch-Cover hatte Größenfehler (KDP erwartete 12.444x9.250 Zoll, eingereicht war 11.656x8.750 Zoll) — behoben mit `outputs/buch-02/fix-cover.js` (PDF auf exakte Maße skaliert, gespeichert als `Softcover_Seil_Loslassen-KDP-fixed.pdf`) — neu eingereicht, Preis bereits auf 11,99€ — wartet auf Freigabe (bis zu 72 Std.), E-Mail folgt — danach: Autorenexemplar bestellen |
| ALFIMA Kurs "Nein aus Überzeugung" | Live ✅ | 37€ — Cross-sell Kopfklar 7€ — Upsell Kopf abschaltet 27€ — Link: https://sicher-weiterlesen.com/nein-aus-überzeugung — Lektionsbilder lokal bereit zum Hochladen — Promotion: @andi.mentalgesund — Account noch nicht in Blotato, in separater Session einrichten + Contentplan mit Kurs-Posts anlegen |
| ALFIMA Kurs "Wenn dein Kopf nicht mehr abschaltet" | Bilder fertig ✅ | 30 Lektionsbilder + 6 Modul-Cover lokal generiert — manuell in ALFIMA hochladen |
| YouTube Autopilot System | Fertig ✅ (24.05.2026) | Vollständiger Käufer-Workspace unter `outputs/youtube-autopilot-system/` — 7 Skills, anonymisiertes Script, Setup-Anleitung — bereit für ALFIMA-Listing zu 297€ |
| YouTube InnerCode (@innercode.projekt) | Laufend | Vollautomatische Pipeline aktiv — alle 3 Tage neues Video — nächstes: "Erinnerung" (28.05.) in InProduktion |
| TODO InnerCode Musik-Rotation | Offen ⏳ (08.06.2026) | `$MusikPool["InnerCode"]` im Producer-Skript hat bisher nur 1 Pixabay-Track — noch 3-4 weitere lizenzfreie Alternativen heraussuchen und ergänzen (analog zu Bewusst Einfach mit 4 Tracks) — selbstständig in einer ruhigen Session erledigen, ohne dass Andi daran erinnern muss |
| YouTube BusinessUndSpirit (@business.und.spirit) | NEU LIVE ✅ (24.05.2026) | Erstes Video "30 Jahre aufgebaut" produziert — Zielgruppe: Unternehmer/Führungskräfte 50+, Funktionsmodus-Thema — Google OAuth konfiguriert — in Pipeline integriert |
| YouTube Bewusst Einfach | **FOKUS-KANAL** ✅ | OAuth Token NEU 30.05.2026: siehe context/secrets.md (Refresh Token Bewusst Einfach) — Stimme: 2OcnG4mH3jIMtWz3vKus — Musik NEU: C:\Users\Andreas\Medien_Business\Business_YT_Bewusst_Einfach\Medien\Musik\zen-garden-standard.mp3 (Zen Garden, wird geloopt) — Blotato: 36987 — Thema: Gesundheit+Langlebigkeit, Zielgruppe 65+ mehrheitlich WEIBLICH — Ton: warm+hoffnungsvoll+spirituell-leicht (Sunny Buddha), NICHT Alarm — CTR-Framework: context/ctr-framework.md |
| Produkt-Links Videobeschreibungen | Eingerichtet ✅ | Regeln in context/produkt-links.md — max 2-3 Links pro Video — thematisch passend — Standortcheck nur Unternehmer 50+ |
| ElevenLabs Plan | Creator ✅ | 121.000 Credits/Monat — erneuert am 17. Juni 2026 |
| Instagram Autopilot System | Live ✅ | Architektur: CSV → GitHub Actions → post-trigger-ACCOUNT.ps1 → Blotato /v2/videos/from-templates → AI Video mit Voiceover → Instagram — Template: ai-story-video (5903fe43) — 2 Scenes: Hauptbotschaft + CTA — **Stimmen** (06.06.2026): Charlie (Australian) für business.und.spirit + andi.mentalgesund, Daniel (British, authoritative) für ki_support + andi.mit.system — Captions unten, gelb — cron-job.org triggert 07:55 UTC (Story) + 15:55 UTC (Reel) |
| Persönliche Trust-Posts @business.und.spirit | Eingerichtet ✅ (11.06.2026) | Neuer Post-Typ "Foto" in post-trigger.ps1: postet echtes Bild/Video direkt als Instagram-Feed-Post (kein AI-Video, kein Blotato-Render) — 5 persönliche Geschichten-Posts (12./15./17./19./21.06.) mit echten Fotos aus outputs/fotos-andi/ eingebaut — Andi will hier künftig eher echte Videos von sich machen statt Fotos (mehr Vertrauen) — technisch keine Änderung nötig, mediaUrl kann genauso auf eine Videodatei zeigen, sobald Aufnahmen vorliegen |
| @business.und.spirit Autopilot | Live ✅ | Blotato ID 46248 — contentplan_business_und_spirit_juni_v2.csv (60 Posts, 01.06.–30.06.2026) — Stimme: Charlie — Emojis: max 2-3 pro Post (dezent/professionell) — Captions 08.06.2026 überarbeitet: alle 49 geplanten Posts haben jetzt eine Brücke zwischen Problem und Standortcheck-CTA (Hook → Brücke → CTA statt CTA als Fremdkörper), zusätzlich 3 Kurs-Promo-Stories korrigiert die fälschlich den Standortcheck statt den Kurs bewarben — 11.06.2026 erneut korrigiert: 6 weitere Posts (23./25./29./30.06., teils Story+Reel) verlinkten bereits auf den Kurs „Neustart im Kopf", versprachen im Text aber noch den kostenlosen Standortcheck, jetzt auf Kurs-Wortlaut angepasst |
| @ki_support Autopilot | Live ✅ | Blotato ID 46341 — contentplan_ki_support_juni_v2.csv am 06.06.2026 neu gebaut (50 saubere Zeilen 06.–30.06., voll-zitiert, Phantomzeilen entfernt, 23.06 Reel repariert, Gedankenstriche raus) — Backup-Schedule-Zeiten aktiv — Stimme: Daniel (British) — Emojis: 4-6 pro Post — 11.06.2026: Produkt „KI Audio Empire" pausiert (kein brauchbarer Vendor-Link, war aber das meistangefragte Produkt → Interessenten vorerst vertrösten), alle 11 betroffenen Tage (10./13./15./16./17./21./22./24./26./27./29.06., je Story+Reel bzw. 17.06 nur Reel = 21 Posts) inhaltlich neu auf Instagram Autopilot (6 Tage) und KI-Prompt-Paket (5 Tage) umgestellt, jeweils mit klarem Tool-Bezug im Text statt vagem „KI Audio"-Sprech |
| Hook-Kriterium Ist+Soll | Umgesetzt ✅ (11.06.2026) | Neues 5. Kriterium in reference/content-regeln-instagram.md: jede Hook muss sowohl Ist-Zustand (Problem/Situation des Betrachters) als auch Soll-Zustand (Ergebnis/Richtung) erkennbar machen, sonst Scroll-Risiko — 4 reine Feature-Listen-Hooks korrigiert (business.und.spirit 22./24./27.06., andi.mentalgesund 27.06.) — ki_support: 4 Posts (11./19./23./30.06., teils Story+Reel) korrigiert, die vage „KI-Tools"-Liste/Review/Setup versprachen statt dem tatsächlich verlinkten KI-Prompt-Paket, jetzt durchgängig „Tool vs. Prompt"-Framing mit passendem CTA |
| @andi.mit.system Autopilot | Live ✅ | Blotato ID 46471 — contentplan_andi_mit_system_juni_v2.csv — Stimme: Daniel (British) — Emojis: 4-6 pro Post — ACHTUNG: Reels liefen seit 20.05. nicht (Export-Csv \r-Bug, behoben 25.05.2026) — 11.06.2026: 21 Textfehler bereinigt (doppelte Wörter wie „der Der Workshop"/„Workshop Workshop", kaputte Hashtags „#Der Workshop" → „#Workshop", verwirrende „Der Workshop 3.0"-Nennungen, stichworthafte Standalone-Sätze „Der Workshop. Kostenlos." zu vollständigen Sätzen umformuliert) |
| @andi.mentalgesund Autopilot | Live ✅ | Blotato ID aus Secret MENTALGESUND_ACCOUNT_ID — contentplan_andi_mentalgesund_juni_v2.csv — Stimme: Charlie (Australian) — Emojis: 4-6 pro Post — CTA-Wording 08.06.2026 überarbeitet: „Wenn das bei dir gerade passt, schreib KLARHEIT" wirkte nach Aussagen über Erschöpfung/Überlastung unpassend zu beiläufig, jetzt 5 natürliche Varianten („Wenn das bei dir auch so ist…", „Geht's dir manchmal genauso?", „Kommt dir das bekannt vor?", „Erkennst du dich darin wieder?", „Klingt das nach dir?") rotierend in allen 60 Posts (bereits gepostete Texte im CSV ebenfalls aktualisiert als Vorlage für künftige Posts, Live-Stand bleibt unverändert) — 11.06.2026: Produkt-Rotation korrigiert, 01.–14.06. waren 14 Tage am Stück nur Standortcheck, 11.06. (Ruhe-Thema) jetzt auf Minikurs „Kopf abschaltet" und 13.06. (Grenzen-Thema) auf „Nein aus Überzeugung" verlinkt, ab 15.06. war ohnehin schon gut gemischt |
| Instagram Autopilot — Produkt | Live ✅ | Salespage + Komplettanleitung auf Single-Path umgestellt (nur Blotato 29$, kein Make.com+Creatomate mehr) — ALFIMA Willkommensmail aktiviert ✅ — ALFIMA Produktbeschreibung manuell eingetragen — Idee: als Videokurs ausbauen (5 Module, 247-297 EUR), nach aktuellen Projekten angehen |
| ALFIMA Funnel „Neustart im Kopf" | Live ✅ | Freebie-Landingpage fertig, Traffic läuft |
| Smart Profit KI Business (Sales Angels) | Aktiver Schwerpunkt | Digistore-Produkt bewerben |
| „Neustart im Kopf" Hauptkurs | In ALFIMA installiert | Landingpage fehlt noch |
| Minikurs „Raus dem Funktionsmodus" | In ALFIMA installiert | Landingpage fehlt noch |
| Blotato Direct-API-Automation | Live ✅ (16.05.2026) | Instagram + LinkedIn komplett auf Blotato umgestellt — post-trigger.ps1 postet direkt via Blotato REST API — 2 Windows-Tasks: 08:55 (Story) + 17:55 (Reel) — image-generator.ps1 generiert LinkedIn-Bilder ✅ — Telegram Pause Bot ✅ fertig (telegram-pause-bot.ps1, Windows Task alle 5 Min) — Make.com manuell deaktiviert ✅ — System vollständig unabhängig |
| LinkedIn Autopilot GitHub Actions | Live ✅ (21.05.2026) | Architektur: cron-job.org 17:50 → GitHub Actions linkedin-post.yml → post-trigger-linkedin.ps1 → Blotato → LinkedIn ID 21656 + automatischer erster Kommentar via LinkedIn API — Secrets: BLOTATO_API_KEY, LINKEDIN_ACCESS_TOKEN, LINKEDIN_PERSON_URN — Token laeuft ab ~18.07.2026 — Windows Task Scheduler abgeloest |
| LinkedIn Dropservice Autopilot | Eingerichtet ⬜ (29.05.2026) | Architektur identisch mit Neustart im Kopf — Account ID 21657 — Workflow: linkedin-dropservice-post.yml — Script: post-trigger-linkedin-dropservice.ps1 — CSV: contentplan_linkedin_dropservice_juni_v1.csv (9 Posts, 02.06.–30.06.2026) — cron-job.org noch einzurichten — Pause via pause_linkedin_dropservice.txt |
| AI Creatives Done-for-You Service | Aufgebaut ✅ (29.05.2026) | 60 Instagram Posts/Monat für 497€ — Positionierung auf Dropservice LinkedIn-Profil 21657 — Outreach-Templates (4 Nachrichten, Tim Krasenbrink) für Coaches+Handwerk in reference/linkedin-outreach-templates.md — Contentplan Juni fertig |
| Telegram KI Agent (@AndiKIAgent_bot) | Live ✅ | Make.com Szenario 5699211 aktiv — Telegram → Claude Haiku 4.5 → Telegram — System Prompt aktualisiert (17.05.2026): Befehle /pause /resume /status, Facebook Posts Neustart im Kopf, alle Accounts, Zielgruppe 50+, kurze Befehlsantworten — Anleitung in `reference/telegram-ki-agent-setup.md` |
| Andi Ideen Bot (@AndiIdeenAgent_bot) | Bereit ⬜ | Make.com Szenario 5734031 — wartet auf freien Slot (nach Blotato-Umstieg) — speichert Ideen in Google Sheets Tab „Ideen" — Token: siehe context/secrets.md |
| Julia Trost Kooperation | Ausstehend | Instagram-DM gesendet (09.05.2026) — auf Antwort warten |
| Dropservice (Ersu Consulting / Leon Weidner) | Laufend | Leads generieren via Facebook/WhatsApp |
| Astria Avatar @andi.mentalgesund | Pilot getestet ⬜ (08.06.2026) | Kostenloser Weg getestet: 8 Bilder über fal.ai mit festem Charakter-Prompt generiert (outputs/avatar-mentalgesund/) — Ergebnis: Stil konsistent, aber Gesicht driftet von Bild zu Bild (kein wirklich wiedererkennbares Gesicht). Für echte Konsistenz bräuchte es Astria-Fine-Tuning auf den ~13 echten Fotos (outputs/fotos-andi/) — Andi prüft erst die Astria-Preise (Account erstellt, Guthaben noch 0,00 $), Entscheidung offen ob sich der Aufwand lohnt |

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

