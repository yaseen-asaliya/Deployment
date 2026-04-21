// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/about_us_screen.dart';
import '../screens/strategy_screen.dart';
import '../screens/investors_governance_screen.dart';
import '../screens/news_careers_screen.dart';

CustomTransitionPage _fadePage(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) => _fadePage(context, state, const HomeScreen()),
    ),
    GoRoute(
      path: '/about-us',
      name: 'about-us',
      pageBuilder: (context, state) => _fadePage(context, state, const AboutUsScreen()),
    ),
    GoRoute(
      path: '/strategy-operations',
      name: 'strategy-operations',
      pageBuilder: (context, state) => _fadePage(context, state, const StrategyScreen()),
    ),
    GoRoute(
      path: '/investors-governance',
      name: 'investors-governance',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: const ValueKey('investors-governance-page'),
        child: const InvestorsGovernanceScreen(),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/news-careers',
      name: 'news-careers',
      pageBuilder: (context, state) => _fadePage(context, state, const NewsCareersScreen()),
    ),
    GoRoute(
      path: '/documents-library',
      name: 'documents-library',
      pageBuilder: (context, state) => _fadePage(context, state, const PlaceholderScreen(title: 'Documents Library')),
    ),
    GoRoute(
      path: '/whistleblowing',
      name: 'whistleblowing',
      pageBuilder: (context, state) => _fadePage(context, state, const PlaceholderScreen(title: 'Whistleblowing')),
    ),
    GoRoute(
      path: '/contact',
      name: 'contact',
      pageBuilder: (context, state) => _fadePage(context, state, const PlaceholderScreen(title: 'Contact')),
    ),
  ],
);

// Placeholder screen for pages that don't exist yet
class PlaceholderScreen extends StatefulWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  State<PlaceholderScreen> createState() => _PlaceholderScreenState();
}

class _PlaceholderScreenState extends State<PlaceholderScreen> {
  @override
  void initState() {
    super.initState();
    final viewId = 'placeholder-${widget.title.hashCode}';
    final div = html.DivElement()
      ..style.display = 'flex'
      ..style.flexDirection = 'column'
      ..style.alignItems = 'center'
      ..style.justifyContent = 'center'
      ..style.height = '100%'
      ..style.width = '100%'
      ..style.fontFamily = 'sans-serif'
      ..style.backgroundColor = '#F8FAFB';

    final title = html.HeadingElement.h1()
      ..text = widget.title
      ..style.fontSize = '32px'
      ..style.fontWeight = 'bold'
      ..style.marginBottom = '16px';

    final sub = html.ParagraphElement()
      ..text = 'This page is under construction'
      ..style.marginBottom = '24px'
      ..style.color = '#6B7280';

    final btn = html.AnchorElement()
      ..href = '/'
      ..text = 'Back to Home'
      ..style.padding = '10px 24px'
      ..style.border = '1px solid #E53935'
      ..style.borderRadius = '20px'
      ..style.color = '#E53935'
      ..style.textDecoration = 'none'
      ..style.fontSize = '13px'
      ..style.cursor = 'pointer';

    div.append(title);
    div.append(sub);
    div.append(btn);

    ui.platformViewRegistry.registerViewFactory(viewId, (_) => div);
  }

  @override
  Widget build(BuildContext context) {
    final viewId = 'placeholder-${widget.title.hashCode}';
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: HtmlElementView(viewType: viewId),
    );
  }
}




