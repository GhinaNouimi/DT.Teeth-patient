import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/rating_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../models/doctor_ui_model.dart';
import '../sections/doctor_about_section.dart';
import '../sections/doctor_contact_section.dart';
import '../sections/doctor_credentials_section.dart';
import '../sections/doctor_info_cards_section.dart';
import '../sections/doctor_profile_header_section.dart';
import '../sections/doctor_ratings_section.dart';

class DoctorProfileScreen extends StatefulWidget {
  final DoctorUiModel doctor;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  double _userRating = 0;

  void _updateRating(double rating) {
    setState(() {
      _userRating = rating;
    });
  }

  void _resetRating() {
    setState(() {
      _userRating = 0;
    });
  }

  void _showPhoneSnackBar(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('الرقم: $phone')),
    );
  }

  void _showRatingSheet(String doctorName) {
    showRatingBottomSheet(
      context,
      doctorName: doctorName,
      rating: _userRating,
      buttonText: 'حسناً',
      onPressed: _resetRating,
    );
  }

  void _goToBooking(DoctorUiModel doctor) {
    context.push(
      AppRoutes.booking,
      extra: doctor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final doctor = widget.doctor;

    return Scaffold(

      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            AppTopBar(
              title: 'ملف الطبيب',
              onBackTap: () => context.pop(),
            ),
            const SizedBox(height: 20),
            DoctorProfileHeaderSection(doctor: doctor),
            const SizedBox(height: 24),
            DoctorAboutSection(
              bio: doctor.bio,
              colors: colors,
              theme: theme,
            ),
            const SizedBox(height: 24),
            DoctorInfoCardsSection(
              yearsOfExperience: doctor.yearsOfExperience,
              treatedPatients: doctor.treatedPatients,
              colors: colors,
              theme: theme,
            ),
            const SizedBox(height: 20),
            DoctorCredentialsSection(
              graduation: doctor.graduation,
              certificates: doctor.certificates,
            ),
            const SizedBox(height: 20),
            DoctorContactSection(
              phone: doctor.phone,
              colors: colors,
              theme: theme,
              onPhoneTap: () => _showPhoneSnackBar(doctor.phone),
            ),
            const SizedBox(height: 20),
            DoctorRatingsSection(
              doctor: doctor,
              userRating: _userRating,
              onRatingChanged: _updateRating,
              onSubmitRating: () => _showRatingSheet(doctor.name),
              colors: colors,
              theme: theme,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _goToBooking(doctor),
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('احجز موعد الآن'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
