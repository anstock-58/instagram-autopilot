'use client'
import { useState, useEffect, useCallback } from 'react'

type Lead = { id: string; name: string; email: string; product: string; date: string; status: string }
type Product = { id: string; name: string; prompt: string }
type Settings = { activeProduct: string; price: number; paypalLink: string }

const STATUS_COLORS: Record<string, string> = {
  offen: 'bg-yellow-500/20 text-yellow-400',
  bezahlt: 'bg-blue-500/20 text-blue-400',
  geliefert: 'bg-green-500/20 text-green-400',
}

export default function AdminPage() {
  const [leads, setLeads] = useState<Lead[]>([])
  const [products, setProducts] = useState<Product[]>([])
  const [settings, setSettings] = useState<Settings>({ activeProduct: '', price: 17, paypalLink: '' })
  const [activePrompt, setActivePrompt] = useState('')
  const [saved, setSaved] = useState(false)
  const [auth, setAuth] = useState(false)
  const [pw, setPw] = useState('')

  const load = useCallback(async () => {
    const [leadsRes, settingsRes] = await Promise.all([
      fetch('/api/leads'),
      fetch('/api/settings'),
    ])
    const leadsData = await leadsRes.json()
    const settingsData = await settingsRes.json()
    setLeads(leadsData)
    setProducts(settingsData.products)
    setSettings({ activeProduct: settingsData.settings.activeProduct, price: settingsData.settings.price, paypalLink: settingsData.settings.paypalLink })
  }, [])

  useEffect(() => { if (auth) load() }, [auth, load])

  async function updateStatus(id: string, status: string) {
    await fetch(`/api/leads/${id}`, { method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ status }) })
    setLeads(leads.map(l => l.id === id ? { ...l, status } : l))
  }

  async function deleteLead(id: string) {
    if (!confirm('Lead löschen?')) return
    await fetch(`/api/leads/${id}`, { method: 'DELETE' })
    setLeads(leads.filter(l => l.id !== id))
  }

  async function saveSettings() {
    await fetch('/api/settings', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(settings) })
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  function generatePrompt(productId: string) {
    const p = products.find(p => p.id === productId)
    setActivePrompt(p?.prompt || '')
  }

  if (!auth) return (
    <div className="min-h-screen flex items-center justify-center bg-gray-950">
      <div className="bg-gray-900 border border-gray-800 rounded-2xl p-8 w-full max-w-sm">
        <h1 className="text-xl font-bold text-white mb-6 text-center">Admin Login</h1>
        <input type="password" value={pw} onChange={e => setPw(e.target.value)} onKeyDown={e => e.key === 'Enter' && pw === 'admin123' && setAuth(true)}
          className="w-full bg-gray-800 border border-gray-700 rounded-xl px-4 py-3 text-white mb-4" placeholder="Passwort" />
        <button onClick={() => pw === 'admin123' ? setAuth(true) : alert('Falsches Passwort')}
          className="w-full bg-orange-500 hover:bg-orange-400 text-white font-bold py-3 rounded-xl">
          Einloggen
        </button>
        <p className="text-gray-600 text-xs text-center mt-3">Standard: admin123 — in settings.json ändern</p>
      </div>
    </div>
  )

  const stats = {
    total: leads.length,
    offen: leads.filter(l => l.status === 'offen').length,
    bezahlt: leads.filter(l => l.status === 'bezahlt').length,
    geliefert: leads.filter(l => l.status === 'geliefert').length,
  }

  return (
    <div className="min-h-screen bg-gray-950 text-white">
      <div className="max-w-6xl mx-auto px-4 py-8">
        <div className="flex items-center justify-between mb-8">
          <h1 className="text-2xl font-bold">Admin Dashboard</h1>
          <a href="/" className="text-orange-400 hover:text-orange-300 text-sm">← Zur Landingpage</a>
        </div>

        {/* STATS */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-8">
          {[['Gesamt', stats.total, 'text-white'], ['Offen', stats.offen, 'text-yellow-400'], ['Bezahlt', stats.bezahlt, 'text-blue-400'], ['Geliefert', stats.geliefert, 'text-green-400']].map(([label, val, cls]) => (
            <div key={label as string} className="bg-gray-900 border border-gray-800 rounded-xl p-4 text-center">
              <div className={`text-3xl font-bold ${cls}`}>{val}</div>
              <div className="text-gray-500 text-sm mt-1">{label}</div>
            </div>
          ))}
        </div>

        {/* EINSTELLUNGEN */}
        <div className="bg-gray-900 border border-gray-800 rounded-2xl p-6 mb-8">
          <h2 className="text-lg font-bold mb-4">Einstellungen</h2>
          <div className="grid sm:grid-cols-3 gap-4 mb-4">
            <div>
              <label className="block text-gray-400 text-sm mb-1">Aktives Produkt</label>
              <select value={settings.activeProduct} onChange={e => setSettings(s => ({ ...s, activeProduct: e.target.value }))}
                className="w-full bg-gray-800 border border-gray-700 rounded-xl px-3 py-2 text-white">
                {products.map(p => <option key={p.id} value={p.id}>{p.name}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-1">Preis (€)</label>
              <select value={settings.price} onChange={e => setSettings(s => ({ ...s, price: Number(e.target.value) }))}
                className="w-full bg-gray-800 border border-gray-700 rounded-xl px-3 py-2 text-white">
                {[17, 27, 29].map(p => <option key={p} value={p}>{p} €</option>)}
              </select>
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-1">PayPal Link</label>
              <input type="text" value={settings.paypalLink} onChange={e => setSettings(s => ({ ...s, paypalLink: e.target.value }))}
                className="w-full bg-gray-800 border border-gray-700 rounded-xl px-3 py-2 text-white text-sm" placeholder="https://paypal.me/..." />
            </div>
          </div>
          <div className="flex gap-3 flex-wrap">
            <button onClick={saveSettings} className="bg-orange-500 hover:bg-orange-400 text-white font-bold px-5 py-2 rounded-xl text-sm">
              {saved ? '✓ Gespeichert' : 'Einstellungen speichern'}
            </button>
          </div>
        </div>

        {/* PRODUKT PROMPTS */}
        <div className="bg-gray-900 border border-gray-800 rounded-2xl p-6 mb-8">
          <h2 className="text-lg font-bold mb-4">Produkt Prompt erstellen</h2>
          <div className="flex gap-2 flex-wrap mb-4">
            {products.map(p => (
              <button key={p.id} onClick={() => generatePrompt(p.id)}
                className="bg-gray-800 hover:bg-gray-700 border border-gray-700 text-sm px-4 py-2 rounded-lg text-gray-200">
                {p.name}
              </button>
            ))}
          </div>
          {activePrompt && (
            <div>
              <div className="bg-gray-800 border border-gray-700 rounded-xl p-4 text-sm text-gray-300 whitespace-pre-wrap mb-3 max-h-64 overflow-y-auto">
                {activePrompt}
              </div>
              <button onClick={() => { navigator.clipboard.writeText(activePrompt); alert('Prompt kopiert!') }}
                className="bg-blue-600 hover:bg-blue-500 text-white text-sm px-4 py-2 rounded-lg">
                Prompt kopieren
              </button>
            </div>
          )}
        </div>

        {/* LEADS TABELLE */}
        <div className="bg-gray-900 border border-gray-800 rounded-2xl overflow-hidden">
          <div className="p-6 border-b border-gray-800 flex items-center justify-between">
            <h2 className="text-lg font-bold">Leads ({leads.length})</h2>
            <button onClick={load} className="text-gray-400 hover:text-white text-sm">↻ Aktualisieren</button>
          </div>
          {leads.length === 0 ? (
            <div className="p-8 text-center text-gray-500">Noch keine Leads vorhanden.</div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="text-gray-500 border-b border-gray-800">
                    <th className="text-left px-4 py-3">Name</th>
                    <th className="text-left px-4 py-3">E-Mail</th>
                    <th className="text-left px-4 py-3 hidden sm:table-cell">Produkt</th>
                    <th className="text-left px-4 py-3 hidden md:table-cell">Datum</th>
                    <th className="text-left px-4 py-3">Status</th>
                    <th className="text-left px-4 py-3">Aktionen</th>
                  </tr>
                </thead>
                <tbody>
                  {leads.map(lead => (
                    <tr key={lead.id} className="border-b border-gray-800/50 hover:bg-gray-800/30">
                      <td className="px-4 py-3 text-white">{lead.name}</td>
                      <td className="px-4 py-3 text-gray-300">
                        <a href={`mailto:${lead.email}`} className="hover:text-orange-400">{lead.email}</a>
                      </td>
                      <td className="px-4 py-3 text-gray-400 hidden sm:table-cell text-xs">{lead.product}</td>
                      <td className="px-4 py-3 text-gray-500 hidden md:table-cell text-xs">
                        {new Date(lead.date).toLocaleDateString('de-DE')}
                      </td>
                      <td className="px-4 py-3">
                        <select value={lead.status} onChange={e => updateStatus(lead.id, e.target.value)}
                          className={`rounded-lg px-2 py-1 text-xs font-medium border-0 cursor-pointer ${STATUS_COLORS[lead.status] || 'bg-gray-700 text-gray-300'}`}>
                          <option value="offen">offen</option>
                          <option value="bezahlt">bezahlt</option>
                          <option value="geliefert">geliefert</option>
                        </select>
                      </td>
                      <td className="px-4 py-3">
                        <button onClick={() => deleteLead(lead.id)} className="text-red-500 hover:text-red-400 text-xs">löschen</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
