import { NextResponse } from 'next/server'
import { readFileSync, writeFileSync } from 'fs'
import { join } from 'path'

const settingsPath = join(process.cwd(), 'config', 'settings.json')
const productsPath = join(process.cwd(), 'config', 'products.json')

export async function GET() {
  const settings = JSON.parse(readFileSync(settingsPath, 'utf-8'))
  const { products } = JSON.parse(readFileSync(productsPath, 'utf-8'))
  const product = products.find((p: { id: string }) => p.id === settings.activeProduct) || products[0]
  return NextResponse.json({ settings, product, products })
}

export async function POST(req: Request) {
  const body = await req.json()
  const settings = JSON.parse(readFileSync(settingsPath, 'utf-8'))
  const updated = { ...settings, ...body }
  writeFileSync(settingsPath, JSON.stringify(updated, null, 2))
  return NextResponse.json({ ok: true })
}
