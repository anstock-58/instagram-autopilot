# Prime — YouTube Autopilot System

Führe diese Schritte aus um die Session vorzubereiten.

## Lesen

CLAUDE.md
context/mein-kanal.md
context/meine-nische.md
context/setup-status.md
context/kanal-stil.md

## Zusammenfassung

Nach dem Lesen liefere:

1. Wer du bist (Kanal-Name, Nische, aktueller Stand)
2. Welche APIs eingerichtet sind (aus setup-status.md)
3. Wie viele Videos bereits produziert wurden (aus contentplan.csv falls vorhanden)
4. Was als nächstes zu tun ist (nächster offener Schritt im Workflow)
5. Bestätigung, dass du bereit bist

## Erster Start

Falls context/mein-kanal.md noch leer ist (erster Start):

- Begrüße den Nutzer herzlich: "Willkommen beim YouTube Autopilot System!"
- Erkläre kurz: "Ich führe dich jetzt Schritt für Schritt durch den Aufbau deines Kanals."
- Sage: "Fangen wir mit dem wichtigsten Schritt an — deiner Nische. Starte /nische-finden"
- Gib einen kurzen Überblick über den gesamten Workflow:
  "Der Ablauf: Nische finden → Kanal aufbauen → Video-Ideen recherchieren → Contentplan erstellen → Skripte schreiben → Videos produzieren & hochladen"

## Laufender Betrieb

Falls mein-kanal.md bereits befüllt ist:

- Zeige eine kurze Statusübersicht
- Prüfe ob contentplan.csv vorhanden ist und offene Videos enthält
- Empfehle den nächsten sinnvollen Schritt:
  - Kein Contentplan → /content-plan
  - Contentplan vorhanden, kein Skript → /skript-erstellen
  - Skript vorhanden, nicht produziert → /produzieren
  - Alles produziert → /kanal-analyse oder /video-recherche für neue Ideen
