# Themen-Recherche-Workflow — BewusstEinfach & InnerCode

Wöchentlich ausführen. Ziel: immer 3-5 geprüfte Themen in der Pipeline.

---

## Schritt 1: Seed-Themen sammeln (5 Min.)

Ausgangspunkte für neue Ideen:

- **Eigene Viral-Muster**: Japan-Arzt, Tod, Gehirn ab 60 — was hat dieses Thema, das andere nicht haben?
- **Erfolgreiche Kanäle**: "Der Weg zu dir", "Greator", "Christoph Baudy" — welche Titel bekommen viele Klicks?
- **Google Trends**: Was suchen Menschen gerade im Bereich Psychologie, Gesundheit, Lebensweisheit?
- **YouTube-Suche**: Thema eingeben, nach Aufrufen sortieren — was performt in der Nische?
- **Eigene Community**: Was fragen Zuschauer in den Kommentaren?

**Format: festes Muster, variables Thema**
- BewusstEinfach: "[Autorität/Studie] + [überraschende Erkenntnis] + [universelle Erfahrung]"
- InnerCode: "[Du] + [Sterblichkeit/Endlichkeit] + [persönliche Konfrontation]"

---

## Schritt 2: CTR-Check (2 Min. pro Thema)

Für jedes Seed-Thema den Quick-Check aus `context/ctr-framework.md` anwenden:

**BewusstEinfach — 3 Fragen:**
1. Hat das Thema einen Überraschungs-Anker? (Wendung die dem Zuschauer widerspricht was er glaubt)
2. Erzeugt der Titel allein schon ein Gefühl?
3. Kann ich den Titel mit "Forscher haben bewiesen", "Das weiß kaum jemand" oder "Du kannst nicht X" formulieren?

**InnerCode — 3 Fragen:**
1. Ist Tod, Vergänglichkeit oder Lebensversäumnis direkt im Thema?
2. Trifft der Titel den Zuschauer persönlich ("Du stirbst", "Du weißt es nicht")?
3. Hat das Video Schock UND Auflösung?

**Unter 2 Ja = verwerfen. 3 Ja = produzieren.**

---

## Schritt 3: Wettbewerbs-Check (5 Min. pro Thema)

YouTube-Suche mit dem geplanten Titel oder Keyword:

- Gibt es bereits viele Videos zu dem Thema? → Kein Problem, wenn unser Winkel anders ist
- Was sagen alle anderen? → Wir sagen das Gegenteil oder gehen tiefer
- Gibt es einen klaren Winkel der noch nicht besetzt ist? → Das ist unser Video

**Regel:** Wenn alle "X tun" sagen, sagen wir "X tun macht es schlimmer — das geht besser".

---

## Schritt 4: Titel und Thumbnail-Text formulieren

Erst den Titel, dann den Thumbnail-Text. Nicht umgekehrt.

**Titel-Formel BewusstEinfach:**
- Forscher haben bewiesen: [überraschende Erkenntnis]
- Warum du [Alltagsproblem]: [unerwartete Ursache]
- [Autoritäts-Anker]: [konkretes Versprechen]

**Titel-Formel InnerCode:**
- Du [Handlung/Zustand]. Und weißt es nicht.
- Was Menschen [kurz vor dem Tod / am Ende] [bereuen / sehen / sagen]
- [Zeitangabe] bevor du stirbst: [Erkenntnis]

**Thumbnail-Text (BILD-Stil, max. 4 Wörter je Zeile, 2 Zeilen):**
- Zeile 1: Schock oder Provokation
- Zeile 2: Auflösung oder Verstärkung
- Beispiele: "DU KANNST / NICHT LOSLASSEN!" — "DEIN KÖRPER / LÜGT NICHT"

---

## Schritt 5: Pipeline befüllen

Geprüfte Themen kommen als neuer Eintrag ins CSV mit Status `Entwurf`.

Felder die jetzt schon ausgefüllt werden:
- Titel
- Thumbnail_Text
- Thumbnail_Modus (buddha)
- Kanal / Ausgabeordner
- Produkt_Thema

Felder die Claude beim Skript-Schreiben ausfüllt:
- Skript (1500+ Wörter, mit Studie/Quelle)
- Bildprompt_1 bis _10
- Kapitel, Beschreibung_Bullets, Tags, Beschreibung

---

## Themen-Pipeline (aktuell geprüft, produktionsbereit)

| Titel | Kanal | CTR-Score | Status |
|---|---|---|---|
| *(nächste Recherche-Session)* | | | |

---

## Bewährte Themen-Cluster für BewusstEinfach

**Gehirn & Gedächtnis (hoch performant):**
- Demenz vorbeugen, Schlaf und Gehirn, Gehirnnahrung, Vergessen ab 60

**Körper & Nervensystem:**
- Chronische Erschöpfung, Stresssymptome, Vagusnerv, Schlaf

**Japan / Langlebigkeit / Autorität:**
- Ältester Arzt, Okinawa, blaue Zonen, was 100-Jährige anders machen

**Psychologie mit Überraschungs-Wendung:**
- Was du falsch machst (mit Forschungsbeleg), warum X das Gegenteil bewirkt

**Einzelschicksal / Sterbeprozess (NEU, warmherzig):**
- Was Menschen sehen wenn sie sterben, was Pflegekräfte am Lebensende beobachten

## Bewährte Themen-Cluster für InnerCode

**Tod & Sterblichkeit direkt:**
- Du stirbst gerade, letzter Tag, was du bereuen wirst

**Zeitverschwendung & Lebensversäumnis:**
- Jahre die du nicht lebst, das Leben das wartet während du funktionierst

**Konfrontation mit dem Nicht-Leben:**
- Warum du nicht wirklich lebst, der Unterschied zwischen existieren und leben
