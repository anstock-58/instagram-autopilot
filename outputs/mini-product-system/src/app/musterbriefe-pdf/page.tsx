'use client'
import React from 'react'

const bereiche = [
  {
    titel: 'BEREICH 1: Krankenkasse und Gesundheit',
    briefe: [
      {
        nr: 1,
        titel: 'Widerspruch gegen Leistungsablehnung',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name der Krankenkasse]
[Adresse der Krankenkasse]

[Ort], den [Datum]

Betreff: Widerspruch gegen Ihren Bescheid vom [Datum]
Versichertennummer: [Deine Versichertennummer]

Sehr geehrte Damen und Herren,

mit Ihrem Schreiben vom [Datum] haben Sie meinen Antrag auf [Leistung genau benennen] abgelehnt.

Gegen diese Entscheidung lege ich hiermit fristgerecht Widerspruch ein.

Begründung:
Die abgelehnte Leistung ist medizinisch notwendig. Mein behandelnder Arzt, [Name des Arztes], hat mir diese Maßnahme ausdrücklich verordnet. Ich füge das ärztliche Attest als Anlage bei.

Ich bitte Sie, meinen Antrag erneut zu prüfen und mir die Leistung zu gewähren.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]

Anlage: Ärztliches Attest vom [Datum]`,
      },
      {
        nr: 2,
        titel: 'Antrag auf Haushaltshilfe',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name der Krankenkasse]
[Adresse der Krankenkasse]

[Ort], den [Datum]

Betreff: Antrag auf Haushaltshilfe gemäß § 38 SGB V
Versichertennummer: [Deine Versichertennummer]

Sehr geehrte Damen und Herren,

ich beantrage hiermit die Gewährung einer Haushaltshilfe.

Grund: Ich befinde mich ab dem [Datum] in stationärer Behandlung und bin anschließend für voraussichtlich [Zeitraum] nicht in der Lage, meinen Haushalt selbst zu führen.

In meinem Haushalt leben folgende Personen, die nicht in der Lage sind, den Haushalt zu übernehmen:
[Angaben, z. B. "Mein Ehemann, 72 Jahre, selbst pflegebedürftig"]

Ich bitte um baldige Entscheidung, da mein Aufenthalt am [Datum] beginnt.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]

Anlage: Ärztliche Bescheinigung über die Behandlung`,
      },
      {
        nr: 3,
        titel: 'Antrag auf Pflegegrad (Erstantrag)',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name der Pflegekasse]
[Adresse der Pflegekasse]

[Ort], den [Datum]

Betreff: Antrag auf Feststellung der Pflegebedürftigkeit
Versichertennummer: [Deine Versichertennummer]

Sehr geehrte Damen und Herren,

hiermit beantrage ich die Feststellung meiner Pflegebedürftigkeit.

Aufgrund von [Erkrankung] bin ich seit [Zeitraum] nicht mehr in der Lage, alle alltäglichen Aufgaben selbstständig zu erledigen.

Ich benötige Unterstützung bei:
[ ] Körperpflege (Waschen, Anziehen)
[ ] Mobilität (Treppensteigen, Gehen)
[ ] Ernährung (Kochen, Einkaufen)
[ ] Medikamenteneinnahme
[ ] Haushaltsführung

Ich bitte um Beauftragung des Medizinischen Dienstes zur Begutachtung.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
      {
        nr: 4,
        titel: 'Widerspruch gegen Pflegegrad-Entscheidung',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name der Pflegekasse]
[Adresse der Pflegekasse]

[Ort], den [Datum]

Betreff: Widerspruch gegen den Bescheid vom [Datum]
Versichertennummer: [Deine Versichertennummer]

Sehr geehrte Damen und Herren,

mit Ihrem Schreiben vom [Datum] wurde mir [kein Pflegegrad / Pflegegrad 1] zuerkannt. Gegen diese Entscheidung lege ich Widerspruch ein.

Begründung:
Der Gutachter hat meinen tatsächlichen Unterstützungsbedarf nicht vollständig erfasst. Ich benötige täglich Hilfe bei:
- [Tätigkeit 1, z. B. "Ich kann mich nicht alleine waschen — dauert mit Hilfe 45 Minuten"]
- [Tätigkeit 2]

Ich bitte um erneute Begutachtung.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]

