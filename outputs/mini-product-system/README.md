# Mini Product System

Ein schlankes Next.js System zum Verkauf digitaler Mini Produkte.

---

## Installation & Start

```bash
# 1. In den Projektordner wechseln
cd outputs/mini-product-system

# 2. Abhängigkeiten installieren
npm install

# 3. Entwicklungsserver starten
npm run dev
```

Dann im Browser öffnen:
- **Landingpage:** http://localhost:3000
- **Admin:** http://localhost:3000/admin (Passwort: `admin123`)

---

## Konfiguration

### PayPal Link eintragen

Datei: `config/settings.json`

```json
{
  "paypalLink": "https://paypal.me/DEINNAME/17"
}
```

### Preis ändern

In `config/settings.json` den Wert für `price` auf `17`, `27` oder `29` setzen.
Oder direkt im Admin unter Einstellungen ändern.

### Aktives Produkt wählen

In `config/settings.json`:

```json
{
  "activeProduct": "ki-content-starter-pack"
}
```

**Verfügbare Produkt-IDs:**
- `ki-content-starter-pack`
- `side-hustle-starter-kit`
- `tiktok-content-ideen-pack`

Oder direkt im Admin unter Einstellungen wechseln — dann Button "Speichern" drücken.

### Admin Passwort ändern

In `config/settings.json`:

```json
{
  "adminPassword": "DEINPASSWORT"
}
```

---

## Leads verwalten

Admin öffnen → http://localhost:3000/admin

- Alle Leads mit Name, E-Mail, Produkt, Datum und Status sehen
- Status per Dropdown ändern: `offen` → `bezahlt` → `geliefert`
- Lead löschen per Klick
- Tabelle aktualisieren per "↻ Aktualisieren"

Leads werden lokal in `data/leads.json` gespeichert.

---

## Produkt Prompts generieren

Admin → Abschnitt "Produkt Prompt erstellen"

Produkt auswählen → Prompt erscheint → "Prompt kopieren" → In ChatGPT oder Claude einfügen.

---

## Produkt Markdown zu PDF

Die Produkt-Rohdateien liegen in `content/`:

```
content/
  produkt-ki-content-starter-pack.md
  produkt-side-hustle-starter-kit.md
  produkt-tiktok-content-ideen-pack.md
```

**Option 1 — Typora / Obsidian:**
Markdown-Datei öffnen → Export als PDF

**Option 2 — VS Code Extension:**
"Markdown PDF" Extension installieren → Rechtsklick → "Export (pdf)"

**Option 3 — Online:**
markdowntopdf.com oder md2pdf.netlify.app

---

## Online stellen (Deployment)

**Option 1 — Vercel (empfohlen, kostenlos):**

```bash
npm install -g vercel
vercel
```

Dann auf vercel.com die Umgebungsvariablen setzen falls nötig.

**Wichtig:** Die `data/leads.json` wird auf Vercel nicht persistiert. Für Produktion entweder:
- Vercel KV nutzen (kostenloser Tier verfügbar)
- Auf einem VPS (Hetzner, DigitalOcean) deployen mit `npm run build && npm start`

**Option 2 — VPS / Root-Server:**

```bash
npm run build
npm start
# Port 3000, oder mit nginx als Reverse Proxy
```

---

## Was zuerst anpassen

1. `config/settings.json` — PayPal Link eintragen
2. Admin öffnen → Aktives Produkt wählen
3. `config/settings.json` — Admin-Passwort ändern
4. Produkt-Markdown mit ChatGPT befüllen (Prompts im Admin)
5. Markdown zu PDF exportieren
6. TikTok-Profil optimieren (`content/tiktok-marketing-plan.md`)

---

## Dateistruktur

```
mini-product-system/
├── config/
│   ├── settings.json       ← PayPal, Preis, aktives Produkt
│   └── products.json       ← Produktdaten und Prompts
├── data/
│   └── leads.json          ← Lokale Lead-Datenbank
├── content/
│   ├── produkt-ki-content-starter-pack.md
│   ├── produkt-side-hustle-starter-kit.md
│   ├── produkt-tiktok-content-ideen-pack.md
│   ├── tiktok-marketing-plan.md
│   ├── marketing-texte.md
│   └── trend-ideen.md
├── src/app/
│   ├── page.tsx            ← Landingpage
│   ├── admin/page.tsx      ← Admin Bereich
│   └── api/
│       ├── leads/          ← Lead API
│       └── settings/       ← Settings API
└── README.md
```
