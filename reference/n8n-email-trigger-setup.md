# n8n: E-Mail-Postfach per IMAP verbinden (Schritt-für-Schritt)

**Zweck:** Anleitung, um ein Gmail-Postfach (oder jedes andere IMAP-fähige Postfach) mit dem Baustein „Email Trigger (IMAP)" in n8n zu verbinden, ohne den aufwendigeren offiziellen Gmail-OAuth-Weg zu gehen. Für eine selbst gehostete n8n-Instanz (wie bei einem lokalen Test oder n8n Cloud) der schnellste Weg, ganz ohne eigenes Google-Cloud-Projekt.

**Wann diesen Weg statt der offiziellen Gmail-Anbindung nutzen:** Für schnelle Tests oder kleine Kunden, bei denen der Aufwand eines eigenen Google-Cloud-Projekts (für den offiziellen OAuth-Weg) nicht gerechtfertigt ist. Funktioniert mit jedem Postfach, das IMAP unterstützt, nicht nur Gmail.

---

## Schritt 1: Gmail-App-Passwort erstellen

Google lässt bei aktivierter Bestätigung in zwei Schritten keine normalen Passwörter mehr für Drittanbieter-Apps zu, dafür gibt es App-Passwörter.

1. Im Browser zu `myaccount.google.com/apppasswords` gehen, mit dem gewünschten Google-Konto eingeloggt sein.
2. Falls die Seite meldet, dass App-Passwörter nicht verfügbar sind: die „Bestätigung in zwei Schritten" ist noch nicht aktiviert, das zuerst auf derselben Seite einschalten.
3. Im Feld „App-Name" einen Namen eintragen (z. B. `n8n`), auf „Erstellen" klicken.
4. Google zeigt einmalig einen 16-stelligen Code. **Diesen sofort notieren**, er wird kein zweites Mal angezeigt. Falls verpasst: das App-Passwort löschen (Mülleimer-Symbol) und neu erstellen.

---

## Schritt 2: Baustein in n8n einfügen

1. Im Workflow auf „+" bzw. „Add first step..." klicken.
2. Im Suchfeld `Email Trigger` eingeben.
3. **„Email Trigger (IMAP)"** auswählen (nicht „Gmail", das ist der aufwendigere OAuth-Weg).

---

## Schritt 3: Zugangsdaten (Credential) einrichten

Im geöffneten Baustein auf **„Set up credential"** klicken, dann eintragen:

| Feld | Wert |
|---|---|
| Host | `imap.gmail.com` |
| Port | `993` |
| SSL/TLS | aktiviert (Standard) |
| User | die volle Gmail-Adresse, z. B. `name@gmail.com` |
| Password | das 16-stellige App-Passwort aus Schritt 1, **nicht** das normale Gmail-Passwort |

Danach speichern.

---

## Schritt 4: Grundeinstellungen im Baustein

- **Mailbox Name**: `INBOX` (Standard, prüft den normalen Posteingang)
- **Action**: `Mark as Read` (Standard) — legt fest, was mit der E-Mail passiert, nachdem n8n sie verarbeitet hat
- **Format**: `Simple` reicht für die meisten Fälle

---

## Schritt 5: Testen

Auf **„Test this trigger"** bzw. „Execute step" klicken. n8n prüft dann das Postfach und zeigt eine neue, ungelesene E-Mail als Testdatensatz an, falls eine vorhanden ist. Von hier aus lässt sich der Workflow genauso weiterbauen wie beim Testlauf mit simulierten Daten (siehe Anhang G der Kernmethodik, z. B. If-Baustein zur Klassifizierung nach Betreff).

---

## Bekanntes Problem: Deutsche Umlaute werden falsch dargestellt

Der IMAP-Trigger-Baustein hat einen bekannten, noch offenen Fehler bei bestimmten Zeichensätzen (offizieller Bug-Report bei n8n auf GitHub, Issue #10230). Deutsche Sonderzeichen (ä, ö, ü, ß) kommen manchmal verstümmelt an, zum Beispiel wird "Straße" zu "StraÃe". Es gibt keine saubere Einstellung, die das direkt behebt.

**Notlösung: eigener Code-Baustein zur Korrektur.** Zwischen den IMAP-Trigger und den nächsten Baustein (z. B. „If") einen **„Code"**-Baustein (Sprache JavaScript) einfügen mit folgendem Inhalt:

```javascript
function fixEncoding(text) {
  if (typeof text !== 'string') return text;
  const replacements = [
    ['Ã', 'ß'],
    ['Ã¤', 'ä'], ['Ã¶', 'ö'], ['Ã¼', 'ü'],
    ['Ã„', 'Ä'], ['Ã–', 'Ö'], ['Ãœ', 'Ü'],
    ['ÃŸ', 'ß'], ['Ã©', 'é'], ['Ã¨', 'è'],
    ['â€™', '’'], ['â€œ', '“'], ['â€', '”'],
    ['â€"', '–'], ['Â ', ' '],
    ['Ã', 'ß'],
  ];
  let fixed = text;
  for (const [broken, correct] of replacements) {
    fixed = fixed.split(broken).join(correct);
  }
  return fixed;
}

for (const item of $input.all()) {
  if (item.json.textPlain) item.json.textPlain = fixEncoding(item.json.textPlain);
  if (item.json.textHtml) item.json.textHtml = fixEncoding(item.json.textHtml);
  if (item.json.subject) item.json.subject = fixEncoding(item.json.subject);
}
return $input.all();
```

Wichtig: Die erste Ersetzungsregel (`Ã` gefolgt vom unsichtbaren Steuerzeichen ``) muss vor der letzten, allgemeinen Regel (nur `Ã`) stehen, sonst bleibt ein unsichtbares Zeichen hinter dem reparierten „ß" übrig (sichtbar als leere Box in manchen Texteditoren). Getestet und bestätigt funktionierend am 14.08.2026.

Diese Lösung ist ein Notbehelf, kein echter Fix des zugrunde liegenden n8n-Fehlers, deckt aber die häufigsten Fälle bei deutschen Geschäftstexten ab.

---

*Erstellt 13.08.2026, während des ersten eigenen n8n-Tests mit dem eigenen Gmail-Postfach. Gehört inhaltlich zu Anhang G (Tool-Referenz) der Kernmethodik. Umlaut-Fix ergänzt 14.08.2026.*
