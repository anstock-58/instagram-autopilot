# KI-Prozessberatung für KMU: Wiederverwendbare Analyse-Methode

**Zweck:** Strukturierte Vorgehensweise, um ein Unternehmen (Branche egal) systematisch auf KI- und Automatisierungspotenzial zu prüfen. Ausgangspunkt ist immer der reale Ablauf im Unternehmen, nicht eine allgemeine KI-Idee von außen. Entstanden aus einem Gespräch mit einem befreundeten Unternehmer (Firma im Millionenumsatzbereich, Übergabe an die Söhne läuft, er selbst noch stark im Tagesgeschäft), der als erstes Pilotprojekt infrage kommt. Danach beliebig auf weitere Unternehmen übertragbar.

**Verwendung:** Prompt unten kopieren, Firmenname und bekannte Eckdaten eintragen, in einer Session ausführen. Der Interview-Leitfaden (Anhang A) und der Mitarbeiter-Fragebogen (Anhang B) liefern die Rohdaten, danach entsteht daraus mit dieser Methode Schritt für Schritt das Unternehmensprofil bis zum fertigen Beratungsbericht (Anhang C). Die Checkliste (Anhang D) dient am Ende zur Priorisierung.

**Nischen-Vertiefung Bauwesen:** Bei Kunden aus dem Bauwesen (Bauunternehmen, Ingenieurbüro, Architekturbüro, Bauhandwerk) zusätzlich [ki-potenzialanalyse-bauwesen.md](ki-potenzialanalyse-bauwesen.md) lesen, bevor das Erstgespräch stattfindet — liefert branchenspezifisches Vorwissen (typische Prozesse, Zeitfresser, Software, Einwände), ersetzt nicht das Zuhören im Gespräch selbst. Aktuell ist Teil 1 (Bauunternehmen) fertig, weitere Teile folgen.

---

## ARBEITSWEISE (gilt vor allem anderen)

Zuerst gezielte Fragen stellen und Informationen sammeln, bevor irgendetwas bewertet wird. Keine Annahmen ohne Grundlage treffen, wenn ein Unternehmen etwas nicht beantwortet hat, wird das als offene Frage markiert statt geraten. Jede Erkenntnis dokumentieren. Am Ende steht ein individuelles Konzept für genau dieses Unternehmen, keine generische KI-Ideenliste.

---

## GRUNDHALTUNG: ÜBERGABE STATT ABHÄNGIGKEIT

Bei jedem Kunden von Anfang an aktiv ansprechen, nicht erst am Ende: Ziel ist nicht dauerhafte Abhängigkeit vom Berater, sondern dass das Unternehmen die Lösung nach der Einführung selbst weiterführen kann, der Berater bleibt bei Bedarf ansprechbar. Wer im Unternehmen später betreuen kann, ist bereits Kriterium 7 der Checkliste (Anhang D) — diese Haltung sollte aber schon im Erstgespräch als eigenes Argument fallen, nicht erst am Ende der Analyse auftauchen.

Praktisch bedeutet das:

- Werkzeuge bevorzugen, die eine echte Übergabe möglich machen: visuelle No-Code/Low-Code-Automatisierungswerkzeuge (z. B. Make.com) statt reinem Code, damit auch ohne Programmierkenntnisse im Browser angepasst werden kann.
- Klar trennen zwischen dem eigenen Werkzeug zum Bauen (z. B. Claude Code, nur für den Berater, braucht Entwickler-Grundverständnis) und dem Werkzeug, das der Kunde später selbst bedient (die fertige Automatisierungsoberfläche, niedrigschwellig). Im Kundengespräch nicht mit dem eigenen Bau-Werkzeug werben, sondern mit dem, was der Kunde später tatsächlich in der Hand hat.
- Diese Haltung entkräftet typische Einwände gleichzeitig aus zwei Richtungen: Kontrollverlust-Sorge auf IT-Seite und Sorge vor dauerhaften laufenden Kosten bei wirtschaftlich denkenden Entscheidern.
- In der Praxis bleibt trotzdem meist ein laufender Betreuungsbedarf bestehen, weil der Aufbau die aufwendigste Phase ist und die Selbstständigkeits-Option selten voll ausgeschöpft wird. Die Offenheit dafür senkt aber die Einstiegshürde beim Verkaufen erheblich, ohne das eigene Geschäft in der Praxis zu gefährden.

---

## ARBEITSWEISE: REMOTE-FIRST, VOR ORT NUR BEI BEDARF

Der Regelfall bei jedem Kunden ist Heimarbeit, nicht dauerhafte Präsenz vor Ort — ergibt sich direkt aus der Werkzeugwahl (cloudbasierte No-Code-Automatisierung) und passt zur Grundhaltung „Übergabe statt Abhängigkeit": alles läuft über Zugänge, nicht über physische Anwesenheit. Gut, das schon im Erstgespräch beiläufig klarzustellen, nimmt beiden Seiten eine unausgesprochene Sorge (Kunde: „müssen wir den Berater dauerhaft bei uns haben?", Berater: „muss ich ständig anreisen?").

Vor Ort wirklich nötig sind in der Regel nur zwei Momente:

- Der Auftakttermin (Erstgespräch, Startbereich festlegen, IT-Bestandsaufnahme).
- Optional die Team-Einweisung am Ende einer Phase — baut bei skeptischer Belegschaft persönlich mehr Vertrauen auf, ist aber keine technische Notwendigkeit, funktioniert genauso per Video-Call.

Alles dazwischen läuft remote:

