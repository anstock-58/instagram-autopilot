# Plan: Facebook-Modul in Make.com Szenario 5522498

**Status:** Bereit zur Umsetzung
**Vorbereitet:** 02.05.2026
**Geschätzte Zeit:** 20–30 Minuten

---

## Was wir tun

Nach den bestehenden Instagram-Modulen zwei neue Facebook-Module einfügen:
- Foto-Post → **Facebook Pages > Create a Post with Photos**
- Reel → **Facebook Pages > Publish Reels**

Die OAuth-Verbindung (`__IMTCONN__: 6974772`) ist bereits in Make.com vorhanden — kein neues Login nötig.

---

## Wichtig vorab: Bekannte Einschränkung

**Reel-Beschreibung darf keine Zahlen enthalten** — sonst schlägt der Post still fehl.
Das bedeutet: im Contentplan-CSV bei Facebook-Reels den Text so formulieren, dass keine Ziffern vorkommen (z.B. "zehn" statt "10").

---

## Schritt-für-Schritt

### Vorbereitung
1. Make.com öffnen → Szenario 5522498 ("Social Media Automation Neustart im Kopf – Webhook")
2. Szenario im Edit-Modus öffnen

---

### Schritt 1: Nach dem letzten Modul einfügen

Das aktuelle Szenario endet mit dem Instagram-Reel-Post-Modul [9] (und dem Foto-Pfad).

**Wo einfügen:** Nach dem Instagram-Modul [9] auf der Reel-Seite und nach dem Foto-Instagram-Modul auf der Foto-Seite.

Rechtsklick auf die Verbindungslinie nach Modul [9] → "Add module"

---

### Schritt 2: Facebook Reel-Modul hinzufügen (Reel-Pfad)

1. Nach Modul [9] (Instagram Reel) → Rechtsklick auf Linie → "Add module"
2. Suchen: **"Facebook Pages"**
3. Modul wählen: **"Publish Reels"**
4. Verbindung: `__IMTCONN__: 6974772` auswählen (bereits vorhanden)
5. Felder befüllen:
   - **Page ID**: deine Facebook-Seite aus dem Dropdown wählen
   - **File URL**: Variable aus Modul [8] (fal.ai Video-URL)
   - **Description**: `{{text}}` aus dem Webhook-Payload (Modul [1])

---

### Schritt 3: Facebook Foto-Modul hinzufügen (Foto-Pfad)

1. Nach dem Instagram Foto-Modul → Rechtsklick auf Linie → "Add module"
2. Suchen: **"Facebook Pages"**
3. Modul wählen: **"Create a Post with Photos"**
4. Verbindung: `__IMTCONN__: 6974772` auswählen
5. Felder befüllen:
   - **Page ID**: deine Facebook-Seite aus dem Dropdown wählen
   - **Photo URL**: Variable aus dem fal.ai Bild-Modul (Bild-URL)
   - **Message**: `{{text}}` aus dem Webhook-Payload (Modul [1])

---

### Schritt 4: Testen

1. Contentplan-CSV: eine Zeile mit Datum = heute und `Plattform = Instagram` anlegen (vorläufig, da Facebook-Posting noch getestet werden muss)
2. Szenario manuell triggern: "Run once" in Make.com
3. Prüfen ob beide Module (Instagram + Facebook) grün durchlaufen
4. Facebook-Seite aufrufen und Post prüfen

---

## Keine Änderungen am PowerShell-Skript nötig

Das post-trigger.ps1 bleibt unverändert — der Webhook-Payload enthält bereits alle benötigten Felder. Make.com erledigt die Verteilung auf Instagram und Facebook.

---

## Falls Facebook-Verbindung neu authorisiert werden muss

Falls `__IMTCONN__: 6974772` beim Auswählen nicht erscheint:
1. Im Facebook-Modul auf "Add" klicken
2. Mit dem Facebook-Account einloggen, auf dem die Facebook-Seite liegt
3. Seiten-Zugriff erlauben
4. Verbindung speichern

---

## Offene Frage für morgen

Soll Facebook immer mitposten (wenn Plattform = Instagram) oder nur wenn Plattform explizit "Facebook" im CSV eingetragen ist?

**Empfehlung:** Erst immer mitposten, dann bei Bedarf einen Filter einbauen.
