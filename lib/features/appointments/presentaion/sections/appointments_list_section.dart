import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../domain/entities/appointment_entity.dart';
import '../widgets/appointment_card_widget.dart';

class AppointmentsListSection extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  final int? cancellingAppointmentId;

  const AppointmentsListSection({
    super.key,
    required this.appointments,
    this.cancellingAppointmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: appointments.map((appointment) {
        final isCancelling =
            cancellingAppointmentId == appointment.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: AppointmentCardWidget(
            appointment: appointment,
            isCancelling: isCancelling,
            onTap: isCancelling
                ? null
                : () {
              context.push(
                AppRoutes.appointmentDetails,
                extra: appointment.id,
              );
            },
          ),
        );
      }).toList(),
    );
  }
}