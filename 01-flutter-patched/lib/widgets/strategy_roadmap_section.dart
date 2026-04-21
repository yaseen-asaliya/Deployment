import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../main.dart';

class StrategyRoadmapSection extends StatefulWidget {
  const StrategyRoadmapSection({super.key});
  @override
  State<StrategyRoadmapSection> createState() => _StrategyRoadmapSectionState();
}

class _StrategyRoadmapSectionState extends State<StrategyRoadmapSection> {
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

    final phases = [
      _Phase(
        badgeText: isArabic ? 'مكتملة حتى 2024' : 'Completed through 2024',
        badgeColor: const Color(0xFF16A34A),
        badgeBg: const Color(0xFFDCFCE7),
        borderColor: const Color(0xFF16A34A),
        phaseLabel: isArabic ? 'المرحلة الأولى' : 'Phase 1',
        title: isArabic ? 'بناء الأساس' : 'Foundation (Completed through 2024)',
        description: isArabic
            ? 'ترسيخ محفظة العلامات التجارية مع التركيز على العلامات المملوكة والحصرية. اكتمال شبكة التجزئة الأولى في المملكة مع حضور خليجي انتقائي. إرساء البنية التحتية للتكامل متعدد القنوات بما يشمل وسائل الدفع الشائعة وأُطر اتفاقيات مستوى الخدمة للتوصيل. تعزيز المستودعات المركزية في الرياض بدعم مركز التوزيع في جدة. تطوير نموذج خدمة ما بعد البيع بضمانات متعددة السنوات ومعالجة مركزية للخدمة.'
            : 'Rationalized and deepened the brand portfolio with focus on owned and exclusive labels. Completed the KSA-first retail network with selective GCC presence. Established omni-channel integration infrastructure including popular payment methods and delivery SLA frameworks. Strengthened Riyadh central warehouses supported by Jeddah fulfillment. Enhanced the after-sales model with multi-year warranties and centralized service processing.',
        kpiTitle: isArabic ? 'مؤشرات الأداء الرئيسية لمرحلة الأساس:' : 'Phase 1 KPIs:',
        kpis: isArabic ? [
          '\u200E73\u200F صالة عرض إجمالاً (\u200E66\u200F في المملكة، \u200E7\u200F في دول الخليج)',
          'مساهمة القنوات الرقمية في الإيرادات: \u200E9.4%\u200F (مقارنة بـ \u200E1.4%\u200F في \u200E2019\u200F)',
          'اتفاقيات مستوى الخدمة: \u200E1\u200F إلى \u200E3\u200F أيام داخل الرياض، \u200E3\u200F إلى \u200E5\u200F أيام على مستوى المملكة، \u200E5\u200F إلى \u200E10\u200F أيام دولياً',
          'اكتمال هيكل العلامات المملوكة والحصرية عبر الفئات الأساسية',
          'تشغيل المستودعات المركزية بوصفها المصدر الرئيسي للمخزون مع إعادة تزويد موحّدة',
        ] : [
          '73 total showrooms (66 KSA, 7 GCC)',
          'Digital channel contribution: 9.4% of revenue (vs. 1.4% in 2019)',
          'Delivery SLAs: Riyadh 1–3 days | Nationwide 3–5 days | International 5–10 days',
          'Owned and exclusive brand structure complete across core categories',
          'Central warehouse operations as primary inventory hub with unified replenishment',
        ],
      ),
      _Phase(
        badgeText: isArabic ? '2025 إلى 2026 — قيد التنفيذ' : '2025 to 2026, Active',
        badgeColor: const Color(0xFFC62030),
        badgeBg: const Color(0xFFFFE4E6),
        borderColor: const Color(0xFFC62030),
        phaseLabel: isArabic ? 'المرحلة الثانية' : 'Phase 2',
        title: isArabic ? 'التوسع المدروس' : 'Measured Expansion (2025 to 2026, Active)',
        description: isArabic
            ? 'توسع انتقائي في شبكة الفروع نحو المدن والمناطق السعودية ذات الاختراق المنخفض، مع مواقع خليجية إضافية حيث تثبت العوائد التجارية جدواها. توسيع المحفظة لتشمل أجهزة المطبخ الكبيرة المختارة وفئات المنزل المكمّلة. تسريع تكامل قنوات البيع. تعزيز إدارة سلسلة التوريد ودوران المخزون عبر منظومة اللوجستيات بين الرياض وجدة.'
            : 'Selective expansion of the showroom network into lower-penetration Saudi cities and regions; additional GCC locations where commercial returns are established. Portfolio expansion to include selected large kitchen appliances and compatible home categories. Acceleration of omni-channel integration. Strengthening supply management and inventory turns through the Riyadh to Jeddah logistics system.',
        kpiTitle: isArabic ? 'مؤشرات أداء المرحلة الثانية:' : 'Phase 2 Performance Indicators (Safe-to-publish formulation):',
        kpis: isArabic ? [
          'حصة التجارة الإلكترونية من الإيرادات ومقاييس استخدام التطبيق',
          'معدلات الامتثال لاتفاقيات مستوى خدمة التوصيل',
          'مزيج المنتجات: مساهمة الأجهزة الصغيرة مقابل الكبيرة',
          'مزيج إيرادات العلامات المملوكة والحصرية وهامش مجمل الربح',
          'معدل دوران المخزون ودورة رأس المال العامل',
          'مؤشرات معدل الشراء المتكرر وعودة العميل',
        ] : [
          'E-commerce share of revenue and app engagement',
          'Delivery SLA compliance rates',
          'Product mix: small vs. large appliances contribution',
          'Owned and exclusive brand revenue mix and gross margin',
          'Inventory turns and working capital cycle',
          'Repeat purchase and customer return rate indicators',
        ],
      ),
      _Phase(
        badgeText: isArabic ? '2026 وما بعدها' : '2026 onwards',
        badgeColor: const Color(0xFF6B7280),
        badgeBg: const Color(0xFFF3F4F6),
        borderColor: const Color(0xFFE5E7EB),
        phaseLabel: isArabic ? 'المرحلة الثالثة' : 'Phase 3',
        title: isArabic ? 'الإمكانات المثلى' : 'Optimal Potential (2026 onwards)',
        description: isArabic
            ? 'أفضل تغطية جغرافية في المدن السعودية ذات الأولوية. نضج تكامل القنوات: مخزون موحّد وتوصيل وخدمة ما بعد البيع تمتد عبر المادية والرقمية معاً. ابتكار عميق في العلامات الخاصة والحصرية. إطار منضبط لتوليد النقد وتخصيص رأس المال يدعم كلاً من النمو والعوائد للمساهمين. تقييم الفرص غير العضوية الانتقائية على أساس مرتكز على العائد المحقق.'
            : 'Best-coverage position across priority Saudi cities. Full channel integration maturity: unified inventory, delivery, and after-sales infrastructure across physical and digital. Deep brand innovation under owned and exclusive labels. Disciplined cash generation and capital allocation framework supporting both growth and returns to shareholders. Selective inorganic growth opportunities evaluated on a return-focused basis.',
        kpiTitle: isArabic ? 'مؤشرات الأداء الرئيسية:' : 'Key Performance Indicators:',
        kpis: isArabic ? [
          'توليد نقدي منضبط',
          'إطار منضبط لتخصيص رأس المال',
          'النمو والعوائد للمساهمين',
          'تقييم الفرص غير العضوية الانتقائية',
          'أساس مرتكز على العائد المحقق',
        ] : [
          'Disciplined cash generation',
          'Capital allocation framework',
          'Growth and returns to shareholders',
          'Selective inorganic growth opportunities',
          'Return-focused basis',
        ],
      ),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 56),
      child: Column(
        children: [
          Text(
            isArabic ? 'الخارطة الاستراتيجية' : 'Strategic Roadmap',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 32),
          // ── Horizontal connector with status indicators ──────────────────
          if (!isMobile) _RoadmapConnector(phases: phases, isArabic: isArabic),
          if (!isMobile) const SizedBox(height: 24),
          isMobile
              ? Column(
                  children: phases
                      .map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _PhaseCard(phase: p, isArabic: isArabic),
                          ))
                      .toList(),
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: phases
                        .map((p) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: _PhaseCard(phase: p, isArabic: isArabic),
                              ),
                            ))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }
}

