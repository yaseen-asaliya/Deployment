import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/stats_section.dart';
import '../widgets/brands_section.dart';
import '../widgets/footer_section.dart';
import '../utils/page_meta.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _statsKey = GlobalKey();
  bool _statsTriggered = false;

  @override
  void initState() {
    super.initState();
    localeProvider.addListener(_rebuild);
    _scrollController.addListener(_checkStatsVisibility);
    setPageMeta(
      title: "Al Saif Gallery | Saudi Arabia's Home & Kitchen Retail Leader | Tadawul 4192",
      description: "Al Saif Gallery -- Saudi Arabia's dominant specialty retailer in household and kitchen appliances. 73 stores, SAR 758.8M revenue, approximately 88% proprietary brands. Tadawul-listed since 2022.",
    );
    // Check on first frame in case stats are already visible without scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkStatsVisibility());
  }

  void _checkStatsVisibility() {
    if (_statsTriggered) return;
    final ctx = _statsKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final pos = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    if (pos.dy < screenHeight) {
      setState(() => _statsTriggered = true);
      _scrollController.removeListener(_checkStatsVisibility);
    }
  }

  @override
  void dispose() {
    localeProvider.removeListener(_rebuild);
    _scrollController.removeListener(_checkStatsVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/modern_kitchen.jpeg'), context);
  }

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1880),
        color: const Color(0xFFF8FAFB),
        child: Column(
          children: [
            const TopBar(),
            const CustomNavigationBar(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const HeroSection(),
                    StatsSection(key: _statsKey, animate: _statsTriggered),
                    const BrandsSection(),
                    const FooterSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SelectionArea(child: content),
    );
  }
}
