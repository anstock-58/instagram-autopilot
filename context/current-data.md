# Aktuelle Projekte und Daten (Stand 16.07.2026)

---

## YouTube-Produktionssystem (Kern-Infrastruktur)

**Pipeline:** CSV → youtube-producer.ps1 → ElevenLabs (Voiceover) → fal.ai FLUX (zehn Bilder) → fal.ai Ideogram V3 (Thumbnail) → FFmpeg (Schnitt) → YouTube Upload (nicht gelistet)

**Drei Kanäle, alle drei Tage gleichzeitig:**

| Kanal | Handle | Ausrichtung |
| --- | --- | --- |
| InnerCode | @innercode.projekt | Neurowissenschaftlich, tiefgründig, Bewusstsein |
| Bewusst Einfach | @bewussteinfach | Bürgernah, emotional, 50+ Mainstream |
| Business und Spirit | @business.und.spirit | Unternehmer/Führungskräfte 50+, Funktionsmodus |

**Technisches:**
- ElevenLabs: Creator Plan, 121.000 Credits/Monat, erneuert am 17. Juni
- Stimmen: InnerCode = JiW03c2Gt43XNUQAumRP / BewusstEinfach + BusinessUndSpirit = 2OcnG4mH3jIMtWz3vKus
- Google OAuth: drei Refresh Tokens, einer pro Kanal, alle aktiv
- Thumbnails: JPG, 1280x720, Ideogram V3, Gesicht rechts, Text links

---

## Aktuelle Videoproduktion

| Datum | Kanal | Titel | Status |
| --- | --- | --- | --- |
| 22.05. | InnerCode | Gedankenlesen | Produziert ✅ |
| 23.05. | BewusstEinfach | Gedankenlesen | Produziert ✅ |
| 26.05. | BewusstEinfach | Prokrastination | Produziert ✅ |
| 28.05. | InnerCode | Erinnerung | In Produktion |
| 28.05. | BusinessUndSpirit | 30 Jahre aufgebaut | Produziert ✅ |
| 29.05. | BewusstEinfach | Kopf schaltet nicht ab | Produziert ✅ |

**Nächste Videos Business und Spirit (ab 31.05., alle drei Tage):**
1. Der stille Preis des Erfolgs — was erfolgreiche Männer ab 50 nie zugeben würden
2. Warum starke Unternehmer innerlich leer werden, ohne dass es jemand sieht
3. Funktionieren ist keine Stärke. Warum Führungskräfte ab 50 langsam an sich selbst vorbeigehen

---

## ALFIMA Produktstatus

| Produkt | Preis | Status |
| --- | --- | --- |
| Nein aus Überzeugung | 37 € | Live ✅ |
| Wenn dein Kopf nicht mehr abschaltet | 37 € | Live ✅ |
| Instagram Autopilot System | 197 € | Live ✅ |
| Kopfklar PDF | 9,85 € | Live ✅ |
| Neustart im Kopf Hauptkurs | 397 € | Live ✅ |
| Raus aus dem Funktionsmodus | 37 € | Live ✅ |
| Instagram Autopilot System | 197 € | Live ✅ |

### TraceFunnels URL-Zuordnung

Funnel-Logik: WordPress-Seite → TraceFunnels LP → Netlify Landingpage → TraceFunnels Salespage → ALFIMA Checkout

| Produkt | TraceFunnels LP | TraceFunnels Salespage | Netlify |
| --- | --- | --- | --- |
| Neustart im Kopf (397 €) | /neustart-kurs | /neustart-im-kopf | shimmering-cassata-a26e4b.netlify.app |
| Raus dem Funktionsmodus (37 €) | /raus-starten | /raus-aus-dem-funktionsmodus | zesty-beijinho-757806.netlify.app |
| Kopf abschaltet (37 €) | /kopf-schaltet-nicht-ab | — | — |
| Instagram Autopilot (197/697 €) | /autopilot-instagram | /instagram-autopilot-system | — |
| Nein aus Überzeugung (37 €) | /nein-aus-überzeugung | — | — |
| Standortcheck (kostenlos) | /standortcheck | — | — |
| Neustart Workbook (kostenlos) | /neustart-workbook | — | — |
| KI Content Starter Pack | /ki-content-starter-pack | — | — |
| KI Prompt Paket | /ki-prompt-paket | — | — |

### Funnel Details

**Nein aus Überzeugung:**
- Checkout: https://alfima.com/andreass95/nein-aus-uberzeugung
- Kurzlink: https://sicher-weiterlesen.com/nein-aus-überzeugung
- Cross-sell: Kopfklar 7 € ✅
- Upsell (OTO): Wenn dein Kopf nicht mehr abschaltet 27 € ✅
- Workbook: fertig in outputs/kurse/nein-aus-ueberzeugung/Dokumente/
- dreißig Lektionsbilder: in ALFIMA hochgeladen ✅

