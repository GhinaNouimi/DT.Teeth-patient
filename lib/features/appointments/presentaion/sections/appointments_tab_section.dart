import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../widgets/switch_tab_button.dart';

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

    return Container(
      height: 62,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SwitchTabButton(
              label: 'القادمة',
              icon: Icons.calendar_today_rounded,
              count: upcomingCount,
              isActive: currentTabIndex == 0,
              onTap: () => onTabChanged(0),
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: SwitchTabButton(
              label: 'السابقة',
              icon: Icons.history_rounded,
              count: pastCount,
              isActive: currentTabIndex == 1,
              onTap: () => onTabChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}