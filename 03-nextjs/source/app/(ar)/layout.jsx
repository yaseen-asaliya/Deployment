import '../global.css';

export const metadata = {
  title: 'مجموعة السيف — علاقات المستثمرين',
  description: 'مجموعة السيف (تداول: 4192). المجموعة السعودية الرائدة في تجارة الأدوات المنزلية والمطبخ — علاقات المستثمرين، الحوكمة، الإفصاحات، ومعلومات السهم.',
};

export const viewport = {
  themeColor: '#C62030',
};

export default function ArRootLayout({ children }) {
  return (
    <html lang="ar" dir="rtl">
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
