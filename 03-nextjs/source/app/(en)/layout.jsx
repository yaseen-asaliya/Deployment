import '../global.css';

export const metadata = {
  title: 'Al Saif Gallery — Investor Relations',
  description: "Al Saif Gallery (Tadawul: 4192). Saudi Arabia's leading home & kitchen retailer — investor relations, governance, disclosures, and share information.",
  icons: {
    icon: "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><circle cx='50' cy='50' r='48' fill='%238B0000'/><ellipse cx='50' cy='50' rx='20' ry='48' fill='none' stroke='white' stroke-width='2.5'/><line x1='2' y1='50' x2='98' y2='50' stroke='white' stroke-width='2.5'/></svg>",
  },
};

export const viewport = {
  themeColor: '#C62030',
};

export default function EnRootLayout({ children }) {
  return (
    <html lang="en" dir="ltr">
      <head>
        <link rel="preconnect" href="https://irp.atnmo.com" crossOrigin="anonymous" />
        <link rel="dns-prefetch" href="https://irp.atnmo.com" />
        <link rel="alternate" hrefLang="en" href="/" />
        <link rel="alternate" hrefLang="ar" href="/ar/" />
      </head>
      <body>
        <div className="page">{children}</div>
      </body>
    </html>
  );
}
