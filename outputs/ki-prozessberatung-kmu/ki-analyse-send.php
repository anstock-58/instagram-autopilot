<?php
// Empfänger fest hinterlegt, nicht durch den Client änderbar
$to = 'info@ansto-finaffairs.com';
$cc = null;

// Kunden-spezifische Weiterleitung für Mitarbeiter-Fragebögen: geht direkt an den
// Kunden-Ansprechpartner, CC an Andi. Ohne Eintrag hier bleibt es beim Standardverhalten
// (nur an info@ansto-finaffairs.com), damit neue Kunden nichts extra konfigurieren müssen.
$mitarbeiterRouting = [
    'B+H Bau GmbH' => ['to' => 'MB@MB-ING.eu', 'cc' => 'info@ansto-finaffairs.com'],
];

function clean($v) {
    // Entfernt Zeilenumbrüche/Steuerzeichen, verhindert Header-Injection
    return trim(str_replace(["\r", "\n"], '', (string)$v));
}
function txt($v) {
    return trim((string)$v);
}
function val($v) {
    $t = txt($v);
    return $t !== '' ? $t : '-';
}

// ---- Minimaler PDF-Generator, ohne externe Bibliothek ----

function pdf_text_encode($s) {
    if (function_exists('iconv')) {
        $r = @iconv('UTF-8', 'CP1252//TRANSLIT', $s);
        if ($r !== false) return $r;
    }
    return @mb_convert_encoding($s, 'ISO-8859-1', 'UTF-8');
}
function pdf_escape($s) {
    return str_replace(['\\', '(', ')'], ['\\\\', '\\(', '\\)'], $s);
}

// $lines: Liste von ['type' => 'title'|'h2'|'label'|'text'|'gap', 'text' => string]
function build_simple_pdf($lines) {
    $pageW = 595; $pageH = 842;
    $marginL = 50; $marginTop = 792; $marginBottom = 50;
    $lineHeight = 14;
    $wrapWidth = 92;

    $sizes = ['title' => 15, 'h2' => 12, 'label' => 10, 'text' => 10];
    $fonts = ['title' => 'F2', 'h2' => 'F2', 'label' => 'F2', 'text' => 'F1'];

    // Zeilen umbrechen
    $expanded = [];
    foreach ($lines as $l) {
        if ($l['type'] === 'gap') { $expanded[] = $l; continue; }
        $wrapped = wordwrap($l['text'], $wrapWidth, "\n", true);
        foreach (explode("\n", $wrapped) as $wline) {
            $expanded[] = ['type' => $l['type'], 'text' => $wline];
        }
    }

    // Auf Seiten verteilen
    $maxLinesPerPage = (int)floor(($marginTop - $marginBottom) / $lineHeight);
    if ($maxLinesPerPage < 1) $maxLinesPerPage = 1;
    $pages = array_chunk($expanded, $maxLinesPerPage);
    if (empty($pages)) $pages = [[]];

    $objects = [];
    $objects[1] = "<< /Type /Catalog /Pages 2 0 R >>";
    $objects[3] = "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>";
    $objects[4] = "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>";

    $nextObjNum = 5;
    $pageObjNums = [];
    $contentObjNums = [];
    foreach ($pages as $p) {
        $pageObjNums[] = $nextObjNum++;
        $contentObjNums[] = $nextObjNum++;
    }

    $kids = [];
    foreach ($pages as $idx => $pageLines) {
        $y = $marginTop;
        $stream = "";
        foreach ($pageLines as $l) {
            if ($l['type'] === 'gap') { $y -= $lineHeight; continue; }
            $font = $fonts[$l['type']];
            $size = $sizes[$l['type']];
            $text = pdf_escape(pdf_text_encode($l['text']));
            $stream .= "BT /$font $size Tf 1 0 0 1 $marginL $y Tm ($text) Tj ET\n";
            $y -= $lineHeight;
            if ($l['type'] === 'title' || $l['type'] === 'h2') { $y -= 4; }
        }
        $contentObjNum = $contentObjNums[$idx];
        $pageObjNum = $pageObjNums[$idx];
        $objects[$contentObjNum] = "STREAM:" . $stream;
        $objects[$pageObjNum] = "<< /Type /Page /Parent 2 0 R /Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> /MediaBox [0 0 $pageW $pageH] /Contents $contentObjNum 0 R >>";
        $kids[] = "$pageObjNum 0 R";
    }

    $objects[2] = "<< /Type /Pages /Kids [" . implode(' ', $kids) . "] /Count " . count($pages) . " >>";

    ksort($objects);
    $maxObjNum = max(array_keys($objects));

    $pdf = "%PDF-1.4\n";
    $offsets = [];
    foreach ($objects as $num => $bodyObj) {
        $offsets[$num] = strlen($pdf);
        if (strpos($bodyObj, 'STREAM:') === 0) {
            $streamContent = substr($bodyObj, 7);
            $len = strlen($streamContent);
            $pdf .= "$num 0 obj\n<< /Length $len >>\nstream\n$streamContent\nendstream\nendobj\n";
        } else {
            $pdf .= "$num 0 obj\n$bodyObj\nendobj\n";
        }
    }

    $xrefStart = strlen($pdf);
    $pdf .= "xref\n0 " . ($maxObjNum + 1) . "\n";
    $pdf .= "0000000000 65535 f \n";
    for ($i = 1; $i <= $maxObjNum; $i++) {
        if (isset($offsets[$i])) {
            $pdf .= sprintf("%010d 00000 n \n", $offsets[$i]);
        } else {
            $pdf .= "0000000000 00000 f \n";
        }
    }
    $pdf .= "trailer\n<< /Size " . ($maxObjNum + 1) . " /Root 1 0 R >>\nstartxref\n$xrefStart\n%%EOF";

    return $pdf;
}

