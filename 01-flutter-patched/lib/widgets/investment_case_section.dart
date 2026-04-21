import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

class InvestmentCaseSection extends StatelessWidget {
  const InvestmentCaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final l = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 35),
      child: Column(
        children: [
          Text(l.investmentTitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(l.investmentSubtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w400)),
          const SizedBox(height: 30),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _InvestmentCard(number: '1', title: l.invest1Title, description: l.invest1Desc)),
                const SizedBox(width: 16),
                Expanded(child: _InvestmentCard(number: '2', title: l.invest2Title, description: l.invest2Desc)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _InvestmentCard(number: '3', title: l.invest3Title, description: l.invest3Desc)),
                const SizedBox(width: 16),
                Expanded(child: _InvestmentCard(number: '4', title: l.invest4Title, description: l.invest4Desc)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _InvestmentCard({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}





