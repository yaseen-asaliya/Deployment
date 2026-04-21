// ignore_for_file: avoid_web_libraries_in_flutter
import 'package:flutter/material.dart';

/// Global keys for scrolling to specific sections
class ScrollKeys {
  static final Map<String, GlobalKey> _keys = {};

  static GlobalKey get(String id) {
    return _keys.putIfAbsent(id, () => GlobalKey());
  }

  static void scrollTo(String id) {
    final key = _keys[id];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }
}
