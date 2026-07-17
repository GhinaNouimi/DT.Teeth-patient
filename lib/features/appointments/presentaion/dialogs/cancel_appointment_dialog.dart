import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

class CancelAppointmentDialog extends StatelessWidget {
  const CancelAppointmentDialog({
    super.key,
  });

  static Future<bool> show(
      BuildContext context,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const CancelAppointmentDialog();
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return AlertDialog(
      backgroundColor: colors.surfacePrimary,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
        side: BorderSide(
          color: theme.colorScheme.error.withValues(
            alpha: 0.16,
          ),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        22,
        22,
        22,
        0,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        22,
        16,
        22,
        0,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        22,
        22,
        22,
        22,
      ),
      title: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.error.withValues(
                alpha: 0.10,
              ),
              border: Border.all(
                color: theme.colorScheme.error.withValues(
                  alpha: 0.18,
                ),
              ),
            ),
            child: Icon(
              Icons.event_busy_rounded,
              color: theme.colorScheme.error,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.cancelAppointmentDialogTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      content: Text(
        l10n.cancelAppointmentDialogMessage,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colors.textSecondary,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  theme.colorScheme.error,
                  foregroundColor:
                  theme.colorScheme.onError,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(
                  Icons.close_rounded,
                  size: 19,
                ),
                label: Text(
                  l10n.confirmCancellationButton,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                  colors.textSecondary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  l10n.keepAppointmentButton,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}