# Instagram Reel Autopilot — Quick-Start in 10 Schritten

## Einmalige Einrichtung (ca. 2–4 Stunden)

☐ Schritt 1 — Accounts prüfen
Instagram Business Account aktiv? Make.com Account? fal.ai Account mit Guthaben?

☐ Schritt 2 — Claude Code öffnen
Setup-Prompt (Datei 5) einfügen. Nische und Zielgruppe am Ende eintragen.

☐ Schritt 3 — Contentplan befüllen
Claude Code erstellt den Plan. Prüfen, anpassen, als CSV speichern.

☐ Schritt 4 — Make.com Blueprint importieren
Neues Szenario → Importieren → Datei 2 hochladen.

☐ Schritt 5 — Verbindungen in Make.com einrichten
Instagram Business verbinden. fal.ai API Key eintragen.

☐ Schritt 6 — Webhook URL kopieren
In Make.com den Webhook-URL aus dem ersten Modul kopieren.

☐ Schritt 7 — Webhook URL ins Skript eintragen
post-trigger.ps1 öffnen → $webhookUrl = "DEINE URL" → speichern.

☐ Schritt 8 — Skript testen
PowerShell → post-trigger.ps1 ausführen → Log prüfen (outputs/post-trigger-log.txt).

☐ Schritt 9 — Windows Task Scheduler einrichten
Aufgabe anlegen: täglich zur gewünschten Uhrzeit, post-trigger.ps1 ausführen.

☐ Schritt 10 — Ersten echten Post testen
Datum im Contentplan auf heute. Status: geplant. Skript starten. Instagram prüfen.

---

Wenn alles grün — das System läuft. Ab jetzt nur noch Contentplan ausfüllen.
