export default function WidgetTabs({ lang }) {
  const isAr = lang === 'ar';

  const primary = [
    { key: 'company-snapshot',   en: 'Company Snapshot',  ar: 'نظرة عامة' },
    { key: 'corporate-news',     en: 'Announcements',     ar: 'الإعلانات' },
    { key: 'fact-sheet',         en: 'Fact Sheet',        ar: 'نشرة المعلومات' },
    { key: 'stock-activity',     en: 'Stock Activity',    ar: 'نشاط السهم' },
    { key: 'corporate-actions',  en: 'Corporate Actions', ar: 'الإجراءات' },
    { key: 'company-financials', en: 'Company Financials',ar: 'البيانات المالية' },
    { key: 'share-price',        en: 'Share Price',       ar: 'سعر السهم' },
    { key: 'performance',        en: 'Performance',       ar: 'الأداء' },
  ];
  const analytics = [
    { key: 'investment-calculator', en: 'Investment Calculator',  ar: 'حاسبة الاستثمار' },
    { key: 'share-series',          en: 'Share Series',           ar: 'سلسلة الأسهم' },
    { key: 'share-view',            en: 'Share View',             ar: 'عرض الأسهم' },
    { key: 'price-lookup',          en: 'Price Lookup',           ar: 'البحث عن السعر' },
    { key: 'peer-group-analysis',   en: 'Peer Group Analysis',    ar: 'تحليل المجموعة المماثلة' },
  ];
  const subscribe = { key: 'email-subscription', en: 'Subscribe', ar: 'الاشتراك' };

  const sections = [
    { key: 'company-snapshot',   en: 'Company Snapshot',   ar: 'نظرة عامة عن الشركة',     widgets: [{ key: 'company-snapshot' }] },
    { key: 'corporate-news',     en: 'Announcements',      ar: 'الإعلانات',                widgets: [{ key: 'corporate-news' }] },
    { key: 'fact-sheet',         en: 'Fact Sheet',         ar: 'نشرة المعلومات',           widgets: [{ key: 'fact-sheet' }] },
    { key: 'stock-activity',     en: 'Stock Activity',     ar: 'نشاط السهم',               widgets: [{ key: 'stock-activity' }] },
    { key: 'corporate-actions',  en: 'Corporate Actions',  ar: 'الإجراءات النظامية',       widgets: [{ key: 'corporate-actions' }] },
    { key: 'company-financials', en: 'Company Financials', ar: 'البيانات المالية',         widgets: [{ key: 'company-financials' }] },
    { key: 'share-price',        en: 'Share Price',        ar: 'سعر السهم',                widgets: [{ key: 'share-price' }] },
    { key: 'performance',        en: 'Performance',        ar: 'الأداء',                   widgets: [{ key: 'performance' }] },
    { key: 'investment-calculator', en: 'Investment Calculator', ar: 'حاسبة الاستثمار',    widgets: [{ key: 'investment-calculator' }] },
    { key: 'share-series',       en: 'Share Series',       ar: 'سلسلة الأسهم',             widgets: [{ key: 'share-series' }] },
    { key: 'share-view',         en: 'Share View',         ar: 'عرض الأسهم',               widgets: [{ key: 'share-view' }] },
    { key: 'price-lookup',       en: 'Price Lookup',       ar: 'البحث عن السعر',           widgets: [{ key: 'price-lookup' }] },
    { key: 'peer-group-analysis',en: 'Peer Group Analysis',ar: 'تحليل المجموعة المماثلة',  widgets: [{ key: 'peer-group-analysis' }] },
    { key: 'email-subscription', en: 'Subscribe',          ar: 'الاشتراك',                 widgets: [{ key: 'email-subscription' }] },
  ];

  const label = (o) => (isAr ? o.ar : o.en);
  const allLabel = isAr ? 'الكل' : 'All';
  const allSectionsLabel = isAr ? 'كل الأقسام' : 'All sections';
  const analyticsLabel = isAr ? 'تحليلات' : 'Analytics';

  return (
    <>
      <div className="ir-filterbar" id="ir-filterbar">
        <div className="ir-filterbar__inner">
          <div className="ir-tabs" role="tablist" aria-label={isAr ? 'أقسام المستثمرين' : 'Investor sections'}>
            <button role="tab" className="ir-tab is-active" data-target="all" aria-selected="true">{allLabel}</button>
            {primary.map(p => (
              <button key={p.key} role="tab" className="ir-tab" data-target={p.key} aria-selected="false">{label(p)}</button>
            ))}
            <div className="ir-tab-dropdown">
              <button type="button" className="ir-tab ir-tab--dropdown" aria-haspopup="menu" aria-expanded="false">
                {analyticsLabel}
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true"><polyline points="6 9 12 15 18 9"/></svg>
              </button>
              <div className="ir-tab-dropdown__menu" role="menu" hidden>
                {analytics.map(a => (
                  <button key={a.key} role="menuitem" data-target={a.key}>{label(a)}</button>
                ))}
              </div>
            </div>
            <button role="tab" className="ir-tab" data-target={subscribe.key} aria-selected="false">{label(subscribe)}</button>
          </div>

          <div className="ir-tabs-mobile">
            <label htmlFor="ir-tab-select" className="sr-only">{isAr ? 'الانتقال إلى قسم' : 'Jump to section'}</label>
            <select id="ir-tab-select" defaultValue="all">
              <option value="all">{allSectionsLabel}</option>
              {sections.map(s => (
                <option key={s.key} value={s.key}>{isAr ? s.ar : s.en}</option>
              ))}
            </select>
          </div>
        </div>
      </div>

      <section className="ir-sections" id="ir-sections" aria-label={isAr ? 'أدوات المستثمرين' : 'Investor widgets'}>
        {sections.map(s => (
          <section key={s.key} className="ir-section" data-section={s.key}>
            <h3 className="ir-section__title">{isAr ? s.ar : s.en}</h3>
            {s.twoUp ? (
              <div className="widget-grid-2">
                {s.widgets.map(w => <div key={w.key} className="widget__body" data-widget={w.key}></div>)}
              </div>
            ) : s.widgets.map(w => <div key={w.key} className="widget__body" data-widget={w.key}></div>)}
          </section>
        ))}
      </section>
    </>
  );
}
