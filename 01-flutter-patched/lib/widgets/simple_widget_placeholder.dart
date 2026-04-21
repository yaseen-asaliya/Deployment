import 'package:flutter/material.dart';
import 'widget_modal.dart';
import '../utils/app_colors.dart';

/// Placeholder بسيط يفتح الـ widget في modal لما تضغط عليه
class SimpleWidgetPlaceholder extends StatelessWidget {
  final String title;
  final String widgetType;
  final String lang;
  final IconData icon;

  const SimpleWidgetPlaceholder({
    super.key,
    required this.title,
    required this.widgetType,
    required this.lang,
    this.icon = Icons.open_in_new,
  });

  void _openModal(BuildContext context) {
    WidgetModal.show(
      context,
      title: title,
      widgetType: widgetType,
      lang: lang,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openModal(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Click to view',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
