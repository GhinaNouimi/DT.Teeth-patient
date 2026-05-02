import 'package:flutter/material.dart';

import '../../doctors/presentation/pages/doctors_screen.dart';
import '../../home/pages/patient_home_screen.dart';
import '../../home/widgets/patient_bottom_nav_bar.dart';


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
    // AppointmentsScreen(),
    // MedicalRecordScreen(),
    // ProfileScreen(),
  ];

  void _onTap(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
