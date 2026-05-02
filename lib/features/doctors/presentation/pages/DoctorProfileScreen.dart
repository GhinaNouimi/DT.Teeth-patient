import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../models/doctor_ui_model.dart';
import '../sections/doctor_profile_about_section.dart';
import '../sections/doctor_profile_actions_section.dart';
import '../sections/doctor_profile_contact_section.dart';
import '../sections/doctor_profile_header_section.dart';

class DoctorProfileScreen extends StatelessWidget {
  final DoctorUiModel doctor;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const AppTopBar(title: 'ملف الطبيب'),
            const SizedBox(height: 18),
            DoctorProfileHeaderSection(doctor: doctor),
            const SizedBox(height: 16),
            DoctorProfileAboutSection(doctor: doctor),
            const SizedBox(height: 16),
            DoctorProfileContactSection(doctor: doctor),
            const SizedBox(height: 20),
            DoctorProfileActionsSection(
              onBookNow: () {
                context.push(
                  AppRoutes.bookDoctorAppointment,
                  extra: doctor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