- Diagnose-Phase: Interview-Antworten auswerten, Abschlussbericht schreiben.
- Abstimmungstermine: Video-Call oder Telefon reicht.
- Zugänge einrichten: der Kunde macht das selbst online (siehe Konto-Empfehlung oben), keine gemeinsame Anwesenheit nötig.
- Der eigentliche Aufbau der Automatisierung: komplett vom eigenen Schreibtisch aus.
- Testphase und laufender Betrieb: ebenfalls remote.

---

## ABRECHNUNG: FESTPREIS ODER STUNDENBASIS, JE NACH KUNDENWUNSCH

Zwei gleichwertige Modelle, keine feste Vorgabe — welches passt, hängt davon ab, was dem jeweiligen Kunden wichtiger ist: Planungssicherheit oder Nachvollziehbarkeit. Am Beispiel B+H Bau (siehe `context/b-h-bau-projekt.md`): ursprünglich Festpreis vorgeschlagen, nach dem Erstgespräch auf ausdrücklichen Kundenwunsch auf Stundenbasis umgestellt.

**Festpreis** — pro klar abgegrenzter Phase, kein Gesamtprojektpreis von Anfang an. Vorteil: lässt sich für eine wirtschaftlich denkende Geschäftsführung leicht mit Alternativen vergleichen (z. B. Kosten einer zusätzlichen Verwaltungskraft), kein Kostenrisiko für den Kunden bei unerwartetem Mehraufwand.

**Stundenbasis** — Stundensatz statt Paketpreis, sinnvoll wenn der Kunde ausdrücklich Transparenz einfordert. Empfohlener Richtwert: **100 €/h als Pilotsatz** (rund 40–50 % Abschlag gegenüber dem für spezialisierte KI-Automatisierungsberatung üblichen Marktsatz von 150–180 €/h, gleiche Logik wie beim Festpreis-Pilotrabatt). Damit reines Stundenzählen nicht wie ein Blankoscheck wirkt: pro Phase trotzdem einen geschätzten Kostenrahmen (Stundenspanne × Satz) vorab nennen, echte Abrechnung dann nach Aufwand mit kurzer, nachvollziehbarer Stundenaufstellung je Rechnung — verbindet Transparenz mit Kostenkontrolle.

Faustregel zur Umrechnung zwischen den Modellen: Festpreis-Richtwert ÷ 100 €/h ergibt eine plausible Stundenschätzung für die gleiche Phase.

---

## DER PROMPT

> Führe eine vollständige KI-Prozessanalyse durch für folgendes Unternehmen: **[FIRMENNAME]**, Branche **[BRANCHE]**, ungefähre Größe **[MITARBEITERANZAHL / UMSATZ]**.
>
> Arbeite die folgenden acht Schritte der Reihe nach ab. Wo Informationen fehlen, stelle konkrete Rückfragen statt zu raten.

### 1. Unternehmensprofil

Erfasse vollständig: Branche, Unternehmensgröße, Mitarbeiteranzahl, Standorte, Geschäftsmodell, Zielkunden, Produkte oder Dienstleistungen, Umsatzmodell, organisatorischer Aufbau, Abteilungen und Verantwortlichkeiten. Aus diesen Angaben ein zusammenhängendes Unternehmensprofil formulieren.

### 2. Branchenanalyse

Für die konkrete Branche des Unternehmens herausarbeiten: typische Geschäftsprozesse, häufige Herausforderungen, typische Zeitfresser, wiederkehrende Aufgaben, übliche Softwarelösungen, mögliche KI-Anwendungsbereiche, branchenspezifische Risiken. Bei mehreren Geschäftsfeldern im selben Unternehmen für jedes Feld eine eigene Kurzanalyse.

### 3. Unternehmensprozess-Mapping

Alle wichtigen Prozesse strukturiert aufnehmen, entlang dieser fünf Bereiche:

**Vertrieb.** Wie kommen Kundenanfragen ins Unternehmen? Wie werden Angebote erstellt? Wie werden Kundendaten verwaltet? Welche Aufgaben laufen manuell?

**Kundenkommunikation.** Welche Kanäle gibt es? Wie werden Anfragen bearbeitet? Gibt es Standardantworten? Wie wird dokumentiert?

**Projektabwicklung.** Wie startet ein Projekt? Welche Schritte folgen? Wer ist beteiligt? Welche Dokumente entstehen? Wo liegen die Schnittstellen zwischen Personen oder Abteilungen?

**Verwaltung.** Rechnungsstellung, Buchhaltung, Dokumentenmanagement, Terminplanung, interne Kommunikation.

**Fachbereich.** Die eigentliche Kernleistung des Unternehmens, also das, womit tatsächlich Geld verdient wird. Hier am genauesten hinschauen, weil hier meist auch das größte Sparpotenzial liegt.

### 4. Zeitfresser-Analyse

Systematisch abfragen: Welche Aufgaben werden täglich wiederholt? Welche dauern länger als sie eigentlich sollten? Welche Prozesse hängen an einer einzelnen Person (Bus-Faktor)? Wo werden dieselben Informationen mehrfach von Hand eingegeben? Wo entstehen regelmäßig Fehler? Welche Aufgaben werden von den Mitarbeitern als lästig empfunden? Was würden sie selbst gerne automatisiert sehen, wenn man sie fragt?

### 5. Software-Analyse

