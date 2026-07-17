import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../appointments/appointments_di.dart';
import '../../appointments/presentaion/bloc/appointments/appointments_bloc.dart';
import '../../appointments/presentaion/bloc/appointments/appointments_event.dart';
import '../../appointments/presentaion/pages/appointments_management_screen.dart';
import '../../doctors/presentation/pages/doctors_screen.dart';
import '../../home/pages/patient_home_screen.dart';
import '../../home/sections/patient_home_app_bar_section.dart';
import '../../home/widgets/patient_bottom_nav_bar.dart';
import '../../medical_record/presentation/pages/medical_record_home_screen.dart';
import '../../profile/presentation/pages/profile_screen.dart';


class PatientMainShellScreen extends StatelessWidget {
  const PatientMainShellScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => AppointmentsBloc(
        showAppointmentsUseCase:
        AppointmentsDi.showAppointmentsUseCase,
        showPreviousAppointmentsUseCase:
        AppointmentsDi.showPreviousAppointmentsUseCase,
        cancelAppointmentUseCase:
        AppointmentsDi.cancelAppointmentUseCase,
      )..add(
        LoadAppointmentsRequested(
          languageCode: languageCode,
        ),
      ),
      child: const _PatientMainShellView(),
    );
  }
}

class _PatientMainShellView extends StatefulWidget {
  const _PatientMainShellView();

  @override
  State<_PatientMainShellView> createState() =>
      _PatientMainShellViewState();
}

class _PatientMainShellViewState
    extends State<_PatientMainShellView> {
  int _currentIndex = 0;

  late final List<Widget> _pages = const [
    PatientHomeScreen(),
    DoctorsScreen(),
    AppointmentsManagementScreen(),
    MedicalRecordHomeScreen(),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
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
              padding: EdgeInsetsDirectional.fromSTEB(
                20,
                16,
                20,
                0,
              ),
              child: PatientHomeAppBarSection(),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}