import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_colors.dart';
import '../utils/responsive.dart';
import '../utils/scroll_keys.dart';
import '../main.dart';
import 'search_dialog.dart';
import 'external_script_widget.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  void initState() {
    super.initState();
    localeProvider.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    localeProvider.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final isMobile = Responsive.isMobile(context);
    final isArabic = localeProvider.isArabic;

    final docLabel  = isArabic ? 'مكتبة الوثائق' : 'Documents Library';
    final conLabel  = isArabic ? 'تواصل معنا'    : 'Contact';
    final srchLabel = isArabic ? 'بحث'           : 'Search';
    final langLabel = 'عربي / EN';

    return Container(
      width: double.infinity,
      height: 26,
      color: AppColors.backgroundLight,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, bottom: 1),
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: isArabic ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  if (!isMobile) ...[
                    _buildItem(docLabel,  'assets/images/document.svg',  () => context.go('/documents-library')),
                    const SizedBox(width: 24),
                    _buildItem(conLabel,  'assets/images/contact.svg',   () => _goToContact(context)),
                    const SizedBox(width: 24),
                    _buildItem(srchLabel, 'assets/images/search.svg',    () => _showSearchDialog(context)),
                    const SizedBox(width: 24),
                    _buildItem(langLabel, 'assets/images/language.svg',  () => _showLanguageDialog(context)),
                  ] else ...[
                    _buildItem('', 'assets/images/document.svg', () => context.go('/documents-library')),
                    const SizedBox(width: 16),
                    _buildItem('', 'assets/images/contact.svg', () => _goToContact(context)),
                    const SizedBox(width: 16),
                    _buildItem('', 'assets/images/search.svg', () => _showSearchDialog(context)),
                    const SizedBox(width: 16),
                    _buildItem(langLabel, 'assets/images/language.svg', () => _showLanguageDialog(context)),
                  ],
                ],
              ),
            ),
          ),
          Container(height: 1, color: AppColors.border),
        ],
      ),
    );
  }

  void _goToContact(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    if (currentPath != '/news-careers') {
      context.go('/news-careers');
      Future.delayed(const Duration(milliseconds: 500), () {
        ScrollKeys.scrollTo('contact');
        contactHighlightNotifier.value = true;
        Future.delayed(const Duration(milliseconds: 2000), () {
          contactHighlightNotifier.value = false;
        });
      });
    } else {
      ScrollKeys.scrollTo('contact');
      contactHighlightNotifier.value = true;
      Future.delayed(const Duration(milliseconds: 2000), () {
        contactHighlightNotifier.value = false;
      });
    }
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const SearchDialog(),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    setAllIframesPointerEvents(false);
    final isArabic = localeProvider.isArabic;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => SelectionContainer.disabled(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SimpleDialog(
            title: const Text('Language', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            children: [
              const Divider(height: 1),
              RadioListTile<bool>(
                value: true,
                groupValue: isArabic,
                onChanged: (_) { Navigator.pop(context); if (!isArabic) localeProvider.toggleLanguage(); },
                title: const Text('العربية'),
                activeColor: AppColors.primary,
              ),
              const Divider(height: 1),
              RadioListTile<bool>(
                value: false,
                groupValue: isArabic,
                onChanged: (_) { Navigator.pop(context); if (isArabic) localeProvider.toggleLanguage(); },
                title: const Text('English'),
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      // Re-enable iframe interaction after the language dialog closes.
      setAllIframesPointerEvents(true);
    });
  }

  Widget _buildItem(String text, String iconPath, VoidCallback? onTap) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 14,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
                ),
                if (text.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}





