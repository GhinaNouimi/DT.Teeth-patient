import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../widgets/home_section_title.dart';
import '../widgets/quick_action_circle_tile.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(title: 'إجراءات سريعة'),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuickActionCircleTile(
              icon: Icons.emergency_outlined,
              label: 'موعد طارئ',
              type: QuickActionCircleType.emergency,
              onTap: () {
                context.push(AppRoutes.emergencyAppointment);
              },
            ),
            const QuickActionCircleTile(
              icon: Icons.call_outlined,
              label: 'التواصل',
              type: QuickActionCircleType.contact,
            ),
            const QuickActionCircleTile(
              icon: Icons.smart_toy_outlined,
              label: 'المساعد الذكي',
              type: QuickActionCircleType.ai,
            ),
          ],
        ),
      ],
    );
  }
}