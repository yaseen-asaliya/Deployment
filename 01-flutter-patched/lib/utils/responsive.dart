import 'package:flutter/material.dart';

class Responsive {
  // Breakpoints
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1920;

  // Check device type
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  // Get responsive padding
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= largeDesktop) {
      return 192.0; // للشاشات الكبيرة جداً (202 - 10)
    } else if (width >= desktop) {
      return ((width * 0.1) - 8).clamp(8.0, 192.0);
    } else if (width >= tablet) {
      return 52.0; // (62 - 10)
    } else {
      return 12.0; // للموبايل (22 - 10)
    }
  }

  // Get responsive value based on screen size
  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return desktop;
  }
}




