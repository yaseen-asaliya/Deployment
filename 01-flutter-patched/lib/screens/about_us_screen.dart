import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/about_hero_section.dart';import '../widgets/our_purpose_section.dart';
import '../widgets/our_values_section.dart';
import '../widgets/heritage_milestones_section.dart';
import '../widgets/leadership_section.dart';
import '../widgets/footer_section.dart';
import '../utils/page_meta.dart';
import '../utils/scroll_keys.dart';
import '../main.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    localeProvider.addListener(_rebuild);
    setPageMeta(
      title: 'About Al Saif Gallery | Saudi Retail Since 1993 | Tadawul 4192',
      description: "Discover the story of Al Saif Gallery -- Saudi Arabia's household and kitchen specialist since 1993. 73 stores, proprietary brands, and a commitment to lasting customer value.",
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
                controller: aboutScrollController,
                child: Column(
                  children: [
                    const AboutHeroSection(),
                    KeyedSubtree(key: ScrollKeys.get('our-purpose'),    child: const OurPurposeSection()),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                    ),
                    KeyedSubtree(key: ScrollKeys.get('our-values'),     child: const OurValuesSection()),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                    ),
                    KeyedSubtree(key: ScrollKeys.get('heritage'),       child: const HeritageMilestonesSection()),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                    ),
                    KeyedSubtree(key: ScrollKeys.get('leadership'),     child: const LeadershipSection()),
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






