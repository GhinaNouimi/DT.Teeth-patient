import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/validators.dart';

class PasswordStrengthCard extends StatelessWidget {
  final String password;
  final bool showTitle;

  const PasswordStrengthCard({
    super.key,
    required this.password,
    this.showTitle = true,
  });

  String _strengthLabel(BuildContext context) {
    final l10n = context.l10n;
    final strength = AppValidators.passwordStrength(password);

    if (password.isEmpty) return l10n.passwordStrengthStart;
    if (strength < 0.4) return l10n.passwordWeak;
    if (strength < 0.75) return l10n.passwordMedium;
    return l10n.passwordStrong;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final strength = AppValidators.passwordStrength(password);
    final label = _strengthLabel(context);

    final hasMinLength = password.length >= 8;
    final hasUpperAndLower =
        RegExp(r'[A-Z]').hasMatch(password) &&
            RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    Color accentColor;
    if (password.isEmpty) {
      accentColor = theme.colorScheme.primary;
    } else if (strength < 0.4) {
      accentColor = const Color(0xFFE76F6F);
    } else if (strength < 0.75) {
      accentColor = const Color(0xFFF2B36D);
    } else {
      accentColor = const Color(0xFF34B67A);
    }

    final titleColor = password.isEmpty
        ? theme.colorScheme.onSurface.withValues(alpha: 0.86)
        : accentColor;

    final checks = [
      _RuleItem(text: l10n.passwordRuleMinLength, passed: hasMinLength),
      _RuleItem(text: l10n.passwordRuleUpperLower, passed: hasUpperAndLower),
      _RuleItem(text: l10n.passwordRuleNumber, passed: hasNumber),
      _RuleItem(text: l10n.passwordRuleSpecial, passed: hasSpecial),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.colorScheme.surface,
        border: Border.all(color: accentColor.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            Row(
              children: [
                Icon(Icons.shield_rounded, color: titleColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.passwordStrengthTitle(label),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: password.isEmpty ? 0 : strength,
              minHeight: 9,
              backgroundColor: accentColor.withValues(alpha: 0.10),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
          const SizedBox(height: 14),
          ...checks.map(
                (item) => item
                .animate(target: 1)
                .fadeIn(duration: 250.ms)
                .slideX(begin: 0.04, end: 0),
          ),
        ],
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final String text;
  final bool passed;

  const _RuleItem({
    required this.text,
    required this.passed,
  });

  @override
  Widget build(BuildContext context) {
    const successColor = Color(0xFF34B67A);
    final theme = Theme.of(context);

    final idleColor = theme.colorScheme.onSurface.withValues(alpha: 0.55);
    final textColor = passed
        ? successColor
        : theme.colorScheme.onSurface.withValues(alpha: 0.78);

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            passed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: passed ? successColor : idleColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: passed ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}