import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_extensions.dart';

class AppFilterTabItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final int? count;

  const AppFilterTabItem({
    required this.value,
    required this.label,
    this.icon,
    this.count,
  });
}

class AppFilterTabs<T> extends StatelessWidget {
  final List<AppFilterTabItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onChanged;

  const AppFilterTabs({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = item.value == selectedValue;

          return Padding(
            padding: const EdgeInsetsDirectional.only(
              end: AppSpacing.sm,
            ),
            child: InkWell(
              onTap: () => onChanged(item.value),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.buttonPrimary
                      : colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: isSelected
                        ? colors.buttonPrimary
                        : colors.borderSoft,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 17,
                        color: isSelected
                            ? colors.textInverse
                            : colors.textPrimary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Text(
                      item.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? colors.textInverse
                            : colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (item.count != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.textInverse.withValues(alpha: 0.16)
                              : colors.surfacePrimary,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: isSelected
                                ? colors.textInverse.withValues(alpha: 0.22)
                                : colors.borderSoft,
                          ),
                        ),
                        child: Text(
                          item.count.toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? colors.textInverse
                                : colors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}