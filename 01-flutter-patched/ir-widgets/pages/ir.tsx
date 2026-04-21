'use client';
import { useEffect, useRef, useState } from 'react';
import Head from 'next/head';
import Script from 'next/script';

const CLIENT_ID = '5be9c146-613e-4141-a351-1f5e13fc5513';
const THEME_ID  = '81a06c05-1a48-4d1b-8dbd-bcf60a76730f';
const VERSION   = 'v2';

type Lang = 'en' | 'ar';

const SECTIONS_EN = [
  { id: 'stock-ticker',          title: '',                       minH: 52,  ticker: true },
  { id: 'company-snapshot',      title: 'Company Snapshot',       minH: 320 },
  { id: 'corporate-news',        title: 'Announcements',          minH: 400 },
  { id: 'fact-sheet-table',      title: 'Fact Sheet',             minH: 500, group: 'fact-sheet',     tabs: [{ label: 'Table', id: 'fact-sheet-table' }, { label: 'Chart', id: 'fact-sheet-charts' }] },
  { id: 'stock-activity-simple', title: 'Stock Activity',         minH: 500, group: 'stock-activity', tabs: [{ label: 'Simple', id: 'stock-activity-simple' }, { label: 'Advanced', id: 'stock-activity-advanced' }] },
  { id: 'corporate-actions',     title: 'Corporate Actions',      minH: 400 },
  { id: 'company-financials',    title: 'Company Financials',     minH: 500 },
  { id: 'investment-calculator', title: 'Investment Calculator',  minH: 400 },
  { id: 'share-price',           title: 'Share Price',            minH: 400 },
  { id: 'peer-group-analysis',   title: 'Peer Group Analysis',    minH: 400 },
  { id: 'performance',           title: 'Performance',            minH: 400 },
  { id: 'share-series',          title: 'Share Series',           minH: 300 },
  { id: 'email-subscription',    title: 'Email Subscription',     minH: 300 },
];

const SECTIONS_AR = [
  { id: 'stock-ticker',          title: '',                                    minH: 52,  ticker: true },
  { id: 'company-snapshot',      title: 'نظرة عامة عن الشركة',                minH: 320 },
  { id: 'corporate-news',        title: 'الإعلانات',                           minH: 400 },
  { id: 'fact-sheet-table',      title: 'نشرة المعلومات',                      minH: 500, group: 'fact-sheet',     tabs: [{ label: 'جدول', id: 'fact-sheet-table' }, { label: 'رسم بياني', id: 'fact-sheet-charts' }] },
  { id: 'stock-activity-simple', title: 'نشاط السهم',                          minH: 500, group: 'stock-activity', tabs: [{ label: 'بسيط', id: 'stock-activity-simple' }, { label: 'متقدم', id: 'stock-activity-advanced' }] },
  { id: 'corporate-actions',     title: 'الإجراءات النظامية',                  minH: 400 },
  { id: 'company-financials',    title: 'البيانات المالية',                    minH: 500 },
  { id: 'investment-calculator', title: 'حاسبة الاستثمار',                     minH: 400 },
  { id: 'share-price',           title: 'سعر السهم',                           minH: 400 },
  { id: 'peer-group-analysis',   title: 'تحليل المجموعة المماثلة',             minH: 400 },
  { id: 'performance',           title: 'الأداء',                              minH: 400 },
  { id: 'share-series',          title: 'سلسلة الأسهم',                        minH: 300 },
  { id: 'email-subscription',    title: 'الاشتراك بالبريد الإلكتروني',         minH: 300 },
];

function IRWidget({ widgetId, lang, minHeight = 300 }: { widgetId: string; lang: Lang; minHeight?: number }) {
  const innerRef = useRef<HTMLDivElement>(null);
  const loaded = useRef(false);

  useEffect(() => {
    const el = innerRef.current;
    if (!el || loaded.current) return;

    const tryLoad = () => {
      const w = window as any;
      if (typeof w.loadWidget === 'function') {
        loaded.current = true;
        w.loadWidget(widgetId, CLIENT_ID, lang, THEME_ID, VERSION);
      } else {
        setTimeout(tryLoad, 200);
      }
    };
    tryLoad();
  }, [widgetId, lang]);

  return (
    <div style={{ minHeight, overflowX: 'auto', WebkitOverflowScrolling: 'touch' as any }}>
      <div ref={innerRef} id={`${widgetId}-widget`} />
    </div>
  );
}

