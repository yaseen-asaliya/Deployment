import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

class OurValuesSection extends StatelessWidget {
  const OurValuesSection({super.key});

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
          Text(
            l.valuesTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _ValueCard(iconPath: 'assets/images/Quality.svg', title: l.valueQualityTitle, description: l.valueQualityDesc)),
                      const SizedBox(width: 20),
                      Expanded(child: _ValueCard(iconPath: 'assets/images/Customer.svg', title: l.valueCustomerTitle, description: l.valueCustomerDesc)),
                      const SizedBox(width: 20),
                      Expanded(child: _ValueCard(iconPath: 'assets/images/Integrity.svg', title: l.valueIntegrityTitle, description: l.valueIntegrityDesc)),
                      const SizedBox(width: 20),
                      Expanded(child: _ValueCard(iconPath: 'assets/images/strategy.svg', title: l.valueImprovementTitle, description: l.valueImprovementDesc)),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _ValueCard(iconPath: 'assets/images/Quality.svg', title: l.valueQualityTitle, description: l.valueQualityDesc)),
                          const SizedBox(width: 16),
                          Expanded(child: _ValueCard(iconPath: 'assets/images/Customer.svg', title: l.valueCustomerTitle, description: l.valueCustomerDesc)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _ValueCard(iconPath: 'assets/images/Integrity.svg', title: l.valueIntegrityTitle, description: l.valueIntegrityDesc)),
                          const SizedBox(width: 16),
                          Expanded(child: _ValueCard(iconPath: 'assets/images/strategy.svg', title: l.valueImprovementTitle, description: l.valueImprovementDesc)),
                        ],
                      ),
                    ),
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

class _ValueCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;

  const _ValueCard({
    required this.iconPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 32, // تقليل حجم الأيقونة
            height: 32,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}





