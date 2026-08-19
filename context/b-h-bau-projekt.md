# B+H Bau GmbH — KI-Prozessberatung, Projektkontext

Stand: 02.08.2026. Diese Datei bündelt alles Wichtige zum ersten Pilotkunden der neuen KI-Prozessberatung. Für die Methodik dahinter siehe `reference/ki-prozessberatung-kmu-methode.md`.

## Firma

B+H Bau GmbH, Simonspike 7, 57489 Drolshagen. Amtsgericht Siegen HRB 13365. Tel. 02761 7298522, info@b-h-bau.de, Website b-h-bau.de.

Ingenieurbau-Unternehmen für Brücken- und Tunnelbau sowie Bahn-/Verkehrswegebau, gegründet 2011, seit Februar 2023 in Drolshagen (vorher 10 Jahre Ettlingen). **Kein normaler Wohnungsbaubetrieb** — bei allen Beispielen und Unterlagen auf Ingenieurbau-Kontext achten (Nachtragsmanagement wegen Baugrund, Abstimmung mit der Bahn zu Sperrpausen, öffentliche Ausschreibungen, Statik/Prüfingenieure), nicht auf Häuslebauer-Szenarien.

**Kerngeschäftsfelder:** konstruktiver Ingenieurbau (Stahlbetonbrücken, massive Stützbauwerke, Bauen unter Eisenbahnbetrieb), Spezialtiefbau (Gründungen, Pfähle, Verankerungen), allgemeiner Erd-/Tiefbau. DB-präqualifiziert in allen drei Bereichen.

**Auftraggeber:** überwiegend öffentliche Hand, Landesbetriebe Straßenbau, Bauämter/Kreise, Deutsche Bahn AG. Einsatzgebiet West-/Südwest-/Süddeutschland (NRW, Hessen, Rheinland-Pfalz, Saarland, Baden-Württemberg, Bayern).

**Personal laut Stellenanzeigen:** Baumaschinenführer/Baggerfahrer, SIVV/Betoninstandsetzer, Poliere/Werkpoliere — offene Stellen vorhanden, Fachkräftemangel vermutlich real.

Vollständiges Firmenschema mit internen Bereichen und externen Partnern: `outputs/ki-prozessberatung-kmu/firmenuebersicht-b-h-bau.docx`.

**Hinweis, nicht kritisch:** Laut Impressum ist Lilli Kettenbach (seit 2018) die einzige eingetragene Geschäftsführerin, nicht Matthias. Vermutlich Ehefrau eines der Söhne. Matthias' genauer aktueller Titel ist offen, spielt für die Zusammenarbeit aber keine große Rolle.

## Kontaktperson und Auslöser

Matthias ist ein Freund von Andi, über den die ganze KI-Prozessberatung als neues Standbein entstanden ist (siehe auch `reference/ki-prozessberatung-kmu-methode.md`). Matthias ist offen für KI, will das Unternehmen voranbringen, entscheidet am Ende. Sein Sohn ist Mitgesellschafter und in der Übergabe.

