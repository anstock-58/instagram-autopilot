# Produzieren

Lies outputs/contentplan.csv und finde die erste Zeile die gleichzeitig:
- Status "Offen" hat
- Ein vollständiges Skript enthält (Skript-Spalte nicht leer)

Falls keine solche Zeile existiert:
"Kein Video produktionsbereit. Starte /skript-erstellen um das nächste Video vorzubereiten."

---

## Voraussetzungs-Check

Lies context/setup-status.md und prüfe:

- Sind ElevenLabs, fal.ai und YouTube API Keys eingerichtet?
- Ist FFmpeg installiert?
- Ist der Ausgabeordner in context/mein-kanal.md eingetragen?

Falls etwas fehlt:
"Vor der Produktion muss noch folgendes eingerichtet werden: [fehlende Punkte]
Anleitung: reference/setup-anleitung.md Abschnitt [X]"

---

## Produktion ankündigen

Informiere den Nutzer vollständig:

"Ich starte jetzt die Produktion für:
📽️ **[Titel]**

Das dauert ca. 15–25 Minuten. Dein Rechner muss dabei an bleiben.

Automatischer Ablauf:
✅ Voiceover wird generiert (ElevenLabs)
✅ 10 Szenenbilder werden generiert (fal.ai / Ideogram)
✅ Thumbnail wird generiert (fal.ai / Ideogram)
✅ Video wird zusammengeschnitten (FFmpeg)
✅ Video wird auf YouTube hochgeladen
✅ Thumbnail wird gesetzt
✅ Beschreibung, Tags und Kapitel werden eingetragen

Soll ich starten?"

---

## Produktion starten

Nach Bestätigung — führe aus:

```powershell
.\scripts\youtube-producer.ps1
```

Das Script liest die contentplan.csv automatisch, verarbeitet das nächste offene Video und setzt den Status auf "Produziert".

---

## Nach der Produktion

Bestätige dem Nutzer:

"✅ Video produziert und hochgeladen!

**Titel:** [Titel]
**YouTube:** Das Video ist jetzt als nicht-öffentlicher Entwurf auf deinem Kanal.

**Nächste Schritte (manuell in YouTube Studio):**
1. Video aufrufen → Sichtbarkeit → 'Öffentlich' oder 'Geplant' setzen
2. End-Screen hinzufügen (letztes Video + Abonnieren-Button)
3. Ggf. ersten Kommentar als Frage pinnen

Möchtest du direkt das nächste Skript schreiben? Starte /skript-erstellen"
