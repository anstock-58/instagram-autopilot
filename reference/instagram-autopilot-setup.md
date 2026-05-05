# Instagram Autopilot — Funktionierende Konfiguration

Stand: 05.05.2026

---

## Architektur

```
contentplan_mai_v2.csv
  → post-trigger.ps1 (17:55 Uhr täglich)
    → Make.com Webhook (Neustart Webhook v3, Szenario 5524877)
      → HTTP Module 3: fal.ai Kling AI (Video generieren)
      → Creatomate Module 20: Video + Overlay + Musik rendern
      → Sleep 120s
      → Instagram Module 9: Reel posten
      → Facebook Module 14: Reel posten
```

---

## Make.com Szenario

- **Name**: Neustart Webhook v3
- **ID**: 5524877
- **Webhook-URL**: `https://hook.eu1.make.com/q1np77hliej89lqdl38ux1bgj9as5xdw`
- **Toggle**: muss aktiv (blau) sein für automatischen Betrieb

---

## Creatomate

- **Template-ID**: `b7392c62-3d93-4ef5-8bd5-462fdc830815`
- **API Key**: in `context/secrets.md`

### Creatomate Modul Body (Make.com Modul 20)

```json
{
  "template_id": "b7392c62-3d93-4ef5-8bd5-462fdc830815",
  "duration": 30,
  "modifications": {
    "video.source": "{{3.data.video.url}}",
    "overlay_text.text": "{{1.textoverlay}}",
    "music.source": "https://raw.githubusercontent.com/anstock-58/instagram-autopilot/master/music/background-chill.mp3",
    "video.volume": 0,
    "music.volume": 2,
    "video.loop": true
  }
}
```

**Wichtig — Modification-Keys:**
- `video.source` (nicht `video_url`) — Element-ID-Targeting
- `overlay_text.text` (nicht `overlay_text`) — Element-ID-Targeting
- `music.source` — überschreibt Template-URL (Template hat noch `/main/`, wir brauchen `/master/`)
- `video.volume: 0` — Originalton des Quellvideos stummschalten
- `music.volume: 2` — Musik verstärken (MP3 ist leise gemastert)
- `video.loop: true` — Video wiederholt sich (Kling-AI-Videos sind ~7 Sek.)
- `duration: 30` — Gesamtlänge auf 30 Sek. begrenzen

**ACHTUNG:** `"sync": true` NICHT verwenden — führt zu Timeout (202 statt Render-URL)

---

## Musik

- **Datei**: `music/background-chill.mp3` im GitHub-Repo
- **URL**: `https://raw.githubusercontent.com/anstock-58/instagram-autopilot/master/music/background-chill.mp3`
- **Repo muss public sein** — privates Repo → 404 bei Creatomate

---

## Text-Overlay Format

Im CSV (`outputs/contentplan_mai_v2.csv`) in der Spalte `Text-Overlay`:
- Zeilenumbrüche im CSV werden automatisch zu `\n` konvertiert (post-trigger.ps1)
- Creatomate rendert `\n` als echten Zeilenumbruch im Video

**Empfohlene Struktur:**
```
[Hook-Aussage]
[Zweite Zeile optional]

👇 [CTA — z.B. "Kommentiere: Was bedeutet das für dich?"]
```

**Beispiel:**
```
Echte Stärke sieht anders aus.

👇 Kommentiere: Was zeigt dir echte Stärke?
```

---

## Facebook-Problem (noch offen)

Facebook-Modul (14) verwendet aktuell `3. data.video_url` (rohe fal.ai-URL) statt die Creatomate-URL. Deshalb: kein Text-Overlay, kein Ton auf Facebook.

**Fix (noch ausstehend):** Facebook-Modul URL auf Creatomate-Output umstellen (Modul 20 Output-URL).

---

## post-trigger.ps1

- **Pfad**: `scripts/post-trigger.ps1`
- **CSV**: `outputs/contentplan_mai_v2.csv`
- **Wichtig**: Textoverlay-Zeilenumbrüche werden zu `\n` konvertiert (nicht zu Leerzeichen!)
- **Nicht implementiert**: Karussell-Posts, Facebook-only-Posts

---

## GitHub Repo

- **URL**: `https://github.com/anstock-58/instagram-autopilot`
- **Branch**: `master` (nicht `main`!)
- **Sichtbarkeit**: public (muss public bleiben für Musik-URL)

---

## Bekannte Fehlerquellen

| Fehler | Ursache | Fix |
|---|---|---|
| Creatomate 404 music | Repo privat oder Branch `main` statt `master` | Repo public + URL auf `master` |
| `{{video_url}}` not resolved | Falscher Modification-Key | `video.source` statt `video_url` |
| JSON-Fehler im Webhook | Roher Zeilenumbruch in textoverlay | `\n` statt echtem Newline |
| Make.com Webhook accepted, nichts passiert | Szenario-Toggle OFF | Toggle in Make.com aktivieren |
| Video 2 Minuten lang | Kein `duration`-Limit | `"duration":30` in Creatomate-Body |
| Video friert nach 7s ein | Kein Loop | `"video.loop":true` in Modifications |
