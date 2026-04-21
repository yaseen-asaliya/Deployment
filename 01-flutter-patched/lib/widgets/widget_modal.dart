// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:flutter/material.dart';

/// Modal يعرض الـ widget في صفحة منفصلة
class WidgetModal extends StatelessWidget {
  final String title;
  final String widgetType;
  final String lang;

  const WidgetModal({
    super.key,
    required this.title,
    required this.widgetType,
    required this.lang,
  });

  static void show(BuildContext context, {
    required String title,
    required String widgetType,
    required String lang,
  }) {
    // فتح الويدجت في صفحة منفصلة
    final url = '${html.window.location.origin}/widget.html?type=$widgetType&lang=$lang';
    
    // على الموبايل بيفتح في tab جديد، على الديسكتوب في نافذة منفصلة
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
