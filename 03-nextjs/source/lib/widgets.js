// Reused verbatim from the Astro version for parity.
export const WIDGET_CONFIG = {
  uuid:      '5be9c146-613e-4141-a351-1f5e13fc5513',
  listingId: '81a06c05-1a48-4d1b-8dbd-bcf60a76730f',
  version:   'v3',
  loaderUrl: 'https://irp.atnmo.com/v3/widget/widget-loader.js',
};

export const TABS = [
  { id: 'overview',      widgets: [{ key: 'company-snapshot',       labelEn: 'Company Snapshot',        labelAr: 'لمحة عن الشركة' }] },
  { id: 'announcements', widgets: [{ key: 'corporate-news',         labelEn: 'Latest Announcements',    labelAr: 'آخر الإعلانات' }] },
  { id: 'factsheet',     widgets: [
      { key: 'fact-sheet-table',  labelEn: 'Fact Sheet',          labelAr: 'نشرة المعلومات' },
      { key: 'fact-sheet-charts', labelEn: 'Fact Sheet — Charts', labelAr: 'نشرة المعلومات — الرسوم' },
  ], twoUp: true },
  { id: 'stockactivity', widgets: [
      { key: 'stock-activity-simple',   labelEn: 'Stock Activity',            labelAr: 'نشاط السهم' },
      { key: 'stock-activity-advanced', labelEn: 'Stock Activity — Advanced', labelAr: 'نشاط السهم — متقدم' },
  ], twoUp: true },
  { id: 'actions',       widgets: [{ key: 'corporate-actions',     labelEn: 'Corporate Actions',     labelAr: 'الإجراءات النظامية' }] },
  { id: 'financials',    widgets: [{ key: 'company-financials',    labelEn: 'Company Financials',    labelAr: 'البيانات المالية' }] },
  { id: 'shareprice',    widgets: [{ key: 'share-price',           labelEn: 'Share Price',           labelAr: 'سعر السهم' }] },
  { id: 'performance',   widgets: [{ key: 'performance',           labelEn: 'Performance',           labelAr: 'الأداء' }] },
  { id: 'calculator',    widgets: [{ key: 'investment-calculator', labelEn: 'Investment Calculator', labelAr: 'حاسبة الاستثمار' }] },
  { id: 'series',        widgets: [{ key: 'share-series',          labelEn: 'Share Series',          labelAr: 'سلسلة الأسهم' }] },
  { id: 'peer',          widgets: [{ key: 'peer-group-analysis',   labelEn: 'Peer Group Analysis',   labelAr: 'تحليل المجموعة المماثلة' }] },
  { id: 'zakat',         widgets: [{ key: 'zakat-calculator',      labelEn: 'Zakat Calculator',      labelAr: 'حاسبة الزكاة' }] },
  { id: 'subscribe',     widgets: [{ key: 'email-subscription',    labelEn: 'Email Subscription',    labelAr: 'الاشتراك في النشرة' }] },
];

export const TAB_LABELS = {
  en: { overview: 'Overview', announcements: 'Announcements', factsheet: 'Fact Sheet', stockactivity: 'Stock Activity', actions: 'Corporate Actions', financials: 'Financials', shareprice: 'Share Price', performance: 'Performance', calculator: 'Calculator', series: 'Share Series', peer: 'Peer Group', zakat: 'Zakat', subscribe: 'Subscribe' },
  ar: { overview: 'نظرة عامة', announcements: 'الإعلانات', factsheet: 'نشرة المعلومات', stockactivity: 'نشاط السهم', actions: 'الإجراءات النظامية', financials: 'البيانات المالية', shareprice: 'سعر السهم', performance: 'الأداء', calculator: 'حاسبة الاستثمار', series: 'سلسلة الأسهم', peer: 'تحليل المجموعة المماثلة', zakat: 'الزكاة', subscribe: 'الاشتراك' },
};

export const CASE_ITEMS = {
  en: [
    { n: '01', title: 'Market leader',       body: 'The largest specialty retailer in household and kitchen appliances in Saudi Arabia, with national coverage through 73 stores.' },
    { n: '02', title: 'Proprietary brands',  body: 'Approximately 88% of revenue from owned brands — EDISON, TORNADO, ROCKY, ROBUST and others — with stronger margins and control over design, sourcing and quality.' },
    { n: '03', title: 'Scalable model',      body: 'Omnichannel retail operating model with end-to-end sourcing, logistics and customer care built to scale into adjacent categories and geographies.' },
    { n: '04', title: 'Strong fundamentals', body: 'SAR 758.8M revenue, proven profitability, and a disciplined capital allocation framework aligned with Saudi Vision 2030.' },
  ],
  ar: [
    { n: '01', title: 'ريادة السوق',       body: 'أكبر مُجزّئ متخصص في الأدوات المنزلية والمطبخ في المملكة العربية السعودية، بتغطية وطنية عبر 73 معرضًا.' },
    { n: '02', title: 'علامات خاصة',       body: 'نحو 88% من الإيرادات تأتي من علامات تجارية مملوكة — EDISON وTORNADO وROCKY وROBUST وغيرها — بهامش أعلى وتحكم كامل في التصميم والتوريد والجودة.' },
    { n: '03', title: 'نموذج قابل للتوسع', body: 'نموذج بيع تجزئة متعدد القنوات مع سلسلة توريد ولوجستيات وخدمة عملاء مبنية للتوسع في فئات ومناطق جغرافية مجاورة.' },
    { n: '04', title: 'أساسيات قوية',      body: 'إيرادات 758.8 مليون ريال، ربحية مثبتة، وإطار منضبط لتوزيع رأس المال متوافق مع رؤية المملكة 2030.' },
  ],
};

