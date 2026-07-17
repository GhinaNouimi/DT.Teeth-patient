import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../appointments/domain/entities/appointment_entity.dart';
import '../../appointments/presentaion/bloc/appointments/appointments_bloc.dart';
import '../../appointments/presentaion/bloc/appointments/appointments_state.dart';
import '../../appointments/presentaion/sections/next_appointment_section.dart';
import '../sections/center_offers_section.dart';
import '../sections/patient_welcome_hero_section.dart';
import '../sections/quick_actions_section.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsBloc, AppointmentsState>(
      builder: (context, state) {
        final nextAppointment = _getLatestAppointment(state);

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  0,
                ),
                child: PatientWelcomeHeroSection(),
              ),
            ),

            if (nextAppointment != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    24,
                    20,
                    0,
                  ),
                  child: NextAppointmentSection(
                    appointment: nextAppointment,
                  ),
                ),
              ),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  0,
                ),
                child: QuickActionsSection(),
              ),
            ),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  0,
                ),
                child: CenterOffersSection(),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.only(
                bottom: 120,
              ),
            ),
          ],
        );
      },
    );
  }

  AppointmentEntity? _getLatestAppointment(
      AppointmentsState state,
      ) {
    if (state is! AppointmentsLoaded) {
      return null;
    }

    if (state.upcomingAppointments.isEmpty) {
      return null;
    }

    final appointments = List<AppointmentEntity>.from(
      state.upcomingAppointments,
    );

    appointments.sort(
          (first, second) => second.id.compareTo(first.id),
    );

    return appointments.first;
  }
}