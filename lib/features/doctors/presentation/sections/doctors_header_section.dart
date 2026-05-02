import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class DoctorsHeaderSection extends StatelessWidget {
  const DoctorsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أطباء المركز',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'اختر الطبيب المناسب لك حسب التخصص والخبرة، ثم احجز موعدك بسهولة.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
