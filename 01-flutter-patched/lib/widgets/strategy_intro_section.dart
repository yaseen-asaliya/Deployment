import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../main.dart';

class StrategyIntroSection extends StatefulWidget {
  const StrategyIntroSection({super.key});
  @override
  State<StrategyIntroSection> createState() => _StrategyIntroSectionState();
}

class _StrategyIntroSectionState extends State<StrategyIntroSection> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isArabic = localeProvider.isArabic;
    final hPad = Responsive.getHorizontalPadding(context);

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                isArabic
                    ? 'استراتيجيتنا ليست معقدة، بل واضحة: تعميق مكانتنا في سوق مستلزمات المنزل السعودي، وتعزيز مزايا علاماتنا التجارية الخاصة، ودمج قنواتنا التقليدية والرقمية في تجربة عميل سلسة، والتوسع الانتقائي في دول مجلس التعاون الخليجي. ويكمن الانضباط في تنفيذ هذه الاستراتيجية دون توسع يتجاوز ما تبرره الأسس التشغيلية والعوائد: ننمو حيث تبرر العوائد هذا النمو، ونُحكم الأساس قبل التوسع في المجالات أو الأسواق الطرفية.'
                    : 'Our strategy is not complex. It is clear: deepen our position in the Saudi household essentials market, extend our proprietary brand advantage, integrate our physical and digital channels into a seamless customer experience, and expand selectively into the GCC. The discipline lies in executing this strategy without overreaching, growing where the returns justify growth, and strengthening the core before scaling the edges.',
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.75,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isArabic
                    ? 'تتألف الخارطة الاستراتيجية من ثلاث مراحل. المرحلة الأولى (بناء الأساس) مكتملة. المرحلة الثانية (التوسع المدروس) قيد التنفيذ حتى \u200E2026\u200F. تليها المرحلة الثالثة (الإمكانات المثلى) بالتكامل الكامل للقنوات وعمق العلامات التجارية وتوليد نقدي مستدام.'
                    : 'The roadmap is structured in three phases. Phase One (Foundation) is complete. Phase Two (Measured Expansion) is underway through 2026. Phase Three (Optimal Potential) follows with full channel integration, mature brand depth, and sustained cash generation.',
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.75,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





