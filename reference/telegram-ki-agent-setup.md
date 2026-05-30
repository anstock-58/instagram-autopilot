# Telegram KI Agent Setup — Anleitung und Learnings

> Erstellt: 12.05.2026 — Funktionierendes System dokumentiert

---

## Was wurde gebaut

Ein persönlicher KI-Assistent auf Telegram, der über Claude (Anthropic API) antwortet.
Architektur: **Telegram Bot → Make.com → Claude API → Telegram Bot (Antwort)**

---

## Zugangsdaten (in secrets.md gespeichert)

- Telegram Bot: @AndiKIAgent_bot
- Bot Token: in `context/secrets.md`
- Claude API Key: in `context/secrets.md`
- Make.com Szenario-ID: 5699211

---

## Schritt-für-Schritt Aufbau

### 1. Claude API Key erstellen
- Auf platform.claude.com einloggen
- Links unter „Verwalten" → „API-Schlüssel"
- Mindestens 5 USD Credits aufladen (unter „Credits")
- Neuen Key erstellen, sicher speichern

### 2. Telegram Bot erstellen
- In Telegram nach @BotFather suchen (blauer Haken)
- `/newbot` senden
- Name vergeben: z.B. „Andi KI Agent"
- Username vergeben (muss auf `_bot` enden): z.B. `AndiKIAgent_bot`
- Token kopieren und sicher speichern

### 3. Make.com Szenario aufbauen

**Modul 1 — Telegram Bot: Watch Updates**
- Neue Verbindung mit Bot Token erstellen
- Webhook wird automatisch generiert

**Modul 2 — Anthropic Claude: Create a Prompt** ⚠️ NICHT „Make an API Call"
- Verbindung mit Claude API Key erstellen
- Model: aus Dropdown wählen (z.B. Claude Haiku 4.5 — günstigst)
- Max Tokens: 1024
- Message hinzufügen: Role = User, Input Type = Single string
- Content = Variable aus Modul 1: „1. Message: Text"

**Modul 3 — Telegram Bot: Send a Text Message or a Reply**
- Gleiche Verbindung wie Modul 1
- Chat ID = Variable aus Modul 1: „1. Message: Chat: ID"
- Text = Variable aus Modul 2: „4. Text Response"

**Aktivierung:**
- „Immediately as data arrives" einschalten
- Schedule Settings: „Immediately" → Save

---

## Kritische Learnings und Fehler

### ❌ Fehler 1: „Make an API Call" statt „Create a Prompt" verwenden
**Problem:** Manuelles JSON ist fehleranfällig — Modellname falsch, JSON-Syntax fehlerhaft
**Lösung:** Immer „Create a Prompt" aus dem Anthropic Claude Modul verwenden — hat Model-Dropdown, kein manuelles JSON nötig

### ❌ Fehler 2: Falscher Modellname im JSON
**Problem:** `claude-haiku-3-5-20241022` → falsch (404 Fehler)
**Richtig:** Über Dropdown auswählen, dann kein Tippfehler möglich

### ❌ Fehler 3: JSON-Syntaxfehler im Body
**Problem:** `{"model":...}` fehlerhaft formatiert → [400] Invalid JSON
**Lösung:** Kein manuelles JSON — „Create a Prompt" Modul verwenden

### ❌ Fehler 4: Modul gelöscht → Referenz defekt
**Problem:** Wenn ein Modul gelöscht wird, referenzieren nachfolgende Module noch die alte ID
**Lösung:** Nach Neuanlage alle nachfolgenden Module öffnen und Variablen neu mappen

### ❌ Fehler 5: Make.com Free Plan — max. 2 aktive Szenarien
**Problem:** Neues Szenario konnte nicht aktiviert werden
**Lösung:** Altes ungenutztes Szenario deaktivieren (nicht löschen)

### ✅ Richtige Vorgehensweise für Text-Output von Claude
Beim „Create a Prompt" Modul heißt der Output-Variable: **„Text Response"**
Im nachfolgenden Telegram-Modul einfach diese Variable als Text auswählen.

---

## Systemkosten (Schätzung)

- Claude API: wenige Cent pro Nachricht (Haiku = günstigstes Modell)
- 5 USD reichen für hunderte bis tausende Nachrichten
- Make.com: kostenloser Plan ausreichend (1 Szenario = dieser Agent)

---

## Make.com E-Mail Benachrichtigungen
- Alle drei Benachrichtigungen deaktiviert (12.05.2026)
- Erreichbar unter: eu1.make.com → Profilbild → Email preferences

---

## Aktueller System Prompt (Stand 12.05.2026)

```
Du bist Andis persönlicher KI-Assistent. Dein Name ist Andi Agent. Du hilfst Andreas Stock (Andi) bei allem rund um sein Online Business: YouTube (Kanäle Bewusst Einfach und InnerCode), Instagram-Automation, Affiliate-Marketing (Mentortools, TAC, Smart Profit), Dropservice, Mentalcoaching, Content-Erstellung und alle anderen Business-Themen.

Wichtige Regeln:
- Antworte IMMER direkt auf das was gefragt wird
- Stelle KEINE Rückfragen außer wenn absolut nötig
- Kein Willkommenstext, keine Vorstellung, kein Smalltalk
- Kurz und präzise — außer Andi will Details
- Antworte auf Deutsch
```

---

## Erweiterungsmöglichkeiten

- **System Prompt hinzufügen:** In Make.com vor der User-Message eine „System"-Message hinzufügen mit Andis Persönlichkeit/Rolle als Coach
- **Gesprächshistorie:** Komplexer — braucht Datenbank (Google Sheets oder Airtable) um vergangene Nachrichten zu speichern
- **Mehrere Nutzer:** Funktioniert bereits — jeder der den Bot findet kann schreiben (wenn gewünscht mit Whitelist einschränken)
- **Befehle:** Mit /start, /help etc. verschiedene Funktionen auslösen
- **ALFIMA-Integration:** Sobald eingehende Webhooks verfügbar — Kaufbestätigungen automatisch beantworten

---

## Nächste sinnvolle Schritte

1. System Prompt einbauen — Andi als Mentalcoach definieren
2. Bot mit persönlicher Begrüßung ausstatten
3. Langfristig: Gesprächshistorie für echten Kontext
