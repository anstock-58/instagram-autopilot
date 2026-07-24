# AI Avatar Factory — Anwendung auf @business.und.spirit

Erster Durchlauf der Methode aus `reference/ai-avatar-factory-methode.md`, angewendet auf den eigenen Hauptaccount statt auf einen fremden Kunden. Stufen 1 bis 5 sind Synthese aus bereits vorhandenem Workspace-Kontext, keine neue Recherche. Stufe 6 bis 8 sind neu entwickelt.

---

## 1. Unternehmensanalyse

Andreas Stock, 67, Dipl.-Ing., Olpe, Einzelunternehmer unter Finaffairs. Geschäftsmodell ist ein Funnel für Männer 50+: kostenloser Standortcheck (zehn Minuten, unverbindlich) als Einstieg, dahinter liegen Minikurs „Raus aus dem Funktionsmodus" (37 Euro) und Hauptkurs „Neustart im Kopf" (397 Euro). Seit 22.06.2026 gilt die feste Regel, dass auf @business.und.spirit ausschließlich der kostenlose Standortcheck beworben wird, keine bezahlten Produkte direkt im Text.

Kanäle: Instagram @business.und.spirit (Autopilot über `post-trigger-business-und-spirit.ps1`, Story 09:00 Uhr, Reel 18:00 Uhr, Blotato) und YouTube-Kanal „Business & Spirit" (wöchentlich). Landingpages laufen über systeme.io (`sicher-weiterlesen.com`).

Bekannter Engpass laut Funnel-Diagnose vom 15.06.2026: der Funnel selbst ist technisch fertig und ohne Platzhalter, aber bei 1659 erreichten Konten in 30 Tagen gab es nur 6 externe Klicks. Reichweite ist also vorhanden, die Wirkung von Hook und CTA oben im Funnel nicht. Genau da soll das Avatar-System ansetzen, nicht bei der Technik.

---

## 2. Markenanalyse

Markenkern: die Verbindung aus unternehmerischer Kompetenz und innerer Klarheit, ohne dabei esoterisch zu werden. Der Name „Business & Spirit" steht für genau diese Brücke.

Wofür die Marke steht: Männer, die jahrzehntelang aufgebaut haben, Firma, Verantwortung, Familie, und die nach außen funktionieren, aber innerlich spüren, dass etwas fehlt. Direkt, würdevoll, alltagstauglich.

Wofür die Marke ausdrücklich nicht steht: Motivationskitsch, Therapiesprache, Weichspüler, Manifestieren, Empowerment-Vokabular, große Versprechen. Die Abgrenzung ist doppelt, kein reiner Business-Kanal, der nur über Wachstum spricht, und kein Spiritual-Coaching-Kanal, der esoterisch wirkt.

---

## 3. Zielgruppenanalyse

Kern-Avatar: Mann, 50 bis 65 Jahre, hat sein Leben lang funktioniert, Beruf, Familie, Pflichten. Nach außen stabil, innen leer oder rastlos. Spürt, dass etwas fehlt, kann es aber nicht benennen.

Drei Personas aus dem bestehenden Deep-Research-Dokument (`context/deep-research-zielgruppe.md`):

**Thomas, 57, Ingenieur.** Verheiratet, erwachsene Kinder, guter Job, eigenes Haus. Von außen ein perfektes Leben, von innen das Gefühl, seit Jahren auf Autopilot zu leben. Bild dafür in seinen eigenen Worten: „eine Glaswand zwischen mir und dem Leben".

**Michael, 53, Selbstständiger.** Unternehmer, viel geleistet, erschöpft, Scheidung hinter sich. Misstraut esoterischem Content, hat schon in teure Coachings ohne Ergebnis investiert.

**Werner, 61, kurz vor Rente.** Angst vor der Leere danach, Arbeit war immer Identität, fühlt sich zunehmend unsichtbar.

