import { NextResponse } from 'next/server'
import { readFileSync, writeFileSync } from 'fs'
import { join } from 'path'

const leadsPath = join(process.cwd(), 'data', 'leads.json')

export async function PATCH(req: Request, { params }: { params: { id: string } }) {
  const body = await req.json()
  const leads = JSON.parse(readFileSync(leadsPath, 'utf-8'))
  const idx = leads.findIndex((l: { id: string }) => l.id === params.id)
  if (idx === -1) return NextResponse.json({ error: 'Not found' }, { status: 404 })
  leads[idx] = { ...leads[idx], ...body }
  writeFileSync(leadsPath, JSON.stringify(leads, null, 2))
  return NextResponse.json({ ok: true })
}

export async function DELETE(_: Request, { params }: { params: { id: string } }) {
  const leads = JSON.parse(readFileSync(leadsPath, 'utf-8'))
  const filtered = leads.filter((l: { id: string }) => l.id !== params.id)
  writeFileSync(leadsPath, JSON.stringify(filtered, null, 2))
  return NextResponse.json({ ok: true })
}
