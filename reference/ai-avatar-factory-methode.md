# AI Avatar Factory: Wiederverwendbare Methode

**Zweck:** Strukturierte Vorgehensweise, um für einen Account, ein Unternehmen oder eine Marke ein komplettes Avatar- und Content-System zu entwickeln. Nicht der Avatar steht im Mittelpunkt, sondern das System dahinter: von der Unternehmens- und Zielgruppenanalyse über die Positionierung bis zum fertigen Master-Prompt und Contentplan. Der Avatar ist nur ein Baustein davon.

**Auslöser:** Andi wollte ursprünglich ein Produkt für fremde Kunden (Coaches, Berater, KMU) daraus machen. Entschieden am 24.07.2026: zuerst intern an den eigenen Instagram-Accounts anwenden und beweisen, dass es funktioniert, bevor es als Angebot für andere ausgebaut wird. Erster Anwendungsfall ist @business.und.spirit, siehe `outputs/business-und-spirit/avatar-factory-analyse.md`.

**Verwendung:** Sagt Andi „erstelle das Avatar-System für Account/Firma X" oder „wende die Avatar Factory auf X an", wird diese Methode automatisch und vollständig angewendet. Bei einem bereits bestehenden Instagram-Account zuerst den vorhandenen Kontext lesen (`context/instagram-accounts.md`, `context/instagram-strategie.md`, `context/deep-research-zielgruppe.md`, `reference/content-regeln-instagram.md`, bisherige Contentpläne) statt Zielgruppe und Stil neu zu erfinden. Fehlt der Kontext (z. B. bei einem echten fremden Kunden), Anhang A als Fragebogen nutzen.

---

## ARBEITSWEISE (gilt vor allem anderen)

Erst prüfen, was zu Marke, Zielgruppe und Stil bereits im Workspace dokumentiert ist, und das als Grundlage nehmen statt zu duplizieren oder zu widersprechen. Wo etwas fehlt, gezielt nachfragen oder recherchieren, nicht raten. Der Avatar muss am Ende zur Positionierung passen, nicht umgekehrt. Jede Stufe baut auf der vorherigen auf, keine Stufe überspringen.

---

## DER PROMPT

> Entwickle ein vollständiges Avatar- und Content-System für: **[ACCOUNT / UNTERNEHMEN]**.
>
> Arbeite die folgenden acht Stufen der Reihe nach ab. Nutze vorhandenen Kontext aus dem Workspace, wo er existiert, und markiere offene Fragen statt zu raten.

### 1. Unternehmensanalyse

Wer steckt dahinter, welches Geschäftsmodell, welche Produkte oder Angebote, welcher Funnel (kostenloser Einstieg, Mini-Angebot, Hauptangebot), über welche Kanäle wird es beworben, welche Automatisierung/Technik läuft bereits dahinter.

### 2. Markenanalyse

Markenkern in wenigen Sätzen: wofür steht die Marke, wofür ausdrücklich nicht, welcher Tonfall, welche Abgrenzung zu naheliegenden Wettbewerbs- oder Genre-Klischees (z. B. „kein Motivationskitsch", „keine Therapiesprache").

### 3. Zielgruppenanalyse

Konkreter Kunden-Avatar (Alter, Situation, Beruf), Schmerzpunkte, unausgesprochene Gedanken, bereits gescheiterte Lösungsversuche, tiefste Sehnsüchte, Bewusstseinsstufen (unbewusst bis kaufbereit) und was in jeder Stufe inhaltlich zieht. Wenn möglich zwei bis drei ausformulierte Personas mit innerem Monolog, Kaufhemmnissen und Kauf-Triggern.

### 4. Positionierung

Wofür steht der Account im Vergleich zu ähnlichen Angeboten, welcher bekannte Engpass besteht aktuell (Reichweite, Hook-Stärke, Vertrauen, Angebot), welches eine zentrale Versprechen trägt den gesamten Content.

### 5. Kommunikationsstil

Tonfall, Satzlänge, erlaubte und verbotene Wörter, Hook-Formel, CTA-Formel, Emoji-Dichte, Umgang mit Fachbegriffen. Wo vorhanden, an bestehende plattformübergreifende Regeln anknüpfen (`reference/hook-formel-universal.md`, `reference/content-regeln-instagram.md`).

### 6. Avatar-Entwicklung

