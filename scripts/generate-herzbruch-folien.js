// generate-herzbruch-folien.js
// 42 PPTX-Dateien — eine pro Lektion, eine Folie, Sprechertext in den Notizen

const pptxgen = require("pptxgenjs");
const path    = require("path");
const fs      = require("fs");

const OUT_DIR   = "C:\\Users\\andre\\claude-workspace-vorlage\\outputs\\kurse\\herzbruch-notfall-kurs\\folien";
const TEXTE_MD  = "C:\\Users\\andre\\claude-workspace-vorlage\\outputs\\kurse\\herzbruch-notfall-kurs\\sprechertexte.md";

const BG     = "3D0A1A";
const GOLD   = "C9952A";
const WHITE  = "FFFFFF";
const LIGHT  = "F0D8D8";

// Sprechertexte parsen
function parseTexte(file) {
  const lines = fs.readFileSync(file, "utf8").split("\n");
  const result = {};
  let m = null, l = null, buf = [];
  for (const line of lines) {
    const mm = line.match(/^## MODUL (\d+):/);
    const ll = line.match(/^### L(\d+):/);
    if (mm) { if (m&&l) { if (!result[m]) result[m]={}; result[m][l]=buf.join("\n").trim(); } m=+mm[1]; l=null; buf=[]; }
    else if (ll) { if (m&&l) { if (!result[m]) result[m]={}; result[m][l]=buf.join("\n").trim(); } l=+ll[1]; buf=[]; }
    else if (!line.startsWith("---") && !line.startsWith("#")) buf.push(line);
  }
  if (m&&l) { if (!result[m]) result[m]={}; result[m][l]=buf.join("\n").trim(); }
  return result;
}

const TEXTE = parseTexte(TEXTE_MD);

function slug(s) {
  return s.toLowerCase()
    .replace(/ä/g,"ae").replace(/ö/g,"oe").replace(/ü/g,"ue").replace(/ß/g,"ss")
    .replace(/[^a-z0-9]+/g,"-").replace(/^-|-$/g,"").substring(0,40);
}

const MODULE = [
  { nr:1, lektionen:[
    { titel:"Realitaets-Check",            sub:"Was ist passiert, was brauchst du jetzt?",   bullets:["Ehrlich hinschauen: Wie geht es dir wirklich?","Trennungsschmerz ist real. Kein Zeichen von Schwäche.","Ziel: Stabilität, nicht Strategie"] },
    { titel:"Stabil bleiben",              sub:"24 bis 72h Notfall-Rituale",                  bullets:["Atmen: 4 ein, 7 halten, 8 aus","Körper: essen, trinken, hinlegen","Umgebung: Trigger vorerst meiden"] },
    { titel:"Sicherheitsnetz",             sub:"SOS-Kontakte, Trigger meiden, Regeln",       bullets:["2 bis 3 Menschen wählen die du anrufen kannst","3 größte Trigger identifizieren und meiden","1 klare Regel für heute festlegen"] },
    { titel:"Journaling und Tracking",     sub:"Gefühlstagebuch und Mini-Ziele starten",     bullets:["Wie habe ich mich gefühlt? (1 bis 10)","Was war der schwerste Moment?","Was hat mir heute geholfen?"] },
    { titel:"Kontakt-Stopp",               sub:"72h ohne Kontakt und digitale Hygiene",      bullets:["Kontaktdrang ist Entzug, keine Liebe","Jeder Blick aufs Profil beginnt den Entzug neu","Dein Nervensystem braucht Pause"] },
    { titel:"Wenn es zu viel wird",        sub:"Warnsignale erkennen und Hilfe holen",       bullets:["3 Tage oder mehr kein Schlafen oder Essen","Gedanken an Selbstverletzung","Griff zu Alkohol oder Substanzen täglich"] }
  ]},
  { nr:2, lektionen:[
    { titel:"Bindungssystem und Entzug",   sub:"Dein Gehirn im Ausnahmezustand",             bullets:["Trennung aktiviert dieselben Areale wie körperlicher Schmerz","Oxytocin, Dopamin: dieselben Systeme wie bei Sucht","Das ist kein Versagen. Das ist Neurobiologie."] },
    { titel:"Trauer ist zyklisch",         sub:"Phasen, Wellen und was normal ist",          bullets:["Trauer kommt in Wellen, nicht linear","Phasen wechseln sich ab und überlappen sich","Keine Welle dauert ewig"] },
    { titel:"Grübelschleifen entzaubern",  sub:"Kognitive Verzerrungen erkennen",            bullets:["'Nie', 'immer', 'alle': das sind Verzerrungen","Gedanken unter Stress sind keine Fakten","Benennen schafft Abstand"] },
    { titel:"Nervensystem regulieren",     sub:"Fight, Flight, Freeze, Fawn beruhigen",      bullets:["Fight: Wut, Nachrichten schicken","Freeze: Erstarrung, keine Entscheidungen möglich","Fawn: Entschuldigen, Beschwichtigen"] },
    { titel:"Koerperliche Symptome",       sub:"Appetit, Schlaf, Energie",                   bullets:["Cortisol unterdrückt Hunger und stört Schlaf","Erschöpfung ohne Aktivität ist normal","Dein Körper kämpft. Das kostet Kraft."] },
    { titel:"Richtige Hilfe waehlen",      sub:"Freunde, Beratung, Therapie",                bullets:["Freunde: Rückhalt, aber nicht objektiv","Beratungsstellen: oft kostenlos, schnell erreichbar","Therapie: wenn Symptome über 6 Wochen andauern"] }
  ]},
  { nr:3, lektionen:[
    { titel:"Akut-Schlafprotokoll",        sub:"3 Säulen für heute Nacht",                   bullets:["Kein Handy 1h vor dem Schlafen","Zimmer kühlen: 17 bis 20 Grad","3 Minuten alles aufschreiben, Gedanken raus"] },
    { titel:"Essen und Trinken",           sub:"Minimal-Standards und Rettungsmahlzeiten",   bullets:["Dreimal täglich etwas essen","Protein und Kohlenhydrate statt Zucker","Kein Alkohol. Er verstärkt Cortisol und stört den Schlaf."] },
    { titel:"Sofort regulieren",           sub:"TIPP, 4-7-8, Orientierung im Raum",         bullets:["Kälte: Wasser ins Gesicht aktiviert den Tauchreflex sofort","4-7-8-Atmung beruhigt den Vagusnerv in Minuten","5-4-3-2-1: Sinne im Raum verankern"] },
    { titel:"Bewegung und Tageslicht",     sub:"20-Minuten-Reset",                           bullets:["20 Minuten Gehen senkt Cortisol messbar","Tageslicht reguliert Schlafrhythmus und Stimmung","Draußen ist besser, drinnen geht auch"] },
    { titel:"Alkohol Koffein Social Media",sub:"Was gerade alles schlimmer macht",           bullets:["Alkohol: kurzfristig betäubt, langfristig verstärkt","Koffein nach 14 Uhr stellt schlechten Schlaf noch schlechter","Social Media: jeder Ex-Check setzt Heilung zurück"] },
    { titel:"Panik-Toolbox",               sub:"Bodyscan, Kälte, Self-Talk",                 bullets:["Bodyscan: Aufmerksamkeit vom Kopf in den Körper","Kälte: schnellste physiologische Beruhigung","Self-Talk: Das ist schmerzhaft und ich überstehe es"] }
  ]},
  { nr:4, lektionen:[
    { titel:"Kontaktpause durchhalten",    sub:"No Contact und Low Contact",                 bullets:["Das Gehirn findet immer einen Grund zu schreiben","No Contact: kein Schreiben, kein Schauen, kein Vorbeifahren","Low Contact: nur das Notwendige, sachlich, kurz"] },
    { titel:"Trigger-Management",          sub:"Orte, Objekte, Routinen",                    bullets:["Trigger sind gespeicherte Erinnerungen, keine Schwäche","Vermeiden, anpassen oder konfrontieren: du entscheidest","Mit Zeit verlieren sie ihre Kraft"] },
    { titel:"Gedankenkreisen stoppen",     sub:"Worry-Time, Noting, Reframing",              bullets:["Worry-Time: 15 Min täglich bewusst grübeln, dann verschieben","Noting: Gedanken benennen, z.B. Grübeln oder Selbstzweifel","Reframing: realistisch statt positiv umformulieren"] },
    { titel:"Digital-Detox",              sub:"Ex stummschalten, Feed säubern",              bullets:["Ex auf allen Plattformen stummschalten","Paar-Content von Bekannten ausblenden","Feed bewusst mit anderen Themen füllen"] },
    { titel:"Selbstmitgefühl",             sub:"Emotionssurfing in 10 Minuten",              bullets:["Mit dir umgehen wie mit einem Freund","Emotion beobachten: Wo? Wie groß? Wie verändert sie sich?","Emotionen die beobachtet werden, verlieren ihre Kraft"] },
    { titel:"Grenzen kommunizieren",       sub:"Kurze Formulierungen fürs Umfeld",           bullets:["Ich brauche jemanden der zuhört, keine Ratschläge","Ich möchte heute nicht darüber reden","Ich komme auf dich zu wenn ich bereit bin"] }
  ]},
  { nr:5, lektionen:[
    { titel:"Kommunikationsleitfäden",     sub:"Für nötigen Kontakt",                        bullets:["Schriftlich statt mündlich: gibt Zeit zum Formulieren","Sachlich und kurz: nur das Notwendige","Keine Kritik und keine Verteidigung"] },
    { titel:"Besitz Schlüssel Haustiere",  sub:"Faire Übergaben planen",                     bullets:["Liste: Was gehört dir, was muss geteilt werden?","Schlüssel so schnell wie möglich klären","Übergaben: neutral, kurz, mit Begleitung wenn möglich"] },
    { titel:"Accounts und Passwoerter",    sub:"Zugänge trennen, Datenschutz",               bullets:["Alle Passwörter ändern wo er oder sie Zugang hatte","Streaming, Cloud, gemeinsame E-Mails trennen","Ortungsdienste deaktivieren"] },
    { titel:"Alltagsstruktur neu ordnen",  sub:"Kleines macht Großes",                       bullets:["Ein Möbelstück umstellen oder neues Element hinzufügen","Neue Routinen für Abende und Wochenenden","Räume die schon immer deins waren: dort öfter sein"] },
    { titel:"Finanz-Quickcheck",           sub:"Nichts vergessen",                           bullets:["Gemeinsames Konto: Zugriffe klären oder trennen","Verträge: Mietvertrag, Strom, Versicherungen","Steuern bei Ehe: Steuerberater konsultieren"] },
    { titel:"Erinnerungen managen",        sub:"Box, Archiv, digitale Ordnung",              bullets:["Nicht sofort löschen. Das ist eine Entscheidung für später.","Fotos in separaten Ordner, aus dem täglichen Sichtfeld","Physische Gegenstände in eine Box, zu, ins Regal"] }
  ]},
  { nr:6, lektionen:[
    { titel:"Tagesstruktur 2.0",           sub:"Morgen-, Abend- und SOS-Anker",             bullets:["Morgenanker: eine kleine Handlung, kein Handy zuerst","Abendanker: eine Handlung die den Tag abschließt","SOS-Anker: für plötzlich schwere Momente"] },
    { titel:"Support-Netzwerk aktivieren", sub:"1 bis 3 verlässliche Menschen",              bullets:["Du brauchst keine große Community, 1 bis 3 reichen","Sag ihnen was du brauchst: Zuhören, Ablenkung, Präsenz","Verbindung ist biologisch notwendig für Heilung"] },
    { titel:"Mini-Freuden-Liste",          sub:"Was war immer schon deins?",                 bullets:["10 bis 20 Dinge die dir Freude machten, unabhängig von der Beziehung","Jeden Tag: eine Sache aus der Liste","Nicht als Ablenkung, sondern als Erinnerung wer du bist"] },
    { titel:"Sinn und Werte",              sub:"Kompass statt Chaos",                        bullets:["5 Dinge die dir wirklich wichtig sind","Welche waren in der Beziehung erfüllt?","Welche willst du mehr von?"] },
    { titel:"Energiepflege",               sub:"Schlaf, Ernährung, Bewegung",                bullets:["Schlaf: gleiche Aufstehzeit auch am Wochenende","Ernährung: morgens Protein stabilisiert für Stunden","Bewegung: 10 Minuten täglich schlagen 60 Minuten einmal"] },
    { titel:"Momentum aufbauen",           sub:"Micro-Ziele, Wins tracken, Rückblick",      bullets:["Wo warst du in Woche 1? Wo bist du jetzt?","Micro-Ziele: klein, erreichbar, konkret","Jeden Abend: eine Sache aufschreiben die gut lief"] }
  ]},
  { nr:7, lektionen:[
    { titel:"Fortschritt messen",          sub:"Skalen, Marker, Meilensteine",               bullets:["Wöchentlich bewerten: 1 bis 10 wie geht es dir?","Marker notieren wenn sie auftauchen","Trend zeigt was das Tagesgefühl nicht kann"] },
    { titel:"Rückfallplan",                sub:"Kontaktdrang, Triggertage, Feiertage",       bullets:["Welche Daten der nächsten 6 Monate sind schwer?","Was machst du konkret an diesem Tag?","Vorbereitung schafft den Unterschied"] },
    { titel:"Regeln ab Tag 30",            sub:"Ex-Kontakt, Dating, Social Media",           bullets:["Ex-Kontakt: weiter kein Kontakt wenn nicht notwendig","Dating: Ablenkung oder Bereitschaft? Ehrlich sein.","Social Media: Ex sichtbar wenn es nicht destabilisiert"] },
    { titel:"4-Wochen-Nachsorgeplan",      sub:"Nach dem Kurs geht es weiter",               bullets:["Körper: eine körperliche Routine beibehalten","Geist: Journaling oder wöchentlicher Check-in","Verbindung: ein echtes Gespräch pro Woche"] },
    { titel:"FAQ Stolpersteine",           sub:"Häufige Fragen und Lösungen",                bullets:["Wie lange? 3 Monate Akutschmerz, danach langsam besser","Er oder sie kommt zurück: Was willst du? Nicht reagieren.","Trauer hört nicht auf: nach 6 Wochen professionelle Hilfe"] },
    { titel:"Ressourcen und Notfallkarte", sub:"Zum Ausdrucken",                             bullets:["Deine SOS-Kontakte","Deine 3 Regulationstechniken","Telefonseelsorge: 0800 111 0 111"] }
  ]}
];

async function createFile(modul, lnr, lekt) {
  const pres = new pptxgen();
  pres.layout = "LAYOUT_16x9";

  const slide = pres.addSlide();
  slide.background = { color: BG };

  // Gold-Streifen links
  slide.addShape(pres.shapes.RECTANGLE, { x:0, y:0, w:0.12, h:5.625, fill:{color:GOLD}, line:{color:GOLD} });

  // Modul-Tag
  slide.addText(`MODUL ${modul.nr}  ·  LEKTION ${lnr}`, {
    x:0.4, y:0.25, w:9.2, h:0.4,
    fontSize:11, color:GOLD, bold:true, charSpacing:3, fontFace:"Calibri", align:"left"
  });

  // Trennlinie
  slide.addShape(pres.shapes.RECTANGLE, { x:0.4, y:0.72, w:9.0, h:0.03, fill:{color:GOLD}, line:{color:GOLD} });

  // Titel
  slide.addText(lekt.titel, {
    x:0.4, y:0.85, w:9.2, h:1.1,
    fontSize:36, color:WHITE, bold:true, fontFace:"Calibri", align:"left"
  });

  // Untertitel
  slide.addText(lekt.sub, {
    x:0.4, y:1.95, w:9.2, h:0.5,
    fontSize:17, color:LIGHT, italic:true, fontFace:"Calibri", align:"left"
  });

  // Bullets
  const items = lekt.bullets.map((b, i) => ({
    text: b,
    options: { bullet:true, breakLine: i < lekt.bullets.length-1, color:WHITE, fontSize:19, fontFace:"Calibri", paraSpaceAfter:12 }
  }));
  slide.addText(items, { x:0.5, y:2.55, w:9.0, h:2.8, valign:"top" });

  // Sprechernotizen — max 950 Zeichen, sauber am letzten Satzende kuerzen
  let notes = (TEXTE[modul.nr] && TEXTE[modul.nr][lnr]) || "";
  if (notes.length > 950) {
    const cut = notes.substring(0, 950);
    const lastDot = Math.max(cut.lastIndexOf(". "), cut.lastIndexOf(".\n"), cut.lastIndexOf("! "), cut.lastIndexOf("? "));
    notes = lastDot > 600 ? cut.substring(0, lastDot + 1) : cut.substring(0, 950);
  }
  if (notes) slide.addNotes(notes);

  const fname = `m${modul.nr}-l${lnr}-${slug(lekt.titel)}.pptx`;
  await pres.writeFile({ fileName: path.join(OUT_DIR, fname) });
  console.log(`  OK: ${fname}`);
}

function slug(s) {
  return s.toLowerCase()
    .replace(/ä/g,"ae").replace(/ö/g,"oe").replace(/ü/g,"ue").replace(/ß/g,"ss")
    .replace(/[^a-z0-9]+/g,"-").replace(/^-|-$/g,"").substring(0,40);
}

(async () => {
  let total = MODULE.reduce((s,m) => s + m.lektionen.length, 0);
  console.log(`\nGeneriere ${total} PPTX-Dateien (1 Folie pro Lektion)...\n`);
  for (const m of MODULE) {
    console.log(`Modul ${m.nr}:`);
    for (let i = 0; i < m.lektionen.length; i++) {
      await createFile(m, i+1, m.lektionen[i]);
    }
  }
  console.log(`\nFertig! ${total} Dateien in:\n${OUT_DIR}`);
})();
