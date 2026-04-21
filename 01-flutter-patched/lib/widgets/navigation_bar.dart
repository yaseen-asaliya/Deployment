// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/ir_section_keys.dart';
import '../utils/scroll_keys.dart';
import '../utils/responsive.dart';
import '../main.dart';
import '../widgets/external_script_widget.dart';
import '../screens/investors_governance_screen.dart';

// ── Global Nav Dropdown Manager ───────────────────────────────────────────────
VoidCallback? _activeNavDropdownCloser;

void _closeActiveNavDropdown() {
  _activeNavDropdownCloser?.call();
  _activeNavDropdownCloser = null;
}

// ── Shared Dropdown Item ──────────────────────────────────────────────────────
class _DropdownItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final bool isArabic;
  final VoidCallback onTap;
  const _DropdownItem({required this.label, required this.isActive, required this.isArabic, required this.onTap});
  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final highlight = widget.isActive || _hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: highlight ? const Color(0xFFFFF5F5) : Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Text(
            widget.label,
            textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.w500 : FontWeight.w400,
              color: highlight ? AppColors.primary : const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }
}
const String _irPageBase = String.fromEnvironment(
  'IR_PAGE_URL',
  defaultValue: 'http://localhost:3001/ir',
);

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  void initState() {
    super.initState();
    localeProvider.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    localeProvider.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _goToIR(BuildContext context) {
    context.go('/investors-governance');
  }

  void _openMenu(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final isArabic = localeProvider.isArabic;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _MobileMenuSheet(
        currentRoute: currentRoute,
        isArabic: isArabic,
        parentContext: context,
      ),
    );
  }

  Widget _mobileItem(String label, String route, String currentRoute, bool isArabic, VoidCallback onTap) {
    final isActive = currentRoute == route;
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          color: isActive ? AppColors.primary.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            if (isActive)
              Container(width: 3, height: 18, color: AppColors.primary,
                margin: EdgeInsets.only(left: isArabic ? 12 : 0, right: isArabic ? 0 : 12)),
            Text(label, style: TextStyle(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppColors.primary : AppColors.textPrimary,
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final isMobile = Responsive.isMobile(context);
    final currentRoute = GoRouterState.of(context).uri.path;
    final l = AppLocalizations.of(context);
    final isAr = l.isArabic;

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(width: 1, color: AppColors.border)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1), spreadRadius: -1),
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3, offset: const Offset(0, 1), spreadRadius: 0),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            if (!isAr) ...[
              if (!isMobile) ...[
                _NavItem(text: l.navHome, isActive: currentRoute == '/', onTap: () => context.go('/')),
                const SizedBox(width: 32),
                _AboutDropdownNavItem(isActive: currentRoute == '/about-us', l: l),
                const SizedBox(width: 32),
                _StrategyDropdownNavItem(isActive: currentRoute == '/strategy-operations', l: l),
                const SizedBox(width: 32),
                _IRDropdownNavItem(isActive: currentRoute == '/investors-governance', l: l, onPage: currentRoute == '/investors-governance'),
                const SizedBox(width: 32),
                _NewsroomDropdownNavItem(isActive: currentRoute == '/news-careers', l: l),
              ] else
                IconButton(icon: const Icon(Icons.menu, color: AppColors.textPrimary), onPressed: () => _openMenu(context)),
              const Spacer(),
            ],
            SizedBox(
              width: 144, height: 59,
              child: SvgPicture.asset('assets/images/Al_Saif_Logo.svg', fit: BoxFit.contain),
            ),
            if (isAr) ...[
              const Spacer(),
              if (!isMobile) ...[
                _NewsroomDropdownNavItem(isActive: currentRoute == '/news-careers', l: l),
                const SizedBox(width: 32),
                _IRDropdownNavItem(isActive: currentRoute == '/investors-governance', l: l, onPage: currentRoute == '/investors-governance'),
                const SizedBox(width: 32),
                _StrategyDropdownNavItem(isActive: currentRoute == '/strategy-operations', l: l),
                const SizedBox(width: 32),
                _AboutDropdownNavItem(isActive: currentRoute == '/about-us', l: l),
                const SizedBox(width: 32),
                _NavItem(text: l.navHome, isActive: currentRoute == '/', onTap: () => context.go('/')),
              ] else
                IconButton(icon: const Icon(Icons.menu, color: AppColors.textPrimary), onPressed: () => _openMenu(context)),
            ],
          ],
        ),
      ),
    );
  }
}

