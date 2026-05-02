'use client'
import { useState, useEffect } from 'react'

type Product = {
  id: string
  name: string
  tagline: string
  description: string
  contents: string[]
}

type Settings = {
  activeProduct: string
  price: number
  currency: string
  paypalLink: string
}

export default function LandingPage() {
  const [product, setProduct] = useState<Product | null>(null)
  const [settings, setSettings] = useState<Settings | null>(null)
  const [form, setForm] = useState({ name: '', email: '', product: '' })
  const [submitted, setSubmitted] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    fetch('/api/settings').then(r => r.json()).then((data: { settings: Settings; product: Product }) => {
      setSettings(data.settings)
      setProduct(data.product)
      setForm(f => ({ ...f, product: data.product?.id || '' }))
    })
  }, [])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!form.name || !form.email) { setError('Bitte Name und E-Mail ausfüllen.'); return }
    setLoading(true)
    setError('')
    try {
      const res = await fetch('/api/leads', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(form),
      })
      if (res.ok) setSubmitted(true)
      else setError('Fehler beim Senden. Bitte nochmal versuchen.')
    } catch {
      setError('Verbindungsfehler.')
    }
    setLoading(false)
  }

  if (!product || !settings) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-gray-400">Lädt...</div>
    </div>
  )

  return (
    <main className="min-h-screen">
      {/* HERO */}
      <section className="bg-gradient-to-br from-gray-900 via-gray-950 to-black px-4 py-16 text-center">
        <div className="max-w-2xl mx-auto">
          <div className="inline-block bg-orange-500/10 border border-orange-500/30 text-orange-400 text-sm px-4 py-1 rounded-full mb-6">
            Digitales Mini Produkt · Sofort nutzbar
          </div>
          <h1 className="text-3xl sm:text-5xl font-bold text-white mb-4 leading-tight">
            {product.name}
          </h1>
          <p className="text-lg text-gray-300 mb-8 max-w-xl mx-auto">
            {product.tagline}
          </p>
          <a href="#kaufen" className="inline-block bg-orange-500 hover:bg-orange-400 text-white font-bold text-lg px-8 py-4 rounded-xl transition-all shadow-lg shadow-orange-500/20">
            Jetzt Starter Pack sichern →
          </a>
          <p className="text-gray-500 text-sm mt-4">Einmalzahlung · {settings.price} {settings.currency} · Sofort nutzbar</p>
        </div>
      </section>

      {/* PROBLEM */}
      <section className="bg-gray-900 px-4 py-14">
        <div className="max-w-2xl mx-auto">
          <h2 className="text-2xl font-bold text-white mb-6 text-center">Kennst du das?</h2>
          <ul className="space-y-4">
            {[
              'Du willst online starten — aber verlierst dich in zu vielen Ideen, Tools und Tipps.',
              'Du weißt nicht, was du posten sollst oder wie du täglich Content erstellst.',
              'Du willst ein kleines Angebot bauen — hast aber keine Vorlage und fängst nicht an.',
              'Du nutzt ChatGPT — aber weißt nicht genau, wie du damit schneller vorankommst.',
            ].map((item, i) => (
              <li key={i} className="flex gap-3 items-start bg-gray-800/50 rounded-xl p-4">
                <span className="text-orange-400 text-xl mt-0.5">✗</span>
                <span className="text-gray-300">{item}</span>
              </li>
            ))}
          </ul>
        </div>
      </section>

      {/* PRODUKT */}
      <section className="bg-gray-950 px-4 py-14">
        <div className="max-w-2xl mx-auto">
          <h2 className="text-2xl font-bold text-white mb-2 text-center">Was du bekommst</h2>
          <p className="text-gray-400 text-center mb-8">{product.description}</p>
          <ul className="space-y-3">
            {product.contents.map((item, i) => (
              <li key={i} className="flex gap-3 items-start bg-gray-900 border border-gray-800 rounded-xl p-4">
                <span className="text-green-400 text-xl mt-0.5">✓</span>
                <span className="text-gray-200">{item}</span>
              </li>
            ))}
          </ul>
        </div>
      </section>

      {/* PREIS */}
      <section className="bg-gray-900 px-4 py-14 text-center">
        <div className="max-w-sm mx-auto bg-gray-950 border border-orange-500/30 rounded-2xl p-8">
          <p className="text-gray-400 text-sm mb-2">Dein Preis heute</p>
          <div className="text-6xl font-bold text-orange-400 mb-1">{settings.price}€</div>
          <p className="text-gray-500 text-sm mb-6">Einmalzahlung. Sofort nutzbar. Keine Mitgliedschaft.</p>
          <a href="#kaufen" className="block bg-orange-500 hover:bg-orange-400 text-white font-bold text-lg px-6 py-3 rounded-xl transition-all">
            Jetzt Starter Pack sichern →
          </a>
        </div>
      </section>

      {/* KAUFBEREICH */}
      <section id="kaufen" className="bg-gray-950 px-4 py-16">
        <div className="max-w-lg mx-auto">
          <h2 className="text-2xl font-bold text-white mb-2 text-center">Zugang anfragen</h2>
          <p className="text-gray-400 text-center mb-8 text-sm">Trag dich ein, du bekommst dann den Zahlungslink per Info.</p>

          {submitted ? (
            <div className="bg-green-900/30 border border-green-500/40 rounded-2xl p-8 text-center">
              <div className="text-4xl mb-4">🎉</div>
              <h3 className="text-xl font-bold text-white mb-3">Danke! Deine Anfrage ist angekommen.</h3>
              <p className="text-gray-300 mb-6">Du kannst jetzt über folgenden Zahlungslink bezahlen:</p>
              <a
                href={settings.paypalLink}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-block bg-blue-600 hover:bg-blue-500 text-white font-bold px-6 py-3 rounded-xl transition-all mb-4"
              >
                Jetzt {settings.price}€ bezahlen via PayPal →
              </a>
              <p className="text-gray-500 text-sm mt-4">Nach Zahlung bekommst du dein Starter Pack per E-Mail.</p>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="bg-gray-900 border border-gray-800 rounded-2xl p-8 space-y-4">
              <div>
                <label className="block text-gray-300 text-sm mb-2">Dein Name</label>
                <input
                  type="text"
                  value={form.name}
                  onChange={e => setForm(f => ({ ...f, name: e.target.value }))}
                  className="w-full bg-gray-800 border border-gray-700 rounded-xl px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-orange-500"
                  placeholder="Vorname"
                />
              </div>
              <div>
                <label className="block text-gray-300 text-sm mb-2">E-Mail Adresse</label>
                <input
                  type="email"
                  value={form.email}
                  onChange={e => setForm(f => ({ ...f, email: e.target.value }))}
                  className="w-full bg-gray-800 border border-gray-700 rounded-xl px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-orange-500"
                  placeholder="deine@email.de"
                />
              </div>
              <div>
                <label className="block text-gray-300 text-sm mb-2">Produkt</label>
                <div className="w-full bg-gray-800 border border-gray-700 rounded-xl px-4 py-3 text-orange-400 font-medium">
                  {product.name} — {settings.price}€
                </div>
              </div>
              {error && <p className="text-red-400 text-sm">{error}</p>}
              <button
                type="submit"
                disabled={loading}
                className="w-full bg-orange-500 hover:bg-orange-400 disabled:opacity-50 text-white font-bold text-lg px-6 py-4 rounded-xl transition-all"
              >
                {loading ? 'Wird gesendet...' : 'Zugang anfragen →'}
              </button>
              <p className="text-gray-600 text-xs text-center">Keine Spam. Nur der Zahlungslink und dein Produkt.</p>
            </form>
          )}
        </div>
      </section>

      <footer className="bg-gray-950 border-t border-gray-900 px-4 py-8 text-center text-gray-600 text-sm">
        <p>Digitales Produkt · Sofort verfügbar nach Zahlung</p>
      </footer>
    </main>
  )
}
