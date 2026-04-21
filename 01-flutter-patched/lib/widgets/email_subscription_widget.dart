import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class EmailSubscriptionWidget extends StatefulWidget {
  const EmailSubscriptionWidget({super.key});
  @override
  State<EmailSubscriptionWidget> createState() => _EmailSubscriptionWidgetState();
}

class _EmailSubscriptionWidgetState extends State<EmailSubscriptionWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    return LazyExternalScriptWidget(
      key: ValueKey('email-subscription-$lang'),
      viewId: 'email-subscription-view-$lang',
      widgetType: 'email-subscription',
      fallbackHeight: 400,
      lang: lang,
    );
  }
}





