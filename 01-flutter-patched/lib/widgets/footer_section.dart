// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../utils/ir_section_keys.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';
import '../main.dart';
import '../screens/investors_governance_screen.dart';
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/bag.svg', width: 28, height: 28, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              const SizedBox(height: 10),
              Text(l.footerCtaTitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 4),
              Text(l.footerCtaSubtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300)),
              const SizedBox(height: 14),
              SelectionContainer.disabled(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => html.window.open('https://alsaifgallery.com/', '_blank'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
                      child: Text(l.footerCtaButton, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _BlackFooter(),
      ],
    );
  }
}

class _BlackFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final l = AppLocalizations.of(context);

    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A1A),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : horizontalPadding, vertical: 28),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _FooterAbout(l: l)),
                    const SizedBox(width: 24),
                    Expanded(child: _FooterColumn(title: l.footerCompany, items: [l.footerAboutUs, l.footerStrategy, l.footerCareers], routes: ['/about-us', '/strategy-operations', '/news-careers'])),
                    const SizedBox(width: 24),
                    Expanded(child: _FooterColumn(title: l.footerInvestors, items: [l.footerAnnualReports, l.footerGovernance, l.footerReports], routes: ['/investors-governance', '/investors-governance', '/investors-governance'], scrollKeys: [IRSectionKeys.companyFinancials, IRSectionKeys.corporateActions, IRSectionKeys.announcements])),
                    const SizedBox(width: 24),
                    Expanded(child: _FooterColumn(title: l.footerContact, items: [l.footerIR, 'ir@alsaifgallery.com', '+966 11 406 4444'], routes: ['/investors-governance', 'mailto:ir@alsaifgallery.com', 'tel:+966114064444'])),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _FooterAbout(l: l)),
                        Expanded(child: _FooterColumn(title: l.footerCompany, items: [l.footerAboutUs, l.footerStrategy, l.footerCareers], routes: ['/about-us', '/strategy-operations', '/news-careers'])),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _FooterColumn(title: l.footerInvestors, items: [l.footerAnnualReports, l.footerGovernance, l.footerReports], routes: ['/investors-governance', '/investors-governance', '/investors-governance'], scrollKeys: [IRSectionKeys.companyFinancials, IRSectionKeys.corporateActions, IRSectionKeys.announcements])),
                        Expanded(child: _FooterColumn(title: l.footerContact, items: [l.footerIR, 'ir@alsaifgallery.com', '+966 11 406 4444'], routes: ['/investors-governance', 'mailto:ir@alsaifgallery.com', 'tel:+966114064444'])),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 28),
          Container(height: 1, color: const Color(0xFF374151)),
          const SizedBox(height: 20),
          _FooterCopyright(l: l),
        ],
      ),
    );
  }
}

class _FooterAbout extends StatelessWidget {
  final AppLocalizations l;
  const _FooterAbout({required this.l});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Al Saif Gallery', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(l.footerEstablished, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontWeight: FontWeight.w400)),
        const SizedBox(height: 2),
        Text('Tadawul: 4192', style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontWeight: FontWeight.w400)),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<String?> routes;
  final List<GlobalKey?> scrollKeys;

  const _FooterColumn({
    required this.title,
    required this.items,
    this.routes = const [],
    this.scrollKeys = const [],
  });

  int _footerTabIndex(GlobalKey key) {
    if (key == IRSectionKeys.companyFinancials) return 5;
    if (key == IRSectionKeys.corporateActions)  return 4;
    if (key == IRSectionKeys.announcements)     return 1;
    return 0;
  }

  void _handleTap(BuildContext context, String route, GlobalKey? scrollKey) {    if (route.startsWith('mailto:')) {
      final email = route.replaceFirst('mailto:', '');
      html.window.open('https://mail.google.com/mail/?view=cm&to=$email', '_blank');
    } else if (route.startsWith('tel:')) {
      html.window.location.assign(route);
    } else if (route.startsWith('http')) {
      html.window.open(route, '_blank');
    } else {
      if (scrollKey != null) {
        final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
        // scrollKey هنا بيحمل الـ tab index كـ int في الـ hashCode
        final tabIndex = _footerTabIndex(scrollKey);
        if (currentPath != '/investors-governance') {
          context.go('/investors-governance');
          Future.delayed(const Duration(milliseconds: 400), () {
            irTabBodyKey.currentState?.switchTab(tabIndex);
          });
        } else {
          irTabBodyKey.currentState?.switchTab(tabIndex);
        }
      } else {
        context.go(route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        ...List.generate(items.length, (i) {
          final route = i < routes.length ? routes[i] : null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SelectionContainer.disabled(
              child: MouseRegion(
                cursor: route != null ? SystemMouseCursors.click : MouseCursor.defer,
                child: GestureDetector(
                  onTap: route != null ? () => _handleTap(context, route, i < scrollKeys.length ? scrollKeys[i] : null) : null,
                  child: Text(
                    items[i],
                    style: TextStyle(
                      color: route != null ? const Color(0xFFD1D5DB) : const Color(0xFF9CA3AF),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _FooterCopyright extends StatelessWidget {
  final AppLocalizations l;
  const _FooterCopyright({required this.l});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.footerCopyright, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w400)),
              Wrap(
                spacing: 24,
                children: [
                  Text(l.footerPrivacy, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w400)),
                  Text(l.footerTerms, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w400)),
                  Text(l.footerCorporateGov, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.footerCopyright, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              Text(l.footerPrivacy, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w400)),
              const SizedBox(height: 8),
              Text(l.footerTerms, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w400)),
              const SizedBox(height: 8),
              Text(l.footerCorporateGov, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w400)),
            ],
          );
        }
      },
    );
  }
}





