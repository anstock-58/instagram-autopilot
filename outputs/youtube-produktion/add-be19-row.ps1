$ErrorActionPreference = "Stop"
$CsvPfad = "C:\Users\andre\claude-workspace-vorlage\outputs\youtube-produktion\video-contentplan.csv"
$SkriptPfad = "C:\Users\andre\claude-workspace-vorlage\outputs\youtube-produktion\bewussteinfach\be19-skript-liebe-oder-angst.txt"

$Raw = Get-Content $SkriptPfad -Raw -Encoding UTF8
$Skript = ($Raw -split "---SKRIPT---")[1].Trim() -replace "\r?\n\r?\n", " " -replace "\r?\n", " "

$ae_kl = [char]0x00E4
$oe_kl = [char]0x00F6
$ue_kl = [char]0x00FC
$ae_gr = [char]0x00C4
$ue_gr = [char]0x00DC
$ss_kl = [char]0x00DF

$Rows = @(Import-Csv $CsvPfad)
$Neu = [PSCustomObject]@{
    Datum = "2026-06-17"
    Kanal = "BewusstEinfach"
    Titel = "Du nennst es Liebe. Aber es ist nur Angst, allein zu sein."
    Beschreibung = "Manchmal nennen wir etwas Liebe, das eigentlich nur die Angst ist, allein zu sein. Dieses Video zeigt den Unterschied, und warum das Erkennen dieser Angst der erste Schritt zu einer ehrlicheren Beziehung mit dir selbst und anderen ist."
    Tags = "Beziehung,Angst allein zu sein,Liebe oder Angst,Bindungstheorie,Selbstliebe,Alleinsein,Beziehung im Alter,emotionale Freiheit"
    Stimme_ID = "2OcnG4mH3jIMtWz3vKus"
    Skript = $Skript
    Bildprompt_1 = "Older European woman sitting by a window in evening light, looking outside, thoughtful expression, warm interior, documentary photography, no text, 16:9"
    Bildprompt_2 = "Older European couple sitting at a dinner table, not talking, looking in different directions, warm lamp light, melancholic but calm, no text, 16:9"
    Bildprompt_3 = "Older European woman walking alone on a quiet path through a park, autumn light, peaceful, documentary photography, no text, 16:9"
    Bildprompt_4 = "Older European man sitting alone on a couch, empty seat beside him, evening light, contemplative, no text, 16:9"
    Bildprompt_5 = "Older European woman writing in a journal at a kitchen table, warm morning light, no text, 16:9"
    Bildprompt_6 = "Older European couple holding hands on a bench, warm sunset light, gentle intimacy, documentary photography, no text, 16:9"
    Bildprompt_7 = "Empty side of a bed with morning light coming through curtains, quiet calm atmosphere, no text, 16:9"
    Bildprompt_8 = "Older European woman gardening alone, focused and content expression, natural light, documentary photography, no text, 16:9"
    Bildprompt_9 = "Older European couple laughing together in a kitchen, warm genuine moment, documentary photography, no text, 16:9"
    Bildprompt_10 = "Older European woman standing at an open door looking out at a garden, soft morning light, sense of new beginning, no text, 16:9"
    Thumbnail_Prompt = "Portrait of an older European woman sitting by a window, warm evening light, wedding ring visible on hand resting on table, calm and thoughtful expression, no drama, warm color tones, hyperrealistic editorial photography, no text, no watermark"
    Thumbnail_Text = "LIEBE? / ODER NUR ANGST?"
    Thumbnail_Modus = "portrait"
    Kapitel = "Der Moment, in dem du es merkst | Zwei verschiedene Dinge | Warum unser Gehirn das verwechselt | Die stille Pr" + $ue_kl + "fung | Der Weg, der wirklich frei macht"
    Beschreibung_Bullets = ([char]::ConvertFromUtf32(0x1F49B) + " Warum sich Bindung und Liebe oft gleich anf" + $ue_kl + "hlen, aber nicht dasselbe sind | " + [char]::ConvertFromUtf32(0x1FA9E) + " Die stille Pr" + $ue_kl + "fung, die dir in zwei Minuten zeigt, woran du wirklich h" + $ae_kl + "ngst | " + [char]::ConvertFromUtf32(0x1F9E0) + " Was die Bindungsforschung " + $ue_kl + "ber die Angst vor dem Alleinsein wei" + $ss_kl + " | " + [char]::ConvertFromUtf32(0x1F33F) + " Warum bewusste Momente allein dich n" + $ae_kl + "her zu dir selbst bringen | " + [char]::ConvertFromUtf32(0x2705) + " Wie aus Angst wieder echte N" + $ae_kl + "he werden kann")
    Produkt_Thema = ""
    Musik_URL = ""
    Ausgabeordner = "C:\Users\Andreas\Medien_Business\Business_YT_Bewusst_Einfach\YT-Videos\BEZIEHUNG\LiebeOderAngst_Video_1"
    Blotato_Account_ID = "36987"
    Status = "Offen"
    Landschaft_Suchbegriffe = ""
}
$Rows += $Neu
$Rows | Export-Csv $CsvPfad -NoTypeInformation -Encoding UTF8
Write-Host "Zeile eingetragen. Zeilen gesamt: $($Rows.Count)"
$Check = Import-Csv $CsvPfad | Where-Object { $_.Status -eq "Offen" }
$Check | ForEach-Object { Write-Host "OFFEN: $($_.Datum) | $($_.Kanal) | $($_.Titel)" }