**Wenn dein Kopf nicht mehr abschaltet (37 €, ALFIMA ID 28661):**
- sieben Module, vierunddreißig Lektionen
- Modul-Einführungsskripte: alle sieben fertig in outputs/kurs-kopf-abschaltet/modul-01 bis 07-skript.md
- Audio-Skripte fertig: audio-4-7-8-skript.md (fünf Min.) + audio-body-scan-skript.md (acht Min.)
- vierunddreißig Lektionsbilder: lokal fertig in outputs/kurse/kopf-abschaltet/lektions-bilder/
- sieben Modul-Cover: fertig in outputs/kurse/kopf-abschaltet/bilder/
- Workbook noch nicht erstellt (Inhalt in outputs/buch-kdp/11-anhang.md)
- Nächster Schritt: Lektionstexte aus ALFIMA → ElevenLabs Charly produzieren → unlisted YouTube → in ALFIMA einbetten

---

## Automation-Infrastruktur

### Instagram (Blotato + GitHub Actions)

| Account | Blotato ID | Status | Posting |
| --- | --- | --- | --- |
| @business.und.spirit | 46248 | Laufend ✅ | Story 06:55 + Reel 15:55 UTC |
| @andi.mit.system | 46471 | Laufend ✅ | GitHub Actions |
| @ki_support | 46341 | Laufend ✅ | Slideshow-Template, Juni fertig (90 Posts) |
| @andi.mentalgesund | — | Laufend ✅ | Verbunden, Posts laufen |

### LinkedIn

- Profil: Dipl.-Ing. Andreas Stock (LinkedIn Account ID 21656)
- Architektur: cron-job.org 17:50 → GitHub Actions linkedin-post.yml → post-trigger-linkedin.ps1 → Blotato → LinkedIn
- Repo: anstock-58/instagram-autopilot
- CSV: outputs/contentplan_mai_v2.csv, alle Posts auf Foto-Typ, 17:55 Uhr
- Automatischer erster Kommentar nach jedem Post via LinkedIn API direkt (Blotato hat keine Kommentar-Funktion)
- Kommentar-Text: "Mach den Standort-Check und erkenne, ob du im Funktionsmodus bist. Hier kannst du ihn kostenlos herunterladen: https://sicher-weiterlesen.com/standortcheck"
- Token läuft ab ca. 18. Juli 2026 — dann neues Token über OAuth-Flow
- GitHub Secrets: BLOTATO_API_KEY, LINKEDIN_ACCESS_TOKEN, LINKEDIN_PERSON_URN
- Person URN: urn:li:person:TVPJInaVk9

### Telegram Bots

- Pause Bot — telegram-pause-bot.ps1, läuft alle fünf Minuten, unsichtbar via run-hidden.vbs (kein PowerShell-Popup)
- Befehle: pause/weiter linkedin/instagram/alle, status, heute
- @AndiKIAgent_bot — Make.com Szenario 5699211, Claude Haiku 4.5, live ✅
- @AndiIdeenAgent_bot — wartet auf Aktivierung

---

## Wichtige getroffene Entscheidungen

- Blotato statt Make.com + Creatomate — vollständig umgestellt, Make.com deaktiviert
- Ideogram V2 via fal.ai für alle Kursbilder (nicht flux — ignoriert Stil)
- Stil Nein aus Überzeugung: Teal/Nachtblau, Silhouetten, glühende Elemente
- Stil Kopf abschaltet: Dunkles Nachtblau/Navy, weißblaues Kopflicht
- Kursvideos: MentorTools Avatar, kein Screenrecording (außer Instagram Autopilot Kurs: Kombination Avatar + Loom)
- Browser-Automation: NICHT für Texteingabe oder Bilder-Upload (zu tokenintensiv — Andi macht das manuell)
- Instagram Autopilot als Videokurs: Idee festgehalten, nach aktuellen Projekten angehen (247 bis 297 €)

---

## Aktive Projekte

