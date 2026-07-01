import 'package:flutter/material.dart';

import '../../../../../../core/localization/app_localizations.dart';

class TeethCleaningSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const TeethCleaningSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final selectedColor = theme.colorScheme.primary;

    final options = [
      _CleaningOption(
        value: 'once',
        title: l10n.teethCleaningOnce,
        icon: Icons.looks_one_rounded,
      ),
      _CleaningOption(
        value: 'twice',
        title: l10n.teethCleaningTwice,
        icon: Icons.looks_two_rounded,
      ),
      _CleaningOption(
        value: 'rarely',
        title: l10n.teethCleaningRarely,
        icon: Icons.auto_awesome_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.teethCleaningFrequency,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: options.map((option) {
            final isSelected = value == option.value;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  label: option.title,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => onChanged(option.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected
                            ? selectedColor.withValues(alpha: 0.18)
                            : theme.colorScheme.surface,
                        border: Border.all(
                          width: isSelected ? 1.6 : 1,
                          color: isSelected
                              ? selectedColor
                              : theme.colorScheme.outline.withValues(
                            alpha: 0.30,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            option.icon,
                            color: isSelected
                                ? selectedColor
                                : theme.colorScheme.onSurface.withValues(
                              alpha: 0.70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            option.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? selectedColor
                                  : theme.colorScheme.onSurface.withValues(
                                alpha: 0.88,
                              ),
                            ),
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
      ],
    );
  }
}

class _CleaningOption {
  final String value;
  final String title;
  final IconData icon;

  const _CleaningOption({
    required this.value,
    required this.title,
    required this.icon,
  });
}