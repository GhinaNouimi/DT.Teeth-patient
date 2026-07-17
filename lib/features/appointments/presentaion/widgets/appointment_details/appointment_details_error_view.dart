import 'package:flutter/material.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';

class AppointmentDetailsErrorView
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppointmentDetailsErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 68,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 18),
            Text(
              context.l10n
                  .appointmentDetailsLoadFailedTitle,
              textAlign: TextAlign.center,
              style:
              theme.textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
              theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                context.l10n.retryButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}