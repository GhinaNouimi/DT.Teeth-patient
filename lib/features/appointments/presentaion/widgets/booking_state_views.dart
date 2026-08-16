import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';

class BookingSkeleton extends StatelessWidget {
  const BookingSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppSkeleton(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          24,
        ),
        children: List.generate(
          4,
              (index) => Padding(
            padding: const EdgeInsets.only(
              bottom: 14,
            ),
            child: Container(
              height: index == 0 ? 70 : 90,
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookingEmptyView extends StatelessWidget {
  final VoidCallback onRetry;

  const BookingEmptyView({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BookingMessageView(
      icon: Icons.event_busy_outlined,
      message: context.l10n.noAppointmentTypesAvailable,
      buttonText: context.l10n.retryButton,
      onPressed: onRetry,
    );
  }
}

class BookingErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const BookingErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BookingMessageView(
      icon: Icons.error_outline_rounded,
      message: message,
      buttonText: context.l10n.retryButton,
      onPressed: onRetry,
    );
  }
}

class BookingMessageView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const BookingMessageView({
    super.key,
    required this.icon,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 54,
              color: colors.textSecondary,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onPressed,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}