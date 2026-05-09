import 'package:flutter/material.dart';


import '../../appointments/presentaion/models/mock_appointments_data.dart';
import '../../appointments/presentaion/sections/next_appointment_section.dart';
import '../sections/center_address_section.dart';
import '../sections/center_offers_section.dart';
import '../sections/patient_home_app_bar_section.dart';
import '../sections/quick_actions_section.dart';
import '../sections/services_section.dart';
import '../sections/specialties_section.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nextAppointment = MockAppointmentsData.getNextAppointment();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: PatientHomeAppBarSection(),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                if (nextAppointment != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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

                // const SliverToBoxAdapter(
                //   child: Padding(
                //     padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                //     child: SpecialtiesSection(),
                //   ),
                // ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: CenterOffersSection(),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: ServicesSection(),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: CenterAddressSection(),
                  ),
                ),

                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 110),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}