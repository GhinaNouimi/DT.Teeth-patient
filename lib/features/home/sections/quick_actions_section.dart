import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../appointments/presentaion/bloc/appointments/appointments_bloc.dart';
import '../../appointments/presentaion/bloc/appointments/appointments_event.dart';
import '../widgets/home_section_title.dart';
import '../widgets/quick_action_circle_tile.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
  });

  Future<void> _openBookingScreen(
      BuildContext context,
      ) async {
    final booked = await context.push<bool>(
      AppRoutes.newAppointment,
    );

    if (booked != true || !context.mounted) {
      return;
    }

    final languageCode =
        Localizations.localeOf(context).languageCode;

    context.read<AppointmentsBloc>().add(
      RefreshAppointmentsRequested(
        languageCode: languageCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(
          title: l10n.quickActions,
        ),

        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuickActionCircleTile(
              icon: Icons.call_outlined,
              label: l10n.contact,
              type: QuickActionCircleType.contact,
            ),
            // QuickActionCircleTile(
            //   icon: Icons.smart_toy_outlined,
            //   label: l10n.smartAssistant,
            //   type: QuickActionCircleType.ai,
            // ),
          ],
        ),
      ],
    );
  }
}