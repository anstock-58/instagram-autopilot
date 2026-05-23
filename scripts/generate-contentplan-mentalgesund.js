// Generiert contentplan_andi_mentalgesund_mai_v1.csv + juni_v1.csv
// Thema: Mentale Gesundheit, Grenzen setzen, People-Pleasing
// Produkt: "Nein aus Überzeugung" — 37€ — https://sicher-weiterlesen.com/nein-aus-überzeugung

const fs = require('fs');
const path = require('path');

const outputDir = path.join('C:/Users/andre/claude-workspace-vorlage/outputs');
const link = 'https://sicher-weiterlesen.com/nein-aus-ueberzeugung';

const header = 'Datum,Uhrzeit,Plattform,Post-Typ,Text,Link,Bild-URL,Bildprompt,Videoprompt,Text-Overlay,Karussell-Slides,Status';

// ─── Bildprompt Varianten (für Stories mit Foto) ─────────────────────
const bildPrompts = [
  'A distinguished European man in his early 60s, silver-gray hair, calm but tired face, sitting alone at a kitchen table with a coffee cup, morning light through window, photorealistic, warm tones, 9:16 vertical',
  'A thoughtful European woman in her 50s, short brunette hair, sitting in a quiet garden, looking into the distance, soft afternoon light, photorealistic, peaceful atmosphere, 9:16 vertical',
  'A mature European man in his late 50s, salt-and-pepper hair, standing at a window looking outside, slightly weary expression, natural indoor light, photorealistic, 9:16 vertical',
  'A European man in his early 60s, reading glasses, silver hair, sitting in a comfortable armchair with a book open on his lap, contemplative expression, warm lamp light, photorealistic, 9:16 vertical',
  'A European woman in her mid 50s, blonde hair with gray, sitting at a desk with hands folded, calm determined expression, natural light, professional setting, photorealistic, 9:16 vertical',
  'A mature European man, short gray beard, sitting on a park bench, quiet autumn scene, thoughtful and at peace, photorealistic, 9:16 vertical',
];

// ─── Videoprompt Varianten (für Reels als B-Roll) ────────────────────
const videoPrompts = [
  'Cinematic B-Roll, slow motion shot of a person walking alone on a quiet path through a forest, early morning mist, peaceful and reflective mood, 9:16 vertical, photorealistic',
  'Cinematic B-Roll, close up of hands slowly unclenching from a tight fist, symbolic of letting go, soft natural light, 9:16 vertical, photorealistic',
  'Cinematic B-Roll, a person sitting at a desk, leaning back and exhaling deeply, visible relief on their face, warm office light, 9:16 vertical',
  'Cinematic B-Roll, slow motion of a person opening a window and breathing in fresh air, morning light, sense of freedom, 9:16 vertical, photorealistic',
  'Cinematic B-Roll, a mature person looking in a mirror with a calm, self-assured expression, bathroom morning light, photorealistic, 9:16 vertical',
  'Cinematic B-Roll, a person shaking their head slowly with a gentle smile, symbolic of saying no, neutral background, soft light, 9:16 vertical',
  'Cinematic B-Roll, two people talking at a café table, one person is calm and speaks clearly, the other listens, warm afternoon light, 9:16 vertical',
  'Cinematic B-Roll, a person alone in a quiet room, writing in a journal by lamplight, thoughtful expression, 9:16 vertical, photorealistic',
  'Cinematic B-Roll, slow zoom out from a single candle flame to a calm, dimly lit room, symbolic of inner peace, 9:16 vertical',
  'Cinematic B-Roll, a person standing at a crossroads on a quiet street, looking left and right, decisive expression, overcast sky, 9:16 vertical',
];

