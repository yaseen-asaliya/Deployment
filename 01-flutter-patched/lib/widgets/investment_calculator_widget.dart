import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class InvestmentCalculatorWidget extends StatefulWidget {
  const InvestmentCalculatorWidget({super.key});
  @override
  State<InvestmentCalculatorWidget> createState() => _InvestmentCalculatorWidgetState();
}

class _InvestmentCalculatorWidgetState extends State<InvestmentCalculatorWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    return LazyExternalScriptWidget(
      key: ValueKey('investment-calculator-$lang'),
      viewId: 'investment-calculator-view-$lang',
      widgetType: 'investment-calculator',
      fallbackHeight: 400,
      lang: lang,
    );
  }
}




