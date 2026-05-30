# Setup-Anleitung — YouTube Autopilot System

Einmalige Einrichtung. Danach läuft alles automatisch.
Dauer: ca. 45–60 Minuten.

---

## Übersicht: Was du brauchst

| Tool | Kosten | Wofür |
|---|---|---|
| Claude Code | ~20€/Monat | Das KI-Gehirn — führt alle Commands aus |
| ElevenLabs | ~22€/Monat | Sprachausgabe für deine Videos |
| fal.ai | ~5€/Monat | KI-Bilder und Thumbnails |
| Google Cloud | kostenlos | YouTube API für automatischen Upload |
| FFmpeg | kostenlos | Video-Zusammenschnitt |

---

## Abschnitt 1: Claude Code installieren

1. Gehe zu **claude.ai/code** und lade Claude Code herunter
2. Installiere Claude Code auf deinem Windows-PC
3. Melde dich mit deinem Anthropic-Account an (oder erstelle einen unter anthropic.com)
4. Wähle eine Subscription (Pro oder Max — beide funktionieren)
5. Öffne diesen Workspace-Ordner in Claude Code:
   - Klicke "Open Folder"
   - Wähle den Ordner in dem diese Datei liegt
6. Tippe `/prime` um zu starten

---

## Abschnitt 2: ElevenLabs einrichten

**Account erstellen:**
1. Gehe zu **elevenlabs.io** und registriere dich
2. Wähle den Plan "Creator" (~22€/Monat, 100.000 Zeichen)
   → Reicht für ca. 8–10 Videos pro Monat

**Stimme wählen:**
1. Klicke auf "Voice Library" (oben im Menü)
2. Suche nach einer Stimme die zu deinem Kanal passt
   - Filter: Deutsch, männlich oder weiblich, dein gewünschter Stil
   - Beliebte deutsche Stimmen: "Adam", "Daniel", "Rachel"
3. Klicke auf die Stimme → "Add to Library"
4. Gehe zu "My Voices" → notiere die **Voice ID** (langer Code unter dem Stimmen-Namen)
5. Trage die Voice ID in `context/mein-kanal.md` ein

**API Key erstellen:**
1. Klicke oben rechts auf dein Profilbild → "Profile + API Key"
2. Klicke "Create API Key"
3. Benenne ihn "YouTube Autopilot"
4. Kopiere den Key (er wird nur einmal angezeigt!)
5. Öffne `scripts/youtube-producer.ps1` in einem Texteditor
6. Suche die Zeile: `$ElevenLabsApiKey = "DEIN_ELEVENLABS_API_KEY_HIER"`
7. Ersetze `DEIN_ELEVENLABS_API_KEY_HIER` durch deinen Key
8. Speichern

---

## Abschnitt 3: fal.ai einrichten

**Account erstellen:**
1. Gehe zu **fal.ai** und registriere dich
2. Klicke auf "Dashboard" → "Billing"
3. Lade Guthaben auf (Empfehlung: 20€ zum Start)
   → Kosten pro Video: ca. 1–2€ für alle Bilder

**API Key erstellen:**
1. Klicke auf "API Keys" im Dashboard
2. Klicke "Create new key"
3. Benenne ihn "YouTube Autopilot"
4. Kopiere den Key
5. Öffne `scripts/youtube-producer.ps1`
6. Suche: `$FalApiKey = "DEIN_FAL_AI_API_KEY_HIER"`
7. Ersetze den Platzhalter durch deinen Key
8. Speichern

---

## Abschnitt 4: YouTube API einrichten

Das ist der technisch aufwendigste Schritt — aber mit dieser Anleitung in 15 Minuten erledigt.

**Google Cloud Projekt erstellen:**
1. Gehe zu **console.cloud.google.com**
2. Klicke oben auf das Dropdown (neben "Google Cloud")
3. Klicke "Neues Projekt" → Name: "YouTube Autopilot" → Erstellen
4. Wechsle in das neue Projekt (oben im Dropdown)

**YouTube Data API aktivieren:**
1. Suche in der Google Cloud Console nach "YouTube Data API v3"
2. Klicke auf das Ergebnis → "Aktivieren"