Aus Markenkern und Zielgruppe einen visuellen Charakter ableiten, der die Zielgruppe glaubwürdig spiegelt oder den Absender glaubwürdig repräsentiert (je nachdem was zur Positionierung passt). Festlegen: Name, Alter, Herkunft/Wirkung, Gesicht, Frisur, Kleidungsstil, Ausstrahlung, Grundhaltung. Muss zum bestehenden Workspace-Avatar-Standard passen oder eine begründete, dokumentierte Abweichung davon sein (`context/current-data.md`, Abschnitt „Avatar-Standard für Bildprompts").

### 7. Master-Prompt und KI-Tool-Umsetzung

Aus Stufe 6 einen festen Charakter-Prompt-Block bauen (ein Satz, der in jedem Bild identisch wiederverwendet wird, siehe Anhang B), plus je nach Bedarf: OpenArt-Charakterdefinition, HeyGen-Avatar-Setup, eine Reihe von Bildprompts für unterschiedliche Szenen, Videoprompts für Reels.

### 8. Content-System

Reel-Serien-Konzept, Hook-Varianten nach der universellen Formel, CTA-Bausteine mit Account-Keyword, Caption-Vorlagen, Contentplan-Struktur (siehe Anhang C), grober 30-Tage-Rhythmus. Am Ende so aufbereitet, dass es direkt in die bestehende Autopilot-Pipeline (`context/instagram-accounts.md`) eingetragen werden kann.

---

## ANHANG A: Eingabefragebogen (nur wenn kein Workspace-Kontext existiert, z. B. echter fremder Kunde)

1. Was genau bietet ihr an, und was ist der kostenlose Einstiegspunkt in den Funnel?
2. Wer ist der typische Kunde, wie alt, welche Lebens- oder Berufssituation?
3. Welches Problem hat er, das er sich selbst kaum eingesteht?
4. Welche Konkurrenten oder ähnlichen Angebote gibt es, und wie grenzt ihr euch ab?
5. Gibt es bereits eine Bildsprache, ein Maskottchen oder eine Person, die für die Marke steht?
6. Welche Wörter oder Tonfälle passen nicht zur Marke (zu weich, zu hart, zu esoterisch, zu corporate)?
7. Über welche Kanäle soll der Content laufen, und welche Automatisierung ist bereits vorhanden?
8. Wie viel Content pro Woche ist realistisch leistbar?

---

## ANHANG B: Avatar-Prompt-Baukasten

Fester Charakter-Block nach dem Muster aus `scripts/generate-avatar-mentalgesund.ps1` (dort als `$CHAR`-Variable): eine zusammenhängende Beschreibung aus Alter, Nationalität/Wirkung, Frisur, Bart/Merkmale, Gesichtsausdruck, Statur, Kleidung, Farbpalette, Lichtstimmung, Bildstil. Dieser Block wird in jedem einzelnen Bildprompt wortgleich vorangestellt, danach folgt nur die Szenenbeschreibung (Ort, Handlung, Pose, Blickrichtung, Lichtsituation), damit der Charakter über alle Bilder hinweg konsistent bleibt.

Technische Eckdaten für die Umsetzung über fal.ai (wie im bestehenden Pilot): Modell `fal-ai/imagen4/preview/fast`, Format `portrait_16_9` für 9:16-Content, ein Bild pro Aufruf, keine Textelemente im Bild, keine Logos.

---

## ANHANG C: Content-System-Vorlage

Contentplan-Spalten wie in den bestehenden CSVs (`outputs/contentplan_*.csv`): Datum, Uhrzeit, Plattform, Post-Typ, Text, Link, Bild-URL, Bildprompt, Videoprompt, Text-Overlay, Karussell-Slides, Status. Grundrhythmus 30 Tage, Story morgens und Reel abends (Standardzeiten siehe `context/instagram-accounts.md`), Produktverlinkung passend zum Tagesthema statt wochenlang gleich (siehe „Produkt-Rotation nach Thema" in `reference/content-regeln-instagram.md`).

---

## ANHANG D: Checkliste vor Rollout

1. Passt der Avatar wirklich zur Zielgruppe aus Stufe 3, oder wurde er nur „hübsch" statt „passend" gestaltet?
2. Widerspricht der Avatar an irgendeiner Stelle der Positionierung aus Stufe 4 (z. B. zu glatt, zu jung, zu perfekt für eine Marke, die Ehrlichkeit verspricht)?
3. Ist der Charakter-Prompt-Block so präzise, dass er in mehreren Bildern zum gleichen Gesicht führt?
4. Sind Hook und CTA gegen die bestehenden plattformübergreifenden Kriterien geprüft (`reference/hook-formel-universal.md`, `reference/content-regeln-instagram.md`)?
5. Ist geklärt, welches Produkt hinter welchem CTA-Keyword steht, und stimmt das mit den aktuellen Produktregeln des Accounts überein?
6. Wurde die Bildgenerierung an einer kleinen Stichprobe (wenige Bilder) getestet, bevor ein ganzer Contentplan darauf aufgebaut wird?

---

*Erstellt: 24.07.2026. Erster Anwendungsfall @business.und.spirit, siehe `outputs/business-und-spirit/avatar-factory-analyse.md`.*