Erfassen: eingesetzte Programme, vorhandene Schnittstellen, Art der Datenablage, Cloud oder lokale Systeme, wo noch mit Excel gearbeitet wird, welche Automatisierungen bereits existieren. Danach bewerten: was kann so bleiben, was lässt sich optimieren, wo fehlen Verbindungen zwischen Systemen, die heute Doppelarbeit verursachen.

### 6. KI-Potenzialanalyse

Für jeden in Schritt 3 und 4 gefundenen Prozess eine eigene Bewertung erstellen, immer nach demselben Muster:

Prozess und Beschreibung. Aktueller Aufwand mit Zeitaufwand und beteiligten Personen. Das konkrete Problem, also was heute schlecht funktioniert. Die KI-Möglichkeit, also welche Lösung realistisch denkbar wäre. Benötigte Tools oder Entwicklungsaufwand. Der Nutzen, aufgeschlüsselt nach Zeitersparnis, Fehlerreduzierung, Kostensenkung und Qualitätsgewinn. Der Umsetzungsaufwand als gering, mittel oder hoch eingestuft.

### 7. Priorisierung

Alle bewerteten Prozesse aus Schritt 6 in eine Matrix einsortieren:

Schnell umsetzbar und hoher Nutzen: sofort starten.
Hoher Nutzen, aber größerer Aufwand: als eigenes Projekt planen.
Geringer Nutzen: nicht priorisieren, im Bericht nur der Vollständigkeit halber erwähnen.

### 8. Abschlussbericht

Am Ende einen zusammenhängenden Beratungsbericht erstellen (Vorlage dafür in Anhang C): Zusammenfassung des Unternehmens, wichtigste Herausforderungen, größte Optimierungsmöglichkeiten, empfohlene KI-Lösungen mit Aufwand und Nutzen gegenübergestellt, konkrete nächste Schritte.

---

## ANHANG A: Interview-Leitfaden für das Erstgespräch mit Geschäftsführern

Ziel des Gesprächs ist, das Unternehmen aus Sicht der Führung zu verstehen, bevor man ins operative Detail geht. Etwa sechzig bis neunzig Minuten einplanen.

**Einstieg und Überblick**

Wie ist das Unternehmen aufgebaut, welche Abteilungen gibt es und wer verantwortet was? Wie hat sich das Geschäft in den letzten Jahren entwickelt? Wo steht das Unternehmen im Vergleich zum Wettbewerb?

**Alltag und Belastung**

Womit verbringen Sie selbst die meiste Zeit im Tagesgeschäft? Welche Aufgaben würden Sie am liebsten abgeben, wenn Sie könnten? Wo im Unternehmen läuft aktuell am meisten manuell oder über Excel-Listen?

**Zahlen und Ziele**

Wie hoch schätzen Sie den Zeitaufwand für wiederkehrende Verwaltungsaufgaben pro Woche? Welche Kosten entstehen durch Fehler, Doppelarbeit oder Verzögerungen, auch wenn nur grob geschätzt? Wo sehen Sie das Unternehmen in drei Jahren, und was müsste sich dafür ändern?

**Technik-Status**

Welche Software wird aktuell im Unternehmen eingesetzt? Gibt es bereits Automatisierungen oder KI-Tools im Einsatz, und wie sind die Erfahrungen damit? Wer im Unternehmen ist offen für neue Technik, wer eher skeptisch?

**Entscheidung und Budget**

Wer entscheidet über neue Investitionen dieser Art? In welcher Größenordnung wäre ein Projekt für Sie überhaupt vorstellbar? Was müsste ein solches Projekt liefern, damit Sie es als Erfolg werten?

**Abschluss**

Gibt es Themen, die wir in diesem Gespräch nicht angesprochen haben, die Ihnen aber wichtig sind? Mit wem im Team sollte ich als Nächstes sprechen, um die Prozesse im Detail zu verstehen?

---

## ANHANG B: Mitarbeiter-Fragebogen zur Prozessaufnahme

**Faustregel, ob Anhang B überhaupt nötig ist:** Unter etwa 10 bis 15 Mitarbeitern kennt der Chef/die Chefin in der Regel die eigenen Abläufe vollständig, dann reicht Anhang A allein. Erst darüber lohnt sich der zusätzliche Mitarbeiter-Fragebogen, um blinde Flecken der Geschäftsführung abzudecken.

Wird an Mitarbeiter aus den Bereichen Vertrieb, Kundenservice, Projektabwicklung, Verwaltung und Fachbereich verteilt. Pro Person etwa fünfzehn bis zwanzig Minuten. Kann schriftlich oder im kurzen Gespräch beantwortet werden.

1. Welche Aufgaben gehören zu Ihrem täglichen Arbeitsablauf?
2. Welche dieser Aufgaben wiederholen sich, ohne dass sich der Inhalt wesentlich ändert?
3. Bei welcher Aufgabe verbringen Sie am meisten Zeit im Verhältnis zu ihrem eigentlichen Nutzen?
4. Wo geben Sie dieselbe Information mehr als einmal in unterschiedliche Systeme oder Dokumente ein?
5. Bei welchem Arbeitsschritt passieren Ihnen oder Kollegen am häufigsten Fehler?
6. Welche Aufgabe würden Sie am liebsten nicht mehr selbst machen müssen?
7. Gibt es Aufgaben, die nur Sie erledigen können, weil sonst niemand weiß, wie es geht?
8. Welche Programme oder Tools nutzen Sie täglich, und wo hakt es dabei am meisten?
9. Wenn Sie sich einen Assistenten wünschen könnten, der Ihnen eine einzige Aufgabe abnimmt: welche wäre das?
10. Was würde für Sie persönlich besser werden, wenn ein Teil Ihrer Arbeit automatisiert wäre?

