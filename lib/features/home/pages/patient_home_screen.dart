import 'package:flutter/material.dart';

import '../sections/center_address_section.dart';
import '../sections/center_offers_section.dart';
import '../sections/next_appointment_section.dart';
import '../sections/patient_home_app_bar_section.dart';
import '../sections/quick_actions_section.dart';
import '../sections/services_section.dart';
import '../sections/specialties_section.dart';
import '../widgets/patient_bottom_nav_bar.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
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
                slivers: const [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: NextAppointmentSection(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: QuickActionsSection(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: SpecialtiesSection(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: CenterOffersSection(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: ServicesSection(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
                      child: CenterAddressSection(),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 110),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
