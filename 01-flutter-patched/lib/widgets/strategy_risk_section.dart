import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../main.dart';

class StrategyRiskSection extends StatefulWidget {
  const StrategyRiskSection({super.key});
  @override
  State<StrategyRiskSection> createState() => _StrategyRiskSectionState();
}

class _StrategyRiskSectionState extends State<StrategyRiskSection> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isArabic = localeProvider.isArabic;
    final hPad = Responsive.getHorizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    final rows = _buildRows(isArabic);

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFB),
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 56),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            Text(
              isArabic ? 'إدارة المخاطر' : 'Risk Management',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            // Subtitle
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                isArabic
                    ? 'تُدير السيف غاليري المخاطر عبر إطار عملي وشفاف مصمّم لحماية موظفينا وعملائنا ومساهمينا واستمرارية أعمالنا. بوصفنا شركة مدرجة في تداول، مُلزَمون بالحفاظ على منظومة فعّالة لإدارة المخاطر والإفصاح عنها وفق اللوائح التنظيمية المعمول بها. ونهجنا استباقي لا ردّ فعل دفاعي: نُحدّد المخاطر بوضوح، نُعيّن المسؤولية، ونُطبّق ضوابط متناسبة مع مستوى كل خطر.'
                    : 'Al Saif Gallery manages risk through a practical, transparent framework designed to protect our employees, customers, shareholders, and business continuity. As a Tadawul-listed company, we are required to maintain and disclose an effective risk management system. Our approach is active, not defensive: we identify risks clearly, assign ownership, and implement controls that are proportionate to the exposure.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.7,
                ),
              ),
            ),
            const SizedBox(height: 36),
            // Disclaimer note above table
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 15, color: Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isArabic
                          ? 'يلخّص الجدول التالي فئات المخاطر الرئيسية. تُضمَّن الإفصاحات الكاملة للمخاطر في التقرير السنوي والبيانات المالية الفصلية.'
                          : 'The following table summarizes principal risk categories. Full risk disclosures are included in the Annual Report and quarterly financial statements.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0369A1),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Table
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: isMobile
                  ? _MobileTable(rows: rows, isArabic: isArabic)
                  : _DesktopTable(rows: rows, isArabic: isArabic),
            ),
            const SizedBox(height: 16),
            // Controls statement
            Text(
              isArabic
                  ? 'بيان الضوابط: بناءً على العمل المنجز خلال العام، ترى الإدارة أن ضوابط المخاطر وإطار إدارتها كانا فعّالَين في جميع الجوانب الجوهرية. تشمل مجالات التحسين المستمر: أساسيات الأمن السيبراني، وتنويع الموردين للعناصر الأعلى طلباً، وممارسات الحد من الفقد داخل شبكة صالات العرض.'
                  : 'Controls Statement: Based on work performed during the year, management considers that our risk controls and management framework were effective in all material respects. Areas of continuous improvement include cybersecurity fundamentals and supplier diversification for highest-demand items.',
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_RiskRow> _buildRows(bool isArabic) => isArabic ? [
    _RiskRow(
      category: 'الطلب السوقي وسلوك المستهلك',
      description: 'التذبذبات الموسمية والدورية في الإنفاق على المنزل، وضغوط التسعير التنافسي، والتحولات في تفضيلات المستهلكين.',
      controls: 'محفظة منتجات متنوعة عبر شرائح الأسعار، مرونة في تسعير العلامات الخاصة، تخطيط الطلب وإدارة المخزون.',
    ),
    _RiskRow(
      category: 'جودة العلامة التجارية والمنتج',
      description: 'عيوب المنتج أو إخفاقات التوريد التي قد تضر بسمعة العلامة أو تستدعي سحب منتجات من السوق.',
      controls: 'بروتوكولات تأهيل الموردين، اختبار العينات، معايير صارمة للتوسيم والسلامة، إجراءات محددة للسحب.',
    ),
    _RiskRow(
      category: 'القناة الرقمية والتقنية',
      description: 'مشكلات أداء المنصة أو مخاطر الأمن السيبراني المؤثرة على عمليات التجارة الإلكترونية وبيانات العملاء.',
      controls: 'الاستثمار في متانة المنصة، برنامج أساسيات الأمن السيبراني، إطار حوكمة البيانات.',
    ),
    _RiskRow(
      category: 'سلسلة التوريد واللوجستيات',
      description: 'التركز لدى الموردين، واضطرابات لوجستيات الاستيراد، أو اختلالات المخزون المؤثرة على توافر المنتجات.',
      controls: 'سياسة الموردَين للعناصر عالية الطلب، إدارة مركزية للمخزون، شركاء لوجستيون مؤهّلون باتفاقيات مستوى خدمة محددة.',
    ),
    _RiskRow(
      category: 'التنظيم والامتثال',
      description: 'التغييرات في اشتراطات الإدراج لدى هيئة السوق المالية، أو لوائح حماية المستهلك، أو معايير الاستيراد.',
      controls: 'وظيفة قانونية وامتثال مخصصة، رصد منتظم للمتطلبات التنظيمية، إشراف مجلس الإدارة على الامتثال.',
    ),
    _RiskRow(
      category: 'استمرارية الأعمال',
      description: 'تعطّل المعرض أو مركز التوزيع جراء أحداث طارئة.',
      controls: 'خطط استمرارية الأعمال، جهات الاتصال للطوارئ، ترتيبات لوجستية بديلة.',
    ),
  ] : [
    _RiskRow(
      category: 'Market & Consumer Demand',
      description: 'Seasonal and cyclical fluctuations in household spending, competitive pricing pressure, and shifts in consumer preferences.',
      controls: 'Diversified product portfolio across price points; owned-brand flexibility in pricing; demand planning and inventory management.',
    ),
    _RiskRow(
      category: 'Brand & Product Quality',
      description: 'Product defects or sourcing failures that could damage brand reputation or require recalls.',
      controls: 'Supplier qualification protocols, sample testing, clear labeling and safety standards, defined recall procedures.',
    ),
    _RiskRow(
      category: 'Digital Channel & Technology',
      description: 'Platform performance issues or cybersecurity risks affecting e-commerce operations and customer data.',
      controls: 'Platform resilience investment, cybersecurity fundamentals program, data governance framework.',
    ),
    _RiskRow(
      category: 'Supply Chain & Logistics',
      description: 'Supplier concentration, import logistics disruption, or inventory imbalances affecting availability.',
      controls: 'Dual-supplier framework for high-demand items; centralized inventory management; qualified logistics partners with defined SLAs.',
    ),
    _RiskRow(
      category: 'Regulatory & Compliance',
      description: 'Changes in CMA listing requirements, consumer protection regulations, or import standards.',
      controls: 'Dedicated legal and compliance function; regular regulatory horizon scanning; board-level compliance oversight.',
    ),
    _RiskRow(
      category: 'Operational Continuity',
      description: 'Store or distribution center disruption from physical events.',
      controls: 'Business continuity plans, emergency contacts, alternative logistics arrangements.',
    ),
  ];
}

