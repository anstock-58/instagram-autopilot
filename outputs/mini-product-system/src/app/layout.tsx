import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Starter Pack Shop',
  description: 'Digitale Mini Produkte für schnellen Start online',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="de">
      <body className="bg-gray-950 text-white antialiased">{children}</body>
    </html>
  )
}