Fünf Bewusstseinsstufen von „weiß noch nicht, dass es ein Problem gibt" bis „kaufbereit", jede Stufe braucht anderen Content, von der Spiegel-Frage ohne Verkauf bis zum klaren CTA. Details siehe Originaldokument.

---

## 4. Positionierung

Zentrales Versprechen: „Du darfst aufhören, nur zu funktionieren." Keine Motivation, keine Erfolgstipps, sondern Orientierung und Klarheit.

Der aktuelle Engpass ist nicht das Angebot und nicht die Technik, sondern dass die Hook oben im Funnel nicht genug Menschen vom Scrollen zum Klicken oder Kommentieren bewegt. Ein konsistenter, glaubwürdiger visueller Avatar kann hier zweifach wirken: erstens als Wiedererkennung, die über viele Posts hinweg Vertrauen aufbaut, zweitens als unmittelbarer Spiegel, der die Zielgruppe in den ersten Sekunden emotional trifft, bevor überhaupt ein Wort gelesen wird.

---

## 5. Kommunikationsstil

Hook-Formel (`context/instagram-strategie.md`): konkrete Szene, die die Person kennt, dann eine Einordnung, die überrascht, dann Versprechen oder Lücke. Eine Hook endet nie mit einer Frage, immer mit Aussage oder Versprechen.

CTA-Formel: Keyword plus konkrete Zeitangabe plus konkretes Ergebnis, keine Weichspüler. Beispiel: „Schreib CHECK, und du weißt in fünf Minuten, ob du noch unter normalem Druck stehst oder bereits im Funktionsmodus feststeckst."

Brücke vom Inhalt zum CTA speziell für diesen Account (`reference/content-regeln-instagram.md`): Problem benennen, dann einordnen „du bist gerade nicht da, wo du sein willst", dann der Standortcheck als Orientierungsangebot.

Verboten: das „Nicht X, sondern Y"-Muster, Spannungsankündigungen wie „Die Wahrheit ist", künstlich tiefe Dreierreihen, die Wörter Mehrwert, Transformation, Authentizität, nachhaltig, ganzheitlich. Maximal zwei bis drei Emojis, dezent am Ende von Abschnitten.

---

## 6. Avatar-Entwicklung

