import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';
import '../main.dart';

class HeritageMilestonesSection extends StatefulWidget {
  const HeritageMilestonesSection({super.key});

  @override
  State<HeritageMilestonesSection> createState() => _HeritageMilestonesSectionState();
}

class _HeritageMilestonesSectionState extends State<HeritageMilestonesSection>
    with SingleTickerProviderStateMixin {
  final ScrollController _timelineController = ScrollController();
  final ScrollController _cardsController = ScrollController();
  late final Ticker _ticker;

  bool _userInteracting = false;
  bool _justResumed = false;
  Duration _lastElapsed = Duration.zero;
  bool _frameScheduled = false;

  static const double _pxPerSecond = 40.0;
  static const Duration _resumeDelay = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    localeProvider.addListener(_onLocaleChanged);
    _ticker = createTicker(_onTick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ticker.start();
    });
  }

  void _onTick(Duration elapsed) {
    if (_userInteracting) {
      _lastElapsed = elapsed;
      return;
    }
    if (_justResumed) {
      _justResumed = false;
      _lastElapsed = elapsed;
      return;
    }

    final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    if (dt <= 0 || dt > 0.5) return;

    final delta = _pxPerSecond * dt;

    // Use Future.microtask to run scroll OUTSIDE the current frame pipeline
    // This prevents the mouse_tracker assertion (line 200) which fires when
    // scroll position changes during Flutter's hit-testing / mouse-tracking phase
    if (!_frameScheduled) {
      _frameScheduled = true;
      Future.microtask(() {
        _frameScheduled = false;
        if (!mounted || _userInteracting) return;
        _applyScroll(delta);
      });
    }
  }

  void _applyScroll(double delta) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _userInteracting) return;
      for (final ctrl in [_cardsController, _timelineController]) {
        if (!ctrl.hasClients) continue;
        final pos = ctrl.position;
        final max = pos.maxScrollExtent;
        if (max <= 0) continue;
        final next = pos.pixels + delta;
        if (next >= max) {
          ctrl.jumpTo(0);
        } else {
          ctrl.jumpTo(next);
        }
      }
    });
  }

  void _onLocaleChanged() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_cardsController.hasClients) _cardsController.jumpTo(0);
      if (_timelineController.hasClients) _timelineController.jumpTo(0);
    });
  }

  @override
  void dispose() {
    localeProvider.removeListener(_onLocaleChanged);
    _ticker.dispose();
    _timelineController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  void _onUserInteractionStart() {
    _userInteracting = true;
  }

  void _onUserInteractionEnd() {
    Future.delayed(_resumeDelay, () {
      if (mounted) {
        _justResumed = true;
        _userInteracting = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final l = AppLocalizations.of(context);
    final isArabic = l.isArabic;

    final milestones = [
      (year: l.m1993year,  title: l.m1993title,  desc: l.m1993desc),
      (year: l.m2006year,  title: l.m2006title,  desc: l.m2006desc),
      (year: l.m2010year,  title: l.m2010title,  desc: l.m2010desc),
      (year: l.m2014year,  title: l.m2014title,  desc: l.m2014desc),
      (year: l.m2015year,  title: l.m2015title,  desc: l.m2015desc),
      (year: l.m2016year,  title: l.m2016title,  desc: l.m2016desc),
      (year: l.m2018year,  title: l.m2018title,  desc: l.m2018desc),
      (year: l.m2022year,  title: l.m2022title,  desc: l.m2022desc),
      (year: l.m2023year,  title: l.m2023title,  desc: l.m2023desc),
      (year: l.m2024year,  title: l.m2024title,  desc: l.m2024desc),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 35,
        bottom: 35,
      ),
      child: Column(
        children: [
          Text(
            l.heritageTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.heritageSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 30),
          if (Responsive.isMobile(context))
            _VerticalTimeline(milestones: milestones, isArabic: isArabic)
          else ...[
          SizedBox(
            height: 10,
            child: SingleChildScrollView(
              controller: _timelineController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: milestones.length * 240 + (milestones.length - 1) * 20.0,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 4,
                      child: Container(height: 2, color: const Color(0xFF101828)),
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < milestones.length; i++) ...[
                          SvgPicture.asset('assets/images/red ball.svg', width: 10, height: 10),
                          if (i < milestones.length - 1) const SizedBox(width: 250),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SelectionContainer.disabled(
            child: MouseRegion(
              onEnter: (_) => _onUserInteractionStart(),
              onExit: (_) => _onUserInteractionEnd(),
              child: SizedBox(
                height: 200,
                child: Listener(
                  onPointerDown: (_) => _onUserInteractionStart(),
                  onPointerUp: (_) => _onUserInteractionEnd(),
                  onPointerCancel: (_) => _onUserInteractionEnd(),
                  child: ListView.separated(
                    controller: _cardsController,
                    scrollDirection: Axis.horizontal,
                    itemCount: milestones.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 20),
                    itemBuilder: (context, index) {
                      final m = milestones[index];
                      return _MilestoneCard(
                        year: m.year,
                        title: m.title,
                        description: m.desc,
                        isArabic: isArabic,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          ], // end else desktop
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final String year;
  final String title;
  final String description;
  final bool isArabic;

  const _MilestoneCard({
    required this.year,
    required this.title,
    required this.description,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                year,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalTimeline extends StatelessWidget {
  final List<({String year, String title, String desc})> milestones;
  final bool isArabic;

  const _VerticalTimeline({required this.milestones, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < milestones.length; i++)
          _VerticalTimelineRow(
            year: milestones[i].year,
            title: milestones[i].title,
            desc: milestones[i].desc,
            isArabic: isArabic,
            isLast: i == milestones.length - 1,
          ),
      ],
    );
  }
}

class _VerticalTimelineRow extends StatelessWidget {
  final String year;
  final String title;
  final String desc;
  final bool isArabic;
  final bool isLast;

  const _VerticalTimelineRow({
    required this.year,
    required this.title,
    required this.desc,
    required this.isArabic,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عمود الخط والنقطة
          SizedBox(
            width: 32,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // الخط يمر من الأعلى للأسفل خلف النقطة
                Positioned(
                  top: 0,
                  bottom: 0,
                  width: 2,
                  child: Container(color: const Color(0xFF6B7280)),
                ),
                // النقطة الحمراء فوق الخط
                Positioned(
                  top: 14,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // البطاقة
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: _VerticalCard(year: year, title: title, desc: desc, isArabic: isArabic),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalCard extends StatelessWidget {
  final String year;
  final String title;
  final String desc;
  final bool isArabic;

  const _VerticalCard({required this.year, required this.title, required this.desc, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(year, style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