// ─── Reel-Texte ───────────────────────────────────────────────────────
const reelTexte = [
  // 24.05
  `Du sagst Ja.
Obwohl du Nein meinst.

Nicht weil du keine Meinung hast.
Sondern weil du weißt was passiert wenn du Nein sagst. 💡

Das schlechte Gewissen. Die Reaktionen. Das Gefühl, jemanden enttäuscht zu haben.

Also sagst du wieder Ja.

Das ist kein Charakter-Fehler.
Das ist ein erlerntes Muster. Und Muster lassen sich verändern.

Wenn das bei dir gerade so klingt: schreib NEIN in die Kommentare.

#GrenzenSetzen #MentaleGesundheit #NeinSagen`,

  // 25.05
  `Der Unterschied zwischen Freundlichkeit und Selbstaufgabe.

Freundlichkeit: Du gibst, weil du es willst.
Selbstaufgabe: Du gibst, weil du Angst hast was passiert wenn du es nicht tust. 🎯

Beide sehen von außen gleich aus.
Nur du weißt was wirklich dahintersteckt.

Und dein Körper weiß es auch.
Erschöpfung. Anspannung. Das Gefühl nie wirklich frei zu sein.

Das lässt sich ändern. Ohne dass du jemanden verletzt.

Schreib NEIN in die Kommentare. Ich zeig dir wie.

#MentaleGesundheit #GrenzenSetzen #Selbstfürsorge`,

  // 26.05
  `Warum du nachts nicht abschaltest.

Dein Kopf läuft weiter wenn der Tag eigentlich vorbei ist.
Was hätte ich anders sagen sollen.
Habe ich zu viel zugesagt.
Was denken die anderen jetzt von mir.

Das ist kein Schlafproblem. 💡
Das ist ein Erschöpfungsproblem.

Wenn du den ganzen Tag für andere funktionierst bleibt keine Energie mehr für dich.
Der Abend wird zur Aufräumzeit für alles was du tagsüber nicht gefühlt hast.

Das muss nicht so sein.

Schreib NEIN in die Kommentare. Ich zeig dir den Weg raus.

#Grübeln #Erschöpfung #NeinSagen`,

  // 27.05
  `Grenzen setzen ist kein Egoismus.

Egoismus bedeutet: ich nehme mir was ich will auf Kosten anderer.
Grenzen setzen bedeutet: ich höre auf mich zu verlieren während ich für andere da bin. 🎯

Das ist ein riesiger Unterschied.

Wer keine Grenzen hat gibt nicht mehr — er gibt einfach weiter bis nichts mehr da ist.

Und dann bricht er zusammen. Oder er wird bitter. Oder er zieht sich zurück.

Das willst du nicht.
Das musst du auch nicht.

Schreib NEIN in die Kommentare. Ich zeig dir den Unterschied.

#GrenzenSetzen #MentaleGesundheit #Selbstfürsorge`,

  // 28.05
  `Was passiert wenn du aufhörst, es allen recht zu machen.

Kurzzeitig: Unruhe. Schuldgefühle. Das Gefühl falsch zu liegen.

Mittelfristig: Klarheit. Energie. Beziehungen die echter sind. 💡

Langfristig: Du erkennst dich selbst wieder.

Ich sage dir nicht dass es einfach ist.
Ich sage dir dass es sich lohnt.

Und ich sage dir: die meisten die diesen Weg gehen können sich nicht vorstellen wie sie vorher gelebt haben.

Schreib NEIN in die Kommentare. Fangen wir damit an.

#MentaleGesundheit #GrenzenSetzen #Veränderung`,

  // 29.05
  `Das schlechte Gewissen nach einem Nein.

Es ist normal.
Es ist sogar ein gutes Zeichen.

Es zeigt dass du ein Mensch bist der sich um andere sorgt.
Nicht dass du falsch gelegen hast. 🎯

Das Problem ist: die meisten interpretieren dieses Gefühl als Signal.
Als ob es sagt: geh zurück. Sag doch Ja. Entschuldige dich.

Aber das Gegenteil ist richtig.
Das Gefühl ist der Übergang. Nicht die Botschaft.

Schreib NEIN in die Kommentare. Ich begleite dich durch den Übergang.

#GrenzenSetzen #SchlechtesGewissen #NeinSagen`,

  // 30.05
  `Du erschöpfst dich für Menschen die deine Erschöpfung nicht sehen.

Das klingt hart.
Aber es ist die Wahrheit vieler.

Du gibst hundert Prozent.
Du hältst Dinge zusammen.
Du bist der Ruhepol für alle anderen.

Und innerlich bist du leer. 💡

Das ist kein Vorwurf an die anderen.
Das ist ein Hinweis auf ein Muster das du selbst verändern kannst.

Schreib NEIN in die Kommentare. Wir fangen jetzt an.

#Erschöpfung #MentaleGesundheit #Selbstfürsorge`,

  // 31.05
  `Monat vorbei. Wie geht es dir wirklich?

Nicht die Antwort für andere.
Die ehrliche.

Bist du erschöpft?
Hast du dich zu oft verbogen?
Hast du Nein gemeint und Ja gesagt?

Wenn ja: du bist nicht allein.
Und du musst es nicht so weiterführen. 🎯

Im nächsten Monat kannst du damit anfangen das zu ändern.
Schritt für Schritt. Ohne alles auf den Kopf zu stellen.

Schreib NEIN in die Kommentare. Ich zeig dir den ersten Schritt.

#Monatsende #MentaleGesundheit #GrenzenSetzen`,

  // 01.06
  `Ein neuer Monat.

Viele nehmen sich vor: mehr Sport. Besser essen. Früher schlafen.

Wie wäre es mit: öfter Nein sagen.

Nicht laut. Nicht dramatisch.
Einfach klar. 💡

Ein Nein heute ist eine Stunde Energie morgen.
Ein Nein heute ist ein ehrliches Ja übermorgen.

Wenn du diesen Monat anfangen willst dich selbst ernst zu nehmen: schreib NEIN in die Kommentare.

#JuniStart #NeinSagen #MentaleGesundheit`,

  // 02.06
  `Warum People-Pleasing so erschöpft.

Weil du nie weißt was du wirklich willst.
Du orientierst dich immer daran was andere brauchen.

Dein innerer Kompass zeigt auf: die anderen. 🎯

Irgendwann weißt du nicht mehr wo du selbst aufhörst und die Erwartungen der anderen anfangen.

Das ist nicht schwach.
Das ist ein Muster das du einmal gelernt hast weil es geholfen hat.

Jetzt hilft es dir nicht mehr.

Schreib NEIN in die Kommentare. Ich zeig dir den Weg zurück zu dir.

#PeoplePleasing #MentaleGesundheit #GrenzenSetzen`,

  // 03.06
  `Du hast gelernt dass Harmonie Priorität hat.

Als Kind vielleicht. In der Familie. Im Job.

Nicht streiten. Nicht auffallen. Nicht enttäuschen.

Das war einmal klug.
Jetzt kostet es dich Energie die du brauchst. 💡

Grenzen setzen bedeutet nicht: Harmonie zerstören.
Es bedeutet: eine Harmonie aufbauen die auch für dich funktioniert.

Schreib NEIN in die Kommentare. Wir fangen an.

#GrenzenSetzen #MentaleGesundheit #Selbstfürsorge`,

  // 04.06
  `Die Menschen in deinem Leben die wirklich zu dir passen respektieren dein Nein.

Die die es nicht respektieren: die wollten nicht dich.
Die wollten was du für sie tust.

Das klingt hart.
Aber es ist befreiend wenn du es einmal siehst. 🎯

Ein Nein filtert.
Und Filtern ist gut.

Schreib NEIN in die Kommentare. Ich zeig dir wie.

#NeinSagen #Beziehungen #GrenzenSetzen`,

  // 05.06
  `Wie ein Nein aussehen kann ohne Drama.

Satz eins: Ich kann das gerade nicht übernehmen.
Satz zwei: Ich melde mich wenn sich das ändert.

Fertig. 💡

Keine Entschuldigung. Keine Begründung. Kein Roman.

Du schuldest niemanden eine Erklärung warum du eine Grenze setzt.

Das ist das erste was viele lernen müssen.

Schreib NEIN in die Kommentare. Ich zeig dir mehr davon.

#NeinSagen #GrenzenSetzen #Kommunikation`,

  // 06.06
  `Erschöpfung ist oft kein Energieproblem.

Es ist ein Grenzenproblem.

Du hast genug Energie.
Aber du gibst sie überall hin außer zu dir selbst. 🎯

Mehr Schlaf hilft kurz.
Mehr Urlaub hilft kurz.
Grenzen setzen hilft dauerhaft.

Schreib NEIN in die Kommentare. Wir fangen heute an.

#Erschöpfung #GrenzenSetzen #MentaleGesundheit`,

  // 07.06
  `Woche eins. Was hast du diese Woche für dich getan?

Nicht für den Job.
Nicht für die Familie.
Für dich. 💡

Wenn die Antwort nichts ist: das ist der Startpunkt.

Nicht Vorwurf. Nicht Drama.
Einfach ein ehrlicher Blick.

Und dann ein kleiner Schritt.

Schreib NEIN in die Kommentare. Dein erster Schritt beginnt heute.

#Selbstfürsorge #MentaleGesundheit #Wochenreflexion`,

  // 08.06
  `Was du im Kurs lernst. Konkret.

Tag 1: Woher kommt dein Ja-Reflex. Was hat ihn einmal sinnvoll gemacht.

Tag 2: Wie du merkst wenn dein Körper Nein sagt. Die Signale die du lernst zu ignorieren. 🎯

Tag 3: Dein erstes kleines Nein. Ohne Schuld. Mit Klarheit.

Tag 4: Was mit deinen Beziehungen passiert wenn du Grenzen setzt.

Tag 5: Dein Nein als dauerhafte Praxis. Nicht als einmaliger Akt.

Fünf Tage. Ein echter Unterschied.

Schreib NEIN in die Kommentare. Ich schick dir alle Details.

#NeinAusUeberzeugung #Kurs #GrenzenSetzen`,

  // 09.06
  `Du hast gelernt: nur wer kämpft verdient Ruhe.

Also kämpfst du.
Immer.
Für andere. Für den Job. Für die Familie.

Und die Ruhe: die kommt irgendwann. Später. Wenn alles erledigt ist.

Aber alles ist nie erledigt. 💡

Ruhe ist kein Verdienst.
Ruhe ist ein Recht.

Schreib NEIN in die Kommentare. Hol dir dein Recht zurück.

#MentaleGesundheit #Erschöpfung #NeinSagen`,

  // 10.06
  `Warum dein Körper schon lange Nein sagt.

Verspannungen. Schlafprobleme. Gereiztheit ohne klaren Grund.

Das ist kein Zufall.
Das ist dein System das sagt: so geht das nicht weiter. 🎯

Der Körper lügt nicht.
Er hält einfach länger aus als gut für ihn ist.

Irgendwann hört er auch damit auf.

Hör hin bevor das passiert.

Schreib NEIN in die Kommentare. Ich zeig dir wie das geht.

#Körpersignale #MentaleGesundheit #GrenzenSetzen`,

  // 11.06
  `Du entschuldigst dich zu oft.

Für Meinungen die du hast.
Für Bedürfnisse die du äußerst.
Für Entscheidungen die du triffst. 💡

Eine Entschuldigung ist für Fehler.
Nicht für das Existieren.

Das ist ein kleiner Satz mit großer Wirkung.

Schreib NEIN in die Kommentare. Fangen wir damit an.

#GrenzenSetzen #NeinSagen #MentaleGesundheit`,

  // 12.06
  `Was passiert wenn die erste Provision — äh, das erste echte Nein kommt.

Unruhe. Schuldgefühle. Warten auf die Reaktion.

Und dann?

Meistens: nichts Schlimmes.
Manchmal: eine Reaktion die zeigt wer wirklich hinter dir steht. 🎯

Das erste Nein ist das schwerste.
Das zweite ist leichter.
Ab dem dritten merkst du: ich kann das.

Schreib NEIN in die Kommentare. Ich begleite dich zum ersten.

#NeinSagen #GrenzenSetzen #ErsterSchritt`,

  // 13.06
  `Der Unterschied zwischen einer Erklärung und einer Entschuldigung.

Erklärung: Ich kann das nicht übernehmen weil meine Kapazität gerade voll ist.
Entschuldigung: Es tut mir so leid ich weiß das ist ungünstig aber vielleicht geht es ja doch irgendwie...

Hörst du den Unterschied? 💡

Die Erklärung setzt eine Grenze.
Die Entschuldigung untergräbt sie sofort wieder.

Schreib NEIN in die Kommentare. Ich zeig dir wie das in der Praxis aussieht.

#Kommunikation #GrenzenSetzen #NeinSagen`,

  // 14.06
  `Halbzeit im Monat. Kurze Frage.

Wie oft hast du in den letzten zwei Wochen Ja gesagt obwohl du Nein gemeint hast?

Einmal? Dreimal? Täglich? 🎯

Ich frage nicht um zu urteilen.
Ich frage weil die Antwort zeigt wie viel Energie gerade woanders landet als bei dir.

Wenn das zu viel ist: jetzt ist ein guter Zeitpunkt etwas daran zu ändern.

Schreib NEIN in die Kommentare. Ich zeig dir den Weg.

#Selbstreflexion #GrenzenSetzen #MentaleGesundheit`,

  // 15.06
  `Grenzen setzen bedeutet nicht: die anderen raushalten.

Es bedeutet: dich selbst reinhalten.

Deine Energie. Deine Zeit. Deine Aufmerksamkeit. 💡

Wenn du keine Grenzen hast fließt alles raus.
Mit Grenzen hast du etwas zum Geben übrig.

Klingt paradox.
Ist es nicht.

Schreib NEIN in die Kommentare. Ich erkläre es dir.

#GrenzenSetzen #Selbstfürsorge #MentaleGesundheit`,

  // 16.06
  `Wer dir sagt dass du egoistisch bist wenn du Nein sagst.

Der hat profitiert davon dass du immer Ja gesagt hast. 🎯

Nicht böse gemeint. Oft nicht mal bewusst.

Aber das zeigt dir was.

Ein Nein das echte Beziehungen kostet war keine echte Beziehung.

Schreib NEIN in die Kommentare. Ich zeig dir mehr.

#NeinSagen #GrenzenSetzen #Beziehungen`,

  // 17.06
  `Du bist nicht verantwortlich für die Gefühle anderer.

Du bist verantwortlich dafür wie du mit ihnen umgehst.
Nicht dafür was sie fühlen.

Das ist ein riesiger Unterschied. 💡

Viele tragen die Stimmungen und Reaktionen aller anderen wie eine Last.

Das ist zu viel.
Und es ist nicht deine Last.

Schreib NEIN in die Kommentare. Wir sortieren das gemeinsam.

#Verantwortung #GrenzenSetzen #MentaleGesundheit`,

  // 18.06
  `Warum du andere nicht enttäuschst wenn du Grenzen setzt.

Du enttäuschst eine Erwartung.
Nicht einen Menschen. 🎯

Und Erwartungen die keine Grenzen kennen — die gehören hinterfragt.

Nicht von dir.
Von denen die sie haben.

Schreib NEIN in die Kommentare. Das ist ein wichtiger Gedanke.

#GrenzenSetzen #NeinSagen #Erwartungen`,

  // 19.06
  `Das Muster erkennen bevor du wieder Ja sagst.

Körpergefühl: etwas zieht sich zusammen.
Gedanke: ich will nicht aber ich sollte.
Reaktion: Ja natürlich kein Problem. 💡

Zwischen Körpergefühl und Reaktion liegt ein Moment.
Dieser Moment ist deine Chance.

Den Moment nutzen lernen — das ist was der Kurs dir beibringt.

Schreib NEIN in die Kommentare. Ich schick dir alle Details.

#MustererkennenNeinSagen #GrenzenSetzen #NeinAusUeberzeugung`,

  // 20.06
  `Fünf Tage die etwas verändern können.

Nicht dein Leben von heute auf morgen.
Aber deine Beziehung zu dir selbst. 🎯

Fünf kurze Einheiten. Klarer Aufbau. Konkrete Übungen.

Am Ende weißt du: warum du immer Ja sagst. Wie du dein Nein findest. Wie du es sagst ohne Drama.

Das ist kein Motivationskurs.
Das ist ein Handwerkzeug.

Schreib NEIN in die Kommentare. Ich schick dir alle Infos.

#NeinAusUeberzeugung #Kurs #GrenzenSetzen`,

  // 21.06
  `Drei Wochen. Was du jetzt weißt.

People-Pleasing ist kein Charakter-Fehler.
Grenzen setzen ist kein Egoismus.
Ein Nein kann eine Beziehung stärken.
Dein Körper gibt dir Signale die du lernen kannst zu lesen.
Schuldgefühle nach einem Nein sind normal und vergehen. 💡

Das war viel.
Jetzt kommt der Teil wo du es übst.

Schreib NEIN in die Kommentare. Ich zeig dir wie du anfängst.

#GrenzenSetzen #NeinSagen #MentaleGesundheit`,

  // 22.06
  `Wer hat dir beigebracht dass du dich erst verdienen musst?

Ruhe verdienen.
Hilfe verdienen.
Nein sagen dürfen.

Das klingt absurd wenn man es so liest. 🎯
Aber viele funktionieren genau so.

Du musst gar nichts verdienen.
Du bist schon genug.

Schreib NEIN in die Kommentare.

#Selbstwert #GrenzenSetzen #MentaleGesundheit`,

  // 23.06
  `Die Erschöpfung sagt dir etwas.

Nicht dass du schwach bist.
Sondern dass du zu lange zu viel gegeben hast ohne aufzufüllen. 💡

Erschöpfung ist Information.
Sie zeigt wo deine Grenzen überschritten wurden.

Jetzt ist die Frage: hörst du hin?

Schreib NEIN in die Kommentare. Ich begleite dich dabei.

#Erschöpfung #GrenzenSetzen #MentaleGesundheit`,

  // 24.06
  `Wie ein klares Nein klingt.

Nicht: ich weiß nicht ob ich das schaffe...
Nicht: vielleicht geht es wenn ich irgendwie...
Nicht: ich muss erst schauen ob...

Sondern: Das geht für mich gerade nicht. 🎯

Fünf Wörter.
Kein Roman.
Keine Entschuldigung.

Einfach klar.

Schreib NEIN in die Kommentare. Ich zeig dir wie du dahin kommst.

#Klarheit #NeinSagen #GrenzenSetzen`,

  // 25.06
  `Was finanzielle Freiheit und innere Freiheit gemeinsam haben.

Beide beginnen damit dass du aufhörst dich zu verbiegen.

Einer für Geld.
Der andere für Harmonie. 💡

Wer sich immer verbeugt verliert den Aufrichtigen Rücken.
Figurativ wie wörtlich.

Schreib NEIN in die Kommentare.

#InnereFreiheit #GrenzenSetzen #NeinSagen`,

  // 26.06
  `Du hast das Recht auf eine Meinung die nicht mit der Mehrheit übereinstimmt.

Du hast das Recht auf Bedürfnisse die unbequem sind.
Du hast das Recht auf ein Nein das keine Begründung braucht. 🎯

Das sind keine Privilegien.
Das ist menschlich.

Schreib NEIN in die Kommentare. Hol dir dieses Recht zurück.

#MentaleGesundheit #GrenzenSetzen #NeinSagen`,

  // 27.06
  `Warum viele erst anfangen Grenzen zu setzen wenn es zu spät scheint.

Weil der Druck vorher noch aushaltbar war.
Weil man immer noch eine Schicht Reserven hatte.
Weil morgen bestimmt besser wird. 💡

Und dann: irgendwann nicht mehr.

Hör nicht auf dieses Signal zu warten.
Fang heute an. Auch wenn der Druck noch aushaltbar ist.

Schreib NEIN in die Kommentare.

#GrenzenSetzen #MentaleGesundheit #Jetzt`,

  // 28.06
  `Der perfekte Zeitpunkt zum Nein-Sagen.

Ist nicht wenn du ausreichend Energie hast.
Ist nicht wenn die Beziehung stabil genug ist.
Ist nicht wenn der Moment günstig ist.

Der perfekte Zeitpunkt ist: jetzt. 🎯

Weil er immer kommt.
Und weil du ihn nie als perfekt erleben wirst bis du anfängst.

Schreib NEIN in die Kommentare. Fang heute an.

#NeinSagen #GrenzenSetzen #Entscheidung`,

  // 29.06
  `Vorletzter Tag im Monat. Eine ehrliche Frage.

Was hat sich in diesem Monat für dich verändert?
Hast du ein Nein gewagt?
Hast du einen Moment gespürt wo du dich selbst ernst genommen hast? 💡

Schreib es in die Kommentare.
Ich lese jeden Eintrag.

Und falls du noch nicht angefangen hast: schreib NEIN. Heute ist noch nicht zu spät.

#Monatsreflexion #GrenzenSetzen #NeinSagen`,

  // 30.06
  `Ein Monat ist vorbei.

Wenn du angefangen hast: gut gemacht. Das war mutig.

Wenn du noch wartest: Juli ist deine nächste Chance. 🎯

Das Muster ändert sich nicht von selbst.
Aber es ändert sich wenn du anfängst.

Ein Kurs. Fünf Tage. Ein Anfang.

Schreib NEIN in die Kommentare. Ich zeig dir den ersten Schritt.

#JuliNeustart #GrenzenSetzen #NeinSagen`,
];

