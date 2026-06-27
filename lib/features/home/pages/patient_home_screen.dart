import 'package:flutter/material.dart';

import '../../appointments/presentaion/models/mock_appointments_data.dart';
import '../../appointments/presentaion/sections/next_appointment_section.dart';
import '../sections/center_offers_section.dart';
import '../sections/patient_welcome_hero_section.dart';
import '../sections/quick_actions_section.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nextAppointment = MockAppointmentsData.getNextAppointment();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: PatientWelcomeHeroSection(),
          ),
        ),

        if (nextAppointment != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: NextAppointmentSection(
                appointment: nextAppointment,
              ),
            ),
          ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: QuickActionsSection(),
          ),
        ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: CenterOffersSection(),
          ),
        ),

        const SliverPadding(
          padding: EdgeInsets.only(bottom: 120),
        ),
      ],
    );
  }
}