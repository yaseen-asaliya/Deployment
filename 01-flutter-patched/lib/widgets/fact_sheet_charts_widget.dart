import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class FactSheetChartsWidget extends StatefulWidget {
  const FactSheetChartsWidget({super.key});
  @override
  State<FactSheetChartsWidget> createState() => _FactSheetChartsWidgetState();
}

class _FactSheetChartsWidgetState extends State<FactSheetChartsWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    return LazyExternalScriptWidget(
      key: ValueKey('fact-sheet-charts-$lang'),
      viewId: 'fact-sheet-charts-view-$lang',
      widgetType: 'fact-sheet-charts',
      fallbackHeight: 500,
      lang: lang,
    );
  }
}