function TabbedWidget({ tabs, lang, minHeight = 400 }: { tabs: { label: string; id: string }[]; lang: Lang; minHeight?: number }) {
  const [active, setActive] = useState(0);
  return (
    <div>
      <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
        {tabs.map((tab, i) => (
          <button key={tab.id} onClick={() => setActive(i)} style={{
            padding: '8px 24px', borderRadius: 6,
            border: `2px solid ${i === active ? '#C62030' : '#E5E7EB'}`,
            background: i === active ? '#fff' : '#F3F4F6',
            color: i === active ? '#101727' : '#9CA3AF',
            fontWeight: i === active ? 600 : 400,
            fontSize: 14, cursor: 'pointer',
          }}>{tab.label}</button>
        ))}
      </div>
      {tabs.map((tab, i) => (
        <div key={tab.id} style={{ display: i === active ? 'block' : 'none' }}>
          <IRWidget widgetId={tab.id} lang={lang} minHeight={minHeight} />
        </div>
      ))}
    </div>
  );
}

export default function IRWidgetsPage() {
  const [lang, setLang] = useState<Lang>('en');
  const [scriptReady, setScriptReady] = useState(false);
  const isAr = lang === 'ar';
  const sections = isAr ? SECTIONS_AR : SECTIONS_EN;

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const urlLang = params.get('lang');
    if (urlLang === 'ar' || urlLang === 'en') setLang(urlLang);
  }, []);

  useEffect(() => {
    const handler = (e: MessageEvent) => {
      if (e.data?.type === 'set-lang' && (e.data.lang === 'ar' || e.data.lang === 'en')) {
        setLang(e.data.lang);
      }
    };
    window.addEventListener('message', handler);
    return () => window.removeEventListener('message', handler);
  }, []);

  // Report height to Flutter parent
  useEffect(() => {
    const report = () => {
      const h = document.body.scrollHeight;
      window.parent?.postMessage({ type: 'ir-page-height', height: h }, '*');
    };
    const ro = new ResizeObserver(report);
    ro.observe(document.body);
    report();
    return () => ro.disconnect();
  }, []);

  return (
    <>
      <Head>
        <meta charSet="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>IR Widgets</title>
      </Head>

      <Script
        src="https://irp.atnmo.com/v2/widget/widget-loader.js"
        strategy="afterInteractive"
        onReady={() => setScriptReady(true)}
      />

      <div dir={isAr ? 'rtl' : 'ltr'} style={{ fontFamily: 'Inter, sans-serif', background: '#fff', padding: '0 0 40px' }}>
        {scriptReady && sections.map((s, idx) => {
          if ((s as any).ticker) {
            return (
              <div key={s.id} style={{
                borderTop: '2px solid #C62030',
                borderBottom: '2px solid #C62030',
                overflow: 'hidden',
                minHeight: 52,
                display: 'flex',
                alignItems: 'center',
              }}>
                <IRWidget widgetId={s.id} lang={lang} minHeight={52} />
              </div>
            );
          }
          return (
            <div key={s.id} style={{
              padding: '32px 0 0',
              borderTop: idx > 1 ? '1px solid #E5E7EB' : 'none',
              marginTop: idx > 1 ? 32 : 0,
            }}>
              {s.title && (
                <h2 style={{
                  fontSize: 20, fontWeight: 600, color: '#101727',
                  marginBottom: 12, textAlign: isAr ? 'right' : 'left',
                }}>{s.title}</h2>
              )}
              {(s as any).tabs
                ? <TabbedWidget tabs={(s as any).tabs} lang={lang} minHeight={s.minH} />
                : <IRWidget widgetId={s.id} lang={lang} minHeight={s.minH} />
              }
            </div>
          );
        })}
      </div>

      <style suppressHydrationWarning>{`
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { background: #fff; overflow-x: hidden; }
        body { font-family: Inter, sans-serif; }
      `}</style>
    </>
  );
}