// ─── Story-Texte ──────────────────────────────────────────────────────
const storyTexte = [
  `Du sagst immer Ja?\nObwohl du Nein meinst?\n\nSchreib NEIN in die Kommentare.`,
  `Freundlichkeit ≠ Selbstaufgabe.\n\nDen Unterschied lernst du im Link in der Bio.`,
  `Dein Kopf läuft nachts noch?\nVielleicht ist das kein Schlafproblem.\n\nSchreib NEIN — ich erkläre es dir.`,
  `Grenzen setzen ist kein Egoismus.\nEs ist Selbstrespekt.\n\nSchreib NEIN in die Kommentare.`,
  `Was passiert wenn du aufhörst es allen recht zu machen?\nMehr als du denkst.\n\nSchreib NEIN — ich zeig's dir.`,
  `Das schlechte Gewissen nach einem Nein?\nNormal. Und es vergeht.\n\nSchreib NEIN in die Kommentare.`,
  `Du erschöpfst dich für andere.\nWann erschöpfst du dich mal für dich?\n\nSchreib NEIN — ich begleite dich.`,
  `Monat vorbei. Wie oft hast du Ja gesagt obwohl du Nein meintest?\n\nSchreib NEIN — wir ändern das.`,
  `Neuer Monat. Neue Chance.\nEin öfteres Nein verändert alles.\n\nSchreib NEIN in die Kommentare.`,
  `People-Pleasing erschöpft.\nNicht weil du zu viel gibst.\nSondern weil du dir selbst zu wenig gibst.\n\nSchreib NEIN.`,
  `Du hast gelernt: Harmonie hat Priorität.\nJetzt kostet es dich zu viel.\n\nSchreib NEIN in die Kommentare.`,
  `Menschen die dein Nein nicht respektieren?\nDie wollten nicht dich.\n\nSchreib NEIN — ich erkläre das.`,
  `Wie sieht ein Nein ohne Drama aus?\nKürzer als du denkst.\n\nSchreib NEIN — ich zeig's dir.`,
  `Erschöpfung ist oft kein Energieproblem.\nEs ist ein Grenzenproblem.\n\nSchreib NEIN in die Kommentare.`,
  `Woche 1 ist vorbei.\nWas hast du diese Woche für dich getan?\n\nSchreib NEIN — fangen wir an.`,
  `5 Tage. Konkrete Übungen. Echter Unterschied.\nDer Kurs startet wann du willst.\n\nLink in der Bio.`,
  `Dein Körper sagt schon lange Nein.\nHörst du ihm zu?\n\nSchreib NEIN in die Kommentare.`,
  `Du entschuldigst dich zu oft.\nFür Dinge die kein Fehler sind.\n\nSchreib NEIN — das ändert sich.`,
  `Erstes Nein sagen ist schwer.\nZweites leichter.\nDrittes: du merkst dass du das kannst.\n\nSchreib NEIN.`,
  `Erklärung ≠ Entschuldigung.\nDen Unterschied hörst du sofort wenn du ihn kennst.\n\nSchreib NEIN.`,
  `Halbzeit im Monat.\nWie oft Ja gesagt obwohl Nein gemeint?\n\nSchreib NEIN — wir ändern das jetzt.`,
  `Grenzen setzen bedeutet: dich selbst reinhalten.\nNicht die anderen raushalten.\n\nSchreib NEIN.`,
  `Wer sagt du bist egoistisch wenn du Nein sagst?\nDer hat profitiert von deinem Ja.\n\nSchreib NEIN.`,
  `Du bist nicht verantwortlich für die Gefühle anderer.\nFür deinen Umgang schon.\n\nSchreib NEIN.`,
  `Du enttäuschst keine Menschen wenn du Nein sagst.\nDu enttäuschst Erwartungen.\n\nSchreib NEIN.`,
  `Muster erkennen bevor du wieder Ja sagst.\nDarum geht's im Kurs.\n\nSchreib NEIN — link in der Bio.`,
  `5 Tage die dein Nein verändern.\nKonkret. Klar. Ohne Drama.\n\nLink in der Bio.`,
  `3 Wochen Inhalte.\nJetzt kommt der Teil wo du übst.\n\nSchreib NEIN in die Kommentare.`,
  `Erschöpfung ist Information.\nSie zeigt wo du zu lange zu viel gegeben hast.\n\nSchreib NEIN.`,
  `Wie klingt ein klares Nein?\nKürzer als du denkst.\n\nSchreib NEIN — ich zeig's dir.`,
  `Du hast das Recht auf ein Nein das keine Begründung braucht.\n\nSchreib NEIN in die Kommentare.`,
  `Wer hat dir gesagt du musst Ruhe verdienen?\nDas war falsch.\n\nSchreib NEIN.`,
  `Fang heute an. Nicht wenn der Moment perfekt ist.\n\nSchreib NEIN in die Kommentare.`,
  `Ein klares Nein stärkt echte Beziehungen.\nSchwache verlässt es.\nBeides ist gut.\n\nSchreib NEIN.`,
  `Innere Freiheit beginnt wo du aufhörst dich zu verbiegen.\n\nSchreib NEIN in die Kommentare.`,
  `Du hast das Recht auf Bedürfnisse die unbequem sind.\n\nSchreib NEIN.`,
  `Fang an bevor der Druck unerträglich wird.\nNicht danach.\n\nSchreib NEIN.`,
  `Der perfekte Zeitpunkt? Jetzt.\nImmer.\n\nSchreib NEIN in die Kommentare.`,
  `Was hat sich diesen Monat verändert?\nSchreib's in die Kommentare.\n\nOder schreib NEIN — wir fangen an.`,
  `Juli wartet.\nDein Nein auch.\n\nSchreib NEIN in die Kommentare — ich zeig dir den ersten Schritt.`,
];

