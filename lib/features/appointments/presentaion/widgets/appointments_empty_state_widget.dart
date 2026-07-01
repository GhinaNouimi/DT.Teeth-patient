import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

class AppointmentsEmptyStateWidget extends StatelessWidget {
  final bool isUpcoming;

  const AppointmentsEmptyStateWidget({
    super.key,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          Icon(
            isUpcoming
                ? Icons.calendar_today_rounded
                : Icons.history_rounded,
            size: 64,
            color: colors.buttonPrimary.withValues(alpha: 0.2),
          ),

          const SizedBox(height: 16),

          Text(
            isUpcoming
                ? l10n.noUpcomingAppointments
                : l10n.noPastAppointments,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            isUpcoming
                ? l10n.bookFirstAppointment
                : l10n.noPastAppointmentsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}