function add_qa(&$lines, $label, $value) {
    $lines[] = ['type' => 'label', 'text' => $label];
    $lines[] = ['type' => 'text', 'text' => val($value)];
    $lines[] = ['type' => 'gap'];
}

// ---- Eingaben lesen ----

header('Content-Type: application/json; charset=UTF-8');

$formtyp = clean($_POST['formtyp'] ?? '');
$firma   = clean($_POST['firma'] ?? '');

if ($firma === '') {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Der Name der Firma fehlt.']);
    exit;
}

if ($formtyp === 'mitarbeiter' && isset($mitarbeiterRouting[$firma])) {
    $to = $mitarbeiterRouting[$firma]['to'];
    $cc = $mitarbeiterRouting[$firma]['cc'];
}

$replyTo = null;

if ($formtyp === 'interview') {

    $kname = clean($_POST['kname'] ?? '');
    $kmail = clean($_POST['kmail'] ?? '');
    if ($kname === '' || $kmail === '' || !filter_var($kmail, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400);
        echo json_encode(['ok' => false, 'error' => 'Name und eine gültige E-Mail-Adresse sind erforderlich.']);
        exit;
    }
    $replyTo = $kname . ' <' . $kmail . '>';

    $branche = clean($_POST['branche'] ?? '');
    $subject = 'KI-Prozessanalyse Erstgespräch: ' . $firma;

    $body  = "Neues Erstgespräch KI-Prozessanalyse\n\n";
    $body .= "Firma: $firma\n";
    $body .= "Branche: " . val($branche) . "\n\n";
    $body .= "--- Einstieg und Überblick ---\n";
    $body .= "Aufbau/Abteilungen: " . val($_POST['aufbau'] ?? '') . "\n\n";
    $body .= "Entwicklung letzte Jahre: " . val($_POST['entwicklung'] ?? '') . "\n\n";
    $body .= "Marktposition: " . val($_POST['marktposition'] ?? '') . "\n\n";
    $body .= "--- Prozesse im Unternehmen ---\n";
    $body .= "Vertrieb (Kundenanfragen/Angebote): " . val($_POST['vertrieb'] ?? '') . "\n\n";
    $body .= "Kundenkommunikation: " . val($_POST['kundenkommunikation'] ?? '') . "\n\n";
    $body .= "Projektabwicklung: " . val($_POST['projektabwicklung'] ?? '') . "\n\n";
    $body .= "Verwaltung (Rechnung/Buchhaltung/Termine): " . val($_POST['verwaltungsprozesse'] ?? '') . "\n\n";
    $body .= "Fachbereich/Kernleistung: " . val($_POST['fachbereich'] ?? '') . "\n\n";
    $body .= "--- Alltag und Belastung ---\n";
    $body .= "Meiste Zeit im Tagesgeschäft: " . val($_POST['zeit'] ?? '') . "\n\n";
    $body .= "Würde am liebsten abgeben: " . val($_POST['abgeben'] ?? '') . "\n\n";
    $body .= "Läuft manuell/über Excel: " . val($_POST['manuell'] ?? '') . "\n\n";
    $body .= "--- Zahlen und Ziele ---\n";
    $body .= "Zeitaufwand Verwaltung pro Woche: " . val($_POST['verwaltung'] ?? '') . "\n\n";
    $body .= "Kosten durch Fehler/Doppelarbeit: " . val($_POST['kosten'] ?? '') . "\n\n";
    $body .= "Ziel in drei Jahren: " . val($_POST['ziel3'] ?? '') . "\n\n";
    $body .= "--- Technik-Status ---\n";
    $body .= "Eingesetzte Software: " . val($_POST['software'] ?? '') . "\n\n";
    $body .= "Bestehende Automatisierung/KI: " . val($_POST['automatisierung'] ?? '') . "\n\n";
    $body .= "Offenheit im Team: " . val($_POST['offenheit'] ?? '') . "\n\n";
    $body .= "--- Entscheidung und Budget ---\n";
    $body .= "Entscheider: " . val($_POST['entscheider'] ?? '') . "\n\n";
    $body .= "Budgetrahmen: " . val($_POST['budget'] ?? '') . "\n\n";
    $body .= "Was zählt als Erfolg: " . val($_POST['erfolg'] ?? '') . "\n\n";
    $body .= "--- Abschluss ---\n";
    $body .= "Nicht angesprochene Themen: " . val($_POST['offeneThemen'] ?? '') . "\n\n";
    $body .= "Als Nächstes befragen: " . val($_POST['naechstePerson'] ?? '') . "\n\n";
    $body .= "--- Kontakt ---\n";
    $body .= "Name: $kname\n";
    $body .= "E-Mail: $kmail\n";
    $body .= "Telefon: " . val($_POST['ktel'] ?? '') . "\n";

    $lines = [];
    $lines[] = ['type' => 'title', 'text' => 'KI-Prozessanalyse: Erstgespräch'];
    $lines[] = ['type' => 'text', 'text' => "Firma: $firma"];
    $lines[] = ['type' => 'text', 'text' => 'Branche: ' . val($branche)];
    $lines[] = ['type' => 'gap'];
    $lines[] = ['type' => 'h2', 'text' => 'Einstieg und Überblick'];
    add_qa($lines, 'Aufbau/Abteilungen', $_POST['aufbau'] ?? '');
    add_qa($lines, 'Entwicklung letzte Jahre', $_POST['entwicklung'] ?? '');
    add_qa($lines, 'Marktposition', $_POST['marktposition'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Prozesse im Unternehmen'];
    add_qa($lines, 'Vertrieb (Kundenanfragen/Angebote)', $_POST['vertrieb'] ?? '');
    add_qa($lines, 'Kundenkommunikation', $_POST['kundenkommunikation'] ?? '');
    add_qa($lines, 'Projektabwicklung', $_POST['projektabwicklung'] ?? '');
    add_qa($lines, 'Verwaltung (Rechnung/Buchhaltung/Termine)', $_POST['verwaltungsprozesse'] ?? '');
    add_qa($lines, 'Fachbereich/Kernleistung', $_POST['fachbereich'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Alltag und Belastung'];
    add_qa($lines, 'Meiste Zeit im Tagesgeschäft', $_POST['zeit'] ?? '');
    add_qa($lines, 'Würde am liebsten abgeben', $_POST['abgeben'] ?? '');
    add_qa($lines, 'Läuft manuell/über Excel', $_POST['manuell'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Zahlen und Ziele'];
    add_qa($lines, 'Zeitaufwand Verwaltung pro Woche', $_POST['verwaltung'] ?? '');
    add_qa($lines, 'Kosten durch Fehler/Doppelarbeit', $_POST['kosten'] ?? '');
    add_qa($lines, 'Ziel in drei Jahren', $_POST['ziel3'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Technik-Status'];
    add_qa($lines, 'Eingesetzte Software', $_POST['software'] ?? '');
    add_qa($lines, 'Bestehende Automatisierung/KI', $_POST['automatisierung'] ?? '');
    add_qa($lines, 'Offenheit im Team', $_POST['offenheit'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Entscheidung und Budget'];
    add_qa($lines, 'Entscheider', $_POST['entscheider'] ?? '');
    add_qa($lines, 'Budgetrahmen', $_POST['budget'] ?? '');
    add_qa($lines, 'Was zählt als Erfolg', $_POST['erfolg'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Abschluss'];
    add_qa($lines, 'Nicht angesprochene Themen', $_POST['offeneThemen'] ?? '');
    add_qa($lines, 'Als Nächstes befragen', $_POST['naechstePerson'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Kontakt'];
    $lines[] = ['type' => 'text', 'text' => "Name: $kname"];
    $lines[] = ['type' => 'text', 'text' => "E-Mail: $kmail"];
    $lines[] = ['type' => 'text', 'text' => 'Telefon: ' . val($_POST['ktel'] ?? '')];

} elseif ($formtyp === 'mitarbeiter') {

    $bereich = clean($_POST['bereich'] ?? '');
    $name    = clean($_POST['name'] ?? '');
    $subject = 'KI-Prozessanalyse Mitarbeiter-Fragebogen: ' . $firma;

    $body  = "Neuer Mitarbeiter-Fragebogen KI-Prozessanalyse\n\n";
    $body .= "Firma: $firma\n";
    $body .= "Bereich: " . val($bereich) . "\n";
    $body .= "Name: " . ($name !== '' ? $name : 'anonym') . "\n\n";
    $body .= "1. Tägliche Aufgaben: " . val($_POST['q1'] ?? '') . "\n\n";
    $body .= "2. Wiederkehrende Aufgaben: " . val($_POST['q2'] ?? '') . "\n\n";
    $body .= "3. Meiste Zeit im Verhältnis zum Nutzen: " . val($_POST['q3'] ?? '') . "\n\n";
    $body .= "4. Mehrfache Eingabe derselben Info: " . val($_POST['q4'] ?? '') . "\n\n";
    $body .= "5. Häufigste Fehlerquelle: " . val($_POST['q5'] ?? '') . "\n\n";
    $body .= "6. Aufgabe, die nicht mehr selbst gemacht werden soll: " . val($_POST['q6'] ?? '') . "\n\n";
    $body .= "7. Nur diese Person kann es erledigen: " . val($_POST['q7'] ?? '') . "\n\n";
    $body .= "8. Genutzte Tools und wo es hakt: " . val($_POST['q8'] ?? '') . "\n\n";
    $body .= "9. Gewünschte Assistenz-Aufgabe: " . val($_POST['q9'] ?? '') . "\n\n";
    $body .= "10. Was würde persönlich besser werden: " . val($_POST['q10'] ?? '') . "\n";

    $lines = [];
    $lines[] = ['type' => 'title', 'text' => 'KI-Prozessanalyse: Mitarbeiter-Fragebogen'];
    $lines[] = ['type' => 'text', 'text' => "Firma: $firma"];
    $lines[] = ['type' => 'text', 'text' => 'Bereich: ' . val($bereich)];
    $lines[] = ['type' => 'text', 'text' => 'Name: ' . ($name !== '' ? $name : 'anonym')];
    $lines[] = ['type' => 'gap'];
    add_qa($lines, '1. Tägliche Aufgaben', $_POST['q1'] ?? '');
    add_qa($lines, '2. Wiederkehrende Aufgaben', $_POST['q2'] ?? '');
    add_qa($lines, '3. Meiste Zeit im Verhältnis zum Nutzen', $_POST['q3'] ?? '');
    add_qa($lines, '4. Mehrfache Eingabe derselben Info', $_POST['q4'] ?? '');
    add_qa($lines, '5. Häufigste Fehlerquelle', $_POST['q5'] ?? '');
    add_qa($lines, '6. Aufgabe, die nicht mehr selbst gemacht werden soll', $_POST['q6'] ?? '');
    add_qa($lines, '7. Nur diese Person kann es erledigen', $_POST['q7'] ?? '');
    add_qa($lines, '8. Genutzte Tools und wo es hakt', $_POST['q8'] ?? '');
    add_qa($lines, '9. Gewünschte Assistenz-Aufgabe', $_POST['q9'] ?? '');
    add_qa($lines, '10. Was würde persönlich besser werden', $_POST['q10'] ?? '');

} elseif ($formtyp === 'handwerk') {

    $kname = clean($_POST['kname'] ?? '');
    $kmail = clean($_POST['kmail'] ?? '');
    if ($kname === '' || $kmail === '' || !filter_var($kmail, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400);
        echo json_encode(['ok' => false, 'error' => 'Name und eine gültige E-Mail-Adresse sind erforderlich.']);
        exit;
    }
    $replyTo = $kname . ' <' . $kmail . '>';

    $branche = clean($_POST['branche'] ?? '');
    $subject = 'KI-Prozessanalyse Handwerksbetrieb: ' . $firma;

    $body  = "Neuer Check für einen Handwerksbetrieb\n\n";
    $body .= "Firma: $firma\n";
    $body .= "Gewerk: " . val($branche) . "\n\n";
    $body .= "--- Einstieg und Überblick ---\n";
    $body .= "Aufbau/wer macht was: " . val($_POST['aufbau'] ?? '') . "\n\n";
    $body .= "Entwicklung letzte Jahre: " . val($_POST['entwicklung'] ?? '') . "\n\n";
    $body .= "Marktposition: " . val($_POST['marktposition'] ?? '') . "\n\n";
    $body .= "--- Alltag und Belastung ---\n";
    $body .= "Meiste Zeit im Tagesgeschäft: " . val($_POST['zeit'] ?? '') . "\n\n";
    $body .= "Würde am liebsten abgeben: " . val($_POST['abgeben'] ?? '') . "\n\n";
    $body .= "Läuft manuell/über Excel: " . val($_POST['manuell'] ?? '') . "\n\n";
    $body .= "--- Prozesse im Detail ---\n";
    $body .= "Mehrfache Eingabe derselben Info: " . val($_POST['doppelt'] ?? '') . "\n\n";
    $body .= "Häufigste Fehlerquelle: " . val($_POST['fehler'] ?? '') . "\n\n";
    $body .= "Nur Chef/Chefin kann es erledigen: " . val($_POST['busfaktor'] ?? '') . "\n\n";
    $body .= "Genutzte Tools und wo es hakt: " . val($_POST['tools'] ?? '') . "\n\n";
    $body .= "Gewünschte Assistenz-Aufgabe: " . val($_POST['wunschassistent'] ?? '') . "\n\n";
    $body .= "--- Zahlen und Ziele ---\n";
    $body .= "Zeitaufwand Verwaltung pro Woche: " . val($_POST['verwaltung'] ?? '') . "\n\n";
    $body .= "Kosten durch Fehler/Doppelarbeit: " . val($_POST['kosten'] ?? '') . "\n\n";
    $body .= "Ziel in drei Jahren: " . val($_POST['ziel3'] ?? '') . "\n\n";
    $body .= "--- Technik-Status ---\n";
    $body .= "Eingesetzte Software: " . val($_POST['software'] ?? '') . "\n\n";
    $body .= "Bestehende Automatisierung/KI: " . val($_POST['automatisierung'] ?? '') . "\n\n";
    $body .= "Offenheit im Team: " . val($_POST['offenheit'] ?? '') . "\n\n";
    $body .= "--- Entscheidung und Budget ---\n";
    $body .= "Entscheider: " . val($_POST['entscheider'] ?? '') . "\n\n";
    $body .= "Budgetrahmen: " . val($_POST['budget'] ?? '') . "\n\n";
    $body .= "Was zählt als Erfolg: " . val($_POST['erfolg'] ?? '') . "\n\n";
    $body .= "--- Abschluss ---\n";
    $body .= "Nicht angesprochene Themen: " . val($_POST['offeneThemen'] ?? '') . "\n\n";
    $body .= "Als Nächstes befragen: " . val($_POST['naechstePerson'] ?? '') . "\n\n";
    $body .= "--- Kontakt ---\n";
    $body .= "Name: $kname\n";
    $body .= "E-Mail: $kmail\n";
    $body .= "Telefon: " . val($_POST['ktel'] ?? '') . "\n";

    $lines = [];
    $lines[] = ['type' => 'title', 'text' => 'KI-Prozessanalyse: Handwerksbetrieb'];
    $lines[] = ['type' => 'text', 'text' => "Firma: $firma"];
    $lines[] = ['type' => 'text', 'text' => 'Gewerk: ' . val($branche)];
    $lines[] = ['type' => 'gap'];
    $lines[] = ['type' => 'h2', 'text' => 'Einstieg und Überblick'];
    add_qa($lines, 'Aufbau/wer macht was', $_POST['aufbau'] ?? '');
    add_qa($lines, 'Entwicklung letzte Jahre', $_POST['entwicklung'] ?? '');
    add_qa($lines, 'Marktposition', $_POST['marktposition'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Alltag und Belastung'];
    add_qa($lines, 'Meiste Zeit im Tagesgeschäft', $_POST['zeit'] ?? '');
    add_qa($lines, 'Würde am liebsten abgeben', $_POST['abgeben'] ?? '');
    add_qa($lines, 'Läuft manuell/über Excel', $_POST['manuell'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Prozesse im Detail'];
    add_qa($lines, 'Mehrfache Eingabe derselben Info', $_POST['doppelt'] ?? '');
    add_qa($lines, 'Häufigste Fehlerquelle', $_POST['fehler'] ?? '');
    add_qa($lines, 'Nur Chef/Chefin kann es erledigen', $_POST['busfaktor'] ?? '');
    add_qa($lines, 'Genutzte Tools und wo es hakt', $_POST['tools'] ?? '');
    add_qa($lines, 'Gewünschte Assistenz-Aufgabe', $_POST['wunschassistent'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Zahlen und Ziele'];
    add_qa($lines, 'Zeitaufwand Verwaltung pro Woche', $_POST['verwaltung'] ?? '');
    add_qa($lines, 'Kosten durch Fehler/Doppelarbeit', $_POST['kosten'] ?? '');
    add_qa($lines, 'Ziel in drei Jahren', $_POST['ziel3'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Technik-Status'];
    add_qa($lines, 'Eingesetzte Software', $_POST['software'] ?? '');
    add_qa($lines, 'Bestehende Automatisierung/KI', $_POST['automatisierung'] ?? '');
    add_qa($lines, 'Offenheit im Team', $_POST['offenheit'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Entscheidung und Budget'];
    add_qa($lines, 'Entscheider', $_POST['entscheider'] ?? '');
    add_qa($lines, 'Budgetrahmen', $_POST['budget'] ?? '');
    add_qa($lines, 'Was zählt als Erfolg', $_POST['erfolg'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Abschluss'];
    add_qa($lines, 'Nicht angesprochene Themen', $_POST['offeneThemen'] ?? '');
    add_qa($lines, 'Als Nächstes befragen', $_POST['naechstePerson'] ?? '');
    $lines[] = ['type' => 'h2', 'text' => 'Kontakt'];
    $lines[] = ['type' => 'text', 'text' => "Name: $kname"];
    $lines[] = ['type' => 'text', 'text' => "E-Mail: $kmail"];
    $lines[] = ['type' => 'text', 'text' => 'Telefon: ' . val($_POST['ktel'] ?? '')];

} else {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Unbekannter Formulartyp.']);
    exit;
}

// ---- PDF bauen ----

$pdfBytes = build_simple_pdf($lines);
$safeFirma = preg_replace('/[^A-Za-z0-9_-]+/', '_', $firma);
$pdfFilename = 'ki-analyse-' . ($safeFirma !== '' ? $safeFirma : 'unternehmen') . '.pdf';

// ---- E-Mail mit PDF-Anhang versenden ----

$boundary = 'kianalyse_' . md5(uniqid((string)mt_rand(), true));

$headers   = [];
$headers[] = 'From: KI-Prozessanalyse <info@ansto-finaffairs.com>';
if ($cc !== null) {
    $headers[] = 'Cc: ' . $cc;
}
if ($replyTo !== null) {
    $headers[] = 'Reply-To: ' . $replyTo;
}
$headers[] = 'MIME-Version: 1.0';
$headers[] = 'Content-Type: multipart/mixed; boundary="' . $boundary . '"';

$mime  = "--$boundary\r\n";
$mime .= "Content-Type: text/plain; charset=UTF-8\r\n";
$mime .= "Content-Transfer-Encoding: 8bit\r\n\r\n";
$mime .= $body . "\r\n\r\n";
$mime .= "--$boundary\r\n";
$mime .= "Content-Type: application/pdf; name=\"$pdfFilename\"\r\n";
$mime .= "Content-Transfer-Encoding: base64\r\n";
$mime .= "Content-Disposition: attachment; filename=\"$pdfFilename\"\r\n\r\n";
$mime .= chunk_split(base64_encode($pdfBytes)) . "\r\n";
$mime .= "--$boundary--";

$encodedSubject = '=?UTF-8?B?' . base64_encode($subject) . '?=';
$ok = mail($to, $encodedSubject, $mime, implode("\r\n", $headers));

if ($ok) {
    echo json_encode(['ok' => true]);
} else {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Versand ist fehlgeschlagen, bitte später erneut versuchen.']);
}
