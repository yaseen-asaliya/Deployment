// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget يحمّل الـ external script مباشرة في Flutter's DOM بدون iframe
/// هيك السكرول بيشتغل طبيعي 100%
class DirectExternalWidget extends StatefulWidget {
  final String viewId;
  final String widgetType;
  final String lang;
  final double minHeight;

  const DirectExternalWidget({
    super.key,
    required this.viewId,
    required this.widgetType,
    this.lang = 'en',
    this.minHeight = 400,
  });

  @override
  State<DirectExternalWidget> createState() => _DirectExternalWidgetState();
}

class _DirectExternalWidgetState extends State<DirectExternalWidget> {
  html.DivElement? _container;
  double _height = 400;
  Timer? _heightCheckTimer;
  bool _scriptLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;

    _height = widget.minHeight;
    _container = html.DivElement()
      ..id = '${widget.widgetType}-widget'
      ..style.width = '100%'
      ..style.minHeight = '${widget.minHeight}px'
      ..style.backgroundColor = '#ffffff';

    // تحميل الـ script مرة واحدة بس
    _loadWidgetScript();

    // مراقبة الارتفاع
    _startHeightMonitoring();

    // تسجيل الـ view
    try {
      ui.platformViewRegistry.registerViewFactory(
        widget.viewId,
        (int id) => _container!,
      );
    } catch (_) {
      // already registered
    }
  }

  void _loadWidgetScript() {
    if (_scriptLoaded) return;

    // تحقق إذا الـ script محمّل
    final existingScript = html.document.querySelector(
      'script[src="https://irp.atnmo.com/v2/widget/widget-loader.js"]',
    );

    if (existingScript == null) {
      final script = html.ScriptElement()
        ..src = 'https://irp.atnmo.com/v2/widget/widget-loader.js'
        ..async = true;
      html.document.head!.append(script);

      script.onLoad.listen((_) {
        _initializeWidget();
      });
    } else {
      // الـ script موجود، حمّل الـ widget مباشرة
      Future.delayed(const Duration(milliseconds: 500), _initializeWidget);
    }
  }

  void _initializeWidget() {
    if (!mounted || _container == null) return;

    try {
      // استدعاء loadWidget من الـ script
      if (js.context.hasProperty('loadWidget')) {
        js.context.callMethod('loadWidget', [
          widget.widgetType,
          '5be9c146-613e-4141-a351-1f5e13fc5513',
          widget.lang,
          '81a06c05-1a48-4d1b-8dbd-bcf60a76730f',
          'v2',
        ]);
        _scriptLoaded = true;
      } else {
        // حاول مرة ثانية بعد شوي
        Future.delayed(const Duration(milliseconds: 1000), _initializeWidget);
      }
    } catch (e) {
      print('Error loading widget: $e');
      Future.delayed(const Duration(milliseconds: 1000), _initializeWidget);
    }
  }

  void _startHeightMonitoring() {
    _heightCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted || _container == null) return;

      final newHeight = _container!.scrollHeight.toDouble();
      if (newHeight > widget.minHeight && (newHeight - _height).abs() > 10) {
        setState(() => _height = newHeight);
      }
    });
  }

  @override
  void dispose() {
    _heightCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();
    
    return SizedBox(
      width: double.infinity,
      height: _height,
      child: HtmlElementView(viewType: widget.viewId),
    );
  }
}
