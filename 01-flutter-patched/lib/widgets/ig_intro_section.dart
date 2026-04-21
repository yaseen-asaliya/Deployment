import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

class IGIntroSection extends StatelessWidget {
  const IGIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final l = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Directionality(
            textDirection: l.isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              crossAxisAlignment: l.isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.center,
              children: [
                Text(
                  l.igIntroDesc1,
                  textAlign: l.isArabic ? TextAlign.right : TextAlign.justify,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.8),
                ),
                const SizedBox(height: 16),
                Text(
                  l.igIntroDesc2,
                  textAlign: l.isArabic ? TextAlign.right : TextAlign.justify,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





