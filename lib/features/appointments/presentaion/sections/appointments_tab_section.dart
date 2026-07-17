import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

class AppointmentsTabSection extends StatelessWidget {
  final int upcomingCount;
  final int pastCount;
  final int currentTabIndex;
  final Function(int) onTabChanged;

  const AppointmentsTabSection({
    super.key,
    required this.upcomingCount,
    required this.pastCount,
    required this.currentTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    Widget buildTab({
      required String label,
      required int count,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? colors.navBarItem
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              boxShadow: selected
                  ? [
                BoxShadow(
                  color: colors.navBarItem.withValues(
                    alpha: 0.16,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      '$count',
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
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: selected
                          ? Colors.white
                          : colors.navBarItem,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.borderSoft.withValues(alpha: 0.9),
        ),
      ),
      child: Row(
        children: [
          buildTab(
            label: l10n.upcomingAppointments,
            count: upcomingCount,
            selected: currentTabIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          const SizedBox(width: 8),
          buildTab(
            label: l10n.pastAppointments,
            count: pastCount,
            selected: currentTabIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}