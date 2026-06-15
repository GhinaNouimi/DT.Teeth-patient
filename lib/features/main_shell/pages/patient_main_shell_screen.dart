import 'package:flutter/material.dart';

import '../../appointments/presentaion/pages/appointments_management_screen.dart';
import '../../doctors/presentation/pages/doctors_screen.dart';
import '../../home/pages/patient_home_screen.dart';
import '../../home/widgets/patient_bottom_nav_bar.dart';
import '../../medical_record/presentation/pages/medical_record_home_screen.dart';
import '../../profile/presentation/pages/profile_screen.dart';

class PatientMainShellScreen extends StatefulWidget {
  const PatientMainShellScreen({super.key});

  @override
  State<PatientMainShellScreen> createState() => _PatientMainShellScreenState();
}

class _PatientMainShellScreenState extends State<PatientMainShellScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages = const [
    PatientHomeScreen(),
    DoctorsScreen(),
    AppointmentsManagementScreen(),
    MedicalRecordHomeScreen(),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