class _RoadmapConnector extends StatelessWidget {
  final List<_Phase> phases;
  final bool isArabic;
  const _RoadmapConnector({required this.phases, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: SizedBox(
        height: 60,
        child: Row(
          children: List.generate(phases.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Connector line between phases
              return Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 24),
                  color: phases[i ~/ 2].borderColor.withOpacity(0.4),
                ),
              );
            }
            final p = phases[i ~/ 2];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Status circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: p.badgeBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: p.borderColor, width: 2),
                  ),
                  child: Center(
                    child: Icon(
                      i == 0
                          ? Icons.check
                          : i == 2
                              ? Icons.play_arrow
                              : Icons.schedule,
                      size: 16,
                      color: p.badgeColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  p.phaseLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: p.badgeColor,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _Phase {
  final String badgeText;
  final Color badgeColor;
  final Color badgeBg;
  final Color borderColor;
  final String phaseLabel;
  final String title;
  final String description;
  final String kpiTitle;
  final List<String> kpis;

  const _Phase({
    required this.badgeText,
    required this.badgeColor,
    required this.badgeBg,
    required this.borderColor,
    required this.phaseLabel,
    required this.title,
    required this.description,
    required this.kpiTitle,
    required this.kpis,
  });
}

class _PhaseCard extends StatelessWidget {
  final _Phase phase;
  final bool isArabic;
  const _PhaseCard({required this.phase, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: phase.borderColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: phase.badgeBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                phase.badgeText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: phase.badgeColor,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Phase label
            Text(
              phase.phaseLabel,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            // Title
            Text(
              phase.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              phase.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.65,
              ),
            ),
            const SizedBox(height: 16),
            // KPI title
            Text(
              phase.kpiTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            // KPI list
            ...phase.kpis.map((kpi) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 15, color: phase.badgeColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          kpi,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4B5563),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}