---

## ANHANG C: Vorlage für den KI-Analysebericht

**Titel:** KI-Prozessanalyse für [Firmenname], erstellt am [Datum]

**1. Zusammenfassung.** In wenigen Sätzen: worum geht es in diesem Unternehmen, was war der Anlass der Analyse, was ist das Kernergebnis.

**2. Unternehmensprofil.** Kurzdarstellung aus Schritt 1 der Methode, maximal eine halbe Seite.

**3. Wichtigste Herausforderungen.** Die drei bis fünf zentralen Probleme, die im Interview und im Fragebogen am häufigsten oder am gewichtigsten genannt wurden.

**4. Prozessübersicht.** Tabelle mit allen untersuchten Prozessen aus Schritt 3, je Prozess eine Zeile: Bereich, Beschreibung, aktueller Zeitaufwand, größtes Problem.

**5. Größte Optimierungsmöglichkeiten.** Die Prozesse aus Schritt 6, die im Ergebnis am meisten Nutzen versprechen, mit kurzer Begründung, warum gerade diese.

**6. Empfohlene KI-Lösungen.** Für jede Empfehlung: was genau vorgeschlagen wird, welches Tool oder welche Entwicklung nötig wäre, erwarteter Nutzen in Zeit, Fehlerreduzierung, Kosten und Qualität, geschätzter Umsetzungsaufwand.

**7. Priorisierungsmatrix.** Die drei Kategorien aus Schritt 7 (sofort starten, als Projekt planen, nicht priorisieren) mit den jeweils zugeordneten Maßnahmen.

**8. Nächste Schritte.** Konkrete, terminierbare Vorschläge, womit als Erstes begonnen werden sollte, inklusive grober Zeit- und Kosteneinschätzung, wo möglich.

---

## ANHANG D: Checkliste zur Bewertung von Automatisierungsmöglichkeiten

Für jeden identifizierten Prozess durchgehen, bevor er priorisiert wird.

1. Wiederholt sich der Prozess regelmäßig, oder ist es ein Einzelfall? Nur regelmäßige Prozesse lohnen die Automatisierung.
2. Folgt der Prozess klaren, nachvollziehbaren Regeln, oder braucht er in jedem Einzelfall menschliches Urteilsvermögen?
3. Ist der aktuelle Zeitaufwand groß genug, dass sich eine Investition in absehbarer Zeit auszahlt?
4. Sind die benötigten Daten bereits digital vorhanden, oder müsste erst eine Digitalisierung vorgeschaltet werden?
5. Existiert eine Schnittstelle zu den beteiligten Systemen, oder müsste diese erst geschaffen werden?
6. Wie hoch ist der Schaden, wenn die Automatisierung einmal einen Fehler macht? Bei hohem Risiko braucht es eine Kontrollinstanz durch einen Menschen.
7. Ist im Unternehmen jemand vorhanden, der die Lösung später betreuen und bei Bedarf anpassen kann?
8. Wie groß ist der Widerstand der betroffenen Mitarbeiter zu erwarten, und wie lässt sich der auffangen?
9. Lässt sich der Erfolg nach der Einführung messbar machen, zum Beispiel über eingesparte Zeit oder reduzierte Fehlerquote?
10. Passt die Lösung zur restlichen Systemlandschaft, oder entsteht eine weitere Insellösung, die später selbst zum Problem wird?

Je mehr dieser Fragen positiv beantwortet werden, desto eher gehört der Prozess in die Kategorie „schnell umsetzbar und hoher Nutzen" aus Schritt 7.

---

## ANHANG E: Muster bei kleinen Handwerksbetrieben im Bau-/Sanierungsbereich

**Nur zur eigenen Orientierung vor dem Erstgespräch, kein Ersatz fürs Zuhören** (siehe ARBEITSWEISE oben) — dient dazu, informiert statt bei null in ein Gespräch zu gehen, nicht dazu, dem Unternehmen etwas zu unterstellen, bevor es selbst gesprochen hat. Relevant für Andis Kontakte aus dem eigenen Sanierungs-/Handwerksumfeld (z. B. Bautenschutz, Malerhandwerk, Dachdecker).

Wiederkehrende Bereiche, die bei solchen Betrieben erfahrungsgemäß häufig vorkommen, unabhängig vom genauen Gewerk:

- Kundenanfragen (Telefon, Mail, zunehmend WhatsApp), oft ohne feste Struktur erfasst
- Angebotserstellung/Kalkulation, häufig mit Textbausteinen oder Excel statt fester Software
- Terminplanung/Personaleinsatz, oft auf Zuruf oder Whiteboard statt digital
- Materialbestellung, oft direkt beim Großhändler ohne System-Anbindung
- Vor-Ort-Dokumentation (Aufmaß, Fotos, Mängel), meist noch auf Papier oder lose Handyfotos
- Rechnungsstellung, oft manuell, seltener eine echte Warenwirtschaft im Hintergrund als bei größeren Firmen

**Unterschied zu größeren Unternehmen wie B+H Bau:** meist weniger Altsoftware/Schnittstellen zu berücksichtigen (eher Excel/WhatsApp/Papier als ein gewachsenes ERP-System), dafür ist der Chef/die Chefin fast immer die einzige relevante Auskunftsperson (siehe Faustregel bei Anhang B oben).

