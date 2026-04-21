import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

Widget _heroBtn(BuildContext context, String label, Color bg, Color fg, VoidCallback onTap) {
  return SelectionContainer.disabled(
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    ),
  );
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabic = l.isArabic;
    final hPad = Responsive.getHorizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = isMobile ? null : constraints.maxWidth / (1920 / 800);

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/modern_kitchen.jpeg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned.fill(
              child: Container(
                  color: Colors.red.shade900.withOpacity(0.7)),
            ),
            Container(
              width: double.infinity,
              height: height,
              constraints:
                  isMobile ? const BoxConstraints(minHeight: 280) : null,
              padding: EdgeInsets.fromLTRB(hPad, isMobile ? 40 : 0, hPad, isMobile ? 32 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      l.heroTitle,
                      textAlign:
                          isArabic ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 28 : 38,
                          fontWeight: FontWeight.w700,
                          height: 1.2),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Text(
                        l.heroSubtitle,
                        textAlign:
                            isArabic ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 750),
                      child: Text(
                        l.heroDesc1,
                        textAlign:
                            isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                             color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            height: 1.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 750),
                      child: Text(
                        l.heroDesc2,
                        textAlign:
                            isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            height: 1.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: isMobile
                        ? Row(
                            children: [
                              Expanded(child: _heroBtn(context, l.heroExploreStory, Colors.white, AppColors.primary, () => context.go('/about-us'))),
                              const SizedBox(width: 12),
                              Expanded(child: _heroBtn(context, l.heroInvestorRelations, const Color(0xFF8B0000), Colors.white, () => context.go('/investors-governance'))),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _heroBtn(
                                  context,
                                  l.heroExploreStory,
                                  Colors.white,
                                  AppColors.primary,
                                  () => context.go('/about-us')),
                              const SizedBox(width: 16),
                              _heroBtn(
                                  context,
                                  l.heroInvestorRelations,
                                  const Color(0xFF8B0000),
                                  Colors.white,
                                  () => context.go('/investors-governance')),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}





