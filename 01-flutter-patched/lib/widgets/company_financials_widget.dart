import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class CompanyFinancialsWidget extends StatefulWidget {
  const CompanyFinancialsWidget({super.key});
  @override
  State<CompanyFinancialsWidget> createState() => _CompanyFinancialsWidgetState();
}

class _CompanyFinancialsWidgetState extends State<CompanyFinancialsWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    return LazyExternalScriptWidget(
      key: ValueKey('company-financials-$lang'),
      viewId: 'company-financials-view-$lang',
      widgetType: 'company-financials',
      fallbackHeight: 500,
      lang: lang,
    );
  }
}