Der bestehende Workspace-Standard für Bildprompts (`context/current-data.md`, Abschnitt „Avatar-Standard für Bildprompts") beschreibt bereits genau diesen Typ: mittelalter bis älterer europäischer Mann, graues oder salt-and-pepper Haar, kurzer grauer Bart, leicht müdes Gesicht, ruhiger und ernster Ausdruck. Das passt inhaltlich sehr gut zur Zielgruppe aus Stufe 3, wird hier zu einem konkreten, wiederverwendbaren Charakter ausgebaut, nach demselben Muster wie der bereits laufende Pilot für @andi.mentalgesund (`scripts/generate-avatar-mentalgesund.ps1`).

**Eine bewusste technische Entscheidung dabei:** Der Mentalgesund-Pilot nutzt „photorealistic editorial portrait photography" statt reiner Illustration, und das Modell (fal-ai/imagen4) ist darauf bereits getestet und funktioniert. Ich übernehme diesen photorealistischen Ansatz auch hier statt der ursprünglich notierten „Editorial-Zeitungsillustration", weil er nachweislich läuft und auf Instagram als Foto/Reel-Content natürlicher wirkt als eine Illustration. Der aktuelle Avatar-Standard in current-data.md wird entsprechend ergänzt, nicht ersetzt.

**Charakter: Matthias, 58.**

Deutscher Mann, achtundfünfzig Jahre, kurzes salt-and-pepper Haar, ordentlich zurückgekämmt, kurzer gepflegter grauer Bart, müde aber gefasste haselnussbraune Augen, wettergegerbtes Gesicht mit feinen Anspannungslinien um die Augen, kräftig-solide Statur. Kleidung bewusst nicht Anzug/Krawatte (zu corporate) und nicht leger (zu wenig „hat etwas aufgebaut"), sondern gedeckter Blazer über dunklem Feinstrick-Rollkragen oder Troyer, dunkle Hose. Gedämpfte, natürliche Farbpalette, kein auffälliges Muster.

Grundhaltung im Bild: kompetent, ruhig, aber mit einer spürbaren inneren Distanz, nie ein breites Lächeln, eher ein stiller, nach innen gerichteter Blick. Das transportiert die „Glaswand" aus der Zielgruppenanalyse, ohne dass ein Bild das Wort je aussprechen müsste.

---

## 7. Master-Prompt und technische Umsetzung

**Fester Charakter-Block** (wird in jedem Bildprompt identisch vorangestellt):

„a 58 year old German man named Matthias, short salt-and-pepper hair neatly combed back, closely trimmed grey beard, tired but composed hazel eyes, weathered face with faint tension lines around the eyes, solid build, wearing a charcoal grey wool blazer over a dark navy fine-knit turtleneck and dark trousers, muted natural color palette, soft natural light, photorealistic editorial portrait photography, shallow depth of field, quiet composed but faintly weary mood, no text, no logo"

**Acht Szenen-Vorschläge** (gleiches Prinzip wie beim Mentalgesund-Pilot, thematisch auf „Funktionsmodus" und „Glaswand" ausgerichtet):

1. Steht abends am Bürofenster, Stadtlichter draußen, eine Hand in der Tasche, blickt hinaus, kein Lächeln. Vertikale 9:16-Komposition.
2. Sitzt allein am Kopfende eines leeren Konferenztisches, Unterlagen geschlossen vor sich, Hände gefaltet, Blick geht an der Kamera vorbei. Vertikale 9:16-Komposition.
3. Fährt nachts allein Auto, beide Hände am Lenkrad, Straßenlaternen spiegeln sich, ruhiger, unlesbarer Ausdruck. Vertikale 9:16-Komposition.
4. Steht abends vor der eigenen Haustür, Schlüssel in der Hand, hält kurz inne bevor er hineingeht, blickt nachdenklich nach unten. Vertikale 9:16-Komposition.
5. Sitzt spätabends allein am Küchentisch, Laptop geschlossen daneben, stützt die Stirn in eine Hand. Vertikale 9:16-Komposition.
6. Geht allein eine leere Straße nahe seinem Büro entlang, Hände in den Manteltaschen, Blick unfokussiert nach vorn. Vertikale 9:16-Komposition.
7. Steht abends auf dem eigenen Balkon, Unterarme auf dem Geländer, blickt über die Dächer, nachdenklich. Vertikale 9:16-Komposition.
8. Sitzt zu Hause in einem Sessel, im Hintergrund leicht unscharf ein gerahmtes Familienfoto, blickt direkt und ruhig-suchend in die Kamera. Vertikale 9:16-Komposition.

**Technische Eckdaten:** fal-ai/imagen4/preview/fast, Format portrait_16_9, ein Bild pro Aufruf, keine Textelemente, kein Logo. Umsetzung vorbereitet in `scripts/generate-avatar-business-spirit.ps1` (noch nicht ausgeführt).

---

## 8. Content-System

Der Avatar speist in die bestehende Foto-Modus-Pipeline des Accounts ein (Bild-URL-Spalte im Contentplan, kein zusätzliches KI-Rendering pro Post nötig, sobald die acht Basisbilder einmal erzeugt sind). Empfehlung für den Rollout: erst die acht Bilder aus Stufe 7 generieren, gegen die Checkliste in Anhang D der Methode prüfen (passt der Avatar wirklich zur Zielgruppe, ist das Gesicht über mehrere Bilder konsistent), und erst danach in den nächsten Contentplan-Zyklus für @business.und.spirit einplanen, mit Hooks nach der Formel aus Stufe 5 und CHECK als einzigem CTA-Keyword.

---

*Erstellt: 24.07.2026, erster Anwendungsfall der AI Avatar Factory Methode (`reference/ai-avatar-factory-methode.md`).*
