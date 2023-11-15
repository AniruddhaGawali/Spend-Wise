import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Spend Wise',
  description: 'Streamlined expense management app for easy tracking, categorization, and control of your finances.',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <head>
      <link rel="icon" href="/wallet.svg" />
      </head>
      <body className={inter.className}>{children}</body>
    </html>
  )
}