| Projekt | Status | Nächster Schritt |
| --- | --- | --- |
| YouTube InnerCode (551 Abos) | Laufend ✅ | Alle drei Tage produzieren |
| YouTube Bewusst Einfach (400 Abos) | Laufend ✅ | Alle drei Tage produzieren, auf 1.000 Abos bringen |
| YouTube Business und Spirit | Laufend ✅ | Alle drei Tage produzieren |
| Facebook Andreas Stock persönlich | Laufend ✅ | 3.929 Freunde, 4.787 Follower, zwei bis drei Posts pro Woche |
| ALFIMA Funnels | Teilweise live ✅ | Landingpages für Neustart + Raus aus dem Funktionsmodus |
| People-Pleasing Minikurs Farm | In Entwicklung | Kursinhalt für Nein aus Überzeugung ausarbeiten |
| Social Media Automation | Laufend ✅ | @andi.mentalgesund noch verbinden, Bio-Link umziehen |
| Dropservice (Ersu Consulting / Leon Weidner) | Laufend | Leads generieren via Facebook/WhatsApp |
| InnerCode KI-Assistent | In Planung | Wissen bündeln, Videokurs folgt |
| Barnaje | Konzeptphase | Blockchain-Struktur definieren |
| Guitar Master Plan | Gestartet | Passende E-Gitarren-Ausrüstung beschaffen |

---

## People-Pleasing Minikurs Farm — komplett fertig ✅

**Hauptprodukt: Nein aus Überzeugung — 37 €**
Zielgruppe: Männer und Frauen ab 35. In fünf Tagen herausfinden warum man nie Nein sagen kann.

Struktur:
- Tag eins und zwei: Das ehrliche Bild (Selbstcheck)
- Tag drei: Die Wurzel (Prägungen, Glaubenssätze) — Quick Win hier
- Tag vier: Der Wendepunkt (Akzeptanz, erste Übung)
- Tag fünf: Das erste echte Nein (Umsetzung)
- Bonus-Tag: Integration
- Boni: Meditation "Ich bin genug" + PDF Workbook

**Order Bump: Die Nein-Formel — 17 €**
Fertige Sätze für häufigste Situationen (Job, Familie, Freunde)

**Upsell: Grenzen leben — 97 €**
Tieferer Kurs, Selbstwert aufbauen, Prägungen auflösen

Max. Warenkorbwert: 151 €. Plattform: ALFIMA. Komplette Farm inkl. E-Mail-Sequenzen und Checkout fertig — Engpass ist Traffic, nicht Content.

---

## Offene manuelle Aufgaben

- **DRINGEND:** LinkedIn Token erneuern vor dem 18. Juli 2026 (OAuth-Flow)
- vierunddreißig Lektionsbilder + sieben Cover für Kopf abschaltet: in ALFIMA hochgeladen ✅
- Workbook für Kopf abschaltet erstellen (Inhalt vorhanden in outputs/buch-kdp/11-anhang.md)
- Sichtbarkeits-Routine: Facebook-Gruppen beigetreten ✅, täglich fünfzehn bis zwanzig Minuten Kommentar-Engagement läuft (siehe reference/sichtbarkeits-routine.md)
- Coaching-Bot live ✅ — https://ansto-finaffairs.com/selbstcheck/ (Netlify: luminous-squirrel-7c08f2.netlify.app)
- People-Pleasing Farm: Traffic für Standortcheck und Nein aus Überzeugung aufbauen — Engpass ist Reichweite, nicht Content

---

## Geplante YouTube-Videos

### Kanal: Bewusst Einfach

| Titel | Status |
| --- | --- |
| Respektlosigkeit ist ein Spiegel | Skript vorhanden |
| Warum 95% der Menschen kein Selbstvertrauen haben | 45 Abschnitte umschreiben |
| Japans ältester Arzt: Vergiss das nicht — Gehirn ab 60 | In Planung |
| Sechs stille Anzeichen, dass du außergewöhnlich gesund alterst | In Planung |
| Du nennst es Liebe … aber es ist nur Angst, allein zu sein | In Planung, Osho-Perspektive ohne Namensnennung |
| Ich wurde geboren — aber niemand hat mich gefragt! | Max. 50 Tonspuren, früher CTA |
| Die ANDEREN leben — und DU funktionierst nur | Eigenständiges neues Video |

### Kanal: InnerCode

| Titel | Status |
| --- | --- |
| Selbstsabotage und Ego | Ca. zehn bis zwölf Min., tiefgründig und humorvoll |
| Videoreihe zu Das weise Herz | Chronologisch, aufmerksamkeitsstarke Titel |

---

## Avatar-Standard für Bildprompts

Editorial-Zeitungsillustrations-Stil. Immer derselbe Avatar: mittelalter bis älterer europäischer Mann, graues oder salt-and-pepper-Haar, kurzer grauer Bart, leicht müdes Gesicht, ruhiger und ernster Ausdruck.

---

## Inhaltsregeln je Kanal

**LinkedIn:** Immer Foto-Typ, Bild-URL aus CSV. Caption endet mit "Hol dir den kostenlosen Standortcheck im ersten Kommentar." Erster Kommentar automatisch via LinkedIn API mit Standortcheck-Link.

