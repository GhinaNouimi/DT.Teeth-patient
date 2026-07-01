import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../widgets/home_section_title.dart';
import '../widgets/quick_action_circle_tile.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(
          title: l10n.quickActions,
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuickActionCircleTile(
              icon: Icons.emergency_outlined,
              label: l10n.emergencyAppointment,
              type: QuickActionCircleType.emergency,
              onTap: () {
                context.push(AppRoutes.emergencyAppointment);
              },
            ),
            QuickActionCircleTile(
              icon: Icons.call_outlined,
              label: l10n.contact,
              type: QuickActionCircleType.contact,
            ),
            QuickActionCircleTile(
              icon: Icons.smart_toy_outlined,
              label: l10n.smartAssistant,
              type: QuickActionCircleType.ai,
            ),
          ],
        ),
      ],
    );
  }
}