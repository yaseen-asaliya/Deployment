import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

class OurPurposeSection extends StatelessWidget {
  const OurPurposeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final l = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFB),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Directionality(
            textDirection: l.isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              children: [
                Text(
                  l.purposeTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.purposeDesc1,
                  textAlign: l.isArabic ? TextAlign.right : TextAlign.justify,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  l.purposeDesc2,
                  textAlign: l.isArabic ? TextAlign.right : TextAlign.justify,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.4),
                ),
                const SizedBox(height: 8),
                if (l.purposeDesc3.isNotEmpty)
                  Text(
                    l.purposeDesc3,
                    textAlign: l.isArabic ? TextAlign.right : TextAlign.justify,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.4),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





