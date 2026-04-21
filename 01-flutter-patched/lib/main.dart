import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'utils/app_router.dart';
import 'utils/locale_provider.dart';
import 'utils/app_localizations.dart';

void main() {
  runApp(const AlSaifGalleryApp());
}

// Global LocaleProvider instance accessible from widgets
final LocaleProvider localeProvider = LocaleProvider();

// Global scroll controller for IR page - receives iframe wheel events
final ScrollController irScrollController = ScrollController();

// Global scroll controller for Strategy page
final ScrollController strategyScrollController = ScrollController();

// Global scroll controller for About page
final ScrollController aboutScrollController = ScrollController();

// Global scroll controller for News page
final ScrollController newsScrollController = ScrollController();

// Global notifier for contact section highlight
final ValueNotifier<bool> contactHighlightNotifier = ValueNotifier(false);

class AlSaifGalleryApp extends StatefulWidget {
  const AlSaifGalleryApp({super.key});

  @override
  State<AlSaifGalleryApp> createState() => _AlSaifGalleryAppState();
}

class _AlSaifGalleryAppState extends State<AlSaifGalleryApp> {
  @override
  void initState() {
    super.initState();
    localeProvider.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => setState(() {});

  @override
  void dispose() {
    localeProvider.removeListener(_onLocaleChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Al Saif Gallery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      builder: (context, child) => AppLocalizationsProvider(
        provider: localeProvider,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: localeProvider.isArabic ? 0.9 : 1.0,
          ),
          child: Directionality(
            textDirection: localeProvider.isArabic
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child!,
          ),
        ),
      ),
    );
  }
}




