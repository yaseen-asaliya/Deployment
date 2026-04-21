import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../utils/responsive.dart';
import '../main.dart';

class ShareViewWidget extends StatefulWidget {
  const ShareViewWidget({super.key});
  @override
  State<ShareViewWidget> createState() => _ShareViewWidgetState();
}

class _ShareViewWidgetState extends State<ShareViewWidget> {
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
      key: ValueKey('share-view-$lang'),
      viewId: 'share-view-view-$lang',
      widgetType: 'share-view',
      fallbackHeight: isMobile ? 600 : 400,
      lang: lang,
      showBorder: false, // بدون بوردر
    );
  }
}
