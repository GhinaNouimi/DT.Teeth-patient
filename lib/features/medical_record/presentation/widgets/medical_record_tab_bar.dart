import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class MedicalRecordTabBar extends StatelessWidget {
  final List<String> labels;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final List<int>? counts;

  const MedicalRecordTabBar({
    super.key,
    required this.labels,
    required this.currentIndex,
    required this.onChanged,
    this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSoft.withValues(alpha: 0.9)),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == currentIndex;
          final hasCount = counts != null && index < counts!.length;

          return Expanded(
            child: InkWell(
              onTap: () => onChanged(index),
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: selected ? colors.navBarItem : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: colors.navBarItem.withValues(alpha: 0.16),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasCount) ...[
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.14)
                              : colors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${counts![index]}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: selected
                                  ? Colors.white
                                  : colors.navBarItem,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Flexible(
                      child: Text(
                        labels[index],
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: selected ? Colors.white : colors.navBarItem,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
