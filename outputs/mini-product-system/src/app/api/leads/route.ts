import { NextResponse } from 'next/server'
import { readFileSync, writeFileSync } from 'fs'
import { join } from 'path'

const leadsPath = join(process.cwd(), 'data', 'leads.json')

function getLeads() {
  try { return JSON.parse(readFileSync(leadsPath, 'utf-8')) } catch { return [] }
}

export async function GET() {
  return NextResponse.json(getLeads())
}

export async function POST(req: Request) {
  const body = await req.json()
  const leads = getLeads()
  const newLead = {
    id: Date.now().toString(),
    name: body.name,
    email: body.email,
    product: body.product,
    date: new Date().toISOString(),
    status: 'offen',
  }
  try {
    leads.push(newLead)
    writeFileSync(leadsPath, JSON.stringify(leads, null, 2))
  } catch {
    // Vercel: Dateisystem read-only — Lead wird nicht gespeichert aber Käufer bekommt PayPal-Link
  }
  return NextResponse.json({ ok: true, id: newLead.id })
}
