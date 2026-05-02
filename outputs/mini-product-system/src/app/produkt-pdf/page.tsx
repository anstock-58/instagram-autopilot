'use client'
import React from 'react'

const hooks = [
  "Wenn du online starten willst, aber nicht weißt womit — schau dir das an.",
  "Die meisten machen diesen Fehler beim ersten TikTok-Video.",
  "Ich wünschte, das hätte mir jemand am Anfang gesagt.",
  "In 30 Sekunden zeige ich dir den einzigen Hook, den du brauchst.",
  "Das wissen die meisten Einsteiger nicht — und es kostet sie Wochen.",
  "Stell dir vor, du weißt jeden Morgen genau was du heute postest.",
  "3 Dinge, die ich täglich mache bevor ich poste.",
  "So habe ich meinen ersten Online-Verkauf gemacht — ohne große Reichweite.",
  "Niemand redet darüber, aber das ist der einfachste erste Schritt.",
  "Der Fehler, den fast alle neuen Creator machen.",
  "Du scrollst täglich TikTok — warum nicht auch davon profitieren?",
  "Ich zeige dir meinen kompletten Content-Plan für diese Woche.",
  "So erstelle ich in 10 Minuten Content für die ganze Woche.",
  "5 Video-Ideen, die du heute noch drehen kannst.",
  "Was ich nach 30 Tagen täglichem Posten gelernt habe.",
  "Mein Setup als Content Creator — unter 50 Euro.",
  "So schreibe ich täglich 3 Posts in unter 15 Minuten.",
  "Dieser eine Satz hat mir mehr Views gebracht als alles andere.",
  "Warum dein erstes Video nicht perfekt sein muss.",
  "3 ChatGPT-Prompts die ich täglich nutze.",
  "Das ist das TikTok-Format, das am einfachsten funktioniert.",
  "So plane ich meinen Content für den ganzen Monat in einer Stunde.",
  "Kennst du das Gefühl, täglich blank zu sein beim Posten?",
  "Ich habe 30 Tage täglich gepostet — was dann passiert ist.",
  "Warum ich keine teure Kamera brauche um auf TikTok zu wachsen.",
  "Das erste Video, das ich je gedreht habe — und was ich daraus gelernt habe.",
  "So findest du dein Thema als Content Creator in 5 Minuten.",
  "Diese 3 Fehler machen fast alle Anfänger auf TikTok.",
  "Mein ehrlicher Rückblick nach 3 Monaten Content Creation.",
  "Hook, Problem, Lösung, CTA — das einzige TikTok-Format das du brauchst.",
]

const videoIdeen: [string, string][] = [
  ["Mein Setup für unter 50 Euro", "Zeig wie du mit dem Handy startest."],
  ["ChatGPT für Einsteiger", "Erkläre in 60 Sekunden wie man einen guten Prompt schreibt."],
  ["3 Fehler die ich am Anfang gemacht habe", "Persönlich, ehrlich, Story-Format."],
  ["Ein Tag im Leben eines Content Creators", "Kurzer Vlog, authentisch."],
  ["Mit diesen 5 Tools spare ich täglich Zeit", "Praktische Tool-Runde."],
  ["So plane ich meinen Posting-Plan für die Woche", "Zeig deinen Kalender."],
  ["Mein erstes TikTok Video", "Stell dich vor, erkläre worum es geht."],
  ["Was niemand über Content Creation sagt", "Ehrlicher Einblick."],
  ["30 Video-Ideen in 5 Minuten mit ChatGPT", "Live zeigen."],
  ["Warum ich trotzdem poste, obwohl niemand zuschaut", "Motivationsformat."],
  ["So schreibe ich Captions die Leute lesen", "Tutorial, praktisch."],
  ["Mein Content-Kalender für diesen Monat", "Transparent zeigen."],
  ["3 Hook-Sätze die ich diese Woche teste", "Experiment-Format."],
  ["Was ist eigentlich ein Hook?", "Für Einsteiger erklärt."],
  ["Mein bisher bestes Video — und warum", "Analyse-Format."],
]

const tage = [
  { tag: "Tag 1", thema: "Vorstellung", hook: "Das ist mein erstes Video.", aufgabe: "Stelle dich vor. Sag wem du hilfst und womit." },
  { tag: "Tag 2", thema: "Problem zeigen", hook: "Kennst du das Gefühl, wenn du nicht weißt was du posten sollst?", aufgabe: "Beschreibe das Problem ehrlich." },
  { tag: "Tag 3", thema: "Erster Tipp", hook: "Das wissen die meisten Einsteiger nicht.", aufgabe: "Zeige einen Tipp den man sofort anwenden kann." },
  { tag: "Tag 4", thema: "Tool empfehlen", hook: "Dieses kostenlose Tool nutze ich täglich.", aufgabe: "Zeige praktisch wie du das Tool verwendest." },
  { tag: "Tag 5", thema: "Behind the Scenes", hook: "So sieht mein Content-Tag wirklich aus.", aufgabe: "Zeig etwas Echtes. Keine Perfektion." },
  { tag: "Tag 6", thema: "Produkt erwähnen", hook: "Ich habe dir etwas vorbereitet.", aufgabe: "Erkläre was im Pack ist. Verweise auf die Bio." },
  { tag: "Tag 7", thema: "Community fragen", hook: "Ich habe eine ehrliche Frage an dich.", aufgabe: "Stelle eine Frage. Antworte auf alle Kommentare." },
]

