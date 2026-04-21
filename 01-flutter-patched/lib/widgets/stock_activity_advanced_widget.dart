import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class StockActivityAdvancedWidget extends StatefulWidget {
  const StockActivityAdvancedWidget({super.key});
  @override
  State<StockActivityAdvancedWidget> createState() => _StockActivityAdvancedWidgetState();
}

class _StockActivityAdvancedWidgetState extends State<StockActivityAdvancedWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    return LazyExternalScriptWidget(
      key: ValueKey('stock-activity-advanced-$lang'),
      viewId: 'stock-activity-advanced-view-$lang',
      widgetType: 'stock-activity-advanced',
      fallbackHeight: 500,
      lang: lang,
    );
  }
}