class _RiskRow {
  final String category;
  final String description;
  final String controls;
  const _RiskRow({required this.category, required this.description, required this.controls});
}

// ── Desktop: 3-column table ──────────────────────────────────────────────────
class _DesktopTable extends StatelessWidget {
  final List<_RiskRow> rows;
  final bool isArabic;
  const _DesktopTable({required this.rows, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.4),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        children: [
          // Header
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
            children: [
              _headerCell(isArabic ? 'فئة المخاطر' : 'Risk Category'),
              _headerCell(isArabic ? 'الوصف' : 'Description'),
              _headerCell(isArabic ? 'الضوابط الرئيسية' : 'Key Controls'),
            ],
          ),
          ...rows.map((r) => TableRow(
            children: [
              _boldCell(r.category),
              _cell(r.description),
              _cell(r.controls),
            ],
          )),
        ],
      ),
    );
  }

  Widget _headerCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF374151))),
      );

  Widget _boldCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
      );

  Widget _cell(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280), height: 1.55)),
      );
}

// ── Mobile: stacked cards ────────────────────────────────────────────────────
class _MobileTable extends StatelessWidget {
  final List<_RiskRow> rows;
  final bool isArabic;
  const _MobileTable({required this.rows, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: rows.map((r) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.category,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 6),
              Text(r.description,
                  style: const TextStyle(fontSize: 12,
                      color: Color(0xFF6B7280), height: 1.55)),
              const SizedBox(height: 8),
              Text(isArabic ? 'الضوابط الرئيسية:' : 'Key Controls:',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF374151))),
              const SizedBox(height: 4),
              Text(r.controls,
                  style: const TextStyle(fontSize: 12,
                      color: Color(0xFF6B7280), height: 1.55)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}





