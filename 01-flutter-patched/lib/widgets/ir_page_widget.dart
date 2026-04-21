// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'dart:async';
import 'dart:js_util' as js_util;
import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../main.dart';

// ── غيّر هذا عند النشر على production ──────────────────────────────────────
const String _irPageUrl = String.fromEnvironment(
  'IR_PAGE_URL',
  defaultValue: 'http://localhost:3001/ir',
);
// ────────────────────────────────────────────────────────────────────────────

class IRPageWidget extends StatefulWidget {
  const IRPageWidget({super.key});

  @override
  State<IRPageWidget> createState() => _IRPageWidgetState();
}

class _IRPageWidgetState extends State<IRPageWidget> {
  static const _viewId = 'ir-nextjs-page';
  html.IFrameElement? _iframe;
  double _height = 600;
  html.EventListener? _msgListener;
  Timer? _debounce;
  bool _registered = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;

    _iframe = html.IFrameElement()
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.pointerEvents = 'auto'
      ..style.userSelect = 'text'
      ..setAttribute('allowfullscreen', 'true')
      ..src = _irPageUrl;

    // Listen for height reports from Next.js page
    _msgListener = (event) {
      final msg = (event as html.MessageEvent).data;
      if (msg == null) return;
      try {
        final type = js_util.getProperty(msg, 'type');
        if (type == 'ir-page-height') {
          final h = (js_util.getProperty(msg, 'height') as num?)?.toDouble() ?? 0;
          if (h > 100) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 200), () {
              if (mounted && (h - _height).abs() > 4) {
                setState(() => _height = h);
              }
            });
          }
        }
      } catch (_) {}
    };
    html.window.addEventListener('message', _msgListener!);

    // Send lang on locale change
    localeProvider.addListener(_sendLang);

    // Register view factory once
    try {
      ui.platformViewRegistry.registerViewFactory(
        _viewId,
        (int id) => _iframe!,
      );
      _registered = true;
    } catch (_) {
      _registered = true; // already registered
    }

    // Send initial lang after iframe loads
    _iframe!.onLoad.first.then((_) {
      Future.delayed(const Duration(milliseconds: 500), _sendLang);
    });
  }

  void _sendLang() {
    if (_iframe?.contentWindow == null) return;
    final lang = localeProvider.isArabic ? 'ar' : 'en';
    // Use js interop to postMessage correctly
    js_util.callMethod(
      _iframe!.contentWindow!,
      'postMessage',
      [
        js_util.jsify({'type': 'set-lang', 'lang': lang}),
        '*',
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    localeProvider.removeListener(_sendLang);
    if (_msgListener != null) {
      html.window.removeEventListener('message', _msgListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      height: _height,
      child: HtmlElementView(viewType: _viewId),
    );
  }
}




