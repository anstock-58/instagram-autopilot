# E-Mail-Klassifizierung per KI — Konzept und Arbeitsanweisung

Erstes eigenes Praxisprojekt für Andis KI-Beratung: automatische Klassifizierung von E-Mails per KI, zuerst am eigenen Postfach getestet, danach als Vorlage für KI-Beratungskunden gedacht.

Stand: 07.08.2026. Entscheidung: Umsetzung mit **n8n, selbst gehostet**, nicht mit Make (siehe Begründung unten).

---

## 1. Ziel

Ein automatischer Workflow, der jede neue E-Mail in einem Postfach liest, per KI in eine von fünf Kategorien einordnet, und je nach Kategorie automatisch reagiert: Label setzen, archivieren, oder Andi per Telegram benachrichtigen. Ziel ist, dass Andi nur noch die Mails öffnen muss, die wirklich etwas von ihm brauchen.

Doppelter Zweck: erstens spart es Andi selbst Zeit im eigenen Postfach, zweitens wird der fertige Workflow zu einem vorzeigbaren, konkreten Beispiel für seine KI-Beratung.

---

## 2. Warum n8n statt Make

Make wurde zuerst geprüft, aber verworfen:

- Andis Make-Konto läuft im kostenlosen Tarif, 1.000 Credits/Monat, bereits 2 von 2 möglichen aktiven Szenarien belegt (unter anderem der Telegram-Bot für Facebook-Posts, der weiterlaufen muss)
- Jede klassifizierte Mail verbraucht in Make mehrere Operationen (Trigger, KI-Aufruf, Label, ggf. Archivieren, ggf. Telegram), bei Andis Mail-Aufkommen wäre das Monatslimit in wenigen Tagen aufgebraucht
- n8n ist selbst hostbar, die Software ist kostenlos, es fallen nur Server-Kosten an (siehe Punkt 3), die bei höherem Volumen deutlich günstiger sind als Make
- n8n ist zudem in der KI-Beratungs-/Automatisierungsbranche verbreiteter als Make, das zahlt direkt auf Andis Positionierung als KI-Berater ein

---

## 3. Hosting

Selbst gehostet auf einem günstigen Server statt n8n Cloud, damit es dauerhaft läuft (auch wenn Andis PC aus ist) und keine laufenden Cloud-Gebühren anfallen.

- Anbieter-Empfehlung: Hetzner, kleiner Server für ca. 4 bis 6 Euro im Monat
- Installation: n8n über Docker auf dem Server
- Wer richtet ein: Claude übernimmt die technische Einrichtung von Server und n8n-Installation

---

## 4. Kategorien und Regeln

| Kategorie | Erkennung | Aktion |
| --- | --- | --- |
| TERMIN | Absender enthält calendly.com/calendar, oder Betreff enthält „Termin"/„bestätigt"/„Reminder" | Label „Termine", im Posteingang lassen, Telegram-Push |
| DRINGEND | KI erkennt: echte Person, individuelle Anfrage, braucht Antwort | Label „Wichtig", im Posteingang lassen, Telegram-Push |
| FINANZEN | Betreff/Absender enthält „Rechnung", „Invoice", „Zahlung", Bank-Namen | Label „Finanzen", im Posteingang lassen |
| INFO | KI erkennt: Systembenachrichtigung, Bestätigung, FAQ, kein Handeln nötig | Label „Info", archivieren |
| WERBUNG | Bekannte Absenderliste ODER KI erkennt Verkaufs-/Funnel-Sprache | Label „Werbung", automatisch archivieren |

---

## 5. Workflow-Aufbau in n8n

Gleiches Grundprinzip wie in Make (Knoten, durch Linien verbunden), nur selbst gehostet:

1. Trigger-Knoten: Gmail, reagiert auf neue E-Mails im gewählten Postfach
2. KI-Knoten: schickt Betreff, Absender und Inhalt an ein Sprachmodell mit dem Klassifizierungs-Prompt unten
3. Router/Switch-Knoten: fünf Zweige, je nach KI-Antwort
4. Pro Zweig: Gmail-Label setzen, optional archivieren, optional Telegram-Nachricht an Andi

## Klassifizierungs-Prompt

```
Du bist ein E-Mail-Klassifizierer für das Postfach eines Selbstständigen
(Online-Marketing, Mentalcoaching, KI-Beratung). Ordne die folgende E-Mail
genau einer dieser Kategorien zu:

TERMIN - Kalender-/Terminbestätigung oder Erinnerung
DRINGEND - persönliche Anfrage einer echten Person, braucht zeitnahe Antwort
FINANZEN - Rechnung, Zahlungsaufforderung, Kontoauszug, Steuerthema
INFO - Systembenachrichtigung, Bestätigung, FAQ, kein Handeln nötig
WERBUNG - Marketing-Mail, Newsletter, Funnel-Sequenz, Verkaufsangebot

Antworte NUR mit der Kategorie in Großbuchstaben, ohne weiteren Text.

Betreff: {{Betreff}}
Absender: {{Absender}}
Inhalt: {{Snippet}}
```

---

## 6. Erkenntnisse aus dem ersten Testlauf (07.08.2026)

An fin.affairs.ansto@gmail.com getestet (manuell, nicht automatisiert), 15 aktuelle Mails: 13 davon Werbung/Funnel-Mails (Sven Meissner, Hermann Scherer, Ralf Schmitz, LinkedIn Newsletter, Manychat, TikTok, leadersmedia, finally-freelancing, bonuskiste, starsandbusiness), nur 1 echte terminrelevante Sache (Calendly), 1 Info-Mail. Zeigt: eine automatische Klassifizierung würde bei diesem Postfach über 85 Prozent der Mails direkt aus dem Weg räumen.

**Wichtiger Fund**: zwei unterschiedliche Calendly-Terminbestätigungen mit derselben Person (Andreas Rieger) an unterschiedlichen Tagen/Uhrzeiten gefunden, möglicher Hinweis auf eine Doppelbuchung. Terminkonflikte sind ein typischer blinder Fleck reiner Klassifizierung ohne Querprüfung, sollte bei jedem Testlauf mit im Blick behalten werden.

---

## 7. Vorgehen, Schritt für Schritt

1. Hetzner-Server einrichten, n8n per Docker installieren (Claude übernimmt)
2. Gmail-Zugang für n8n einrichten (OAuth, Andi bestätigt den Zugriff)
3. Workflow mit den fünf Kategorien aufbauen (gemeinsam, Andi lernt dabei mit, wie bei ELSTER)
4. Ersten Testlauf auf echten Mails im eigenen Postfach fahren, Ergebnisse prüfen
5. Bei Fehlklassifizierungen den Prompt nachschärfen
6. Workflow aktivieren, einige Tage laufen lassen, beobachten
7. Danach: Vorlage für KI-Beratungskunden vorbereiten

---

## 8. Offene Punkte für den Ausbau als Kundenangebot

- Für Kundenprojekte: eigene Google-App-Verifizierung nötig, sobald nicht mehr nur Andi selbst als Nutzer zugreift
- Bei sensiblen/finanznahen Postfächern: Datenschutz-Hinweis für Kunden vorbereiten, bevor Mailinhalte an ein KI-Modell geschickt werden
- Preismodell für Kunden noch offen (einmalige Einrichtung, laufende Betreuung, oder beides)
