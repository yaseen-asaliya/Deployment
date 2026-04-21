// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

/// Widget يعرض الـ external widget مباشرة في الصفحة (inline)
class EmbeddedWidget extends StatefulWidget {
  final String widgetType;
  final String lang;
  final double height;

  const EmbeddedWidget({
    super.key,
    required this.widgetType,
    required this.lang,
    this.height = 600,
  });

  @override
  State<EmbeddedWidget> createState() => _EmbeddedWidgetState();
}

class _EmbeddedWidgetState extends State<EmbeddedWidget> {
  html.IFrameElement? _iframe;
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'embedded-widget-${widget.widgetType}-${DateTime.now().millisecondsSinceEpoch}';
    _createIframe();
  }

  void _createIframe() {
    _iframe = html.IFrameElement()
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '${widget.height}px'
      ..style.display = 'block'
      ..setAttribute('scrolling', 'no')
      ..src = '${html.window.location.origin}/widget.html?type=${widget.widgetType}&lang=${widget.lang}';

    try {
      ui.platformViewRegistry.registerViewFactory(_viewId, (int id) => _iframe!);
    } catch (_) {
      // already registered
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: HtmlElementView(viewType: _viewId),
      ),
    );
  }
}
