import 'package:flutter/material.dart';

import '../widgets/home_section_title.dart';
import '../widgets/quick_action_tile.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        HomeSectionTitle(title: 'إجراءات سريعة'),
        SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            QuickActionTile(
              icon: Icons.call_outlined,
              label: 'التواصل',
            ),
            QuickActionTile(
              icon: Icons.emergency_outlined,
              label: 'موعد طارئ',
              isEmergency: true,
            ),
            QuickActionTile(
              icon: Icons.calendar_month_outlined,
              label: 'حجز موعد',
            ),
            QuickActionTile(
              icon: Icons.smart_toy_outlined,
              label: 'المساعد الذكي',
            ),
          ],
        ),
      ],
    );
  }
}