**Praktische Konsequenz für die Erstansprache:** Bei Kontakten, die kein persönliches Naheverhältnis wie bei Matthias haben, kann der Interview-Link (Anhang A, `ansto-finaffairs.com/ki-analyse-interview.html`) direkt als niedrigschwelliger erster Schritt verschickt werden, statt zuerst ein persönliches Treffen zu vereinbaren — wer sich die 15 bis 20 Minuten nimmt, zeigt echtes Interesse, das filtert von selbst vor.

---

## ANHANG F: Datenschutz- und EU-AI-Act-Checkliste (Stand August 2026)

**Wichtiger Hinweis vorab:** Diese Checkliste ist keine Rechtsberatung. Sie dient dazu, im Beratungsgespräch die relevanten Themen anzusprechen und zu dokumentieren, welche Punkte offen sind — die rechtsverbindliche Klärung übernimmt bei Bedarf ein Fachanwalt oder der Datenschutzbeauftragte des Kunden. Diese Trennung sollte im Erstgespräch klar kommuniziert werden, zum Beispiel so: „Ich zeige euch, wo ihr datenschutzrechtlich hinschauen müsst, die endgültige rechtliche Bewertung macht dann eure eigene Fachperson."

**Warum das jetzt relevant ist:** Der EU AI Act ist seit dem 2. August 2026 mit seinen Transparenz- und Kennzeichnungspflichten scharf. Er gilt nicht nur für Anbieter von KI-Systemen, sondern ausdrücklich auch für Betreiber, also jedes Unternehmen, das KI-Tools wie ChatGPT oder Copilot einsetzt. Für ein Beratungsangebot, das genau solche Unternehmen zum KI-Einsatz bewegen will, gehört das Thema von Anfang an mit auf den Tisch, nicht erst wenn ein Kunde selbst danach fragt.

**DSGVO-Punkte, die im Gespräch angesprochen werden sollten**

1. Rechtsgrundlage: Für jede geplante KI-Datenverarbeitung sollte klar sein, auf welcher Rechtsgrundlage nach Art. 6 DSGVO sie beruht, und das sollte dokumentiert werden.
2. Auftragsverarbeitungsvertrag (AVV): Mit jedem KI-Anbieter, den der Kunde einsetzt (OpenAI, Microsoft Copilot, n8n-Cloud etc.), braucht es einen AVV nach Art. 28. Häufigster blinder Fleck bei KMU.
3. Datenschutz-Folgenabschätzung (DSFA): Wird relevant, sobald personenbezogene Daten systematisch ausgewertet werden, zum Beispiel wenn eine KI Kunden-E-Mails klassifiziert oder Bewerbungen/Mitarbeiterdaten bewertet. Dann ist eine DSFA nach Art. 35 nötig.
4. Datenschutzerklärung: Muss den KI-Einsatz erwähnen (Art. 13/14), sobald personenbezogene Daten betroffen sind.
5. Datenschutzbeauftragter: Ab 20 Mitarbeitenden mit regelmäßiger Verarbeitung sensibler Daten ohnehin gesetzlich vorgeschrieben, unabhängig vom KI-Einsatz — bei größeren Kunden vorab prüfen, ob das schon vorhanden ist.

**EU-AI-Act-Punkte, die im Gespräch angesprochen werden sollten**

6. Kennzeichnungspflicht (Art. 50): KI-generierte Inhalte müssen gekennzeichnet werden, Nutzer müssen wissen, wenn sie mit einem Chatbot oder einer KI-generierten Antwort interagieren.
7. KI-Kompetenz der Mitarbeitenden: Wer mit KI-Tools arbeitet, muss entsprechend geschult sein, das Unternehmen muss das sicherstellen können.
8. Einstufung des Anwendungsfalls: Grob einordnen, ob die geplante Lösung eher eine unkritische Routineautomatisierung ist oder als Hochrisiko-Anwendung gilt (zum Beispiel Bewerberauswahl, Bonitätsprüfung, sicherheitsrelevante Entscheidungen) — bei Hochrisikofällen ist externe Fachberatung zwingend, nicht nur empfohlen.

**Wann eine externe Fachperson zwingend eingebunden werden muss, nicht nur empfohlen**

- Sobald personenbezogene Daten in großem Umfang oder systematisch verarbeitet werden (DSFA-Fall).
- Sobald der Anwendungsfall in Richtung Hochrisiko-KI geht (Personal, Bonität, sicherheitsrelevante Bereiche).
- Sobald der Kunde selbst unsicher ist, ob eine bestehende Datenschutzerklärung oder ein AVV ausreicht.

In allen anderen Fällen reicht es, die offenen Punkte im Abschlussbericht (Anhang C) zu vermerken, mit der klaren Empfehlung, sie vor dem produktiven Einsatz zu klären.

---

## ANHANG G: Tool-Referenz nach Anwendungsfall

**Grundprinzip zuerst:** Claude Code taucht in dieser Liste bewusst nicht als Kundenempfehlung auf. Es ist und bleibt Andis eigenes Bauwerkzeug (siehe GRUNDHALTUNG oben) — damit werden Automatisierungen vorbereitet, getestet und die Übergabe-Dokumentation erstellt. Was der Kunde am Ende selbst in die Hand bekommt, ist immer eines der Tools aus dieser Liste, nie Claude Code direkt.

**Begriffe einfach erklärt (zum Nachschlagen)**

