import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
      ),
      // استخدام Alexandria كخط افتراضي لكل التطبيق (عربي وإنجليزي)
      fontFamily: 'Alexandria',
      textTheme: const TextTheme(
        // العناوين الكبيرة
        displayLarge: TextStyle(fontFamily: 'Alexandria', fontSize: 58, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(fontFamily: 'Alexandria', fontSize: 46, fontWeight: FontWeight.w600),
        displaySmall: TextStyle(fontFamily: 'Alexandria', fontSize: 37, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(fontFamily: 'Alexandria', fontSize: 33, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontFamily: 'Alexandria', fontSize: 29, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontFamily: 'Alexandria', fontSize: 25, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontFamily: 'Alexandria', fontSize: 23, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontFamily: 'Alexandria', fontSize: 17, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontFamily: 'Alexandria', fontSize: 15, fontWeight: FontWeight.w500),
        // النصوص العادية
        bodyLarge: TextStyle(fontFamily: 'Alexandria', fontSize: 17, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontFamily: 'Alexandria', fontSize: 15, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontFamily: 'Alexandria', fontSize: 13, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontFamily: 'Alexandria', fontSize: 15, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontFamily: 'Alexandria', fontSize: 13, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontFamily: 'Alexandria', fontSize: 12, fontWeight: FontWeight.w500),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Color(0xFF5AAAF9),
        cursorColor: Color(0xFF1976D2),
        selectionHandleColor: Color(0xFF1976D2),
      ),
      useMaterial3: true,
    );
  }
}




