import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/nc_hero_section.dart';
import '../widgets/nc_news_section.dart';
import '../widgets/nc_careers_section.dart';
import '../widgets/nc_contact_section.dart';
import '../main.dart';
import '../widgets/footer_section.dart';
import '../utils/page_meta.dart';
import '../utils/scroll_keys.dart';
import '../main.dart';

class NewsCareersScreen extends StatefulWidget {
  const NewsCareersScreen({super.key});

  @override
  State<NewsCareersScreen> createState() => _NewsCareersScreenState();
}

class _NewsCareersScreenState extends State<NewsCareersScreen> {
  @override
  void initState() {
    super.initState();
    localeProvider.addListener(_rebuild);
    setPageMeta(
      title: 'Al Saif Gallery Newsroom | Corporate News & Press Releases',
      description: 'Latest corporate news, press releases, and regulatory announcements from Al Saif Gallery (Tadawul: 4192). Bilingual newsroom updated on every disclosure.',
    );
  }

  @override
  void dispose() {
    localeProvider.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

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
                controller: newsScrollController,
                child: Column(
                  children: [
                    const NCHeroSection(),
                    KeyedSubtree(key: ScrollKeys.get('news'),    child: const NCNewsSection()),
                    KeyedSubtree(key: ScrollKeys.get('careers'), child: const NCCareersSection()),
                    KeyedSubtree(key: ScrollKeys.get('contact'), child: const NCContactSection()),
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






