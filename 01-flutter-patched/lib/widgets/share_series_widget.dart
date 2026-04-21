import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class ShareSeriesWidget extends StatefulWidget {
  const ShareSeriesWidget({super.key});
  @override
  State<ShareSeriesWidget> createState() => _ShareSeriesWidgetState();
}

class _ShareSeriesWidgetState extends State<ShareSeriesWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    return LazyExternalScriptWidget(
      key: ValueKey('share-series-$lang'),
      viewId: 'share-series-view-$lang',
      widgetType: 'share-series',
      fallbackHeight: 400,
      lang: lang,
    );
  }
}