Anlage: Pflegetagebuch der letzten 2 Wochen`,
      },
      {
        nr: 5,
        titel: 'Antrag auf Befreiung von Zuzahlung',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name der Krankenkasse]
[Adresse der Krankenkasse]

[Ort], den [Datum]

Betreff: Antrag auf Zuzahlungsbefreiung für das Jahr [Jahr]
Versichertennummer: [Deine Versichertennummer]

Sehr geehrte Damen und Herren,

hiermit beantrage ich die Ausstellung einer Befreiungskarte von der Zuzahlungspflicht für das Jahr [Jahr].

Mein Bruttoeinkommen beträgt [Betrag] Euro im Jahr. Die Belastungsgrenze von 2 Prozent ist durch meine bisherigen Zuzahlungen bereits erreicht.

Gesamtbetrag der bisherigen Zuzahlungen: [Betrag] Euro

Ich bitte um Ausstellung der Befreiungskarte.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]

Anlage: Zuzahlungsbelege`,
      },
    ],
  },
  {
    titel: 'BEREICH 2: Verträge kündigen',
    briefe: [
      {
        nr: 6,
        titel: 'Kündigung Handyvertrag',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Mobilfunkanbieters]
[Adresse des Anbieters]

[Ort], den [Datum]

Betreff: Kündigung meines Mobilfunkvertrags
Kundennummer: [Deine Kundennummer]
Rufnummer: [Deine Handynummer]

Sehr geehrte Damen und Herren,

hiermit kündige ich meinen Mobilfunkvertrag ordentlich zum nächstmöglichen Zeitpunkt.

Ich bitte um schriftliche Bestätigung der Kündigung und Mitteilung des genauen Enddatums.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
      {
        nr: 7,
        titel: 'Kündigung Zeitschriften-/Zeitungsabo',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Verlags]
[Adresse des Verlags]

[Ort], den [Datum]

Betreff: Kündigung meines Abonnements
Abonummer: [Deine Abonummer]

Sehr geehrte Damen und Herren,

hiermit kündige ich mein Abonnement für [Name der Zeitschrift / Zeitung] zum nächstmöglichen Termin, spätestens zum [Datum].

Ich bitte um schriftliche Bestätigung des Kündigungstermins.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
      {
        nr: 8,
        titel: 'Kündigung Fitnessstudio oder Verein',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Studios / Vereins]
[Adresse]

[Ort], den [Datum]

Betreff: Kündigung meiner Mitgliedschaft
Mitgliedsnummer: [Falls vorhanden]

Sehr geehrte Damen und Herren,

hiermit kündige ich meine Mitgliedschaft zum nächstmöglichen Termin.

[Optional: Ich kündige aus gesundheitlichen Gründen außerordentlich zum [Datum]. Attest liegt bei.]

Ich bitte um schriftliche Bestätigung.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
      {
        nr: 9,
        titel: 'Kündigung Versicherung',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name der Versicherung]
[Adresse der Versicherung]

[Ort], den [Datum]

Betreff: Kündigung meines Versicherungsvertrags
Versicherungsscheinnummer: [Nummer]

Sehr geehrte Damen und Herren,

hiermit kündige ich den oben genannten Versicherungsvertrag ordentlich zum nächstmöglichen Termin.

Bitte überweisen Sie etwaige Rückzahlungen auf:
IBAN: [Deine IBAN]

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
      {
        nr: 10,
        titel: 'Außerordentliche Kündigung nach Preiserhöhung',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Anbieters]
[Adresse]

[Ort], den [Datum]

Betreff: Außerordentliche Kündigung wegen Preiserhöhung
Kundennummer: [Deine Kundennummer]

Sehr geehrte Damen und Herren,

mit Ihrem Schreiben vom [Datum] haben Sie mir eine Preiserhöhung mitgeteilt. Von diesem Sonderkündigungsrecht mache ich hiermit Gebrauch.

Ich kündige meinen Vertrag außerordentlich zum [Datum der Preiserhöhung].

Ich bitte um schriftliche Bestätigung.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
    ],
  },
  {
    titel: 'BEREICH 3: Reklamation und Beschwerde',
    briefe: [
      {
        nr: 11,
        titel: 'Reklamation beim Versandhandel',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Shops]
[Adresse]

[Ort], den [Datum]

Betreff: Reklamation — Bestellnummer [Bestellnummer]

Sehr geehrte Damen und Herren,

am [Datum] habe ich bei Ihnen [Produkt] bestellt und am [Datum] erhalten.

Leider ist die Ware fehlerhaft:
[Fehler genau beschreiben]

Ich bitte um:
[ ] Kostenlose Reparatur
[ ] Ersatzprodukt
[ ] Rückerstattung des Kaufpreises: [Betrag] Euro

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]

Anlage: Kopie der Rechnung`,
      },
      {
        nr: 12,
        titel: 'Beschwerde über Handwerker',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Handwerkers]
[Adresse]

[Ort], den [Datum]

Betreff: Mängelrüge bezüglich der Arbeiten vom [Datum]

Sehr geehrte Damen und Herren,

am [Datum] haben Sie bei mir [Art der Arbeit] durchgeführt. Leider habe ich folgende Mängel festgestellt:
- [Mangel 1 genau beschreiben]
- [Mangel 2]

Ich fordere Sie auf, diese Mängel bis spätestens [Datum] kostenfrei zu beheben.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]

Anlage: Fotos der Mängel`,
      },
      {
        nr: 13,
        titel: 'Beschwerde beim Nachbarn wegen Lärm',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

An: [Name des Nachbarn]
[Adresse des Nachbarn]

[Ort], den [Datum]

Betreff: Lärmbelästigung

Sehr geehrte/r Frau / Herr [Nachbarname],

seit einiger Zeit fühle ich mich durch [Lärm beschreiben, z. B. "laute Musik in den Abendstunden"] erheblich gestört.

Konkrete Vorfälle:
- [Datum]: [Beschreibung]

Ich bitte Sie herzlich, auf diese Situation Rücksicht zu nehmen.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
      {
        nr: 14,
        titel: 'Mahnung an säumigen Schuldner',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Schuldners]
[Adresse]

[Ort], den [Datum]

Betreff: Mahnung — Offene Forderung über [Betrag] Euro

Sehr geehrte/r Frau / Herr [Name],

ich erlaube mir, Sie an eine noch offene Zahlung zu erinnern.

Sachverhalt: [Kurz beschreiben]

Trotz meiner bisherigen Erinnerung ist der Betrag von [Betrag] Euro noch nicht eingegangen.

Ich bitte um Überweisung bis spätestens [Datum]:
Empfänger: [Dein Name]
IBAN: [Deine IBAN]

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
    ],
  },
  {
    titel: 'BEREICH 4: Behörden und Ämter',
    briefe: [
      {
        nr: 15,
        titel: 'Einspruch gegen Steuerbescheid',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

Finanzamt [Name]
[Adresse des Finanzamts]

[Ort], den [Datum]

Betreff: Einspruch gegen den Einkommensteuerbescheid [Jahr]
Steuernummer: [Deine Steuernummer]

Sehr geehrte Damen und Herren,

gegen den Einkommensteuerbescheid für [Jahr] vom [Datum] lege ich hiermit Einspruch ein.

Begründung:
[z. B. "Die Kosten für meine Brille in Höhe von [Betrag] Euro wurden nicht als außergewöhnliche Belastung anerkannt, obwohl ein ärztliches Attest vorliegt."]

Ich bitte um Überprüfung und Abänderung des Bescheids.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]

Anlage: [Belege]`,
      },
      {
        nr: 16,
        titel: 'Antrag auf Befreiung vom Rundfunkbeitrag',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

ARD ZDF Deutschlandradio Beitragsservice
50656 Köln

[Ort], den [Datum]

Betreff: Antrag auf Befreiung vom Rundfunkbeitrag
Beitragsnummer: [Falls vorhanden]

Sehr geehrte Damen und Herren,

hiermit beantrage ich die Befreiung vom Rundfunkbeitrag.

Begründung: Ich beziehe [Grundsicherung / Wohngeld / ALG II] und bin daher gemäß § 4 Abs. 1 RBStV von der Beitragspflicht befreit.

Ich füge den aktuellen Bewilligungsbescheid als Anlage bei.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]
Geburtsdatum: [Dein Geburtsdatum]

Anlage: Bewilligungsbescheid vom [Datum]`,
      },
      {
        nr: 17,
        titel: 'Antrag auf Schwerbehindertenausweis',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Versorgungsamt / Landratsamt]
[Adresse der Behörde]

[Ort], den [Datum]

Betreff: Antrag auf Feststellung des Grades der Behinderung (GdB)

Sehr geehrte Damen und Herren,

hiermit stelle ich einen Antrag auf Feststellung meines Grades der Behinderung und Ausstellung eines Schwerbehindertenausweises.

Meine gesundheitlichen Einschränkungen:
- [Erkrankung 1, z. B. "Diabetes mellitus Typ 2 seit [Jahr]"]
- [Erkrankung 2]

Behandelnde Ärzte:
- [Name des Hausarztes, Adresse]
- [Name des Facharztes, Adresse]

Ich bitte um Zusendung der notwendigen Formulare.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]
Geburtsdatum: [Dein Geburtsdatum]`,
      },
      {
        nr: 18,
        titel: 'Widerspruch gegen Rentenbescheid',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

Deutsche Rentenversicherung [Zuständige Stelle]
[Adresse]

[Ort], den [Datum]

Betreff: Widerspruch gegen den Rentenbescheid vom [Datum]
Versicherungsnummer: [Deine Versicherungsnummer]

Sehr geehrte Damen und Herren,

gegen Ihren Bescheid vom [Datum] lege ich hiermit fristgerecht Widerspruch ein.

Begründung:
[z. B. "Folgende Beschäftigungszeiten wurden nicht berücksichtigt: [Zeitraum, Arbeitgeber]"]

Ich bitte um erneute Prüfung und Korrektur meines Rentenbescheids.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]
Geburtsdatum: [Dein Geburtsdatum]

Anlage: [Nachweise, z. B. Lohnunterlagen]`,
      },
    ],
  },
  {
    titel: 'BEREICH 5: Wohnen und Vermieter',
    briefe: [
      {
        nr: 19,
        titel: 'Aufforderung zur Mängelbeseitigung an Vermieter',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Vermieters]
[Adresse des Vermieters]

[Ort], den [Datum]

Betreff: Aufforderung zur Mängelbeseitigung
Mietobjekt: [Adresse der Wohnung]

Sehr geehrte/r Frau / Herr [Vermieter],

in meiner Wohnung bestehen seit [Zeitraum] folgende Mängel:
- [Mangel 1, z. B. "Im Badezimmer ist Schimmel an der Außenwand aufgetreten."]
- [Mangel 2]

Ich bitte Sie, die Mängel bis spätestens [Datum] zu beseitigen.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]

Anlage: Fotos der Mängel`,
      },
      {
        nr: 20,
        titel: 'Kündigung des Mietvertrags durch Mieter',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Vermieters]
[Adresse des Vermieters]

[Ort], den [Datum]

Betreff: Kündigung des Mietverhältnisses
Mietobjekt: [Adresse der Wohnung]

Sehr geehrte/r Frau / Herr [Vermieter],

hiermit kündige ich das Mietverhältnis ordentlich zum [Datum, in der Regel 3 Monate nach Monatsende].

Ich bitte um schriftliche Bestätigung und Vereinbarung eines Termins für die Wohnungsübergabe.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
      {
        nr: 21,
        titel: 'Widerspruch gegen Nebenkostenabrechnung',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Vermieters]
[Adresse des Vermieters]

[Ort], den [Datum]

Betreff: Widerspruch gegen die Nebenkostenabrechnung [Jahr]
Mietobjekt: [Adresse der Wohnung]

Sehr geehrte/r Frau / Herr [Vermieter],

Ihre Nebenkostenabrechnung für [Jahr] habe ich erhalten. Ich erhebe Einwände gegen folgende Positionen:
- [Position 1, z. B. "Reinigungskosten in Höhe von [Betrag] Euro — bitte Vorlage der Rechnung"]

Ich bitte um Einsicht in die zugrundeliegenden Belege.

Die Nachzahlung leiste ich vorerst unter Vorbehalt.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
    ],
  },
  {
    titel: 'BEREICH 6: Bank und Finanzen',
    briefe: [
      {
        nr: 22,
        titel: 'Beschwerde über Kontogebühren',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name der Bank]
[Adresse der Bank]

[Ort], den [Datum]

Betreff: Beschwerde über Kontoführungsgebühren
IBAN: [Deine IBAN]

Sehr geehrte Damen und Herren,

ich bin seit [Jahr] Kunde bei Ihnen. Die Erhöhung der monatlichen Gebühr von [alter Betrag] auf [neuer Betrag] Euro halte ich nicht für gerechtfertigt.

Ich bitte um Prüfung, ob mir ein günstigeres Kontomodell angeboten werden kann.

Andernfalls sehe ich mich gezwungen, mein Konto zu verlegen.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
      {
        nr: 23,
        titel: 'Widerruf einer SEPA-Lastschrift',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]

[Name des Unternehmens]
[Adresse]

[Ort], den [Datum]

Betreff: Widerruf der SEPA-Lastschriftermächtigung
Kundennummer: [Falls vorhanden]

Sehr geehrte Damen und Herren,

hiermit widerrufe ich die Ihnen erteilte SEPA-Lastschriftermächtigung mit sofortiger Wirkung.

Zukünftige Abbuchungen von meinem Konto (IBAN: [Deine IBAN]) sind damit unzulässig.

Bitte bestätigen Sie den Widerruf schriftlich.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]`,
      },
    ],
  },
  {
    titel: 'BEREICH 7: Vollmachten und allgemeine Vorlagen',
    briefe: [
      {
        nr: 24,
        titel: 'Vorsorgevollmacht (einfache Version)',
        text: `VORSORGEVOLLMACHT

Ich, [Dein vollständiger Name],
geboren am [Geburtsdatum],
wohnhaft: [Deine Adresse],

erteile hiermit

Frau / Herrn [Name der bevollmächtigten Person],
geboren am [Geburtsdatum],
wohnhaft: [Adresse der bevollmächtigten Person],

Vollmacht, mich zu vertreten in folgenden Angelegenheiten:

[ ] Gesundheitsangelegenheiten
[ ] Behörden und Ämter
[ ] Bankgeschäfte bis [Betrag] Euro
[ ] Post öffnen und bearbeiten
[ ] Wohnungsangelegenheiten

Diese Vollmacht gilt ab sofort / nur bei meiner Handlungsunfähigkeit.

[Ort], den [Datum]

[Unterschrift]
[Dein Name]

Hinweis: Für rechtssichere Vollmachten empfiehlt sich eine notarielle Beglaubigung.`,
      },
      {
        nr: 25,
        titel: 'Allgemeiner Brief an Behörden (universelle Vorlage)',
        text: `[Dein Name]
[Deine Adresse]
[PLZ Ort]
Telefon: [Telefonnummer]

[Name der Behörde / des Amts]
[Abteilung, falls bekannt]
[Adresse]

[Ort], den [Datum]

Betreff: [Ihr Anliegen in einem Satz]
Aktenzeichen: [Falls vorhanden]

Sehr geehrte Damen und Herren,

ich wende mich mit folgendem Anliegen an Sie:

[Ihr Anliegen in 2-4 klaren Sätzen:
Was ist passiert? Was möchten Sie? Bis wann brauchen Sie eine Antwort?]

Ich bitte um [schriftliche Antwort / Terminvereinbarung / Bearbeitung] bis spätestens [Datum].

Für Rückfragen stehe ich unter der oben genannten Telefonnummer zur Verfügung.

Mit freundlichen Grüßen

[Unterschrift]
[Dein Name]

Anlage: [Unterlagen, die du beifügst]`,
      },
    ],
  },
]