// ─── Datum-Generator ─────────────────────────────────────────────────
function genDates(start, end) {
  const dates = [];
  const cur = new Date(start);
  const endD = new Date(end);
  while (cur <= endD) {
    const d = String(cur.getDate()).padStart(2, '0');
    const m = String(cur.getMonth() + 1).padStart(2, '0');
    const y = cur.getFullYear();
    dates.push(`${d}.${m}.${y}`);
    cur.setDate(cur.getDate() + 1);
  }
  return dates;
}

function csvRow(fields) {
  return fields.map(f => '"' + String(f).replace(/"/g, '""') + '"').join(',');
}

// Mai: 24.05 - 31.05 (8 Tage)
const maiDates = genDates('2026-05-24', '2026-05-31');
// Juni: 01.06 - 30.06 (30 Tage)
const juniDates = genDates('2026-06-01', '2026-06-30');

let reelIdx = 0;
let storyIdx = 0;
let bildIdx = 0;
let videoIdx = 0;

function buildRows(dates) {
  const rows = [header];
  dates.forEach(datum => {
    // Story 09:00
    const storyText = storyTexte[storyIdx % storyTexte.length];
    const bild = bildPrompts[bildIdx % bildPrompts.length];
    rows.push(csvRow([
      datum, '09:00', 'Instagram', 'Story',
      storyText,
      link, '', bild, '', '', '', 'Geplant'
    ]));
    storyIdx++; bildIdx++;

    // Reel 18:00
    const reelText = reelTexte[reelIdx % reelTexte.length];
    const video = videoPrompts[videoIdx % videoPrompts.length];
    rows.push(csvRow([
      datum, '18:00', 'Instagram', 'Reel',
      reelText,
      link, '', '', video, '', '', 'Geplant'
    ]));
    reelIdx++; videoIdx++;
  });
  return rows.join('\n');
}

// Mai
const maiRows = buildRows(maiDates);
fs.writeFileSync(path.join(outputDir, 'contentplan_andi_mentalgesund_mai_v1.csv'), maiRows, 'utf8');
console.log(`✓ Mai: ${maiDates.length} Tage × 2 Posts = ${maiDates.length * 2} Einträge`);

// Juni
const juniRows = buildRows(juniDates);
fs.writeFileSync(path.join(outputDir, 'contentplan_andi_mentalgesund_juni_v1.csv'), juniRows, 'utf8');
console.log(`✓ Juni: ${juniDates.length} Tage × 2 Posts = ${juniDates.length * 2} Einträge`);

console.log('\nFertig. Beide Contentpläne erstellt.');
