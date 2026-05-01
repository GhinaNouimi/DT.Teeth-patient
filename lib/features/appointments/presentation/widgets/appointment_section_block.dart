import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import 'appointment_details_card.dart';

class AppointmentSectionBlock extends StatelessWidget {
  final String title;
  final Widget child;

  const AppointmentSectionBlock({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return AppointmentDetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: colors.buttonPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
