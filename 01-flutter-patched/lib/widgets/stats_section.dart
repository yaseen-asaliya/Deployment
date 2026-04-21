import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

class StatsSection extends StatelessWidget {
  final bool animate;
  const StatsSection({super.key, this.animate = false});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final l = AppLocalizations.of(context);
    final isArabic = l.isArabic;

    final cards = [
      _StatCardData(prefix: '',     target: 73,    suffix: '',   title: l.statsShowrooms,    subtitle: l.statsShowroomsSubtitle),
      _StatCardData(prefix: 'SAR ', target: 758.8, suffix: 'M',  title: l.statsRevenue,      subtitle: l.statsRevenueSubtitle,   isDecimal: true, prefixAr: '', suffixAr: ' مليون ريال'),
      _StatCardData(prefix: '~',    target: 88,    suffix: '%',  title: l.statsPropRevenue,  subtitle: l.statsPropRevenueSubtitle),
      _StatCardData(prefix: '',     target: 37,    suffix: '%',  title: l.statsEcommerce,    subtitle: l.statsEcommerceSubtitle),
    ];

    final orderedCards = isArabic ? cards.reversed.toList() : cards;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 35,
        bottom: 35,
      ),
      decoration: const BoxDecoration(color: Color(0xFFF8FAFB)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return Row(
              children: List.generate(orderedCards.length, (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 12,
                    right: i == orderedCards.length - 1 ? 0 : 12,
                  ),
                  child: _AnimatedStatCard(data: orderedCards[i], animate: animate, isArabic: isArabic),
                ),
              )),
            );
          } else {
            return Column(
              children: [
                IntrinsicHeight(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Expanded(child: _AnimatedStatCard(data: orderedCards[0], animate: animate, isArabic: isArabic)),
                    const SizedBox(width: 16),
                    Expanded(child: _AnimatedStatCard(data: orderedCards[1], animate: animate, isArabic: isArabic)),
                  ]),
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Expanded(child: _AnimatedStatCard(data: orderedCards[2], animate: animate, isArabic: isArabic)),
                    const SizedBox(width: 16),
                    Expanded(child: _AnimatedStatCard(data: orderedCards[3], animate: animate, isArabic: isArabic)),
                  ]),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class _StatCardData {
  final String prefix;
  final double target;
  final String suffix;
  final String title;
  final String subtitle;
  final bool isDecimal;
  final String? prefixAr;
  final String? suffixAr;

  const _StatCardData({
    required this.prefix,
    required this.target,
    required this.suffix,
    required this.title,
    required this.subtitle,
    this.isDecimal = false,
    this.prefixAr,
    this.suffixAr,
  });
}

class _AnimatedStatCard extends StatefulWidget {
  final _StatCardData data;
  final bool animate;
  final bool isArabic;
  const _AnimatedStatCard({required this.data, required this.animate, this.isArabic = false});

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    if (widget.animate) _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedStatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Color(0x19000000), blurRadius: 2, offset: Offset(0, 1), spreadRadius: -1),
          BoxShadow(color: Color(0x19000000), blurRadius: 3, offset: Offset(0, 1), spreadRadius: 0),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final current = widget.data.target * _controller.value;
              final display = widget.data.isDecimal
                  ? current.toStringAsFixed(1)
                  : current.toInt().toString();
              final prefix = widget.isArabic && widget.data.prefixAr != null
                  ? widget.data.prefixAr!
                  : widget.data.prefix;
              final suffix = widget.isArabic && widget.data.suffixAr != null
                  ? widget.data.suffixAr!
                  : widget.data.suffix;
              return Text(
                '$prefix$display$suffix',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFC62030),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Text(widget.data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF101727), fontSize: 11, fontWeight: FontWeight.w700, height: 1.48),
          ),
          const SizedBox(height: 3),
          Text(widget.data.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF495565), fontSize: 9, fontWeight: FontWeight.w400, height: 1.40),
          ),
        ],
      ),
    );
  }
}
