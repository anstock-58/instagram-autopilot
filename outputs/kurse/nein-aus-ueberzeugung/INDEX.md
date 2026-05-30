# Nein aus Überzeugung — Kurs-Index

**ALFIMA Kurs-ID:** 32188  
**Preis:** 37 €  
**Format:** 5-Tage-Minikurs · 6 Module · 30 Lektionen  
**Status:** In Vorbereitung — Texte + Bilder noch einzupflegen

---

## Funnel-Struktur

| Element | Datei | Preis | Status |
|---|---|---|---|
| Sales Page | `funnel/salespage.html` | — | ✅ Erstellt |
| Order Bump | `funnel/order-bump.html` | 17 € | ✅ Erstellt |
| Upsell "Grenzen leben" | `funnel/upsell-konzept.md` | 97 € OTO | ✅ Konzept fertig |

---

## Kurs-Inhalte

| Datei | Inhalt | Status |
|---|---|---|
| `kursinhalt.md` | Vollständige Kursstruktur (alle Module + Lektionen) | ✅ |
| `lektionstexte.md` | Kurztexte unter dem Video für alle 30 Lektionen | ✅ Bereit zum Einfügen |
| `sprechertext.html` | Vollständige Sprecher-Skripte für Avatar-Produktion | ✅ |
| `workbook.html` | Workbook (Bildschirm-Version) | ✅ |
| `workbook-print.html` | Workbook (Druck-Version) | ✅ |

---

## Bilder

| Datei | Modul | Status |
|---|---|---|
| `bilder/modul-1-selbstcheck.jpg` | Modul 1: Tag 1 – Der Selbstcheck | ✅ Generiert |
| `bilder/modul-2-die-muster.jpg` | Modul 2: Tag 2 – Die Muster | ✅ Generiert |
| `bilder/modul-3-die-wurzel.jpg` | Modul 3: Tag 3 – Die Wurzel | ✅ Generiert |
| `bilder/modul-4-der-wendepunkt.jpg` | Modul 4: Tag 4 – Der Wendepunkt | ✅ Generiert |
| `bilder/modul-5-das-erste-nein.jpg` | Modul 5: Tag 5 – Das erste echte Nein | ✅ Generiert |
| `bilder/bonus-integration.jpg` | Bonus: Integration im Alltag | ✅ Generiert |

**Stil:** Cinematic dark, tiefes Rot und Schwarz, dramatisches Seitenlicht, kein Text, 16:9

---

## Modul-Übersicht

### Modul 1: Tag 1 – Der Selbstcheck
1. Willkommen
2. Warum du immer Ja sagst
3. Der innere Ja-Reflex
4. Was Ja-Sagen kostet
5. Dein Selbstcheck

### Modul 2: Tag 2 – Die Muster
1. Deine Muster erkennen
2. Der Auslöser-Moment
3. Automatismus vs. Entscheidung
4. Dein persönliches Muster
5. Reflexion Tag 2

### Modul 3: Tag 3 – Die Wurzel
1. Wo kommt das her?
2. Kindheit und Anpassung
3. Der Glaubenssatz dahinter
4. Intelligente Überlebensstrategie
5. Reflexion Tag 3

### Modul 4: Tag 4 – Der Wendepunkt
1. Du bist nicht dein Muster
2. Die Drei-Sekunden-Pause
3. Innere Erlaubnis
4. Neue Reaktionsmuster
5. Reflexion Tag 4

### Modul 5: Tag 5 – Das erste echte Nein
1. Das erste echte Nein
2. Sprache des Neins
3. Ohne Erklärung
4. Übung: Das Nein-Gespräch
5. Abschluss & Ausblick

### Bonus: Integration im Alltag
1. Nein im Alltag
2. Die Drei-Sekunden-Regel täglich
3. Wenn Rückfälle kommen
4. Dein Unterstützungssystem
5. Weitermachen

---

## Offene To-dos

- [ ] Lektionstexte in ALFIMA einfügen (aus `lektionstexte.md` kopieren)
- [ ] Modul-Cover-Bilder in ALFIMA hochladen (aus `bilder/`)
- [ ] Alle Module in ALFIMA veröffentlichen
- [ ] Sales Page in TraceFunnels bauen
- [ ] Order Bump in ALFIMA Checkout konfigurieren (17 €)
- [ ] Upsell "Grenzen leben" — Kursstruktur in ALFIMA anlegen

---

## Bild-Generierung (fal.ai FLUX)

**Script:** `scripts/generate-modul-covers.ps1`  
**API-Key:** siehe `context/secrets.md`  
**Style-Prefix für neue Bilder:**
```
Cinematic dark photography, deep red and black tones, dramatic side lighting, no text, wide 16:9, photorealistic
```
Diesen Prefix + individueller Inhaltsprompt = konsistente Bildsprache für alle Kurse.