// ── About Us Dropdown Nav Item ────────────────────────────────────────────────
class _AboutDropdownNavItem extends StatefulWidget {
  final bool isActive;
  final AppLocalizations l;
  const _AboutDropdownNavItem({required this.isActive, required this.l});
  @override
  State<_AboutDropdownNavItem> createState() => _AboutDropdownNavItemState();
}

class _AboutDropdownNavItemState extends State<_AboutDropdownNavItem> {
  bool _hovered = false;
  OverlayEntry? _overlay;
  final _key = GlobalKey();

  void _show() {
    _closeActiveNavDropdown();
    _remove();
    _activeNavDropdownCloser = _remove;
    final box = _key.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final isArabic = widget.l.isArabic;

    final items = isArabic ? [
      ('هدفنا',              'our-purpose'),
      ('قيمنا',              'our-values'),
      ('المسيرة والمحطات',   'heritage'),
      ('القيادة',            'leadership'),
    ] : [
      ('Our Purpose',        'our-purpose'),
      ('Our Values',         'our-values'),
      ('Heritage & Milestones', 'heritage'),
      ('Leadership',         'leadership'),
    ];

    _overlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned(
            left: isArabic ? null : offset.dx,
            right: isArabic ? MediaQuery.of(context).size.width - offset.dx - box.size.width : null,
            top: offset.dy + box.size.height + 4,
            child: MouseRegion(
              onExit: (_) => _remove(),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items.map((item) {
                      return _DropdownItem(
                        label: item.$1,
                        isActive: false,
                        isArabic: isArabic,
                        onTap: () {
                          _remove();
                          final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
                          if (currentPath != '/about-us') {
                            GoRouter.of(context).go('/about-us');
                            Future.delayed(const Duration(milliseconds: 400), () => ScrollKeys.scrollTo(item.$2));
                          } else {
                            ScrollKeys.scrollTo(item.$2);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _remove() { _overlay?.remove(); _overlay = null; if (_activeNavDropdownCloser == _remove) _activeNavDropdownCloser = null; }

  @override
  void dispose() { _remove(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        key: _key,
        cursor: SystemMouseCursors.click,
        onEnter: (_) { setState(() => _hovered = true); _show(); },
        onExit:  (_) { setState(() => _hovered = false); },
        child: GestureDetector(
          onTap: () {
            final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
            if (currentPath == '/about-us') {
              // إذا كان بنفس الصفحة، ارجع للأعلى
              _scrollToTopOfCurrentPage(context);
            } else {
              GoRouter.of(context).go('/about-us');
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.l.navAboutUs,
                    style: TextStyle(
                      color: (widget.isActive || _hovered) ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 13.1, fontWeight: FontWeight.w400,
                    )),
                ],
              ),
              const SizedBox(height: 4),
              Container(height: 2, width: 40, color: widget.isActive ? AppColors.primary : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Strategy Dropdown Nav Item ────────────────────────────────────────────────
class _StrategyDropdownNavItem extends StatefulWidget {
  final bool isActive;
  final AppLocalizations l;
  const _StrategyDropdownNavItem({required this.isActive, required this.l});
  @override
  State<_StrategyDropdownNavItem> createState() => _StrategyDropdownNavItemState();
}

class _StrategyDropdownNavItemState extends State<_StrategyDropdownNavItem> {
  bool _hovered = false;
  OverlayEntry? _overlay;
  final _key = GlobalKey();

  void _show() {
    _closeActiveNavDropdown();
    _remove();
    _activeNavDropdownCloser = _remove;
    final box = _key.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final isArabic = widget.l.isArabic;

    final items = isArabic ? [
      ('مقدمة الاستراتيجية',   'strategy-intro'),
      ('ركائز الاستراتيجية',   'strategy-pillars'),
      ('خارطة الطريق',         'strategy-roadmap'),
      ('إدارة المخاطر',        'strategy-risk'),
    ] : [
      ('Strategy Overview',    'strategy-intro'),
      ('Strategic Pillars',    'strategy-pillars'),
      ('Roadmap',              'strategy-roadmap'),
      ('Risk Management',      'strategy-risk'),
    ];

    _overlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned(
            left: isArabic ? null : offset.dx,
            right: isArabic ? MediaQuery.of(context).size.width - offset.dx - box.size.width : null,
            top: offset.dy + box.size.height + 4,
            child: MouseRegion(
              onExit: (_) => _remove(),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items.map((item) {
                      return _DropdownItem(
                        label: item.$1,
                        isActive: false,
                        isArabic: isArabic,
                        onTap: () {
                          _remove();
                          final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
                          if (currentPath != '/strategy-operations') {
                            GoRouter.of(context).go('/strategy-operations');
                            Future.delayed(const Duration(milliseconds: 400), () => ScrollKeys.scrollTo(item.$2));
                          } else {
                            ScrollKeys.scrollTo(item.$2);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _remove() { _overlay?.remove(); _overlay = null; if (_activeNavDropdownCloser == _remove) _activeNavDropdownCloser = null; }

  @override
  void dispose() { _remove(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        key: _key,
        cursor: SystemMouseCursors.click,
        onEnter: (_) { setState(() => _hovered = true); _show(); },
        onExit:  (_) { setState(() => _hovered = false); },
        child: GestureDetector(
          onTap: () {
            final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
            if (currentPath == '/strategy-operations') {
              // إذا كان بنفس الصفحة، ارجع للأعلى
              _scrollToTopOfCurrentPage(context);
            } else {
              GoRouter.of(context).go('/strategy-operations');
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.l.navStrategy,
                    style: TextStyle(
                      color: (widget.isActive || _hovered) ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 13.1, fontWeight: FontWeight.w400,
                    )),
                ],
              ),
              const SizedBox(height: 4),
              Container(height: 2, width: 40, color: widget.isActive ? AppColors.primary : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Newsroom Dropdown Nav Item ────────────────────────────────────────────────
class _NewsroomDropdownNavItem extends StatefulWidget {
  final bool isActive;
  final AppLocalizations l;
  const _NewsroomDropdownNavItem({required this.isActive, required this.l});
  @override
  State<_NewsroomDropdownNavItem> createState() => _NewsroomDropdownNavItemState();
}

class _NewsroomDropdownNavItemState extends State<_NewsroomDropdownNavItem> {
  bool _hovered = false;
  OverlayEntry? _overlay;
  final _key = GlobalKey();

  void _show() {
    _closeActiveNavDropdown();
    _remove();
    _activeNavDropdownCloser = _remove;
    final box = _key.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final isArabic = widget.l.isArabic;

    final items = isArabic ? [
      ('آخر الأخبار',   'news'),
      ('الوظائف',       'careers'),
      ('تواصل معنا',    'contact'),
    ] : [
      ('Latest News',   'news'),
      ('Careers',       'careers'),
      ('Contact Us',    'contact'),
    ];

    _overlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned(
            left: isArabic ? null : offset.dx,
            right: isArabic ? MediaQuery.of(context).size.width - offset.dx - box.size.width : null,
            top: offset.dy + box.size.height + 4,
            child: MouseRegion(
              onExit: (_) => _remove(),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items.map((item) {
                      return _DropdownItem(
                        label: item.$1,
                        isActive: false,
                        isArabic: isArabic,
                        onTap: () {
                          _remove();
                          final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
                          if (currentPath != '/news-careers') {
                            GoRouter.of(context).go('/news-careers');
                            Future.delayed(const Duration(milliseconds: 400), () => ScrollKeys.scrollTo(item.$2));
                          } else {
                            ScrollKeys.scrollTo(item.$2);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _remove() { _overlay?.remove(); _overlay = null; if (_activeNavDropdownCloser == _remove) _activeNavDropdownCloser = null; }

  @override
  void dispose() { _remove(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        key: _key,
        cursor: SystemMouseCursors.click,
        onEnter: (_) { setState(() => _hovered = true); _show(); },
        onExit:  (_) { setState(() => _hovered = false); },
        child: GestureDetector(
          onTap: () {
            final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
            if (currentPath == '/news-careers') {
              // إذا كان بنفس الصفحة، ارجع للأعلى
              _scrollToTopOfCurrentPage(context);
            } else {
              GoRouter.of(context).go('/news-careers');
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.l.navNewsroom,
                    style: TextStyle(
                      color: (widget.isActive || _hovered) ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 13.1, fontWeight: FontWeight.w400,
                    )),
                ],
              ),
              const SizedBox(height: 4),
              Container(height: 2, width: 40, color: widget.isActive ? AppColors.primary : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}

// ── IR Dropdown Nav Item ──────────────────────────────────────────────────────
class _IRDropdownNavItem extends StatefulWidget {
  final bool isActive;
  final bool onPage;
  final AppLocalizations l;
  const _IRDropdownNavItem({required this.isActive, required this.l, required this.onPage});

  @override
  State<_IRDropdownNavItem> createState() => _IRDropdownNavItemState();
}

class _IRDropdownNavItemState extends State<_IRDropdownNavItem> {
  bool _hovered = false;
  OverlayEntry? _overlay;
  final _key = GlobalKey();

  void _showDropdown() {
    _closeActiveNavDropdown();
    _removeDropdown();
    _activeNavDropdownCloser = _removeDropdown;
    setAllIframesPointerEvents(false);
    final ctx = _key.currentContext ?? context;
    final box = ctx.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final isArabic = widget.l.isArabic;

    final items = isArabic ? [
      ('مقومات الاستثمار',       -1),
      ('نظرة عامة',              0),
      ('الإعلانات',              1),
      ('نشرة المعلومات',         2),
      ('نشاط السهم',             3),
      ('الإجراءات النظامية',     4),
      ('البيانات المالية',       5),
      ('سعر السهم',              6),
      ('الأداء',                 7),
      ('حاسبة الاستثمار',        8),
      ('سلسلة الأسهم',           9),
      ('تحليل المجموعة المماثلة', 10),
      ('الاشتراك',               11),
    ] : [
      ('Investment Case',        -1),
      ('Company Snapshot',       0),
      ('Announcements',          1),
      ('Fact Sheet',             2),
      ('Stock Activity',         3),
      ('Corporate Actions',      4),
      ('Company Financials',     5),
      ('Share Price',            6),
      ('Performance',            7),
      ('Investment Calculator',  8),
      ('Share Series',           9),
      ('Peer Group Analysis',    10),
      ('Subscribe',              11),
    ];

    _overlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned(
            left: isArabic ? null : offset.dx,
            right: isArabic ? MediaQuery.of(context).size.width - offset.dx - box.size.width : null,
            top: offset.dy + box.size.height + 4,
            child: MouseRegion(
              onExit: (_) => _removeDropdown(),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items.map((item) {
                      return InkWell(
                        onTap: () {
                          final tabIndex = item.$2;
                          _removeDropdown();
                          final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
                          if (currentPath != '/investors-governance') {
                            GoRouter.of(context).go('/investors-governance');
                            Future.delayed(const Duration(milliseconds: 600), () {
                              if (tabIndex == -1) {
                                // سكرول للـ Investment Case
                                ScrollKeys.scrollTo('ig-investment-case');
                              } else {
                                irTabBodyKey.currentState?.switchTab(tabIndex);
                                Future.delayed(const Duration(milliseconds: 200), () {
                                  ScrollKeys.scrollTo('ir-widgets');
                                });
                              }
                            });
                          } else {
                            if (tabIndex == -1) {
                              ScrollKeys.scrollTo('ig-investment-case');
                            } else {
                              irTabBodyKey.currentState?.switchTab(tabIndex);
                              Future.delayed(const Duration(milliseconds: 100), () {
                                ScrollKeys.scrollTo('ir-widgets');
                              });
                            }
                          }
                        },
                        child: _DropdownItem(
                          label: item.$1,
                          isActive: false,
                          isArabic: isArabic,
                          onTap: () {
                            final tabIndex = item.$2;
                            _removeDropdown();
                            final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
                            if (currentPath != '/investors-governance') {
                              GoRouter.of(context).go('/investors-governance');
                              Future.delayed(const Duration(milliseconds: 600), () {
                                if (tabIndex == -1) {
                                  ScrollKeys.scrollTo('ig-investment-case');
                                } else {
                                  irTabBodyKey.currentState?.switchTab(tabIndex);
                                  Future.delayed(const Duration(milliseconds: 200), () {
                                    ScrollKeys.scrollTo('ir-widgets');
                                  });
                                }
                              });
                            } else {
                              if (tabIndex == -1) {
                                ScrollKeys.scrollTo('ig-investment-case');
                              } else {
                                irTabBodyKey.currentState?.switchTab(tabIndex);
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  ScrollKeys.scrollTo('ir-widgets');
                                });
                              }
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _removeDropdown() {
    _overlay?.remove();
    _overlay = null;
    // Restore iframe interaction after the dropdown closes. Leaving them
    // disabled after each dropdown dismissal was a big part of the mobile
    // "unresponsive" perception.
    setAllIframesPointerEvents(true);
    if (_activeNavDropdownCloser == _removeDropdown) _activeNavDropdownCloser = null;
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        key: _key,
        cursor: SystemMouseCursors.click,
        onEnter: (_) { setState(() => _hovered = true); _showDropdown(); },
        onExit:  (_) { setState(() => _hovered = false); },
        child: GestureDetector(
          onTap: () {
            final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
            if (currentPath == '/investors-governance') {
              // إذا كان بنفس الصفحة، ارجع للأعلى
              _scrollToTopOfCurrentPage(context);
            } else {
              GoRouter.of(context).go('/investors-governance');
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.l.navInvestors,
                style: TextStyle(
                  color: (widget.isActive || _hovered) ? AppColors.textPrimary : AppColors.textSecondary,
                  fontSize: 13.1,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Container(height: 2, width: 40, color: widget.isActive ? AppColors.primary : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {  final String text;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({required this.text, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
            if (currentPath == '/') {
              // إذا كان بنفس الصفحة، ارجع للأعلى
              _scrollToTopOfCurrentPage(context);
            } else {
              onTap?.call();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                  fontSize: 13.1,
                  fontWeight: FontWeight.w400,
                  height: 1.53,
                ),
              ),
              const SizedBox(height: 4),
              Container(height: 2, width: 40, color: isActive ? AppColors.primary : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}

void _scrollToTopOfCurrentPage(BuildContext context) {
  final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
  
  // ابحث عن الـ ScrollController في الصفحة الحالية
  ScrollController? controller;
  
  if (currentPath == '/investors-governance') {
    controller = irScrollController;
  } else if (currentPath == '/strategy-operations') {
    controller = strategyScrollController;
  } else if (currentPath == '/about-us') {
    controller = aboutScrollController;
  } else if (currentPath == '/news-careers') {
    controller = newsScrollController;
  } else {
    // للصفحات الأخرى (Home)، ابحث عن أي ScrollView في الـ widget tree
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      controller = scrollable.widget.controller;
    }
  }
  
  if (controller != null && controller.hasClients) {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

// ── Mobile Sub Item ───────────────────────────────────────────────────────────
class _MobileSubItem extends StatefulWidget {
  final String label;
  final bool isArabic;
  final VoidCallback onTap;
  const _MobileSubItem({required this.label, required this.isArabic, required this.onTap});
  @override
  State<_MobileSubItem> createState() => _MobileSubItemState();
}

class _MobileSubItemState extends State<_MobileSubItem> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: widget.isArabic ? 24 : 40,
            right: widget.isArabic ? 40 : 24,
            top: 13, bottom: 13,
          ),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFFFF5F5) : Colors.transparent,
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Text(widget.label, style: TextStyle(
            fontSize: 13,
            fontWeight: _hovered ? FontWeight.w500 : FontWeight.w400,
            color: _hovered ? AppColors.primary : const Color(0xFF374151),
          )),
        ),
      ),
    );
  }
}

// ── Mobile Menu Sheet ─────────────────────────────────────────────────────────
class _MobileMenuSheet extends StatefulWidget {
  final String currentRoute;
  final bool isArabic;
  final BuildContext parentContext;
  const _MobileMenuSheet({required this.currentRoute, required this.isArabic, required this.parentContext});

  @override
  State<_MobileMenuSheet> createState() => _MobileMenuSheetState();
}

class _MobileMenuSheetState extends State<_MobileMenuSheet> {
  int? _expanded; // index of expanded item

  void _navigate(String route, [String? scrollKey, int tabIndex = -1]) {
    Navigator.pop(context);
    final ctx = widget.parentContext;
    final currentPath = GoRouter.of(ctx).routerDelegate.currentConfiguration.uri.path;

    // إذا كبس على نفس الصفحة بدون sub-section، ارجع للأعلى
    if (currentPath == route && scrollKey == null && tabIndex == -1) {
      _scrollToTopOfCurrentPage(ctx);
      return;
    }

    void doNavigate() {
      if (tabIndex >= 0) {
        // أظهر الـ widget لوحدها زي الديسكتوب
        irTabBodyKey.currentState?.switchTab(tabIndex);
        Future.delayed(const Duration(milliseconds: 150), () {
          ScrollKeys.scrollTo('ir-widgets');
        });
      } else if (scrollKey != null) {
        Future.delayed(const Duration(milliseconds: 300), () => ScrollKeys.scrollTo(scrollKey));
      }
    }

    if (currentPath != route) {
      GoRouter.of(ctx).go(route);
      Future.delayed(const Duration(milliseconds: 600), doNavigate);
    } else {
      doNavigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isAr = widget.isArabic;

    final items = [
      _NavMenuItem(
        label: l.navHome,
        route: '/',
        subs: [],
      ),
      _NavMenuItem(
        label: l.navAboutUs,
        route: '/about-us',
        subs: isAr ? [
          ('هدفنا',            'our-purpose', -1),
          ('قيمنا',            'our-values',  -1),
          ('المسيرة والمحطات', 'heritage',    -1),
          ('القيادة',          'leadership',  -1),
        ] : [
          ('Our Purpose',          'our-purpose', -1),
          ('Our Values',           'our-values',  -1),
          ('Heritage & Milestones','heritage',    -1),
          ('Leadership',           'leadership',  -1),
        ],
      ),
      _NavMenuItem(
        label: l.navStrategy,
        route: '/strategy-operations',
        subs: isAr ? [
          ('مقدمة الاستراتيجية', 'strategy-intro',    -1),
          ('ركائز الاستراتيجية', 'strategy-pillars',  -1),
          ('خارطة الطريق',       'strategy-roadmap',  -1),
          ('إدارة المخاطر',      'strategy-risk',     -1),
        ] : [
          ('Strategy Overview', 'strategy-intro',   -1),
          ('Strategic Pillars', 'strategy-pillars', -1),
          ('Roadmap',           'strategy-roadmap', -1),
          ('Risk Management',   'strategy-risk',    -1),
        ],
      ),
      _NavMenuItem(
        label: l.navInvestors,
        route: '/investors-governance',
        subs: isAr ? [
          ('مقومات الاستثمار',        'ig-investment-case', -1),
          ('نظرة عامة',               'ir-tab-0',            0),
          ('الإعلانات',               'ir-tab-1',            1),
          ('نشرة المعلومات',          'ir-tab-2',            2),
          ('نشاط السهم',              'ir-tab-3',            3),
          ('الإجراءات النظامية',      'ir-tab-4',            4),
          ('البيانات المالية',        'ir-tab-5',            5),
          ('سعر السهم',               'ir-tab-6',            6),
          ('الأداء',                  'ir-tab-7',            7),
          ('حاسبة الاستثمار',         'ir-tab-8',            8),
          ('سلسلة الأسهم',            'ir-tab-9',            9),
          ('تحليل المجموعة المماثلة', 'ir-tab-10',          10),
          ('الاشتراك',                'ir-tab-11',          11),
        ] : [
          ('Investment Case',        'ig-investment-case', -1),
          ('Company Snapshot',       'ir-tab-0',            0),
          ('Announcements',          'ir-tab-1',            1),
          ('Fact Sheet',             'ir-tab-2',            2),
          ('Stock Activity',         'ir-tab-3',            3),
          ('Corporate Actions',      'ir-tab-4',            4),
          ('Company Financials',     'ir-tab-5',            5),
          ('Share Price',            'ir-tab-6',            6),
          ('Performance',            'ir-tab-7',            7),
          ('Investment Calculator',  'ir-tab-8',            8),
          ('Share Series',           'ir-tab-9',            9),
          ('Peer Group Analysis',    'ir-tab-10',          10),
          ('Subscribe',              'ir-tab-11',          11),
        ],
      ),
      _NavMenuItem(
        label: l.navNewsroom,
        route: '/news-careers',
        subs: isAr ? [
          ('آخر الأخبار', 'news',    -1),
          ('الوظائف',     'careers', -1),
          ('تواصل معنا',  'contact', -1),
        ] : [
          ('Latest News', 'news',    -1),
          ('Careers',     'careers', -1),
          ('Contact Us',  'contact', -1),
        ],
      ),
    ];

    return SelectionContainer.disabled(
      child: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 4),
                ...List.generate(items.length, (i) {
                  final item = items[i];
                  final isActive = widget.currentRoute == item.route;
                  final isExpanded = _expanded == i;
                  final hasSubs = item.subs.isNotEmpty;

                  return Column(
                    children: [
                      InkWell(
                        onTap: () => _navigate(item.route),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                            color: isActive ? AppColors.primary.withOpacity(0.05) : Colors.white,
                          ),
                          child: Row(
                            children: [
                              if (isActive)
                                Container(width: 3, height: 18, color: AppColors.primary,
                                  margin: EdgeInsets.only(left: isAr ? 12 : 0, right: isAr ? 0 : 12)),
                              Expanded(
                                child: Text(item.label, style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                                )),
                              ),
                              if (hasSubs)
                                GestureDetector(
                                  onTap: () => setState(() => _expanded = isExpanded ? null : i),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: AnimatedRotation(
                                      turns: isExpanded ? 0.5 : 0,
                                      duration: const Duration(milliseconds: 200),
                                      child: Icon(Icons.keyboard_arrow_down,
                                        size: 22,
                                        color: isActive ? AppColors.primary : Colors.grey.shade400),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Sub items
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        firstChild: const SizedBox.shrink(),
                        secondChild: Container(
                          color: const Color(0xFFF8FAFB),
                          child: Column(
                            children: item.subs.map((sub) => _MobileSubItem(
                              label: sub.$1,
                              isArabic: isAr,
                              onTap: () => _navigate(item.route, sub.$2, sub.$3),
                            )).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavMenuItem {
  final String label;
  final String route;
  final List<(String, String, int)> subs;
  const _NavMenuItem({required this.label, required this.route, required this.subs});
}

// ── Mobile Section Dropdown ───────────────────────────────────────────────────
// استخدمه في كل صفحة على الموبايل لعرض sections كـ dropdown
class MobileSectionDropdown extends StatefulWidget {
  final List<(String label, String scrollKey)> sections;
  const MobileSectionDropdown({super.key, required this.sections});

  @override
  State<MobileSectionDropdown> createState() => _MobileSectionDropdownState();
}

class _MobileSectionDropdownState extends State<MobileSectionDropdown> {
  bool _open = false;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isMobile(context)) return const SizedBox.shrink();
    final isArabic = localeProvider.isArabic;
    final hp = Responsive.getHorizontalPadding(context);
    final selected = widget.sections[_selected].$1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: hp, vertical: 13),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Expanded(
                  child: Text(selected,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 20),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Column(
              children: List.generate(widget.sections.length, (i) {
                final isActive = _selected == i;
                return InkWell(
                  onTap: () {
                    setState(() { _selected = i; _open = false; });
                    ScrollKeys.scrollTo(widget.sections[i].$2);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: hp, vertical: 13),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary.withOpacity(0.05) : Colors.white,
                      border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
                    ),
                    child: Row(
                      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        if (isActive)
                          Container(
                            width: 3, height: 16,
                            margin: EdgeInsets.only(
                              right: isArabic ? 0 : 10,
                              left: isArabic ? 10 : 0,
                            ),
                            color: AppColors.primary,
                          ),
                        Text(widget.sections[i].$1,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            color: isActive ? AppColors.primary : const Color(0xFF374151),
                          )),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
