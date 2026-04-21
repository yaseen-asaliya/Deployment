import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../main.dart';

class StrategyHeroSection extends StatefulWidget {
  const StrategyHeroSection({super.key});
  @override
  State<StrategyHeroSection> createState() => _StrategyHeroSectionState();
}

class _StrategyHeroSectionState extends State<StrategyHeroSection> {
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

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(isArabic ? 3.14159 : 0),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/strategy_background.jpeg',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
          Positioned.fill(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isArabic ? 3.14159 : 0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Directionality(
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'الاستراتيجية والعمليات' : 'Strategy & Operations',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isArabic
                            ? 'تنفيذ منضبط. نمو مدروس. نموذج يُراكم قيمة حقيقية عبر الزمن.'
                            : 'Disciplined execution. Measured growth.\nA model built to compound value over time.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: isMobile ? 13 : 15,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                        ),
                      ),
                      if (isArabic) ...[
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Text(
                            'استراتيجية السيف غاليري ثلاثية المراحل: ملكية العلامات التجارية، والانتشار الوطني، والتكامل الرقمي، وعمق خدمة ما بعد البيع. نموذج تشغيلي منضبط بُني لخلق قيمة مستدامة.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: isMobile ? 12 : 14,
                              fontWeight: FontWeight.w400,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