**OAuth Client erstellen:**
1. Gehe zu "APIs & Dienste" → "Anmeldedaten"
2. Klicke "Anmeldedaten erstellen" → "OAuth-Client-ID"
3. Anwendungstyp: "Desktop-App"
4. Name: "YouTube Autopilot"
5. Erstellen → Notiere **Client-ID** und **Client-Secret**
6. Klicke "JSON herunterladen" → speichere als `client_secrets.json` im scripts/ Ordner

**Refresh Token generieren:**

Öffne PowerShell und führe diesen Befehl aus:

```powershell
$ClientId = "DEINE_CLIENT_ID"
$ClientSecret = "DEIN_CLIENT_SECRET"
$Scope = "https://www.googleapis.com/auth/youtube.upload https://www.googleapis.com/auth/youtube"
$AuthUrl = "https://accounts.google.com/o/oauth2/auth?client_id=$ClientId&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=$Scope&access_type=offline"
Start-Process $AuthUrl
```

1. Ein Browser öffnet sich — melde dich mit dem Google-Account an der den YouTube-Kanal besitzt
2. Bestätige die Berechtigungen
3. Kopiere den angezeigten **Authorization Code**
4. Führe diesen Befehl in PowerShell aus (Code einsetzen):

```powershell
$Code = "DEIN_AUTHORIZATION_CODE"
$Body = "code=$Code&client_id=$ClientId&client_secret=$ClientSecret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code"
$Response = Invoke-RestMethod -Uri "https://oauth2.googleapis.com/token" -Method Post -Body $Body -ContentType "application/x-www-form-urlencoded"
$Response.refresh_token
```

5. Kopiere den ausgegebenen **Refresh Token**
6. Öffne `scripts/youtube-producer.ps1`
7. Suche: `$GoogleRefreshToken = "DEIN_GOOGLE_REFRESH_TOKEN_HIER"`
8. Ersetze den Platzhalter → Speichern

**Client ID und Secret eintragen:**
In `scripts/youtube-producer.ps1` auch:
- `$GoogleClientId = "DEINE_CLIENT_ID"`
- `$GoogleClientSecret = "DEIN_CLIENT_SECRET"`

---

## Abschnitt 5: FFmpeg installieren

1. Gehe zu **ffmpeg.org/download.html**
2. Klicke auf "Windows" → "Windows builds from gyan.dev"
3. Lade `ffmpeg-release-essentials.zip` herunter
4. Entpacke den Ordner nach `C:\ffmpeg\`
5. Der Pfad zu ffmpeg.exe ist dann: `C:\ffmpeg\bin\ffmpeg.exe`
6. Öffne `scripts/youtube-producer.ps1`
7. Suche: `$FFmpegPath = "PFAD_ZU_FFMPEG_HIER"`
8. Ersetze durch: `"C:\ffmpeg\bin\ffmpeg.exe"` → Speichern

---

## Abschnitt 6: Ausgabeordner festlegen

1. Erstelle einen Ordner auf deinem PC wo Videos gespeichert werden sollen
   Beispiel: `C:\MeineYouTubeVideos\`
2. Trage den Pfad in `context/mein-kanal.md` ein (Abschnitt "Ausgabeordner")
3. Dieser Pfad wird automatisch von /skript-erstellen in die CSV eingetragen

---

## Abschnitt 7: Setup-Status abhaken

Öffne `context/setup-status.md` und hake alle erledigten Punkte ab.
Wenn alle Punkte erledigt sind: Trage "Bereit" als Status ein.

---

## Abschnitt 8: Erster Test

1. Starte Claude Code und öffne diesen Workspace
2. Tippe `/prime` — Claude gibt dir eine Statusübersicht
3. Falls du noch keine Nische hast: `/nische-finden` starten
4. Falls alles eingerichtet ist: Ein Test-Video mit `/skript-erstellen` → `/produzieren` erstellen

**Wenn die Produktion läuft und das Video auf YouTube erscheint: Setup erfolgreich.**

Bei Problemen: Schreibe an den Support mit einer Beschreibung des Fehlers und welcher Schritt nicht funktioniert hat.
