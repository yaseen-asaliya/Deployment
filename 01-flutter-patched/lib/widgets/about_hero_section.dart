import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

class AboutHeroSection extends StatelessWidget {
  const AboutHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabic = l.isArabic;
    final isMobile = Responsive.isMobile(context);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(isArabic ? 3.14159 : 0),
      child: Container(
        width: double.infinity,
        height: isMobile ? 240 : 350,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          image: DecorationImage(
            image: AssetImage('assets/images/Background_HorizontalBorder.png'),
            fit: BoxFit.cover,
            alignment: Alignment(0.0, -1),
          ),
        ),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(isArabic ? 3.14159 : 0),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.getHorizontalPadding(context),
              vertical: isMobile ? 32 : 60,
            ),
            child: Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l.aboutHeroTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 22 : 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.aboutHeroSubtitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





