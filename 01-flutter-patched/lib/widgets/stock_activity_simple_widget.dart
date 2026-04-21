import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class StockActivitySimpleWidget extends StatefulWidget {
  const StockActivitySimpleWidget({super.key});
  @override
  State<StockActivitySimpleWidget> createState() => _StockActivitySimpleWidgetState();
}

class _StockActivitySimpleWidgetState extends State<StockActivitySimpleWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    return LazyExternalScriptWidget(
      key: ValueKey('stock-activity-$lang'),
      viewId: 'stock-activity-view-$lang',
      widgetType: 'stock-activity',
      fallbackHeight: 500,
      lang: lang,
    );
  }
}





