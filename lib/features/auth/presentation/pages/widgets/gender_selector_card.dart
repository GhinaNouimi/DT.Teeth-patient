import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/localization/app_localizations.dart';

class GenderSelectorCard extends StatelessWidget {
  final String? selectedGender;
  final List<String> options;
  final bool showError;
  final ValueChanged<String> onSelected;
  final Duration delay;

  const GenderSelectorCard({
    super.key,
    required this.selectedGender,
    required this.options,
    required this.showError,
    required this.onSelected,
    required this.delay,
  });

  Color _selectedColor(BuildContext context, String option) {
    final l10n = context.l10n;

    if (option == l10n.male) {
      return const Color(0xFF4A90E2);
    }

    return const Color(0xFFE97FB5);
  }

  IconData _genderIcon(BuildContext context, String option) {
    final l10n = context.l10n;

    if (option == l10n.male) {
      return Icons.male_rounded;
    }

    return Icons.female_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.gender,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: options.map((option) {
            final isSelected = selectedGender == option;
            final accentColor = _selectedColor(context, option);

            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: option == options.first ? 0 : 8,
                ),
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  label: option,
                  child: InkWell(
                    onTap: () => onSelected(option),
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: isSelected
                            ? accentColor.withValues(alpha: 0.14)
                            : colors.surface,
                        border: Border.all(
                          color: isSelected
                              ? accentColor
                              : colors.outline.withValues(alpha: 0.38),
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ]
                            : null,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isSelected)
                            PositionedDirectional(
                              end: 0,
                              top: 0,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _genderIcon(context, option),
                                color: isSelected
                                    ? accentColor
                                    : colors.onSurface.withValues(alpha: 0.72),
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                option,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? accentColor
                                      : colors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (showError) ...[
          const SizedBox(height: 8),
          Text(
            l10n.genderRequired,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    ).animate().fadeIn(delay: delay).slideX(begin: 0.08, end: 0);
  }
}