Matthias hat Andis Fragen zum Unternehmen bereits per Mail direkt beantwortet (nicht über das digitale Interview-Formular, siehe Abschnitt „Digitale Erhebungsformulare" unten — den Link dazu hat er zwar bekommen, aber bewusst nicht genutzt, wollte das eigentliche Gespräch erst am Montag abwarten).

## Erster Termin: BESTÄTIGT — Donnerstag, 20.08.2026, 11:00 Uhr

Ursprünglich für Montag, 03.08.2026, geplant, dann verschoben, jetzt final bestätigt (Stand 14.08.2026).

**Grund für die Verschiebung:** Am ursprünglichen Termintag wurden bei B+H Bau drei neue Mitarbeiter eingestellt und im Besprechungsraum eingeführt (zwei Poliere, ein Auszubildender) — der Raum war dadurch belegt, das Gespräch fiel deshalb teilweise aus.

Teilnehmer: Matthias, sein IT-Verantwortlicher, die Geschäftsführung (Sohn, Mitgesellschafter). Andi nimmt den Laptop mit — Übersichtsseite mit allen Links (Demos + Unterlagen + Live-Formulare) zum Anklicken: `outputs/ki-prozessberatung-kmu/termin-uebersicht.html`.

**Erkenntnis aus einem Telefonat mit Matthias (02.08.2026):** Andi sollte an seiner Stelle erst mal zuhören und grundlegend erfassen, wie die Firma strukturiert ist (Abteilungen usw.), bevor irgendwas vorgeschlagen wird. Bestätigt genau die ARBEITSWEISE aus `reference/ki-prozessberatung-kmu-methode.md` ("Zuerst gezielte Fragen stellen und Informationen sammeln, bevor irgendetwas bewertet wird") — keine Planänderung nötig, eher eine Bestätigung, den ersten Termin bewusst als reine Bestandsaufnahme zu führen statt schon Lösungen zu pitchen.

**Neue Firmenfakten aus demselben Telefonat (02.08.2026):**
- Rund 40 Mitarbeiter im Feststamm (fest angestellt, inklusive Verwaltung).
- Die eigentliche Ausführung auf der Baustelle läuft überwiegend über externe Nachunternehmer/Subunternehmer — so fängt die Firma den Fachkräftemangel auf, statt nur über eigenes Personal zu wachsen.
- Es gibt einen zweiten Sohn (bisher nicht erwähnt, zusätzlich zum Sohn/Mitgesellschafter aus dem Erstgespräch), der sich akribisch um Personalgewinnung kümmert, unter anderem über Social Media — scheint zu wirken, siehe die drei Neueinstellungen am selben Tag.
- **Bestätigt: B+H Bau arbeitet auf Basis von Microsoft 365.** Beantwortet direkt die erste IT-Frage aus dem Leitfaden ("Welches E-Mail-System wird genutzt?"). Zusammen mit der schon bekannten Nutzung einer bezahlten ChatGPT-Version heißt das: die Firma hat sowohl die M365-Basis für Copilot als auch schon eine eigene ChatGPT-Lizenz — beide Chat-Tools wären technisch leicht verfügbar, keins davon automatisiert aber von sich aus etwas (siehe „Automatisierungsgrad" in `vorschlag-email-phase-varianten.docx`). Relevant für Variante A, sobald der neue Termin ansteht.

## Offene Frage: Automatisierungswerkzeug für Variante B — Make.com oder n8n?

Andi warf am 02.08.2026 die Frage auf, ob statt Make.com eher n8n eingesetzt werden sollte, weil n8n ein deutscher Anbieter ist. Recherche-Ergebnis (per WebSearch, 02.08.2026):

- **n8n:** echtes deutsches Unternehmen (n8n GmbH, Berlin, seit 2019). Cloud-Daten liegen auf Azure in Frankfurt (Deutschland/EU), self-hosted sogar auf einem deutschen Server möglich (volle Kontrolle).
- **Make.com:** gehört zu Celonis SE, Hauptsitz **München** (also selbst ein deutsches Unternehmen, mit zusätzlich großem US-Geschäft). Serverstandort für EU-Kunden ist aber **Dublin, Irland** (EU, nicht Deutschland), über AWS.
- Andis ursprüngliche Annahme ("Make ist ausländisch") war also nicht ganz korrekt — der Unterschied liegt beim tatsächlichen Server-/Datenstandort (Frankfurt vs. Dublin), nicht bei der Unternehmensherkunft.

**Abwägung:** n8n self-hosted bringt echten Wartungsaufwand mit (Server, Updates) — würde der „Übergabe statt Abhängigkeit"-Idee eher entgegenstehen. **n8n Cloud** (von n8n GmbH selbst gehostet, Frankfurt) wäre der Mittelweg: genauso einfach zu bedienen wie Make, aber mit deutschem Anbieter und deutschem Serverstandort. Andi kennt sich mit beiden Tools nicht tief aus, arbeitet in beiden Fällen nach Anleitung — die Lernkurve zwischen Make und n8n Cloud dürfte für ihn ähnlich sein, solange es bei der Cloud-Version bleibt (nicht self-hosted).

**Entscheidung vertagt:** Nicht vorab festgelegt. Neue Frage im Leitfaden ergänzt (`gespraechsleitfaden-termin-matthias.docx`, IT-Fragen-Abschnitt): ob der Firma ein deutscher Datenstandort wichtig ist (z. B. wegen DB-Aufträgen/öffentlicher Vergabe). Antwort entscheidet, ob n8n Cloud als Alternative zu Make.com vorgeschlagen wird.

**Falls B+H Bau/der ITler das offenlässt und Andis Empfehlung will:** klare Empfehlung n8n Cloud (nicht Patt zwischen beiden Optionen) — Begründung: n8n ist stark für KI-gestützte Automatisierungen mit eingebauten KI-Bausteinen genau für diesen Anwendungsfall, bietet die spätere Umzugsoption auf eigenen Server (passt zu „Übergabe statt Abhängigkeit"), und der deutsche Serverstandort ist ein kostenloser Zusatznutzen für später (öffentliche Vergabe, DB-Aufträge). Make.com bleibt die Alternative, falls doch Präferenz für das Bekanntere besteht.

**Zusatzargument für n8n (Recherche 02.08.2026):** n8n-Workflows lassen sich später problemlos von n8n Cloud auf einen selbst gehosteten Server umziehen (Workflows als JSON exportierbar, alle Bausteine/Verbindungen bleiben erhalten; nur Zugangsdaten müssen der ITler nach dem Umzug manuell neu eintragen, ca. eine Stunde Aufwand). Make.com bietet diese Selbst-Hosting-Option gar nicht — reines SaaS ohne Ausstiegsweg. Guter Pitch: klein mit n8n Cloud starten (kein Wartungsaufwand), später bei Bedarf auf eigenen Server umziehen möglich, das kann der ITler selbst übernehmen, wäre eine der wenigen Aufgaben, die tatsächlich in dessen eigene Verantwortung fallen (siehe „Übergabe statt Abhängigkeit").

**Konkreter Beleg für den Wartungsaufwand bei self-hosted (19.08.2026):** n8n verschickt alle zwei Wochen ein Sicherheits-Bulletin an Self-Hoster. Die Ausgabe vom 19.08. listete allein sieben Lücken mit Schweregrad „High", darunter zwei Möglichkeiten für Remote Code Execution (u. a. über die Ausdrucks-Engine, die auch der Code-Baustein nutzt) und mehrere Wege, wie gespeicherte Zugangsdaten über bestimmte Bausteine abfließen können. Bei n8n Cloud übernimmt n8n das Patchen automatisch, bei self-hosted müsste der ITler diese Bulletins aktiv verfolgen und selbst updaten, sonst bleiben bekannte Lücken offen. Gutes, konkretes Argument für n8n Cloud im Gespräch, falls die Selbst-Hosting-Option zur Sprache kommt.

**Dritter Baustein, falls Altsoftware ohne API im Spiel ist: Microsoft Power Automate (ergänzt 03.08.2026, von Andi mit Google-Recherche vorbereitet, von Claude geprüft/korrigiert).** Weder Make noch n8n können ein lokal installiertes Programm ohne moderne Schnittstelle steuern — Power Automate kann das per RPA (Desktop-Automatisierung, simuliert Mausklicks/Tastatureingaben wie ein Mensch). Relevant, falls sich bei der IT-Bestandsaufnahme zeigt, dass eine der eingesetzten Programme (z. B. Kalkulationssoftware) keine API hat. Denkbares Kombi-Modell: n8n übernimmt die KI-lastige Arbeit von unterwegs/Baustelle (z. B. Foto eines Lieferscheins per WhatsApp/Telegram → KI liest Daten aus), Power Automate übernimmt die "letzte Meile" ins alte Bürosystem, das keine API hat. Zwei Korrekturen zur ursprünglichen Recherche: (1) self-hosted n8n kostet nicht buchstäblich 0€, sondern nur die geringen Serverkosten (ca. 5-20€/Monat) statt Makes Pro-Schritt-Abrechnung; (2) Power Automate ist nur mit den einfachen Cloud-Flows kostenlos in M365 enthalten, die für diesen Fall relevante Desktop-RPA-Funktion braucht ein Premium-Upgrade (ca. 13€/Nutzer/Monat, Stand Recherche 03.08.2026). Noch nicht in den Leitfaden übernommen, da abhängig davon, ob die IT-Bestandsaufnahme überhaupt API-lose Altsoftware zutage fördert — erst dann relevant machen, nicht vorher pitchen.

**Neue Erkenntnis (31.07.2026):** Laut Andi nutzt B+H Bau bereits eine bezahlte ChatGPT-Version (vermutlich Business oder Team), nicht (nur) Microsoft Copilot. Wichtig für Variante A im Vergleich: ein Chat-Tool wie ChatGPT oder Copilot kann Texte erstellen, aber nichts bauen — es liest das Postfach nicht selbstständig aus und legt keine Entwürfe automatisch ab, der Mitarbeiter muss es bei jeder Mail aktiv anstoßen. Genau das ist der Kernunterschied zur maßgeschneiderten Lösung (Variante B). Ergänzt in `outputs/ki-prozessberatung-kmu/vorschlag-email-phase-varianten.docx` (neue Tabellenzeile „Automatisierungsgrad", neuer Absatz, neuer Checklistenpunkt).

**Erwartete Skepsis, unterschiedlich begründet:** ITler eher wegen Kontrollverlust, Geschäftsführung eher wirtschaftlich orientiert (Kosten/Nutzen). Matthias selbst ist schon überzeugt — die eigentliche Aufgabe im Termin ist nicht, alle drei zu überzeugen, sondern dass ITler und Geschäftsführung das erste kleine Projekt nicht madig reden.

Matthias kommuniziert kurz und auf den Punkt, keine langen Herleitungen.

**Hintergrund dazu, aus demselben Telefonat (02.08.2026):** Matthias hat nach eigener Aussage mehrere Firmen saniert, die schlecht dastanden (genannte Namen laut Andi: Singbau, Gothabau, Falkenhahn — Transkription unsicher), jeweils mit mehreren Millionen Zuwachs. Deshalb kennt er sich mit Organisationsstrukturen aus und schätzt selbst das Prinzip "erst hinsetzen, zuhören, alte Strukturen genau kennenlernen, bevor man etwas Neues aufsetzt" — das ist also nicht nur Andis Methodik, sondern deckt sich mit Matthias' eigener Erfahrung als Sanierer.

**Wichtige Kommunikations-Einschränkung, unbedingt beachten:** Matthias' Kürze ist nicht nur Stilfrage, sondern laut Andi eher eine echte Grenze — er will und kann tiefere technische Erklärungen kaum aufnehmen, zum Beispiel Begründungen wie "KI funktioniert nur gut, wenn das System dahinter schon stabil ist". Solche technischen Herleitungen sollten NICHT bei Matthias selbst ausgebreitet werden, sondern beim IT-Verantwortlichen platziert werden, wenn es um die technische Bestandsaufnahme geht (Agenda-Punkt 3). Bei Matthias reichen kurze, konkrete Aussagen ohne Warum-Herleitung.

**Rechtlicher Rahmen:** EU AI Act Artikel 50 (ab 2.8.2026) verlangt keine Kennzeichnung bei KI-Unterstützung mit menschlicher Prüfung vor Versand (Assistenzfunktion-Ausnahme). Passt zum „Mensch prüft und gibt frei"-Prinzip, gutes Argument gegen die Kontrollverlust-Sorge des ITlers.

**Neues Argument, Bitkom-Zahlen (10.08.2026):** Fünfter Punkt unter „Die wichtigsten Argumente" in `gespraechsleitfaden-termin-matthias.docx` ergänzt: Laut Bitkom-KI-Studie 2026 setzen 41% der deutschen Unternehmen KI aktiv ein (verdoppelt von 17% im Vorjahr), im Mittelstand aber deutlich weniger als bei Konzernen (dort über 60%) — B+H Bau ist also nicht allein mit dem Zögern. Gegenläufig dazu: 33% sagen KI wurde teurer als erwartet, fast jedes fünfte Unternehmen hat deswegen Stellen abgebaut — stützt das eigene Festpreis-Pilotmodell als kontrollierten Gegenentwurf zum unkontrollierten Loslegen. Nicht für Matthias selbst zum Vorlesen gedacht (siehe Kommunikations-Hinweis oben), eher Munition für Gespräch mit der wirtschaftlich denkenden Geschäftsführung oder bei Rückfragen.

**Neues Argument „Übergabe statt Abhängigkeit" (01.08.2026):** Ziel ist nicht dauerhafte Abhängigkeit von Andi, sondern dass B+H Bau die Lösung nach der Einführung selbst weiterführen kann, Andi bleibt bei Bedarf ansprechbar. Entkräftet gleichzeitig die Kontrollverlust-Sorge des ITlers und die Kosten-Sorge der Geschäftsführung. Wichtig dabei: nicht mit Claude Code werben (Entwickler-Werkzeug, nur für Andi selbst), sondern mit der Automatisierungsoberfläche, die der Kunde später tatsächlich bedienen würde (bei Variante B voraussichtlich Make.com, visuell im Browser, ohne Programmierkenntnisse). Als fester Punkt in `outputs/ki-prozessberatung-kmu/gespraechsleitfaden-termin-matthias.docx` unter „Die wichtigsten Argumente" ergänzt, und als Grundhaltung für alle künftigen Kunden in `reference/ki-prozessberatung-kmu-methode.md` (neuer Abschnitt „Grundhaltung: Übergabe statt Abhängigkeit").

## Vorbereitungsmaterial (alles in `outputs/ki-prozessberatung-kmu/`)

Zum Ausdrucken für Montag:
- `gespraechsleitfaden-termin-matthias.docx` — roter Faden, Agenda, Argumente, IT-Fragen (inkl. CRM-Frage), Spickzettel
- `vorschlag-email-phase-varianten.docx` — vorhandenes Chat-Tool (Copilot/ChatGPT Business) vs. maßgeschneiderte Lösung im Vergleich, mit Ankreuzfeldern (31.07.2026 ergänzt: Zeile „Automatisierungsgrad", Hinweis dass B+H Bau schon ChatGPT Business nutzt aber nur zum Schreiben nicht automatisiert)
- `schema-vorselektion-prioritaet-zuordnung.docx` — wie Kategorie/Priorität/Zuordnung technisch funktioniert
- `status-ohne-crm.docx` — was automatisch läuft, was manuell nachgetragen werden muss
- `firmenuebersicht-b-h-bau.docx` — Firmenstruktur, interne Bereiche, externe Partner

**Zwei weitere private Vorbereitungsdokumente (30.07.2026, vermutlich in der allgemeineren Session „KI-Automatisierung für KMU" entstanden statt in dieser dedizierten B+H-Bau-Session, nicht zum Zeigen, nur für Andi selbst):**
- `checkliste-optimalfall-organisation.docx/pdf` — „Der Optimalfall": persönliche Checkliste, um beim Zuhören am Montag einzuschätzen, wie strukturiert B+H Bau organisatorisch schon ist (einheitliche Bauwerksbezeichnungen, zentrale Ablage, Kategorienliste, Freigabeprozess Rechnungen, Kalkulationsvorlagen usw.) und wie realistisch der Zeitplan ist.
- `ablaufplan-bautagebuch-workflow.docx` — persönliche Gedankenstütze, wie der Workflow für Phase 3 (Bautagebuch per Spracherkennung) technisch aussehen würde: WhatsApp-Business-Schnittstelle → Make.com steuert den Ablauf (wie beim eigenen Telegram-Bot) → Transkription → Claude strukturiert nach festen Feldern (Datum, Bauwerk, Wetter, Anwesende, Tätigkeiten, Materialverbrauch, Besonderheiten, Vorfälle) → automatische Ablage + Mail an Polier und Büro → Mensch-prüft-Bestätigung in der Gruppe. Einzig wirklich neuer Baustein gegenüber Andis bestehenden Automatisierungen ist die WhatsApp-Business-Anbindung, der Rest folgt demselben Prinzip wie Social-Media-Automatisierung und Telegram-Bot — bestätigt Make.com als naheliegendes Werkzeug auch für spätere Phasen, nicht nur die E-Mail-Phase.

**Präzisierung "Kundenservice"-Postfach (14.08.2026), aus der Bauwesen-Recherche abgeleitet:** B+H Bau ist kein Endkundengeschäft (Auftraggeber: Bauämter, Landesbetriebe, DB, dazu Nachunternehmer/Lieferanten) — ein klassisches Kundenservice-Postfach wie bei einem Handwerksbetrieb mit Privatkunden gibt es vermutlich nicht. Wahrscheinlicher: allgemeines Büro-/Verwaltungspostfach mit Nachunternehmer-Rückmeldungen, Lieferanten-Kommunikation, Rechnungseingang. Baustelle-Büro-Kommunikation läuft bei dieser Größe eher über WhatsApp/Telefon, passt zu Phase 3, nicht Phase 1. Als Vermutung (nicht Tatsache) in `gespraechsleitfaden-termin-matthias.docx` direkt nach "Wahrscheinlichster Kandidat" ergänzt, klar als Andis eigene Vorab-Einordnung markiert, nicht im Termin selbst vorwegnehmen — echtes Postfach wird gemeinsam geklärt. Frische PDF exportiert, B+H-GmbH-Ordner aktualisiert.

**Remote-first Arbeitsweise geklärt und in der Methodik verankert (18.08.2026):** Andi fragte, ob er dauerhaft vor Ort bei B+H Bau sein müsste — nein, Regelfall ist Heimarbeit. Vor Ort wirklich nötig: nur der Auftakttermin und optional die spätere Team-Einweisung, alles dazwischen (Diagnose, Zugänge einrichten, Workflow bauen, testen, laufender Betrieb) läuft remote. Als allgemeingültiger Grundsatz (nicht B+H-Bau-spezifisch) in `reference/ki-prozessberatung-kmu-methode.md` ergänzt, neuer Abschnitt „Arbeitsweise: Remote-first, vor Ort nur bei Bedarf" direkt nach der Grundhaltung „Übergabe statt Abhängigkeit".

**Verschwundene Dateien wiederhergestellt + neues Dokument (18.08.2026):** `fragen-antworten-termin.docx/pdf` und `kostenuebersicht-b-h-bau.docx/pdf` waren zwischenzeitlich aus dem Ordner verschwunden (weder Git-Historie noch klare Ursache auffindbar — Andi hat nichts gelöscht, hat nur seine M365-Jahreslizenz gekündigt, arbeitet jetzt mit Word-Web-Version; Projektordner liegt aber außerhalb von OneDrive-Sync, damit wahrscheinlich nicht die Ursache). Inhaltlich identisch neu erstellt, inklusive der "Drei Türen"-Box in Datei 6. Zusätzlich neues Dokument `beispielszenarien-ki-unterstuetzung.docx/pdf`: fünf realistische Beispiel-E-Mails für den Ingenieurbau/Bahnbau (Störungsmeldung DB Netz, Planänderung, Lieferverzug, Behörde, Angebotsanfrage), Herkunft ein Text den Andi aus einem vermuteten Webinar hatte — Inhalt gut, aber ursprünglich mit "Montag"-Referenzen (vor der Terminverschiebung) und einer Live-Demo-Anleitung, die eine Systemreife suggerierte, die der aktuelle n8n-Prototyp (nur Klassifizierung nach Betreffzeile, siehe `reference/n8n-email-trigger-setup.md`) noch nicht hat. Deshalb bewusst NICHT als Live-Skript übernommen, sondern als Anschauungsmaterial fürs Gespräch umgebaut, klar mit Hinweisbox "keine live getestete Vorführung" markiert. Alle drei jetzt als Dateien 6, 7, 8 im B+H-GmbH-Ordner und in `termin-uebersicht.html` verlinkt.

**Vereinfachte Zugriffs-Erklärung ergänzt (14.08.2026):** In `fragen-antworten-termin.docx` direkt nach der Zugriffs-Frage eine "Drei Türen, drei Schlüssel"-Analogie eingefügt (Werkstatt=Make.com/n8n-Einladung wie Google-Doc-Gast, Postfach=einmaliger Erlauben-Klick wie bei einer Handy-App, KI-Zugang=Bezahlkarte von B+H Bau selbst) — als einfachere Rückfalloption, falls die technische Erklärung zu abstrakt ankommt.

**Zwei neue Dokumente (14.08.2026):** `fragen-antworten-termin.docx/pdf` (F&A nach ITler/Geschäftsführung/allgemein sortiert, mit vorbereiteten Antworten, nicht wörtlich vorlesen) und `kostenuebersicht-b-h-bau.docx/pdf` (Ablauf + zwei Kostenebenen: Honorar an Andi 2.700-5.000€ einmalig für Diagnose+Phase 1, laufende Tool-Kosten direkt an Anbieter ca. 20-24€/Monat n8n + nutzungsabhängige KI-API-Kosten noch offen mangels bekanntem E-Mail-Volumen). Beide als Dateien 6 und 7 im B+H-GmbH-Ordner, in `termin-uebersicht.html` unter "Unterlagen zum Nachschauen" verlinkt.

**Praktischer Zugriff aufs B+H-Bau-Konto (14.08.2026):** Andi fragte, ob er als Zugang zum empfohlenen B+H-Bau-Konto ein Passwort bräuchte, das er als möglichen Stolperstein sah. Klargestellt: kein Passwort nötig, drei getrennte Verbindungen (nicht alternativ, alle drei zusammen erforderlich): (1) Make.com/n8n-Workspace-Einladung mit eigenem Login und widerrufbarer Rolle, (2) Postfach-Zugriff per einmaligem Microsoft-OAuth-Klick, (3) KI-API-Schlüssel aus ihrem eigenen Anthropic/OpenAI-Konto, den Andi während der Bauphase zwangsläufig sieht, danach vom ITler austauschbar. Alles in `gespraechsleitfaden-termin-matthias.docx` unter "Rechtlich/Datenschutz" ergänzt. Frische PDF exportiert, B+H-GmbH-Ordner aktualisiert.

**AVV-Klarstellung und Konto-Empfehlung (13.08.2026):** Auf Andis Nachfrage präzisiert, was "AVV mit dem KI-Anbieter" konkret heißt: zwei Verträge nötig (Automatisierungsplattform Make.com/n8n UND KI-Modell-Anbieter wie Anthropic/OpenAI), beide bieten Standard-AVVs zum Akzeptieren im Geschäftskonto. Wichtigste Ergänzung: klare Empfehlung, dass die KI/Automatisierung über ein **eigenes Konto von B+H Bau** laufen sollte, nicht über Andis Konto — Begründung: volle Kontrolle für den ITler (entkräftet seine Kernsorge), transparente Kosten für die Geschäftsführung, keine Abhängigkeit von Andis eigenem Konto/Geschäft (passt zu „Übergabe statt Abhängigkeit"). Ausnahme: fürs reine Testen mit Fake-Daten vor dem Echtbetrieb spricht nichts gegen Andis eigenes Konto. Muss der ITler technisch selbst einrichten, deshalb als Vorschlag ins Gespräch bringen, nicht voraussetzen. In `gespraechsleitfaden-termin-matthias.docx` unter "Rechtlich/Datenschutz" ergänzt, inklusive Verweis, dass Andi bei der genauen rechtlichen Ausgestaltung an Datenschutzbeauftragten/Fachanwalt verweist (Prozess-/Technikberatung, keine Rechtsberatung). Frische PDF exportiert, B+H-GmbH-Ordner aktualisiert.

**Neuer Abschnitt "Was wir für den Start brauchen" (12.08.2026):** Am Ende von `gespraechsleitfaden-termin-matthias.docx` ergänzt, für Agenda-Punkt 5 (nächste Schritte). Vier Kategorien: Technischer Zugang (OAuth-Freigabe vom ITler für die Postfächer, Entscheidung Make.com/n8n Cloud), Inhaltliche Festlegungen mit B+H Bau (Kategorienliste, Zuständigkeits-Zuordnung, echte Beispiel-Mails zur Kalibrierung), Rechtlich/Datenschutz (AVV mit KI-Anbieter, Rücksprache Datenschutzbeauftragter), Freigabe (Ansprechpartner, erstes Test-Postfach festlegen). Frische PDF exportiert, B+H-GmbH-Ordner aktualisiert.

**Reframing Variante A/B (12.08.2026), Andis eigene Erkenntnis:** Andi wies selbst darauf hin, dass Copilot funktional dieselbe Kategorie wie ChatGPT ist (Abfrage-, kein Ausführungssystem) — da B+H Bau ChatGPT Business schon nutzt, wäre eine "Variante A" als frische Wahlmöglichkeit irreführend, und für Andi gäbe es dabei auch nichts zu tun/keinen Auftrag. Statt Variante A ganz zu streichen (das würde die Integrität der ehrlichen Beratung schwächen), in `vorschlag-email-phase-varianten.docx` umgedreht: von "zwei gleichwertige Wege" zu "das habt ihr schon (ChatGPT), hier ist die Grenze, deshalb Variante B". Konkret geändert: Untertitel, Hauptüberschrift, neue Einleitung, Variante-A-Überschrift ("Der Status quo — das habt ihr im Grunde schon"), Checkliste- und Entscheidungs-Checkboxen entsprechend umformuliert. Frische PDF exportiert und im B+H-GmbH-Ordner aktualisiert.

**Terminologie-Anpassung 12.08.2026:** Auf Andis Wunsch "Sohn" durchgängig durch "Geschäftsführung" ersetzt, wo es als Teilnehmer-/Rollenbezeichnung verwendet wird (Teilnehmerliste, Skepsis-Beschreibung, Bitkom-Argument, Übergabe-Argument, Abrechnung, Leitfaden-Bullet "Wegen der Skepsis im Team"). Bewusst NICHT geändert: die rein biografischen Sätze, die die Familienbeziehung erklären ("Sein Sohn ist Mitgesellschafter...", "Es gibt einen zweiten Sohn, der sich um Personalgewinnung kümmert...") — dort ist "Sohn" eine sachliche Information, keine Rollenbezeichnung. Frische PDF exportiert und im B+H-GmbH-Ordner aktualisiert.

**Aufräumen 11.08.2026:** Platzhalter-Untertitel "KI-Prozessanalyse bei Matthias' Bauunternehmen" (Leitfaden) und "KI-Prozessanalyse Bauunternehmen Matthias" (Vorschlag E-Mail-Varianten) durch "KI-Prozessanalyse bei B+H Bau GmbH" bzw. "KI-Prozessanalyse B+H Bau GmbH" ersetzt — beide klangen wie unausgefüllte Platzhalter statt konkret die Firma zu nennen. Andere drei Dokumente (Firmenübersicht, Status-ohne-CRM, Schema-Vorselektion, Checkliste Optimalfall) geprüft, dort kein Platzhalter-Muster gefunden. Frische PDFs exportiert, B+H-GmbH-Ordner aktualisiert (Dateien 1 und 3). Außerdem entdeckt: Word lässt sich per PowerShell-COM-Automatisierung fernsteuern (`New-Object -ComObject Word.Application`, `SaveAs` Format 17 = PDF) — Claude kann Docx→PDF jetzt selbst exportieren, Andi muss das nicht mehr manuell in Word machen.

**Erweiterung 10.08.2026, live bestätigt:** `ki-analyse-interview.html` hat jetzt einen zusätzlichen Schritt "Prozesse im Unternehmen" (Vertrieb, Kundenkommunikation, Projektabwicklung, Verwaltung, Fachbereich, nach Schritt 3 der Methodik), direkt nach der Firmenübersicht, vor "Alltag und Belastung" — 8 statt 7 Schritte insgesamt. `ki-analyse-send.php` verarbeitet die 5 neuen Felder mit in E-Mail und PDF. Von Andi selbst per FTP auf ansto-finaffairs.com hochgeladen und mit echtem Testdurchlauf verifiziert (PDF mit allen neuen Feldern korrekt angekommen). Grund für die Erweiterung: das reine Anhang-A-Formular deckte nur die Übersichtsebene ab, nicht die detaillierte Prozess-Landkarte aus Schritt 3 der Methodik — jetzt in einem einzigen durchgehenden Tool vereint, passend zu Andis Wunsch, beim Termin nicht Formular und separate Mitschrift parallel führen zu müssen.

## Digitale Erhebungsformulare (Anhang A/B) — LIVE, nicht nur lokal

Quelldateien liegen in `outputs/ki-prozessberatung-kmu/` (`ki-analyse-interview.html`, `ki-analyse-mitarbeiter.html`, `ki-analyse-send.php`), sind aber zusätzlich schon auf Andis eigener Website gehostet und am 01.08.2026 per WebFetch live bestätigt:

- **Interview für Matthias/Geschäftsführung:** `https://ansto-finaffairs.com/ki-analyse-interview.html` — 6 Abschnitte (Eckdaten, Einstieg/Überblick, Alltag/Belastung, Zahlen/Ziele, Technik-Status, Entscheidung/Budget), 15-20 Minuten.
- **Fragebogen fürs Team:** `https://ansto-finaffairs.com/ki-analyse-mitarbeiter.html` — persönliche Angaben, Arbeitsalltag, Wünsche/Wissen, 10-15 Minuten, Name optional.
- Beide senden bei Absenden automatisch eine E-Mail mit PDF-Zusammenfassung an info@ansto-finaffairs.com (`ki-analyse-send.php`, PHP `mail()`, kein externer Dienst). Laut Andi bereits erfolgreich getestet.
- Andi hat Matthias den Link bereits vor dem Termin geschickt, Matthias hat ihn aber noch nicht genutzt — hat sich stattdessen direkt per Mail bei Andi gemeldet und wollte das eigentliche Gespräch erst am Montag abwarten.
- **Für Montag geplant:** Da die Seiten live und funktionsfähig sind, kann Andi das Interview-Formular während des Gesprächs auf den Beamer werfen und gemeinsam mit Matthias live ausfüllen — braucht anders als die drei offline-fähigen Demos eine Internetverbindung vor Ort. Empfehlung: kurz vor Montag nochmal eine Testeingabe machen, um sicherzugehen dass der Mail-Versand noch funktioniert.
- Der Mitarbeiter-Fragebogen ist ein guter nächster Schritt NACH Montag, sobald ein Startbereich feststeht — Link an 2-3 Personen aus unterschiedlichen Bereichen bei B+H Bau weiterleiten.

**Andis eigene Vorauswahl für Montag:** Ordner `outputs/ki-prozessberatung-kmu/B+H GmbH/` mit 5 nummerierten PDFs (Leitfaden, Firmenübersicht, Vorschlag E-Mail-Varianten, Status-ohne-CRM, Checkliste Optimalfall) — Desktop-Verknüpfungen „B+H Bau - Termin Montag" (Ordner) und „B+H Bau - Demos (Browser)" (termin-uebersicht.html) angelegt, 01.08.2026. Grund: sein Browser lädt Dateien nur herunter statt sie zu öffnen, deshalb Unterlagen bewusst per Windows-Explorer statt über die HTML-Übersichtsseite. ⚠️ Stand 01.08.2026: PDF Nr. 3 im B+H-GmbH-Ordner war noch die alte Version vor der Ergänzung — muss von Andi manuell aus der frisch exportierten `vorschlag-email-phase-varianten.pdf` im Hauptordner ersetzt werden.

Live-Demos zum Zeigen (auf realistische Brückenbau-Szenarien umgestellt, ein durchgehender Fall — Rissbildung Brückenpfeiler BW 7 — zieht sich durch alle drei):
- `demo-email-automation.html`
- `demo-statusliste.html`
- `demo-bautagebuch-spracherkennung.html`

Für später, nicht für Montag: `beispielrechnung-ki-beratung-firma-xy.docx`, `buchhaltung-euer-2026.xlsx`, `reference/rechnung-vorlage-beispiel.docx`.

## Empfohlene Startreihenfolge

1. E-Mail-Kommunikation (sofort machbar, sichtbarer erster Erfolg, geringstes Risiko)
2. Rechnungsprüfung / Rechnungseingang
3. Bautagebuch per Spracherkennung (z. B. WhatsApp-Sprachnachricht in eine feste Gruppe, niedrigste Einstiegshürde)
4. Kalkulation / Angebotserstellung
5. Nachtragsmanagement

## Abrechnung

Festpreis für die klar abgegrenzte erste Phase (nicht Stunden nach Aufwand), das lässt sich gegenüber der wirtschaftlich denkenden Geschäftsführung klarer vergleichen, zum Beispiel gegen die Kosten einer zusätzlichen Verwaltungskraft. Grundprinzip: **jede der 5 Phasen aus der Startreihenfolge bekommt ihr eigenes, separates Angebot**, erst wenn die vorherige läuft und sich bewährt hat — kein Gesamtprojektpreis von Anfang an.

**Baustein 1 — Diagnose-Phase (bepreist, 10.08.2026): 1.200 bis 2.000 € Festpreis** für die komplette erste Phase (Interview, ggf. Mitarbeiter-Fragebogen, vollständiger Abschlussbericht nach Anhang C) — bewusster Pilotpreis mit rund 40 bis 50 % Abschlag gegenüber dem vollen Marktwert (2.500 bis 4.000 € für etablierte Berater), im Gegenzug Recht auf Nutzung als Referenz sobald gelaufen. Zahlungsstruktur: 50 % bei Start, 50 % bei Übergabe des Berichts.

**Baustein 2 — Umsetzungs-Phase 1, E-Mail-Automatisierung (Richtwert, noch nicht final beziffert, ergänzt 10.08.2026): 1.500 bis 3.000 € Festpreis.** Umfasst: Make.com/n8n einrichten, Postfach anbinden, KI-Klassifizierung und Entwurf-Erstellung bauen, testen, Team einweisen, kurze Doku für den ITler. Genaue Zahl erst nach dem Termin festlegen, wenn der tatsächliche Umfang klar ist (Anzahl Postfächer, Anzahl Kategorien). Gleiche Logik wie Baustein 1: Pilotpreis, Referenz-Gegenleistung.

**Weitere Phasen (Rechnungsprüfung, Bautagebuch, Kalkulation, Nachtragsmanagement):** jeweils eigenes Angebot erst, wenn die vorherige Phase läuft, noch nicht beziffert.

Danach bei Bedarf laufende Betreuung, Pauschale oder Aufwand, siehe „Übergabe statt Abhängigkeit" — Betreuung ist optional, kein Zwang, falls B+H Bau lieber selbst übernimmt.

## Nächste Schritte

1. **Offen, wartet auf Matthias (Stand 02.08.2026):** Andi hat Matthias gebeten, in der Zwischenzeit eine Form der Firmenstruktur zu schicken (Organigramm, Zeichnung, oder eine schriftliche Beschreibung, wie die Firma aufgebaut ist). Zweck: Andi will sich das vorab anschauen und schon mal überlegen, wo Schnittstellen liegen und wo KI-Einsatz sinnvoll sein könnte, bevor der eigentliche Termin stattfindet. Sobald das ankommt, in dieser Session einreichen — passt zu Schritt 1 (Unternehmensprofil) und Schritt 3 (Prozess-Mapping) der Methodik.
2. Neuer Termin: Startbereich gemeinsam festlegen (voraussichtlich E-Mail), IT-Bestandsaufnahme läuft in diesem Termin mit (Agenda-Punkt 3 im Leitfaden). Bei Matthias selbst keine tiefen technischen Herleitungen, siehe Kommunikations-Hinweis oben.
3. Falls die Zeit im Termin nicht reicht: separates, kurzes Technik-Gespräch nur mit dem ITler.
4. Danach: Festpreis-Angebot für die konkret abgegrenzte erste Phase erstellen.
5. Beiläufig, nicht als Pitch: nach der Personalsituation fragen (Fachkräftemangel), als möglicher Ansatzpunkt für eine spätere, komplett separate Idee über Andis Dropservice-Netzwerk mit Hakan Ersu — nicht im Termin selbst ansprechen.
