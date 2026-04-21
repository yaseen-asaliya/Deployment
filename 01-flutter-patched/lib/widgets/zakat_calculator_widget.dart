import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../utils/responsive.dart';
import '../main.dart';

class ZakatCalculatorWidget extends StatefulWidget {
  const ZakatCalculatorWidget({super.key});
  @override
  State<ZakatCalculatorWidget> createState() => _ZakatCalculatorWidgetState();
}

class _ZakatCalculatorWidgetState extends State<ZakatCalculatorWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    final isMobile = Responsive.isMobile(context);
    return LazyExternalScriptWidget(
      key: ValueKey('zakat-calculator-$lang'),
      viewId: 'zakat-calculator-view-$lang',
      widgetType: 'zakat-calculator',
      fallbackHeight: isMobile ? 600 : 400,
      lang: lang,
      showBorder: false, // بدون بوردر
    );
  }
}
