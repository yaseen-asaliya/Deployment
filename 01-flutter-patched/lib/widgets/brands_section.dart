import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';
import '../utils/scroll_keys.dart';
import 'brand_portfolio_dialog.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final l = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          if (isMobile)
            Positioned.fill(
              child: Align(
                alignment: const Alignment(0, -0.63),
                child: Opacity(
                  opacity: 0.08,
                  child: SvgPicture.asset(
                    'assets/images/JUG.svg',
                    width: 500,
                    height: 500,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(Color(0xFFD91F36), BlendMode.srcIn),
                  ),
                ),
              ),
            )
          else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Center(
              child: Opacity(
                opacity: 0.08,
                child: SvgPicture.asset(
                  'assets/images/JUG.svg',
                  width: 700,
                  height: 700,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(Color(0xFFD91F36), BlendMode.srcIn),
                ),
              ),
            ),
          ),
            Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: 51,
                  bottom: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l.brandsTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: screenWidth > 1600 ? 1000 : (isMobile ? screenWidth * 0.9 : screenWidth * 0.6),
                      child: Text(
                        l.brandsDesc1,
                        textAlign: l.isArabic ? TextAlign.right : (isMobile ? TextAlign.start : TextAlign.justify),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.68,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth > 1600 ? 1000 : (isMobile ? screenWidth * 0.9 : screenWidth * 0.6),
                      child: Text(
                        l.brandsDesc2,
                        textAlign: l.isArabic ? TextAlign.right : (isMobile ? TextAlign.start : TextAlign.justify),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.68,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: 20,
                  bottom: 60,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      final cardWidth = ((constraints.maxWidth - 14 - (3 * 24)) / 4).clamp(0.0, double.infinity);
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(width: cardWidth, child: _ServiceCard(iconPath: 'assets/images/strategy.svg', title: l.cardStrategyTitle, description: l.cardStrategyDesc, linkText: l.cardStrategyLink)),
                            const SizedBox(width: 24),
                            SizedBox(width: cardWidth, child: _ServiceCard(iconPath: 'assets/images/investors.svg', title: l.cardInvestorsTitle, description: l.cardInvestorsDesc, linkText: l.cardInvestorsLink)),
                            const SizedBox(width: 24),
                            SizedBox(width: cardWidth, child: _ServiceCard(iconPath: 'assets/images/brands.svg', title: l.cardBrandsTitle, description: l.cardBrandsDesc, linkText: l.cardBrandsLink)),
                            const SizedBox(width: 24),
                            SizedBox(width: cardWidth, child: _ServiceCard(iconPath: 'assets/images/career.svg', title: l.cardCareersTitle, description: l.cardCareersDesc, linkText: l.cardCareersLink)),
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
                                Expanded(child: _ServiceCard(iconPath: 'assets/images/strategy.svg', title: l.cardStrategyTitle, description: l.cardStrategyDesc, linkText: l.cardStrategyLink)),
                                const SizedBox(width: 16),
                                Expanded(child: _ServiceCard(iconPath: 'assets/images/investors.svg', title: l.cardInvestorsTitle, description: l.cardInvestorsDesc, linkText: l.cardInvestorsLink)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(child: _ServiceCard(iconPath: 'assets/images/brands.svg', title: l.cardBrandsTitle, description: l.cardBrandsDesc, linkText: l.cardBrandsLink)),
                                const SizedBox(width: 16),
                                Expanded(child: _ServiceCard(iconPath: 'assets/images/career.svg', title: l.cardCareersTitle, description: l.cardCareersDesc, linkText: l.cardCareersLink)),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final String linkText;

  const _ServiceCard({
    required this.iconPath,
    required this.title,
    required this.description,
    required this.linkText,
  });

  String? _getRouteFromTitle() {
    if (title.contains('Strategy') || title.contains('الاستراتيجية')) return '/strategy-operations';
    if (title.contains('Investors') || title.contains('المستثمرون') || title.contains('الحوكمة')) return '/investors-governance';
    if (title.contains('Careers') || title.contains('الوظائف')) return '/news-careers#careers';
    if (title.contains('Brands') || title.contains('علاماتنا') || title.contains('العلامات')) return null; // Open dialog instead
    return '/';
  }

  bool _isBrandsCard() {
    return title.contains('Brands') || title.contains('علاماتنا') || title.contains('العلامات');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      constraints: const BoxConstraints(minHeight: 240),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _LearnMoreLink(
            route: _getRouteFromTitle(),
            text: linkText,
            isBrandsCard: _isBrandsCard(),
          ),
        ],
      ),
    );
  }
}

class _LearnMoreLink extends StatefulWidget {
  final String? route;
  final String text;
  final bool isBrandsCard;

  const _LearnMoreLink({
    required this.route,
    required this.text,
    this.isBrandsCard = false,
  });

  @override
  State<_LearnMoreLink> createState() => _LearnMoreLinkState();
}

class _LearnMoreLinkState extends State<_LearnMoreLink> {
  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (widget.isBrandsCard) {
              BrandPortfolioDialog.show(context);
            } else if (widget.route != null) {
              final route = widget.route!;
              if (route.contains('#')) {
                final parts = route.split('#');
                final path = parts[0];
                final scrollKey = parts[1];
                final currentPath = GoRouterState.of(context).uri.path;
                
                if (currentPath != path) {
                  context.go(path);
                  Future.delayed(const Duration(milliseconds: 400), () {
                    ScrollKeys.scrollTo(scrollKey);
                  });
                } else {
                  ScrollKeys.scrollTo(scrollKey);
                }
              } else {
                context.go(route);
              }
            }
          },
          child: Row(
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                'assets/images/arrow.svg',
                width: 14,
                height: 14,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





