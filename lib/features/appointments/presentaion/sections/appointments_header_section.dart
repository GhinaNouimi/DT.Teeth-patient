import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class AppointmentsHeaderSection extends StatelessWidget {
  const AppointmentsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إدارة المواعيد',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'تابع مواعيدك القادمة والسابقة بسهولة.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
