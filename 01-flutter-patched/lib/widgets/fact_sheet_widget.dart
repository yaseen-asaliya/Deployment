import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../utils/app_colors.dart';
import '../main.dart';

class FactSheetWidget extends StatefulWidget {
  const FactSheetWidget({super.key});
  @override
  State<FactSheetWidget> createState() => _FactSheetWidgetState();
}

class _FactSheetWidgetState extends State<FactSheetWidget> {
  int _tab = 0; // 0 = Table, 1 = Chart

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
    final tableLabel = isAr ? 'جدول' : 'Table';
    final chartLabel = isAr ? 'رسم بياني' : 'Chart';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Tab Bar ──
        Row(
          children: [
            _TabButton(label: tableLabel, active: _tab == 0, onTap: () => setState(() => _tab = 0)),
            const SizedBox(width: 8),
            _TabButton(label: chartLabel, active: _tab == 1, onTap: () => setState(() => _tab = 1)),
          ],
        ),
        const SizedBox(height: 12),
        // ── Content — keep both mounted to avoid reload ──
        Offstage(
          offstage: _tab != 0,
          child: Stack(children: [
            Offstage(offstage: isAr,  child: const ExternalScriptWidget(viewId: 'fact-sheet-table-view-en', widgetType: 'fact-sheet-table', fallbackHeight: 400, lang: 'en')),
            Offstage(offstage: !isAr, child: const ExternalScriptWidget(viewId: 'fact-sheet-table-view-ar', widgetType: 'fact-sheet-table', fallbackHeight: 400, lang: 'ar')),
          ]),
        ),
        Offstage(
          offstage: _tab != 1,
          child: Stack(children: [
            Offstage(offstage: isAr,  child: const ExternalScriptWidget(viewId: 'fact-sheet-charts-view-en', widgetType: 'fact-sheet-charts', fallbackHeight: 400, lang: 'en')),
            Offstage(offstage: !isAr, child: const ExternalScriptWidget(viewId: 'fact-sheet-charts-view-ar', widgetType: 'fact-sheet-charts', fallbackHeight: 400, lang: 'ar')),
          ]),
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




