# Session-Brief: @andi.mentalgesund Instagram Autopilot einrichten

**Ziel dieser Session:** Den Instagram-Account @andi.mentalgesund genau so in die bestehende Blotato-Automation einbinden wie die anderen Accounts — inklusive Contentplan für den Kurs "Nein aus Überzeugung".

---

## Was bereits existiert (nicht neu bauen)

Die komplette Automation läuft bereits für drei Accounts:

| Account | Blotato ID | Skript |
|---|---|---|
| @business.und.spirit | 46248 | post-trigger-business-und-spirit.ps1 |
| @andi.mit.system | 46471 | post-trigger-andi-mit-system.ps1 |
| @ki_support | 46341 | post-trigger-ki-support.ps1 |

**Architektur (baugleich übernehmen):**
```
CSV-Contentplan → GitHub Actions (cron) → post-trigger-[account].ps1 → Blotato REST API → Instagram
```

- **Blotato API Key:** in `context/secrets.md`
- **GitHub Actions Workflow:** `.github/workflows/` — bestehende Workflows als Vorlage nehmen
- **Posting-Zeiten:** 06:55 UTC (Story) + 15:55 UTC (Reel) — oder anpassen falls @andi.mentalgesund andere Zeiten braucht
- **Blotato Endpoint:** `https://backend.blotato.com/v2/posts` (Auth: `blotato-api-key: KEY`)

---

## Was neu zu tun ist

### Schritt 1: Blotato Account-ID ermitteln
@andi.mentalgesund ist noch nicht in Blotato verbunden oder hat noch keine ID in secrets.md.
→ In Blotato unter "Social Accounts" nachschauen ob der Account schon verbunden ist und die ID holen.
→ ID in `context/secrets.md` unter Blotato Account IDs eintragen.

### Schritt 2: Post-Trigger-Skript erstellen
→ `scripts/post-trigger-andi-mentalgesund.ps1` — baugleich zu `post-trigger-ki-support.ps1` erstellen
→ Nur Account-ID und CSV-Pfad anpassen

### Schritt 3: GitHub Actions Workflow erstellen
→ `.github/workflows/post-andi-mentalgesund.yml` — baugleich zu bestehendem Workflow
→ Zeiten: 06:55 UTC (Story) + 15:55 UTC (Reel)

### Schritt 4: Contentplan erstellen
→ Datei: `outputs/contentplan_andi_mentalgesund_juni_v1.csv`
→ Gleiche CSV-Struktur wie die anderen Contentpläne
→ Thema und Tonalität: siehe unten

---

## Account-Profil @andi.mentalgesund

**Thema:** Mentale Gesundheit, Grenzen setzen, People-Pleasing, emotionale Erschöpfung
**Zielgruppe:** Männer und Frauen 50+, die funktionieren aber innerlich erschöpft sind
**Ton:** Warm, direkt, ohne Floskeln — kein Coaching-Sprech, keine leeren Motivationsfloskeln
**Stil:** Kurze, ehrliche Aussagen die treffen. Nah am Alltag.

**Beispiel-Themen für Posts:**
- Warum du immer Ja sagst obwohl du Nein meinst
- Der Unterschied zwischen Freundlichkeit und Selbstaufgabe
- Was passiert wenn du aufhörst, es allen recht zu machen
- Grenzen setzen ist kein Egoismus
- Warum du nachts nicht abschaltest (Grübeln, Dauerstress)
- Das schlechte Gewissen nach einem Nein — und warum es normal ist

**Produkt das beworben wird:**
- "Nein aus Überzeugung" — 5-Tage-Minikurs — 37€
- Link: https://sicher-weiterlesen.com/nein-aus-überzeugung
- CTA: "Hol dir den Kurs im Link in der Bio" oder "5 Tage — link in bio"

---

## CSV-Struktur (gleich wie andere Contentpläne)

Spalten: `Datum, Uhrzeit, Plattform, Post-Typ, Text, Link, Bild-URL, Bildprompt, Videoprompt, Text-Overlay, Karussell-Slides, Status`

- Post-Typ: `Reel` oder `Foto`
- Plattform: `instagram`
- Für Reels: Videoprompt ausfüllen, Bildprompt leer
- Für Fotos: Bildprompt ausfüllen, Videoprompt leer
- CTA am Ende jedes Textes: Hinweis auf Link in Bio

---

## Referenzdateien

- Bestehende Skripte: `scripts/post-trigger-ki-support.ps1` (beste Vorlage)
- Secrets: `context/secrets.md` (Blotato API Key, Account IDs)
- Bestehender Workflow: `.github/workflows/` (als Vorlage)
- Contentplan-Beispiel: `outputs/contentplan_ki_support_juni_v1.csv`
- Prompts für Contentplan: `reference/prompts-instagram-reels.md`
