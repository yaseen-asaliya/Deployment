import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../utils/responsive.dart';
import '../main.dart';

class PriceLookupWidget extends StatefulWidget {
  const PriceLookupWidget({super.key});
  @override
  State<PriceLookupWidget> createState() => _PriceLookupWidgetState();
}

class _PriceLookupWidgetState extends State<PriceLookupWidget> {
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
      key: ValueKey('price-lookup-$lang'),
      viewId: 'price-lookup-view-$lang',
      widgetType: 'price-lookup',
      fallbackHeight: isMobile ? 600 : 400,
      lang: lang,
      showBorder: false, // بدون بوردر
    );
  }
}
