import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../appointments/presentaion/pages/appointments_management_screen.dart';
import '../../doctors/presentation/pages/doctors_screen.dart';
import '../../home/pages/patient_home_screen.dart';
import '../../home/widgets/patient_bottom_nav_bar.dart';

class PatientMainShellScreen extends StatefulWidget {
  final int initialIndex;

  const PatientMainShellScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<PatientMainShellScreen> createState() =>
      _PatientMainShellScreenState();
}

class _PatientMainShellScreenState
    extends State<PatientMainShellScreen> {
  late int _currentIndex;

  late final List<Widget> _pages = const [
    PatientHomeScreen(),
    DoctorsScreen(),
    AppointmentsManagementScreen(),
    _ComingSoonScreen(title: 'ملفي الطبي'),
    _ComingSoonScreen(title: 'حسابي'),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(
      covariant PatientMainShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        _currentIndex = widget.initialIndex;
      });
    }
  }

  void _onTap(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,

      floatingActionButton: _currentIndex == 2
          ? Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: FloatingActionButton.extended(
          elevation: 8,
          onPressed: () {
            context.push(AppRoutes.newAppointment);
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'حجز موعد جديد',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      )
          : null,

      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

class _ComingSoonScreen extends StatelessWidget {
  final String title;

  const _ComingSoonScreen({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}