import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class ComplaintsEmptyState extends StatelessWidget {
  final VoidCallback onCreateTap;

  const ComplaintsEmptyState({
    super.key,
    required this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 34,
              color: colors.navBarItem,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد شكاوى بعد',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنك إرسال أول شكوى أو استفسار عند الحاجة، وسنتابعها معك خطوة بخطوة.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCreateTap,
              child: const Text('تقديم شكوى جديدة'),
            ),
          ),
        ],
      ),
    );
  }
}