export const COPY = {
  en: {
    eyebrow: 'Investors & Governance',
    heroTitle: 'Building long-term value for our shareholders',
    heroSubtitle: "Al Saif Gallery (Tadawul: 4192) is Saudi Arabia's dominant specialty retailer in household and kitchen appliances, with a 73-store network, SAR 758.8M in revenue, and approximately 88% proprietary brands.",
    introTitle: 'A leading position in a <em>growing</em> Saudi retail market.',
    introBody: ['Since our listing on the Saudi Exchange (Tadawul) in 2022, we have continued to invest in our proprietary brand portfolio, expand our national footprint, and deepen our operational excellence.', 'This page brings together the disclosures, financials, share information and governance resources that our investors, analysts and other stakeholders need. All data below is sourced from our IR platform and updated in real time.'],
    caseEyebrow: 'Investment Case',
    caseTitle: 'Why Al Saif Gallery',
    contact: 'Contact', irTeam: 'IR Team', langToggle: 'العربية', langToggleHref: '/ar/',
    navHome: 'Home', navAbout: 'About', navStrategy: 'Strategy', navIR: 'Investors & Governance', navNews: 'News & Careers', navContact: 'Contact',
    footerInvestors: 'Investors', footerCompany: 'Company', footerContact: 'Contact IR',
    footerTagline: "Tadawul: 4192 — Saudi Arabia's dominant specialty retailer in household and kitchen appliances.",
    footerLinks: { irHome: 'IR Home', sharePrice: 'Share Price', financials: 'Financials', announcements: 'Announcements', about: 'About', strategy: 'Strategy', news: 'News', contact: 'Contact' },
    copyright: 'All rights reserved.',
  },
  ar: {
    eyebrow: 'المستثمرون والحوكمة',
    heroTitle: 'نبني قيمة مستدامة لمساهمينا على المدى الطويل',
    heroSubtitle: 'مجموعة السيف (تداول: 4192) هي المجموعة السعودية الرائدة في تجارة الأدوات المنزلية والمطبخ، بشبكة 73 معرضًا، وإيرادات تبلغ 758.8 مليون ريال، وتمثّل العلامات التجارية الخاصة قرابة 88% من المبيعات.',
    introTitle: 'مكانة رائدة في سوق تجزئة سعودي <em>ينمو</em>.',
    introBody: ['منذ إدراج المجموعة في السوق المالية السعودية (تداول) في عام 2022، واصلنا الاستثمار في محفظة علاماتنا الخاصة، وتوسيع انتشارنا الوطني، وتعميق التميز التشغيلي.', 'تجمع هذه الصفحة الإفصاحات، والبيانات المالية، ومعلومات السهم، وموارد الحوكمة التي يحتاجها المستثمرون والمحللون وسائر الأطراف المعنية. جميع البيانات أدناه مصدرها منصة علاقات المستثمرين ويتم تحديثها مباشرة.'],
    caseEyebrow: 'مقومات الاستثمار',
    caseTitle: 'لماذا مجموعة السيف',
    contact: 'اتصل بنا', irTeam: 'فريق علاقات المستثمرين', langToggle: 'English', langToggleHref: '/',
    navHome: 'الرئيسية', navAbout: 'من نحن', navStrategy: 'الاستراتيجية', navIR: 'المستثمرون والحوكمة', navNews: 'الأخبار والوظائف', navContact: 'اتصل بنا',
    footerInvestors: 'المستثمرون', footerCompany: 'الشركة', footerContact: 'تواصل مع علاقات المستثمرين',
    footerTagline: 'تداول: 4192 — المجموعة السعودية الرائدة في تجارة الأدوات المنزلية والمطبخ.',
    footerLinks: { irHome: 'الصفحة الرئيسية', sharePrice: 'سعر السهم', financials: 'البيانات المالية', announcements: 'الإعلانات', about: 'من نحن', strategy: 'الاستراتيجية', news: 'الأخبار', contact: 'اتصل بنا' },
    copyright: 'جميع الحقوق محفوظة.',
  },
};
