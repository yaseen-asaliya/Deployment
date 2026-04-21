class SearchResult {
  final String titleEn;
  final String titleAr;
  final String descEn;
  final String descAr;
  final String route;
  final String? fragment;
  final String categoryEn;
  final String categoryAr;

  const SearchResult({
    required this.titleEn,
    required this.titleAr,
    required this.descEn,
    required this.descAr,
    required this.route,
    this.fragment,
    required this.categoryEn,
    required this.categoryAr,
  });
}

class SearchData {
  static const List<SearchResult> items = [
    // ── Home ──────────────────────────────────────────────────────────────────
    SearchResult(
      titleEn: 'Home', titleAr: 'الرئيسية',
      descEn: 'Al Saif Gallery main page', descAr: 'الصفحة الرئيسية للسيف غاليري',
      route: '/', categoryEn: 'Pages', categoryAr: 'الصفحات',
    ),

    // ── About Us ──────────────────────────────────────────────────────────────
    SearchResult(
      titleEn: 'About Us', titleAr: 'من نحن',
      descEn: 'Our story, purpose and values since 1993', descAr: 'قصتنا وقيمنا منذ 1993',
      route: '/about-us', categoryEn: 'Pages', categoryAr: 'الصفحات',
    ),
    SearchResult(
      titleEn: 'Leadership', titleAr: 'القيادة',
      descEn: 'Board of Directors and Executive Management', descAr: 'مجلس الإدارة والإدارة التنفيذية',
      route: '/about-us', fragment: 'leadership',
      categoryEn: 'About', categoryAr: 'من نحن',
    ),
    SearchResult(
      titleEn: 'Board of Directors', titleAr: 'مجلس الإدارة',
      descEn: 'Strategic oversight and shareholder interests', descAr: 'الإشراف الاستراتيجي وحماية حقوق المساهمين',
      route: '/about-us', fragment: 'leadership',
      categoryEn: 'About', categoryAr: 'من نحن',
    ),
    SearchResult(
      titleEn: 'Our Values', titleAr: 'قيمنا',
      descEn: 'The values that guide Al Saif Gallery', descAr: 'القيم التي توجه السيف غاليري',
      route: '/about-us', fragment: 'our-values',
      categoryEn: 'About', categoryAr: 'من نحن',
    ),
    SearchResult(
      titleEn: 'Heritage & Milestones', titleAr: 'الإرث والإنجازات',
      descEn: 'Our journey from 1993 to today', descAr: 'رحلتنا من 1993 حتى اليوم',
      route: '/about-us', fragment: 'heritage',
      categoryEn: 'About', categoryAr: 'من نحن',
    ),

    // ── Strategy ──────────────────────────────────────────────────────────────
    SearchResult(
      titleEn: 'Strategy & Operations', titleAr: 'الاستراتيجية والعمليات',
      descEn: 'Three-phase growth strategy and operating model', descAr: 'استراتيجية النمو ثلاثية المراحل',
      route: '/strategy-operations', categoryEn: 'Pages', categoryAr: 'الصفحات',
    ),
    SearchResult(
      titleEn: 'Strategic Pillars', titleAr: 'الركائز الاستراتيجية',
      descEn: 'Brand ownership, national reach, digital integration', descAr: 'ملكية العلامة التجارية والانتشار الوطني',
      route: '/strategy-operations', fragment: 'strategy-pillars',
      categoryEn: 'Strategy', categoryAr: 'الاستراتيجية',
    ),
    SearchResult(
      titleEn: 'Growth Roadmap', titleAr: 'خارطة طريق النمو',
      descEn: 'Phase 1, 2 and 3 expansion plan', descAr: 'خطة التوسع للمراحل 1 و2 و3',
      route: '/strategy-operations', fragment: 'strategy-roadmap',
      categoryEn: 'Strategy', categoryAr: 'الاستراتيجية',
    ),
    SearchResult(
      titleEn: 'Risk Management', titleAr: 'إدارة المخاطر',
      descEn: 'Key risks and mitigation strategies', descAr: 'المخاطر الرئيسية واستراتيجيات التخفيف',
      route: '/strategy-operations', fragment: 'strategy-risk',
      categoryEn: 'Strategy', categoryAr: 'الاستراتيجية',
    ),

    // ── Investor Relations ────────────────────────────────────────────────────
    SearchResult(
      titleEn: 'Investor Relations', titleAr: 'علاقات المستثمرين',
      descEn: 'Financial results, governance and shareholder services', descAr: 'النتائج المالية والحوكمة وخدمات المساهمين',
      route: '/investors-governance', categoryEn: 'Pages', categoryAr: 'الصفحات',
    ),
    SearchResult(
      titleEn: 'Annual Reports', titleAr: 'التقارير السنوية',
      descEn: 'Audited financial results and annual disclosures', descAr: 'النتائج المالية المدققة والإفصاحات السنوية',
      route: '/investors-governance', fragment: 'annual-reports',
      categoryEn: 'Investors', categoryAr: 'المستثمرون',
    ),
    SearchResult(
      titleEn: 'Corporate Governance', titleAr: 'حوكمة الشركات',
      descEn: 'CMA compliance and governance framework', descAr: 'الامتثال لهيئة السوق المالية وإطار الحوكمة',
      route: '/investors-governance', fragment: 'corporate-actions',
      categoryEn: 'Investors', categoryAr: 'المستثمرون',
    ),
    SearchResult(
      titleEn: 'Stock Activity', titleAr: 'نشاط السهم',
      descEn: 'Tadawul 4192 share price and trading data', descAr: 'سعر سهم تداول 4192 وبيانات التداول',
      route: '/investors-governance', fragment: 'stock-activity',
      categoryEn: 'Investors', categoryAr: 'المستثمرون',
    ),
    SearchResult(
      titleEn: 'Financial Results', titleAr: 'النتائج المالية',
      descEn: 'SAR 758.8M revenue, FY2025 performance', descAr: 'إيرادات 758.8 مليون ريال، أداء 2025',
      route: '/investors-governance', fragment: 'financials',
      categoryEn: 'Investors', categoryAr: 'المستثمرون',
    ),
    SearchResult(
      titleEn: 'Fact Sheet', titleAr: 'نشرة المعلومات',
      descEn: 'Key company facts and financial highlights', descAr: 'الحقائق الرئيسية والأبرز المالية',
      route: '/investors-governance', fragment: 'fact-sheet',
      categoryEn: 'Investors', categoryAr: 'المستثمرون',
    ),
    SearchResult(
      titleEn: 'Investment Calculator', titleAr: 'حاسبة الاستثمار',
      descEn: 'Calculate your investment returns', descAr: 'احسب عوائد استثمارك',
      route: '/investors-governance', fragment: 'investment-calculator',
      categoryEn: 'Investors', categoryAr: 'المستثمرون',
    ),

    // ── Newsroom & Careers ────────────────────────────────────────────────────
    SearchResult(
      titleEn: 'Newsroom & Careers', titleAr: 'الأخبار والوظائف',
      descEn: 'Latest news, press releases and job opportunities', descAr: 'آخر الأخبار والبيانات الصحفية وفرص العمل',
      route: '/news-careers', categoryEn: 'Pages', categoryAr: 'الصفحات',
    ),
    SearchResult(
      titleEn: 'Corporate News', titleAr: 'أخبار الشركة',
      descEn: 'Press releases and regulatory announcements', descAr: 'البيانات الصحفية والإعلانات التنظيمية',
      route: '/news-careers', fragment: 'news',
      categoryEn: 'News', categoryAr: 'الأخبار',
    ),
    SearchResult(
      titleEn: 'Careers', titleAr: 'الوظائف',
      descEn: 'Join the Al Saif Gallery team', descAr: 'انضم لفريق السيف غاليري',
      route: '/news-careers', fragment: 'careers',
      categoryEn: 'News', categoryAr: 'الأخبار',
    ),

    // ── Contact ───────────────────────────────────────────────────────────────
    SearchResult(
      titleEn: 'Contact IR', titleAr: 'تواصل مع علاقات المستثمرين',
      descEn: 'ir@alsaifgallery.com | +966 11 406 4444', descAr: 'ir@alsaifgallery.com | +966 11 406 4444',
      route: '/news-careers', fragment: 'contact',
      categoryEn: 'Contact', categoryAr: 'تواصل معنا',
    ),
  ];

  static List<SearchResult> search(String query, bool isArabic) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase().trim();
    return items.where((item) {
      return item.titleEn.toLowerCase().contains(q) ||
             item.titleAr.contains(q) ||
             item.descEn.toLowerCase().contains(q) ||
             item.descAr.contains(q) ||
             item.categoryEn.toLowerCase().contains(q) ||
             item.categoryAr.contains(q);
    }).toList();
  }
}