const prompts: [string, string][] = [
  ["Hook generieren", "Erstelle mir 10 TikTok-Hook-Sätze für: [THEMA]\nTon: direkt, anfängerfreundlich.\nFormat: Nummeriert, max. 15 Wörter pro Hook."],
  ["Video-Skript", "Schreib mir ein 45-Sek.-TikTok-Skript über: [THEMA]\nAufbau: Hook, Problem, Lösung, CTA.\nTon: einfach, direkt, menschlich."],
  ["Caption schreiben", "Schreib mir 3 TikTok-Captions für: [THEMA]\nJede: max. 5 Zeilen plus 3 Hashtags."],
  ["Video-Ideen", "20 TikTok-Video-Ideen für: [THEMA]\nZielgruppe: [ZIELGRUPPE]\nFormat: Titel plus 1 Satz."],
  ["Content-Kalender", "7-Tage-Content-Kalender für TikTok.\nThema: [THEMA]\nPro Tag: Thema, Hook, Format, CTA."],
  ["Bio schreiben", "3 TikTok-Bio-Varianten.\nIch helfe: [ZIELGRUPPE] bei: [PROBLEM]\nJede Bio: max. 3 Zeilen plus 1 Emoji."],
  ["Kommentar beantworten", "Kommentar: [KOMMENTAR]\n3 kurze, freundliche Antworten.\nTon: menschlich, nicht wie ein Bot."],
  ["DM schreiben", "DM für: [PRODUKT] zu [PREIS]\nTon: freundlich, direkt, kein Spam-Gefühl."],
  ["Produktbeschreibung", "Produktbeschreibung für: [PRODUKT]\nZielgruppe: [ZIELGRUPPE]\nFormat: 3-5 Bulletpoints plus Abschlusssatz."],
  ["Wochenplan", "Wochenplan für Creator mit [ZEIT] täglich.\nThema: [THEMA]\nMo bis So mit konkreten Aufgaben."],
]

