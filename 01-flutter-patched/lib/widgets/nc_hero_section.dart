import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';
import '../main.dart';

class NCHeroSection extends StatefulWidget {
  const NCHeroSection({super.key});
  @override
  State<NCHeroSection> createState() => _NCHeroSectionState();
}

class _NCHeroSectionState extends State<NCHeroSection> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabic = localeProvider.isArabic;
    final isMobile = Responsive.isMobile(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = isMobile ? 160.0 : constraints.maxWidth / (1600 / 475);
        final horizontalPadding = Responsive.getHorizontalPadding(context);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(isArabic ? 3.14159 : 0),
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/news.jpeg',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(isArabic ? 3.14159 : 0),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isArabic ? 0 : horizontalPadding,
                      right: isArabic ? horizontalPadding : 0,
                    ),
                    child: Align(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                l.ncHeroTitle,
                                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 20 : 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                l.ncHeroSubtitle,
                                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 12 : 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}





