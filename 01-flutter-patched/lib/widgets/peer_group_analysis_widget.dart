import 'package:flutter/material.dart';
import 'external_script_widget.dart';
import '../main.dart';

class PeerGroupAnalysisWidget extends StatefulWidget {
  const PeerGroupAnalysisWidget({super.key});
  @override
  State<PeerGroupAnalysisWidget> createState() => _PeerGroupAnalysisWidgetState();
}

class _PeerGroupAnalysisWidgetState extends State<PeerGroupAnalysisWidget> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    return LazyExternalScriptWidget(
      key: ValueKey('peer-group-analysis-$lang'),
      viewId: 'peer-group-analysis-view-$lang',
      widgetType: 'peer-group-analysis',
      fallbackHeight: 400,
      lang: lang,
    );
  }
}