*AVV — Auftragsverarbeitungsvertrag.* Wie bei einer externen Reinigungsfirma fürs Büro: die Putzkräfte haben Zugang zu den Räumen, deshalb unterschreibt man vorher einen Vertrag, der Regeln festlegt. Ein AVV ist dasselbe, nur mit Daten statt Räumen. Nutzt ein Betrieb zum Beispiel ChatGPT oder Copilot mit Kunden- oder Mitarbeiterdaten, "betritt" der Anbieter diese Daten. Der AVV legt vertraglich fest, dass der Anbieter die Daten nur im Auftrag des Betriebs verarbeiten und nicht weitergeben darf. Ohne AVV ist die Nutzung mit echten Kundendaten eigentlich nicht erlaubt.

*DSFA — Datenschutz-Folgenabschätzung.* Eine Risikoprüfung vor dem Start, wie eine Gefährdungsbeurteilung vor dem Einsatz einer neuen Maschine auf der Baustelle. Bevor eine KI zum Beispiel systematisch Bewerbungen bewertet oder Kunden-E-Mails automatisch einsortiert, wird vorher geprüft, was für die betroffenen Personen schiefgehen könnte und wie man das absichert. Nur bei größeren, systematischen Fällen nötig, nicht bei jedem kleinen Automatisierungsschritt.

*No-Code / Automatisierung (Make.com, n8n).* Wie ein Flussdiagramm, das man am Bildschirm zusammenklickt statt auf Papier zu malen: "Wenn eine E-Mail mit 'Angebot' reinkommt" → "dann Inhalt auslesen" → "dann in Tabelle eintragen" → "dann Bestätigung zurückschicken". Alles per Maus aus Kästchen zusammengebaut, ganz ohne Programmcode. "No-Code" heißt wörtlich "ohne Code". Der Vorteil für den Kunden: er kann nach der Einführung selbst kleine Änderungen vornehmen, ohne Andi jedes Mal anrufen zu müssen — bei echtem Code (wie Claude Code) bräuchte es dafür Programmierkenntnisse.

*Meetings transkribieren.* "Transkribieren" heißt: gesprochene Sprache wird automatisch in geschriebenen Text umgewandelt. Ein Tool hört beim Meeting mit, schreibt automatisch mit und fasst hinterher zusammen, was entschieden wurde und wer was bis wann erledigen muss. Niemand muss mehr selbst mitschreiben.

*Datenschutzkonforme interne Wissens-KI.* Für Betriebe mit vielen internen Dokumenten (Verträge, Kalkulationen, Kundendaten), bei denen Mitarbeitende einfach fragen können sollen "wie war das nochmal bei Kunde X geregelt?". Der Unterschied zu normalem ChatGPT: alles bleibt innerhalb einer abgesicherten, meist firmeneigenen Umgebung, die Daten verlassen diesen geschützten Raum nie. Wie eine Suchmaschine nur für die eigenen Firmendokumente, mit einem Schloss drum herum.

*Spezialisierte SaaS-Tools.* "SaaS" steht für "Software as a Service": man zahlt eine monatliche Gebühr für ein Tool, das komplett im Browser läuft, nichts wird lokal installiert. "Spezialisiert" heißt: das Tool kann genau eine Sache richtig gut, statt vieles gleichzeitig, zum Beispiel ein Tool, das nur Telefonanrufe entgegennimmt und zusammenfasst. Das Gegenteil wäre ein Alleskönner wie ChatGPT.

*KI-Modell / LLM.* Das "Gehirn" hinter Tools wie ChatGPT oder Claude. Wurde mit riesigen Mengen an Text trainiert und kann deshalb Sprache verstehen und selbst Texte erzeugen. LLM steht für "Large Language Model". Wie ein extrem belesener Kollege, der Millionen Texte gelesen hat, aber nichts davon im menschlichen Sinn "weiß" — er berechnet nur, welches Wort als Nächstes am wahrscheinlichsten passt.

*Prompt.* Die Anweisung oder Frage, die man der KI gibt. Je genauer der Prompt, desto besser das Ergebnis. Wie eine Bestellung beim Bäcker: "ein Brot" ist ungenau, "ein dunkles Roggenbrot, mittelgroß" liefert genau das.

*Halluzination.* Die KI erfindet manchmal selbstbewusst falsche Fakten, ohne dass man es ihr ansieht. Wichtig für Kundengespräche: KI-Ergebnisse müssen immer von einem Menschen geprüft werden, blind vertrauen ist keine Option. Wie ein Kollege, der lieber eine plausible Antwort erfindet, als "weiß ich nicht" zu sagen.

*Automatisierung vs. KI.* Der wichtigste Unterschied, den viele Kunden durcheinanderwerfen. Automatisierung folgt starren Regeln: "wenn X passiert, dann immer Y". KI trifft eigenständige Einschätzungen, auch bei Fällen, die vorher nicht exakt festgelegt wurden. Eine Automatisierung leitet jede E-Mail mit dem Wort "Rechnung" in den Buchhaltungsordner. Eine KI liest die E-Mail, versteht den Inhalt und entscheidet auch bei uneindeutigen Fällen selbst.

*API / Schnittstelle.* Die Verbindung, über die zwei Programme automatisch miteinander reden, ohne dass ein Mensch Daten von Hand kopiert. Wie eine Steckdose mit genormtem Stecker: jedes Gerät mit dem passenden Stecker kann sich anschließen und Daten austauschen.

*Personenbezogene Daten.* Alles, was sich auf eine konkrete, identifizierbare Person zurückführen lässt: Name, E-Mail-Adresse, Kundennummer, Telefonnummer, sogar ein Foto. Der Auslöser für fast alle Datenschutzpflichten aus Anhang F (AVV, DSFA, Datenschutzerklärung).

