import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../models/appointments_store.dart';
import '../sections/appointments_header_section.dart';
import '../sections/appointments_list_section.dart';
import '../sections/appointments_tab_section.dart';
import '../widgets/appointments_empty_state_widget.dart';

class AppointmentsManagementScreen extends StatefulWidget {
  const AppointmentsManagementScreen({super.key});

  @override
  State<AppointmentsManagementScreen> createState() =>
      _AppointmentsManagementScreenState();
}

class _AppointmentsManagementScreenState
    extends State<AppointmentsManagementScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: AppointmentsStore.instance,
      builder: (context, _) {
        final upcomingAppointments =
            AppointmentsStore.instance.upcomingAppointments;

        final pastAppointments = AppointmentsStore.instance.pastAppointments;

        final displayedAppointments = _currentTabIndex == 0
            ? upcomingAppointments
            : pastAppointments;

        return Scaffold(
          backgroundColor: colors.background,
          body: SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                const AppointmentsHeaderSection(),

                const SizedBox(height: 20),

                AppointmentsTabSection(
                  upcomingCount: upcomingAppointments.length,
                  pastCount: pastAppointments.length,
                  currentTabIndex: _currentTabIndex,
                  onTabChanged: (index) {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                ),

                const SizedBox(height: 20),

                if (displayedAppointments.isEmpty)
                  AppointmentsEmptyStateWidget(
                    isUpcoming: _currentTabIndex == 0,
                  )
                else
                  AppointmentsListSection(appointments: displayedAppointments),
              ],
            ),
          ),
        );
      },
    );
  }
}
