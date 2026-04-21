import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

class IGInvestmentCaseSection extends StatelessWidget {
  const IGInvestmentCaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final l = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFB),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 35),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(l.igInvestTitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: Text(l.igInvestSubtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w400)),
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _IGInvestmentCard(number: '1', title: l.igInvest1Title, description: l.igInvest1Desc)),
                      const SizedBox(width: 16),
                      Expanded(child: _IGInvestmentCard(number: '2', title: l.igInvest2Title, description: l.igInvest2Desc)),
                      const SizedBox(width: 16),
                      Expanded(child: _IGInvestmentCard(number: '3', title: l.igInvest3Title, description: l.igInvest3Desc)),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    _IGInvestmentCard(number: '1', title: l.igInvest1Title, description: l.igInvest1Desc),
                    const SizedBox(height: 16),
                    _IGInvestmentCard(number: '2', title: l.igInvest2Title, description: l.igInvest2Desc),
                    const SizedBox(height: 16),
                    _IGInvestmentCard(number: '3', title: l.igInvest3Title, description: l.igInvest3Desc),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _IGInvestmentCard(number: '4', title: l.igInvest4Title, description: l.igInvest4Desc)),
                      const SizedBox(width: 16),
                      Expanded(child: _IGInvestmentCard(number: '5', title: l.igInvest5Title, description: l.igInvest5Desc)),
                      const SizedBox(width: 16),
                      Expanded(child: _IGInvestmentCard(number: '6', title: l.igInvest6Title, description: l.igInvest6Desc)),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    _IGInvestmentCard(number: '4', title: l.igInvest4Title, description: l.igInvest4Desc),
                    const SizedBox(height: 16),
                    _IGInvestmentCard(number: '5', title: l.igInvest5Title, description: l.igInvest5Desc),
                    const SizedBox(height: 16),
                    _IGInvestmentCard(number: '6', title: l.igInvest6Title, description: l.igInvest6Desc),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _IGInvestmentCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _IGInvestmentCard({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context).isArabic;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الرقم في أعلى اليمين دائماً
            Align(
              alignment: isArabic ? Alignment.topRight : Alignment.topLeft,
              child: Text(
                number,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





