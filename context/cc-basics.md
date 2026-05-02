# Claude Code (CC) — Wichtigste Grundlagen

## Was ist CC

Claude Code (CC) ist eine KI-gestützte Entwicklungsumgebung, die direkt im Terminal läuft. Sie verbindet Claude (das Sprachmodell) mit deinem lokalen System — CC kann Dateien lesen, schreiben, bearbeiten, Commands ausführen und im Workspace arbeiten.

---

## Wie Sessions funktionieren

Jede Session startet neu. CC hat kein automatisches Gedächtnis zwischen Sessions. Deshalb:

- `/prime` am Anfang jeder Session ausführen — lädt Kontext aus `context/` und CLAUDE.md
- Alles Wichtige steht in den Kontext-Dateien, nicht im Chat-Verlauf
- Was du in einer Session erarbeitest, muss in einer Datei gespeichert werden, sonst ist es weg

---

## Workspace-Commands

| Command | Was er macht |
| --- | --- |
| `/prime` | Session starten, Kontext laden, Bereitschaft bestätigen |
| `/create-plan [thema]` | Implementierungsplan erstellen, bevor etwas umgesetzt wird |
| `/implement [plan-pfad]` | Plan aus `plans/` Schritt für Schritt umsetzen |
| `/shutdown` | Session sauber beenden |

---

## Wie CC denkt und arbeitet

- CC liest zuerst, dann schlägt er vor, dann wartet er auf dein Ja
- Kein Aktionismus — erst Vorschlag, dann Umsetzung
- CC kann parallel mehrere Dateien lesen und bearbeiten
- Für größere Aufgaben: `/create-plan` nutzen, damit der Plan sichtbar und steuerbar bleibt

---

## Kontext-Dateien in diesem Workspace

| Datei | Inhalt |
| --- | --- |
| `CLAUDE.md` | Kern-Anweisungen, immer automatisch geladen |
| `context/andi-profil.md` | Andis Rolle, Projekte, Stil-Regeln, Claude-Anweisungen |
| `context/personal-info.md` | Persönliche Stammdaten, Werte, Tools, Links |
| `context/strategy.md` | Aktuelle Strategie und Prioritäten |
| `context/current-data.md` | Laufende Projekte und geplante Videos |
| `context/cc-basics.md` | Diese Datei — CC-Grundlagen |
| `context/cc-anweisung.md` | Verbindliche Verhaltensanweisung — wird bei /prime geladen und gilt für die gesamte Session |

---

## Wichtige Begriffe

**Session** — Eine einzelne Gesprächssitzung mit CC. Endet, wenn du das Fenster schließt.

**Kontext** — Alles, was CC über dich und deine Ziele weiß. Kommt aus den Dateien in `context/`.

**Command** — Slash-Befehl wie `/prime`, den CC als strukturierte Aufgabe ausführt.

**Plan** — Dokument in `plans/`, das vor einer größeren Umsetzung erstellt wird.

**Output** — Ergebnis einer Aufgabe, gespeichert in `outputs/`.

**Prompt** — Deine Eingabe an CC. Je klarer, desto besser das Ergebnis.

---

## Praktische Tipps

- Kurze, klare Anweisungen funktionieren besser als lange Erklärungen
- Wenn CC etwas falsch macht: direkt korrigieren, kein Umweg
- Für wiederkehrende Aufgaben (z.B. YouTube-Skript) einfach sagen: „Mach ein Skript für InnerCode über Thema X" — CC kennt alle Stil-Regeln aus `andi-profil.md`
- Dateipfade immer vollständig angeben, wenn du auf eine bestimmte Datei verweist
- CC kann mehrere Aufgaben parallel erledigen, wenn sie voneinander unabhängig sind