**YouTube InnerCode:** vierzig Abschnitte, je zwei bis drei Sätze, Osho nie namentlich erwähnen, CTA "Schreib es in die Kommentare, ein Satz reicht."

**YouTube Bewusst Einfach:** Einstieg als emotionaler Cliffhanger, einfache bürgernah Sprache, CTA früh und am Ende natürlich eingebaut.

**YouTube Business und Spirit:** Ruhig, direkt, ehrlich. Zielgruppe Unternehmer/Führungskräfte 50+. Kein Motivationssprech.

**Alle YouTube-Videos:** Skripte immer direkt ins CSV, nie in den Chat. Maximal zwei bis drei Produktlinks pro Beschreibung. Standortcheck nur bei Unternehmer/Führungskräfte 50+ Themen.

---

## Facebook-Gruppen Traffic-Strategie (15.06.2026)

Recherche direkt in Facebook (Gruppensuche) für die People-Pleasing Farm und Standortcheck. Ziel: organische Reichweite über Engagement in fremden Gruppen, da Kachinga-Automatisierung weggefallen ist.

**Für @business.und.spirit (Standortcheck, Unternehmer/Führungskräfte 50+) — Priorität:**
1. Von Unternehmern für Unternehmer — 12.474 Mitglieder, 20+ Beiträge/Tag — beste Mischung aus Größe und Zielgruppenschärfe
2. Führung. Leadership. — 2.668 Mitglieder, 5 Beiträge/Tag — direkter inhaltlicher Fit (Führungsthemen)
3. Führungskraft. Leader. Vorgesetzter. — 2.552 Mitglieder, 2 Beiträge/Tag
4. Führungskräfte, Leitende Angestellte & Geschäftsführer — 787 Mitglieder — klein, aber sehr zielgenau
5. Unternehmer helfen Unternehmern – Selbstständige helfen Selbstständigen — 16.308 Mitglieder, 10+ Beiträge/Tag — größte Reichweite, etwas breiter

**Für @andi.mentalgesund (Nein aus Überzeugung, Grenzen setzen, Burnout):**
1. Burnout verstehen & bewältigen — 1.337 Mitglieder — direkter thematischer Treffer
2. Erfahrungsaustausch - Burnout — 712 Mitglieder, aktiv
3. Einmal Burnout und zurück — 685 Mitglieder — passt zur "Wendepunkt"-Story-Linie des Kurses
4. Seelsorge & Unterstützung bei psychischen Problemen, Depressionen, Ängsten — 2.023 Mitglieder, 10+ Beiträge/Tag

**Strategie (kein Pitchen, kein Spam):**
- Erst ein bis zwei Wochen nur kommentieren — echte Erfahrung, ehrliche Einordnung, keine Links
- Profil-Bio mit Standortcheck-/Freebie-Link versehen, das übernimmt die Conversion
- Danach gelegentlich eigener Beitrag mit echtem Mehrwert (keine Werbung), Link weiterhin nur im Profil
- Gruppen-Algorithmus bestraft schnelle Eigenwerbung — Konten können gesperrt werden

**Nächster Schritt (manuell, Login nötig — nicht automatisierbar):** Andi tritt den priorisierten Gruppen bei und kommentiert täglich zehn bis fünfzehn Minuten unter aktuellen Posts.

---

## MentorTools KI-Agent — Bewertung (26.05.2026)

MentorTools-Agent hat fünfzehn Skills (Kurserstellung, Design, Medien, Landingpages, Social Posting). Kurse laufen aktuell ausschließlich über ALFIMA, MentorTools spielt für Andi keine aktive Rolle mehr. Bewertung:

**Empfohlen:**
- Marketing-Video-Creation (acht Sekunden, mit Andis Avatar/Stimme) — einziger Skill der etwas liefert das aktuell fehlt: echte Talking-Head-Clips für Instagram-Reels, passend zur Authentizitäts-Strategie

**Nicht weiterverfolgen:** course-create/export, landing-page, social-media-posting, slideshow-creation, MCP-Server-Anbindung, profitable-course-research — Überschneidung mit ALFIMA/TraceFunnels/Blotato ohne Mehrwert, bzw. MentorTools-Kurse nicht mehr relevant

---

## Wichtige technische Entscheidungen (dauerhaft)

- Windows Task Scheduler abgelöst durch GitHub Actions + cron-job.org (läuft auch wenn PC aus)
- Make.com deaktiviert — alles läuft direkt über Blotato REST API
- Blotato ist das einzige Posting-Tool — kein Creatomate, kein Make.com
- Browser-Automation nicht für Texteingabe oder Bilder-Upload (zu tokenintensiv)
- PowerShell: Write-Log muss Write-Host statt Write-Output — sonst kontaminiert Log-Output den Funktionsrückgabewert