export default function MusterbriefeP() {
  const s = {
    page: { background: 'white', color: 'black', minHeight: '100vh' } as React.CSSProperties,
    wrap: { maxWidth: '720px', margin: '0 auto', padding: '40px 32px' } as React.CSSProperties,
    hint: { background: '#eff6ff', border: '1px solid #bfdbfe', borderRadius: '12px', padding: '16px', marginBottom: '32px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' } as React.CSSProperties,
    btn: { background: '#2563eb', color: 'white', border: 'none', padding: '8px 16px', borderRadius: '8px', fontWeight: 'bold', cursor: 'pointer' } as React.CSSProperties,
    h1: { fontSize: '2.25rem', fontWeight: 'bold', margin: '0 0 8px' } as React.CSSProperties,
    h2: { fontSize: '1.1rem', fontWeight: 'bold', background: '#1e3a5f', color: 'white', padding: '10px 16px', borderRadius: '8px', marginBottom: '12px', marginTop: '32px' } as React.CSSProperties,
    briefBox: { border: '1px solid #e5e7eb', borderRadius: '10px', padding: '16px', marginBottom: '16px', pageBreakInside: 'avoid' as const } as React.CSSProperties,
    briefTitel: { fontWeight: 'bold', fontSize: '0.95rem', marginBottom: '10px', color: '#1e3a5f' } as React.CSSProperties,
    briefNr: { background: '#f97316', color: 'white', fontSize: '0.75rem', padding: '2px 10px', borderRadius: '999px', fontWeight: 'bold', marginRight: '8px' } as React.CSSProperties,
    pre: { background: '#f9fafb', border: '1px solid #e5e7eb', borderRadius: '6px', padding: '14px', fontSize: '0.78rem', color: '#374151', whiteSpace: 'pre-wrap' as const, margin: 0, fontFamily: 'inherit', lineHeight: '1.6' } as React.CSSProperties,
    tipBox: { background: '#fefce8', border: '1px solid #fde68a', borderRadius: '10px', padding: '16px', marginTop: '24px', marginBottom: '24px' } as React.CSSProperties,
  }

  return (
    <div style={s.page}>
      <div style={s.wrap}>

        {/* Drucken-Hinweis */}
        <div style={s.hint} className="no-print">
          <p style={{ color: '#1e40af', fontWeight: '600', margin: 0 }}>Strg+P → Als PDF speichern → Speichern</p>
          <button style={s.btn} onClick={() => window.print()}>PDF erstellen</button>
        </div>

        {/* Titelbereich */}
        <div style={{ textAlign: 'center', borderBottom: '2px solid #e5e7eb', paddingBottom: '32px', marginBottom: '32px' }}>
          <h1 style={s.h1}>Musterbriefe Pack für Senioren</h1>
          <p style={{ color: '#6b7280', margin: '0 0 12px' }}>25 fertige Briefe — einfach ausfüllen und abschicken</p>
          <span style={{ background: '#fff7ed', color: '#c2410c', fontSize: '0.85rem', padding: '4px 16px', borderRadius: '999px', fontWeight: '600' }}>Sofort nutzbar · Kein Juristendeutsch</span>
        </div>

        {/* Vorwort */}
        <div style={{ background: '#f9fafb', borderRadius: '12px', padding: '20px', marginBottom: '24px' }}>
          <h2 style={{ fontSize: '1.1rem', fontWeight: 'bold', marginTop: 0 }}>Vorwort</h2>
          <p style={{ color: '#374151', lineHeight: '1.7', margin: '0 0 8px' }}>Du musst kein Jurist sein, um dein Recht zu bekommen. Die meisten Menschen schieben unangenehme Briefe wochenlang vor sich her — weil sie nicht wissen wie man das formuliert. Dieses Pack gibt dir 25 fertige Musterbriefe für die häufigsten Alltagssituationen.</p>
          <p style={{ color: '#374151', lineHeight: '1.7', margin: 0 }}><strong>So gehst du vor:</strong> Den passenden Brief wählen → Lücken in [eckigen Klammern] ausfüllen → Datum und Unterschrift hinzufügen → Ausdrucken und abschicken.</p>
        </div>

        {/* Tipps */}
        <div style={s.tipBox}>
          <strong>Wichtige Tipps für alle Briefe:</strong>
          <ul style={{ margin: '8px 0 0', paddingLeft: '20px', color: '#374151', fontSize: '0.875rem', lineHeight: '1.8' }}>
            <li>Wichtige Briefe immer als <strong>Einschreiben</strong> schicken (kostet ca. 3-5 Euro, Quittung aufheben)</li>
            <li>Widersprüche müssen meist <strong>innerhalb eines Monats</strong> eingelegt werden</li>
            <li>Immer eine <strong>Kopie</strong> des Briefes behalten</li>
            <li>Anlagen: immer <strong>Kopien</strong> schicken, niemals Originale</li>
          </ul>
        </div>

        {/* Alle Briefe */}
        {bereiche.map((bereich) => (
          <div key={bereich.titel}>
            <h2 style={s.h2}>{bereich.titel}</h2>
            {bereich.briefe.map((brief) => (
              <div key={brief.nr} style={s.briefBox}>
                <div style={s.briefTitel}>
                  <span style={s.briefNr}>Brief {brief.nr}</span>
                  {brief.titel}
                </div>
                <pre style={s.pre}>{brief.text}</pre>
              </div>
            ))}
          </div>
        ))}

        {/* Footer */}
        <p style={{ textAlign: 'center', color: '#9ca3af', fontSize: '0.75rem', borderTop: '1px solid #e5e7eb', paddingTop: '16px', marginTop: '32px' }}>
          Musterbriefe Pack für Senioren · 19 Euro · Einmalzahlung · Alle Briefe dienen als Orientierung. Bei rechtlich komplexen Fällen empfiehlt sich zusätzliche Beratung.
        </p>

      </div>
      <style>{`.no-print {} @media print { .no-print { display: none !important; } }`}</style>
    </div>
  )
}
