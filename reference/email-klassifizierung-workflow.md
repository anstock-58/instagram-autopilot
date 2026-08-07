# E-Mail-Klassifizierung — Workflow-Vorlage

Vorlage für automatische E-Mail-Klassifizierung per KI, erst am eigenen Postfach getestet (fin.affairs.ansto@gmail.com), gedacht als wiederverwendbare Grundlage für KI-Beratungskunden.

---

## Kategorien und Regeln

| Kategorie | Erkennung | Aktion |
| --- | --- | --- |
| TERMIN | Absender enthält calendly.com/calendar, oder Betreff enthält „Termin"/„bestätigt"/„Reminder" | Label „Termine", im Posteingang lassen, Telegram-Push |
| DRINGEND | KI erkennt: echte Person, individuelle Anfrage, braucht Antwort | Label „Wichtig", im Posteingang lassen, Telegram-Push |
| FINANZEN | Betreff/Absender enthält „Rechnung", „Invoice", „Zahlung", Bank-Namen | Label „Finanzen", im Posteingang lassen |
| INFO | KI erkennt: Systembenachrichtigung, Bestätigung, kein Handeln nötig | Label „Info", archivieren |
| WERBUNG | Bekannte Absenderliste ODER KI erkennt Verkaufs-/Funnel-Sprache | Label „Werbung", automatisch archivieren |

---

## Make.com-Aufbau

1. Trigger: Gmail „Watch Emails" auf dem gewünschten Postfach
2. KI-Modul (Claude oder GPT) mit dem Klassifizierungs-Prompt unten
3. Router mit fünf Zweigen, einer pro Kategorie
4. Pro Zweig: Gmail „Add Label" plus optional „Archive" plus optional Telegram-Nachricht

---

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

## Erkenntnisse aus dem ersten Testlauf (07.08.2026)

An fin.affairs.ansto@gmail.com getestet, 15 aktuelle Mails: 13 davon Werbung/Funnel-Mails (Sven Meissner, Hermann Scherer, Ralf Schmitz, LinkedIn Newsletter, Manychat, TikTok, leadersmedia, finally-freelancing, bonuskiste, starsandbusiness), nur 1 echte terminrelevante Sache (Calendly), 1 Info-Mail. Zeigt: bei diesem Postfach würde eine automatische Klassifizierung über 85 Prozent der Mails direkt aus dem Weg räumen, ohne dass Andi sie öffnen muss.

**Wichtiger Fund beim Testlauf**: zwei unterschiedliche Calendly-Terminbestätigungen mit derselben Person (Andreas Rieger) an unterschiedlichen Tagen/Uhrzeiten gefunden — möglicher Hinweis auf Doppelbuchung, sollte man bei jedem Testlauf im Blick behalten, da Terminkonflikte ein typischer, teurer blinder Fleck sind, den reine Klassifizierung ohne Querprüfung übersieht.

---

## Nächste Schritte

- Zuerst am eigenen Business-Postfach in Make umsetzen und einige Tage laufen lassen
- Danach für Kundenprojekte: eigene App-Verifizierung bei Google nötig, sobald nicht mehr nur Andi selbst als Nutzer zugreift
- Bei sensiblen/finanznahen Postfächern: Datenschutz-Hinweis für Kunden vorbereiten, bevor Mailinhalte an ein KI-Modell geschickt werden
