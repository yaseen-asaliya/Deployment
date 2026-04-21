// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

void setPageMeta({required String title, required String description}) {
  if (!kIsWeb) return;
  html.document.title = title;
  final meta = html.document.querySelector('meta[name="description"]');
  if (meta != null) meta.setAttribute('content', description);
}
