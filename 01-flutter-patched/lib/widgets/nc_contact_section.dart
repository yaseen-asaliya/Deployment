import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../main.dart';

class NCContactSection extends StatefulWidget {
  const NCContactSection({super.key});
  @override
  State<NCContactSection> createState() => _NCContactSectionState();
}

class _NCContactSectionState extends State<NCContactSection> with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    localeProvider.addListener(_rebuild);
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _glow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
    contactHighlightNotifier.addListener(_onHighlight);
  }

  void _onHighlight() {
    if (contactHighlightNotifier.value) {
      _glowCtrl.repeat(reverse: true);
    } else {
      _glowCtrl.stop();
      _glowCtrl.reset();
    }
  }

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void dispose() {
    localeProvider.removeListener(_rebuild);
    contactHighlightNotifier.removeListener(_onHighlight);
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = localeProvider.isArabic;
    final hp = Responsive.getHorizontalPadding(context);

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: hp, vertical: 56),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            // Title
            Text(
              isArabic ? 'تواصل مع الإعلام والمستثمرين' : 'Media & Investor Contact',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle
            Text(
              isArabic
                  ? 'للاستفسارات الإعلامية وأسئلة علاقات المستثمرين أو المعلومات المؤسسية العامة،\nيرجى التواصل مع فريقنا:'
                  : 'For media inquiries, investor relations questions, or general corporate information,\nplease contact our team:',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),
            // Two cards
            LayoutBuilder(builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 500;
              final cards = [
                _ContactCard(
                  title: isArabic ? 'علاقات المستثمرين' : 'Investor Relations',
                  rows: [
                    _ContactRow(label: isArabic ? 'البريد الإلكتروني:' : 'Email:', value: 'ir@alsaifgallery.com'),
                    _ContactRow(label: isArabic ? 'الهاتف:' : 'Phone:', value: '+966 11 XXX XXXX'),
                    _ContactRow(label: isArabic ? 'العنوان:' : 'Address:', value: isArabic ? 'الرياض، المملكة العربية السعودية' : 'Riyadh, Saudi Arabia'),
                  ],
                ),
                _ContactCard(
                  title: isArabic ? 'العلاقات الإعلامية' : 'Media Relations',
                  rows: [
                    _ContactRow(label: isArabic ? 'البريد الإلكتروني:' : 'Email:', value: 'media@alsaifgallery.com'),
                    _ContactRow(label: isArabic ? 'الهاتف:' : 'Phone:', value: '+966 11 XXX XXXX'),
                    _ContactRow(label: isArabic ? 'مجموعة الصحافة:' : 'Press Kit:', value: isArabic ? 'متاحة عند الطلب' : 'Available upon request'),
                  ],
                ),
              ];
              if (isNarrow) {
                return Column(
                  children: [cards[0], const SizedBox(height: 16), cards[1]],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 300, child: cards[0]),
                  const SizedBox(width: 20),
                  SizedBox(width: 300, child: cards[1]),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ContactRow {
  final String label;
  final String value;
  const _ContactRow({required this.label, required this.value});
}

class _ContactCard extends StatelessWidget {
  final String title;
  final List<_ContactRow> rows;
  const _ContactCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(10),
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
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SelectableText.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF444444),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: '${r.label} ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: r.value),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}





