import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class StockTickerWidget extends StatefulWidget {
  const StockTickerWidget({super.key});
  @override
  State<StockTickerWidget> createState() => _StockTickerWidgetState();
}

class _StockTickerWidgetState extends State<StockTickerWidget> {
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
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    // Stock Ticker يتحمل مباشرة على كل المنصات (مهم ولازم يبقى ظاهر)
    return ExternalScriptWidget(
      key: ValueKey('stock-ticker-$lang'),
      viewId: 'stock-ticker-view-$lang',
      widgetType: 'stock-ticker',
      fallbackHeight: 46,
      lang: lang,
      priority: true,
      showBorder: false, // بدون بوردر
    );
  }
}






