import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/responsive.dart';
import '../main.dart';

class NCCareersSection extends StatefulWidget {
  const NCCareersSection({super.key});
  @override
  State<NCCareersSection> createState() => _NCCareersSectionState();
}

class _NCCareersSectionState extends State<NCCareersSection> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isArabic = localeProvider.isArabic;
    final hp = Responsive.getHorizontalPadding(context);

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFB),
      padding: EdgeInsets.symmetric(horizontal: hp, vertical: 56),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            // ── Title & subtitle ──
            Text(
              isArabic ? 'الوظائف في السيف غاليري' : 'Careers at Al Saif Gallery',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                isArabic
                    ? 'ابنِ مسيرتك المهنية مع الرائد السعودي في مستلزمات المنزل. نبحث عن أفراد موهوبين للانضمام إلى فريقنا المتنامي الذي يضم أكثر من \u200E1,280\u200F موظفاً في خمسة أسواق.'
                    : "Build your career with Saudi Arabia's leading household essentials retailer. We're looking for talented individuals to join our growing team of 1,280+ employees across Saudi Arabia and 4 GCC countries.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ── Stats row ──
            LayoutBuilder(builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              final stats = [
                _StatItem(
                  icon: 'assets/images/Customer.svg',
                  value: '\u200E1,280+\u200F',
                  label: isArabic ? 'موظف' : 'Employees',
                  sub: isArabic ? 'في 5 أسواق' : 'Across 5 markets',
                ),
                _StatItem(
                  icon: 'assets/images/location.svg',
                  value: '73',
                  label: isArabic ? 'صالة عرض' : 'Showrooms',
                  sub: isArabic ? 'السعودية ودول الخليج' : 'KSA & GCC',
                ),
                _StatItem(
                  icon: 'assets/images/strategy.svg',
                  value: '30+',
                  label: isArabic ? 'سنة' : 'Years',
                  sub: isArabic ? 'من النمو' : 'Of growth',
                ),
                _StatItem(
                  icon: 'assets/images/department.svg',
                  value: isArabic ? 'متعددة' : 'Multiple',
                  label: isArabic ? 'أقسام' : 'Departments',
                  sub: isArabic ? 'أدوار متنوعة' : 'Diverse roles',
                ),
              ];
              if (isNarrow) {
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _StatCard(item: stats[0], delay: 0)),
                          const SizedBox(width: 12),
                          Expanded(child: _StatCard(item: stats[1], delay: 120)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _StatCard(item: stats[2], delay: 240)),
                          const SizedBox(width: 12),
                          Expanded(child: _StatCard(item: stats[3], delay: 360)),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < stats.length; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      Expanded(child: _StatCard(item: stats[i], delay: i * 120)),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // ── Why Join Us + Our Departments ──
            LayoutBuilder(builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;
              final whyJoin = _InfoCard(
                title: isArabic ? 'لماذا تنضم إلينا' : 'Why Join Us',
                bullets: isArabic
                    ? [
                        'العمل في شركة مدرجة في تداول ذات مسار نمو قوي',
                        'كن جزءاً من الرائد السعودي في مستلزمات المنزل',
                        'برامج تدريب منظّمة وتطوير مهني',
                        'حزمة تعويضات ومزايا تنافسية',
                        'فرص التقدم الوظيفي عبر أقسام متعددة',
                        'ثقافة عمل شاملة وموجّهة نحو الأداء',
                      ]
                    : [
                        'Work for a Tadawul-listed company with strong growth trajectory',
                        "Be part of Saudi Arabia's household essentials leader",
                        'Structured training and professional development programs',
                        'Competitive compensation and benefits package',
                        'Career advancement opportunities across multiple departments',
                        'Inclusive, performance-oriented workplace culture',
                      ],
              );
              final depts = _InfoCard(
                title: isArabic ? 'أقسامنا' : 'Our Departments',
                bullets: isArabic
                    ? [
                        'العمليات التجارية: إدارة صالات العرض، خدمة العملاء، المبيعات',
                        'اللوجستيات وسلسلة التوريد: المستودعات، التوزيع، إدارة المخزون',
                        'الرقمي والتجارة الإلكترونية: تطوير المنصات، التسويق الرقمي، التحليلات',
                        'خدمة ما بعد البيع: معالجة الضمانات، الإصلاح، دعم العملاء',
                        'الوظائف المؤسسية: المالية، الموارد البشرية، القانونية، الحوكمة',
                        'تطوير العلامات والمنتجات: التوريد، ضبط الجودة، الابتكار',
                      ]
                    : [
                        'Retail Operations: Showroom management, customer service, sales',
                        'Logistics & Supply Chain: Warehouse, distribution, inventory management',
                        'Digital & E-Commerce: Platform development, digital marketing, analytics',
                        'After-Sales Service: Warranty processing, repairs, customer support',
                        'Corporate Functions: Finance, HR, legal, compliance, governance',
                        'Brand & Product Development: Sourcing, quality control, innovation',
                      ],
                boldFirst: true,
              );
              if (isNarrow) {
                return Column(children: [whyJoin, const SizedBox(height: 16), depts]);
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: whyJoin),
                    const SizedBox(width: 16),
                    Expanded(child: depts),
                  ],
                ),
              );
            }),
            const SizedBox(height: 32),

            // ── CTA Banner ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFC62030),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
              child: Column(
                children: [
                  Text(
                    isArabic ? 'هل أنت مستعد لبناء مسيرتك معنا؟' : 'Ready to Build Your Career with Us?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isArabic
                        ? 'نبحث دائماً عن أفراد موهوبين يشاركوننا التزامنا بالجودة وخدمة العملاء والتميز التشغيلي.'
                        : "We're always looking for talented individuals who share our commitment to quality, customer service, and operational excellence.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ).copyWith(
                      mouseCursor: const MaterialStatePropertyAll(SystemMouseCursors.click),
                    ),
                    child: Text(
                      isArabic ? 'عرض الوظائف المتاحة' : 'View Open Positions',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat item model ──
class _StatItem {
  final String icon;
  final String value;
  final String label;
  final String sub;
  const _StatItem({required this.icon, required this.value, required this.label, required this.sub});
}

// ── Animated Stat card ──
class _StatCard extends StatefulWidget {
  final _StatItem item;
  final int delay;
  const _StatCard({required this.item, this.delay = 0});
  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  double _countValue = 0;
  bool _counted = false;

  // استخرج الرقم من الـ value string
  double? _parseNumber(String val) {
    final clean = val.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean);
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (!mounted) return;
      _ctrl.forward();
      _startCountUp();
    });
  }

  void _startCountUp() {
    final target = _parseNumber(widget.item.value);
    if (target == null) return;
    const steps = 30;
    const duration = Duration(milliseconds: 800);
    final stepDuration = Duration(milliseconds: duration.inMilliseconds ~/ steps);
    int step = 0;
    Future.doWhile(() async {
      await Future.delayed(stepDuration);
      if (!mounted) return false;
      step++;
      setState(() => _countValue = target * step / steps);
      return step < steps;
    });
  }

  String _displayValue() {
    final target = _parseNumber(widget.item.value);
    if (target == null || _countValue == 0) return widget.item.value;
    final suffix = widget.item.value.replaceAll(RegExp(r'[0-9,.]'), '');
    if (target == target.truncateToDouble()) {
      return '${_countValue.toInt()}$suffix';
    }
    return '${_countValue.toStringAsFixed(0)}$suffix';
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(widget.item.icon, width: 32, height: 32,
                colorFilter: const ColorFilter.mode(Color(0xFFC62030), BlendMode.srcIn)),
              const SizedBox(height: 10),
              Text(
                _displayValue(),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 2),
              Text(widget.item.label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
              const SizedBox(height: 2),
              Text(widget.item.sub,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Info card (Why Join / Departments) ──
class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> bullets;
  final bool boldFirst;
  const _InfoCard({required this.title, required this.bullets, this.boldFirst = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: CircleAvatar(radius: 3, backgroundColor: Color(0xFFC62030)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: boldFirst
                          ? _BoldFirstText(text: b)
                          : Text(b, style: const TextStyle(fontSize: 13, color: Color(0xFF444444), height: 1.5)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// Renders "Bold Part: rest" for department bullets
class _BoldFirstText extends StatelessWidget {
  final String text;
  const _BoldFirstText({required this.text});

  @override
  Widget build(BuildContext context) {
    final idx = text.indexOf(':');
    if (idx == -1) {
      return Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF444444), height: 1.5));
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Color(0xFF444444), height: 1.5),
        children: [
          TextSpan(text: text.substring(0, idx + 1), style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: text.substring(idx + 1)),
        ],
      ),
    );
  }
}





