import 'package:flutter/material.dart';

import '../../../../../core/localization/app_localizations.dart';

class PasswordMatchCard extends StatelessWidget {
  final String password;
  final String confirmPassword;

  const PasswordMatchCard({
    super.key,
    required this.password,
    required this.confirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final hasValue = confirmPassword.isNotEmpty;
    final matches = hasValue && password == confirmPassword;

    final color = !hasValue
        ? theme.colorScheme.primary
        : matches
        ? const Color(0xFF34B67A)
        : const Color(0xFFE76F6F);

    final text = !hasValue
        ? l10n.passwordConfirmHint
        : matches
        ? l10n.passwordsMatch
        : l10n.passwordsNotMatching;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            !hasValue
                ? Icons.info_outline_rounded
                : matches
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}