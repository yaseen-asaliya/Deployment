import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';
import 'board_of_directors_dialog.dart';
import 'executive_management_dialog.dart';

class LeadershipSection extends StatelessWidget {
  const LeadershipSection({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final l = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFB),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 35),
      child: Column(
        children: [
          Text(l.leadershipTitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Center(
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(width: 320, child: _LeadershipCard(title: l.boardTitle, description: l.boardDesc, linkText: l.boardLink, isBoard: true)),
                        const SizedBox(width: 24),
                        SizedBox(width: 320, child: _LeadershipCard(title: l.execTitle, description: l.execDesc, linkText: l.execLink, isBoard: false)),
                      ],
                    ),
                  ),
                );
              } else {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _LeadershipCard(title: l.boardTitle, description: l.boardDesc, linkText: l.boardLink, isBoard: true)),
                      const SizedBox(width: 16),
                      Expanded(child: _LeadershipCard(title: l.execTitle, description: l.execDesc, linkText: l.execLink, isBoard: false)),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LeadershipCard extends StatelessWidget {
  final String title;
  final String description;
  final String linkText;
  final bool isBoard;

  const _LeadershipCard({
    required this.title,
    required this.description,
    required this.linkText,
    required this.isBoard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const Spacer(),
          const SizedBox(height: 8),
          SelectionContainer.disabled(
            child: InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: () {
                if (isBoard) {
                  BoardOfDirectorsDialog.show(context);
                } else {
                  ExecutiveManagementDialog.show(context);
                }
              },
              child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    linkText,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SvgPicture.asset(
                  'assets/images/arrow.svg',
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}





