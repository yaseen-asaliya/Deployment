import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class SharePriceWidget extends StatefulWidget {
  const SharePriceWidget({super.key});
  @override
  State<SharePriceWidget> createState() => _SharePriceWidgetState();
}

class _SharePriceWidgetState extends State<SharePriceWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    return LazyExternalScriptWidget(
      key: ValueKey('share-price-$lang'),
      viewId: 'share-price-view-$lang',
      widgetType: 'share-price',
      fallbackHeight: 400,
      lang: lang,
    );
  }
}




