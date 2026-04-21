// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  bool _isArabic = _loadFromStorage();

  static bool _loadFromStorage() {
    try {
      return html.window.localStorage['lang'] == 'ar';
    } catch (_) {
      return false;
    }
  }

  bool get isArabic => _isArabic;
  String get languageCode => _isArabic ? 'ar' : 'en';
  TextDirection get textDirection => _isArabic ? TextDirection.rtl : TextDirection.ltr;

  void toggleLanguage() {
    _isArabic = !_isArabic;
    try {
      html.window.localStorage['lang'] = _isArabic ? 'ar' : 'en';
    } catch (_) {}
    notifyListeners();
  }
}