*Hochrisiko-KI-System.* Ein Anwendungsfall, bei dem der EU AI Act besonders strenge Regeln vorschreibt, weil eine falsche KI-Entscheidung große Auswirkungen auf eine Person hätte, zum Beispiel automatisierte Bewerberauswahl, Bonitätsprüfung oder sicherheitsrelevante Entscheidungen. Bei sowas: sofort externe Fachperson dazuholen, nicht selbst einschätzen (siehe Anhang F).

*KI-Kompetenz-Pflicht.* Die Vorgabe aus dem EU AI Act (Art. 4): Unternehmen müssen sicherstellen, dass Mitarbeitende, die mit KI-Tools arbeiten, dafür ausreichend geschult sind. Reine Nutzung ohne jegliches Verständnis reicht rechtlich nicht mehr.

*Bus-Faktor.* Wie viele Personen müssten ausfallen, damit ein Prozess komplett stillsteht? Bus-Faktor 1 heißt: nur eine einzige Person weiß, wie's geht, hohes Risiko für den Betrieb. Der Name kommt vom Gedankenspiel "was, wenn diese Person von einem Bus erfasst wird". Zentraler Punkt bei der Zeitfresser-Analyse (Schritt 4 der Methode).

*Workflow.* Die Kette von Schritten, die automatisiert abläuft, im Grunde das, was tatsächlich in Make.com oder n8n gebaut wird. Wie ein Fließband: Anfrage kommt rein → wird geprüft → landet im richtigen System → löst die nächste Aktion aus.

*Skalierbarkeit.* Ob eine Lösung auch bei doppelt oder zehnfach so vielen Anfragen noch funktioniert, ohne dass doppelt so viel Aufwand oder Personal nötig wird. Eine gute Automatisierung ist skalierbar: 10 oder 100 Anfragen kosten sie fast gleich viel "Mühe".

**1. Automatisierung und Prozessverbindung — das eigentliche Herzstück**

Für alles, was mehrere Systeme verbindet oder Abläufe auslöst (Anfrage kommt rein → wird eingeordnet → landet im richtigen Postfach oder System): Make.com oder n8n. Beides No-Code, im Browser bedienbar, damit der Kunde nach der Einführung selbst kleine Anpassungen vornehmen kann. Die Wahl zwischen beiden richtet sich nach Datenresidenz-Anforderungen des Kunden (siehe Anhang F) und danach, was im jeweiligen Umfeld bereits verbreitet ist. Für die schnelle Verbindung eines E-Mail-Postfachs per IMAP (ohne aufwendiges Google-Cloud-OAuth-Setup) siehe Schritt-für-Schritt-Anleitung in [n8n-email-trigger-setup.md](n8n-email-trigger-setup.md).

**Faustregel CRM andocken vs. n8n-only.** Ist beim Kunden bereits ein CRM im Einsatz (z. B. HubSpot, Salesforce, Pipedrive), daran andocken statt es zu ersetzen: n8n verbindet sich über fertige Bausteine mit der jeweiligen Schnittstelle, das CRM bleibt die zentrale Wahrheit für Kundendaten, n8n übernimmt die Automatisierung drumherum, keine doppelte Datenerfassung. Ist kein CRM vorhanden, nicht automatisch eins einführen, nur weil es professionell klingt — erst prüfen, ob der eigentliche Bedarf das rechtfertigt. Ein echtes CRM lohnt sich meist erst bei einer wirklich komplexen Vertriebs-Pipeline mit vielen Kontakten und Phasen über Zeit. Für reine Anfragen- und Statusverfolgung (wie bei B+H Bau, siehe [status-ohne-crm.docx](../outputs/ki-prozessberatung-kmu/status-ohne-crm.docx)) reicht häufig eine schlanke, direkt über n8n gebaute Statusübersicht, günstiger und schneller eingeführt als ein volles CRM-System.

**Faustregel n8n vs. Microsoft Power Automate.** Beide sind No-Code-Automatisierungstools, aber mit unterschiedlichem Schwerpunkt. n8n ist flexibel und plattformunabhängig, gut geeignet für alles außerhalb des Büros oder mit externen Diensten (Baustelle, WhatsApp/Telegram, KI-lastige Verarbeitung). Power Automate ist Teil von Microsoft 365 und läuft nativ in Outlook, SharePoint, Excel, Teams, sinnvoll bei Kunden, die ohnehin M365 nutzen und rein büro-interne Abläufe automatisieren wollen. Besonderer Vorteil von Power Automate: kann per RPA (simuliert Mausklicks/Tastatureingaben wie ein Mensch) auch alte, lokal installierte Software ohne moderne Schnittstelle steuern, was weder Make.com noch n8n können. Kombi-Modell möglich: n8n übernimmt die KI-lastige Arbeit von unterwegs, Power Automate die "letzte Meile" ins alte Bürosystem ohne API. Ausführlich mit Preisen und einem konkreten Anwendungsfall durchgerechnet in [b-h-bau-projekt.md](../context/b-h-bau-projekt.md).

**2. Alltags-Textarbeit — Angebote, E-Mails, Konzepte**

Wenn der Kunde bereits Microsoft 365 nutzt (wie B+H Bau), liegt Microsoft Copilot nahe, weil es direkt in Outlook, Word und Excel arbeitet und keine neue Oberfläche braucht. Ohne bestehende M365-Lizenz ist ein allgemeiner Chat-Assistent wie ChatGPT die niedrigschwelligere Einstiegsoption.

**3. Baustellen- und Vor-Ort-Dokumentation**

