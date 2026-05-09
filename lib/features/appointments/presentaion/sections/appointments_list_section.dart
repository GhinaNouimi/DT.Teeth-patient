import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../models/appointment_ui_model.dart';
import '../widgets/appointment_card_widget.dart';

class AppointmentsListSection extends StatelessWidget {
  final List<AppointmentUiModel> appointments;

  const AppointmentsListSection({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: appointments.map((appointment) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: AppointmentCardWidget(
            appointment: appointment,
            isUpcoming: appointment.isUpcoming,
            onTap: () {
              context.push(
                AppRoutes.appointmentDetails,
                extra: appointment,
              );
            },
          ),
        );
      }).toList(),
    );
  }
}