export default function ProduktPDF() {
  const s = {
    page: { background: 'white', color: 'black', minHeight: '100vh' } as React.CSSProperties,
    wrap: { maxWidth: '700px', margin: '0 auto', padding: '40px 32px' } as React.CSSProperties,
    hint: { background: '#eff6ff', border: '1px solid #bfdbfe', borderRadius: '12px', padding: '16px', marginBottom: '32px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' } as React.CSSProperties,
    btn: { background: '#2563eb', color: 'white', border: 'none', padding: '8px 16px', borderRadius: '8px', fontWeight: 'bold', cursor: 'pointer' } as React.CSSProperties,
    h1: { fontSize: '2.25rem', fontWeight: 'bold', margin: '0 0 8px' } as React.CSSProperties,
    h2: { fontSize: '1.5rem', fontWeight: 'bold', borderBottom: '2px solid #e5e7eb', paddingBottom: '8px', marginBottom: '16px' } as React.CSSProperties,
    box: { background: '#f9fafb', borderRadius: '10px', padding: '14px', marginBottom: '8px', display: 'flex', gap: '12px' } as React.CSSProperties,
    num: { color: '#f97316', fontWeight: 'bold', fontSize: '0.85rem', minWidth: '24px' } as React.CSSProperties,
    tag: { background: '#f97316', color: 'white', fontSize: '0.75rem', padding: '2px 10px', borderRadius: '999px', fontWeight: 'bold' } as React.CSSProperties,
    pre: { background: 'white', border: '1px solid #bfdbfe', borderRadius: '6px', padding: '10px', fontSize: '0.8rem', color: '#374151', whiteSpace: 'pre-wrap', margin: 0, fontFamily: 'inherit' } as React.CSSProperties,
  }

  return (
    <div style={s.page}>
      <div style={s.wrap}>
        <div style={s.hint} className="no-print">
          <p style={{ color: '#1e40af', fontWeight: '600', margin: 0 }}>Strg+P klicken → Als PDF speichern → Speichern</p>
          <button style={s.btn} onClick={() => window.print()}>PDF erstellen</button>
        </div>

        <div style={{ textAlign: 'center', borderBottom: '2px solid #e5e7eb', paddingBottom: '32px', marginBottom: '32px' }}>
          <h1 style={s.h1}>KI Content Starter Pack</h1>
          <p style={{ color: '#6b7280', margin: '0 0 12px' }}>Dein Starter Pack für TikTok, Instagram und Reels</p>
          <span style={{ background: '#fff7ed', color: '#c2410c', fontSize: '0.85rem', padding: '4px 16px', borderRadius: '999px', fontWeight: '600' }}>Sofort nutzbar · Alle Vorlagen fertig</span>
        </div>

        <div style={{ background: '#f9fafb', borderRadius: '12px', padding: '24px', marginBottom: '24px' }}>
          <h2 style={{ fontSize: '1.25rem', fontWeight: 'bold', marginTop: 0 }}>Vorwort</h2>
          <p style={{ color: '#374151', lineHeight: '1.7', margin: 0 }}>Du musst nicht perfekt sein, um anzufangen. Du musst anfangen, um besser zu werden. Die meisten verlieren sich in Tools, Strategien und Theorien bevor sie auch nur ein einziges Video gedreht haben. Dieses Starter Pack gibt dir alles, was du für die ersten Wochen brauchst: fertige Vorlagen, klare Ideen, einfache Prompts. Du musst nur noch starten.</p>
        </div>

        <h2 style={s.h2}>TEIL 1: 30 Hook Vorlagen</h2>
        <div style={{ marginBottom: '32px' }}>
          {hooks.map((hook, i) => (
            <div key={i} style={s.box}>
              <span style={s.num}>{i + 1}.</span>
              <span style={{ color: '#374151', fontSize: '0.9rem' }}>{hook}</span>
            </div>
          ))}
        </div>

        <h2 style={s.h2}>TEIL 2: 15 Video Ideen</h2>
        <div style={{ marginBottom: '32px' }}>
          {videoIdeen.map(([titel, desc], i) => (
            <div key={i} style={s.box}>
              <span style={s.num}>{i + 1}.</span>
              <span style={{ color: '#374151', fontSize: '0.9rem' }}><strong>{titel}</strong> — {desc}</span>
            </div>
          ))}
        </div>

        <h2 style={s.h2}>TEIL 3: 7 Tage Posting Plan</h2>
        <div style={{ marginBottom: '32px' }}>
          {tage.map((t) => (
            <div key={t.tag} style={{ background: '#f9fafb', borderRadius: '10px', padding: '14px', marginBottom: '8px' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '6px' }}>
                <span style={s.tag}>{t.tag}</span>
                <span style={{ fontWeight: 'bold' }}>{t.thema}</span>
              </div>
              <p style={{ margin: '0 0 4px', color: '#4b5563', fontSize: '0.875rem' }}><strong>Hook:</strong> {t.hook}</p>
              <p style={{ margin: 0, color: '#4b5563', fontSize: '0.875rem' }}><strong>Aufgabe:</strong> {t.aufgabe}</p>
            </div>
          ))}
        </div>

        <h2 style={s.h2}>TEIL 4: 10 ChatGPT Prompts</h2>
        <div style={{ marginBottom: '32px' }}>
          {prompts.map(([titel, prompt], i) => (
            <div key={i} style={{ background: '#eff6ff', borderRadius: '10px', padding: '14px', marginBottom: '8px' }}>
              <div style={{ marginBottom: '8px' }}>
                <span style={{ background: '#dbeafe', color: '#1d4ed8', fontSize: '0.75rem', padding: '2px 8px', borderRadius: '4px', fontWeight: '600' }}>Prompt {i + 1}</span>
                <span style={{ color: '#374151', fontSize: '0.875rem', fontWeight: '600', marginLeft: '8px' }}>{titel}</span>
              </div>
              <pre style={s.pre}>{prompt}</pre>
            </div>
          ))}
        </div>

        <div style={{ background: '#fff7ed', border: '1px solid #fed7aa', borderRadius: '12px', padding: '24px', textAlign: 'center', marginBottom: '24px' }}>
          <h2 style={{ fontSize: '1.2rem', fontWeight: 'bold', marginTop: 0 }}>Nächster Schritt</h2>
          <p style={{ color: '#374151', margin: '0 0 8px' }}>Wähle eine Video-Idee aus Teil 2. Such dir einen Hook aus Teil 1. Dreh das Video heute.</p>
          <p style={{ color: '#ea580c', fontWeight: '600', margin: 0 }}>Perfekt ist der Feind von gut. Dein erster Post ist besser als kein Post.</p>
        </div>

        <p style={{ textAlign: 'center', color: '#9ca3af', fontSize: '0.75rem', borderTop: '1px solid #e5e7eb', paddingTop: '16px' }}>
          KI Content Starter Pack · 17 Euro · Einmalzahlung
        </p>
      </div>
      <style>{`.no-print { } @media print { .no-print { display: none !important; } }`}</style>
    </div>
  )
}
