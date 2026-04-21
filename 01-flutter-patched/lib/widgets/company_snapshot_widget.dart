import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../utils/responsive.dart';
import '../main.dart';

class CompanySnapshotWidget extends StatefulWidget {
  const CompanySnapshotWidget({super.key});
  @override
  State<CompanySnapshotWidget> createState() => _CompanySnapshotWidgetState();
}

class _CompanySnapshotWidgetState extends State<CompanySnapshotWidget> {
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
      key: ValueKey('company-snapshot-$lang'),
      viewId: 'company-snapshot-view-$lang',
      widgetType: 'company-snapshot',
      fallbackHeight: isMobile ? 600 : 400,
      lang: lang,
    );
  }
}




