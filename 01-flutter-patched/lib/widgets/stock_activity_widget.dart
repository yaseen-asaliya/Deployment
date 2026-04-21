import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../utils/app_colors.dart';
import '../main.dart';

class StockActivityWidget extends StatefulWidget {
  const StockActivityWidget({super.key});
  @override
  State<StockActivityWidget> createState() => _StockActivityWidgetState();
}

class _StockActivityWidgetState extends State<StockActivityWidget> {
  int _tab = 0; // 0 = Simple, 1 = Advanced

  @override
  void initState() {
    super.initState();
    localeProvider.addListener(_rebuild);
  }

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void dispose() {
    localeProvider.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = localeProvider.isArabic;
    final lang = isAr ? 'ar' : 'en';
    final simpleLabel  = isAr ? 'بسيط'  : 'Simple';
    final advancedLabel = isAr ? 'متقدم' : 'Advanced';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Tab Bar ──
        Row(
          children: [
            _TabButton(label: simpleLabel,   active: _tab == 0, onTap: () => setState(() => _tab = 0)),
            const SizedBox(width: 8),
            _TabButton(label: advancedLabel, active: _tab == 1, onTap: () => setState(() => _tab = 1)),
          ],
        ),
        const SizedBox(height: 12),
        // ── Content — keep both mounted ──
        Offstage(
          offstage: _tab != 0,
          child: ExternalScriptWidget(
            key: ValueKey('stock-activity-simple-$lang'),
            viewId: 'stock-activity-simple-view-$lang',
            widgetType: 'stock-activity-simple',
            fallbackHeight: 400,
            lang: lang,
          ),
        ),
        Offstage(
          offstage: _tab != 1,
          child: ExternalScriptWidget(
            key: ValueKey('stock-activity-advanced-$lang'),
            viewId: 'stock-activity-advanced-view-$lang',
            widgetType: 'stock-activity-advanced',
            fallbackHeight: 400,
            lang: lang,
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: active ? Colors.white : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: active ? AppColors.primary : const Color(0xFFE5E7EB),
                width: 2,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppColors.textPrimary : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}