Für den in Anhang E beschriebenen Fall (Diktieren statt Papier/Handyfotos): eine Spracherkennungs-/Diktierfunktion, die direkt strukturierte Einträge erzeugt, wie im Demo `demo-bautagebuch-spracherkennung.html` gezeigt. Baut auf Sprache-zu-Text-Diensten auf, die Andi über eine Automatisierung (Punkt 1) an die Struktur des jeweiligen Betriebs anpasst — kein fertiges Einzeltool, sondern eine Kombination.

**4. Meetings und Gespräche dokumentieren**

Für Betriebe mit vielen Besprechungen oder Kundengesprächen: ein Transkriptions- und Zusammenfassungsdienst (z. B. Fireflies.ai oder vergleichbare Anbieter), der automatisch Aufgaben und Entscheidungen aus dem Gespräch herausfiltert, statt dass jemand von Hand mitschreibt.

**5. Kundenanfragen und Erstkontakt**

Für Betriebe mit hohem Aufkommen an Standardanfragen (Preise, Verfügbarkeit, erste Fragen): ein Chatbot, der aus vorhandenen Website-Inhalten und FAQs trainiert wird, für die Website.

Für telefonische Anfragen gibt es vergleichbare Dienste (KI-Telefonassistenten), die Anrufe automatisch annehmen, Standardfragen beantworten, Termine buchen und wichtige Gespräche strukturiert weiterleiten — besonders relevant für kleine Betriebe, in denen niemand ständig ans Telefon kann, im Handwerk klassisch das Dilemma „wer auf der Baustelle ist, kann nicht ans Telefon, wer ans Telefon geht, ist nicht auf der Baustelle".

Typische Kernfunktionen dieser Telefonassistenten:

- Rund-um-die-Uhr-Erreichbarkeit, auch außerhalb der Geschäftszeiten und am Wochenende
- Echtes Gespräch statt Tastendruck-Menü, versteht natürliche Sprache
- Strukturierte Aufnahme der wichtigen Details (z. B. Adresse, Art des Problems, Dringlichkeit)
- Direkte Terminbuchung im Kalender, ohne dass jemand zurückrufen muss
- Automatische Bestätigungs-SMS an den Kunden
- Dringlichkeits-Einordnung (Triage): eilige Fälle direkt an eine echte Person weiterleiten, Standardanfragen erledigt die KI selbst
- Antwortzeit unter einer Sekunde, kein Warten in der Leitung

Aktuelle Anbieter mit Fokus auf deutsche KMU (Stand 2026): Vokaro (branchenspezifisch), Fonio (Pay-per-Use statt Grundgebühr, gut für schwankendes Anrufaufkommen), Livestep (Mittelstand-Fokus), voiceOne (deutscher Anbieter, hohes Anrufaufkommen), Telfo.

Berichteter Effekt aus der Praxis: Handwerksbetriebe berichten von bis zu 40 % weniger verpassten Anfragen nach der Einführung — als "berichtet", nicht als garantiert kennzeichnen, wenn das gegenüber einem Kunden erwähnt wird. Bei Kosten-Nutzen-Rechnungen von Anbieterseite (z. B. konkrete ROI-Prozentzahlen) generell skeptisch bleiben und nicht ungeprüft übernehmen, oft Einzelfall-Marketingbeispiele statt verlässlicher Branchenzahlen.

**6. Interne Wissensnutzung mit sensiblen Daten**

Sobald ein Kunde interne Dokumente, Kalkulationen oder Kundendaten mit KI durchsuchbar machen will, aber Bedenken wegen Datenschutz hat (siehe Anhang F, AVV/DSFA-Pflicht): Tools, die speziell für eine geschützte, unternehmensinterne Umgebung gebaut sind, statt Inhalte einfach in einen öffentlichen Chat zu laden. Hier lohnt sich immer der Blick auf den Serverstandort des Anbieters.

**7. Präsentationen und Auswertungen**

Für schnelle Entscheidungsvorlagen oder Angebotspräsentationen aus vorhandenem Text: KI-gestützte Präsentationstools, die aus Stichpunkten fertige Foliensätze erzeugen. Eher ein Nice-to-have als ein Kernbaustein, meist erst relevant, wenn die Basis-Automatisierungen schon stehen.

**Wie diese Liste im Beratungsprozess genutzt wird:** In Schritt 6 der Methode (KI-Potenzialanalyse) bei jedem Prozess prüfen, in welche der sieben Kategorien er fällt, und daraus die Tool-Richtung ableiten. Die konkrete Anbieterwahl hängt immer vom Einzelfall ab (bestehende Systeme, Budget, Datenschutz-Anforderungen aus Anhang F) — diese Liste gibt die Richtung vor, nicht die endgültige Entscheidung.

---

*Erstellt: 24.07.2026, Auslöser war ein Gespräch mit einem befreundeten Unternehmer (Millionenumsatz, Firmenübergabe an die Söhne läuft), der als erstes Pilotprojekt infrage kommt. Anhang E ergänzt 03.08.2026, als Andi überlegte, das Angebot auch an eigene Kontakte aus dem Handwerks-/Sanierungsbereich heranzutragen. Anhang F ergänzt 06.08.2026, nachdem der EU AI Act am 02.08.2026 mit seinen Transparenzpflichten scharf wurde. Anhang G ergänzt 06.08.2026, nach Durchsicht eines Digital-Beat-Lead-Magnets mit 15 KI-Use-Cases, als eigenständig formulierte Tool-Referenz statt Übernahme aus fremdem Material.*
