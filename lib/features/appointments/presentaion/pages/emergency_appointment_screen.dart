import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';

import '../models/appointment_status.dart';
import '../models/appointment_type.dart';
import '../models/appointment_ui_model.dart';
import '../models/appointments_store.dart';
import '../models/mock_appointments_data.dart';
import '../models/service_type.dart';

class EmergencyAppointmentScreen extends StatefulWidget {
  const EmergencyAppointmentScreen({super.key});

  @override
  State<EmergencyAppointmentScreen> createState() =>
      _EmergencyAppointmentScreenState();
}

class _EmergencyAppointmentScreenState
    extends State<EmergencyAppointmentScreen> {
  final TextEditingController _problemController = TextEditingController();

  bool _requiresCall = false;

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  Future<void> _callClinic() async {
    final Uri uri = Uri(scheme: 'tel', path: '+31234567890');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // void _submitEmergencyRequest() {
  //   final doctor = MockAppointmentsData.getDoctorsByService(
  //     ServiceType.emergency,
  //   ).first;
  //
  //   final appointment = AppointmentUiModel(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //
  //     doctor: doctor,
  //
  //     appointmentDate: DateTime.now(),
  //
  //     appointmentTime: 'أقرب وقت متاح',
  //
  //     type: AppointmentType.emergency,
  //
  //     service: ServiceType.emergency,
  //
  //     status: AppointmentStatus.pending,
  //
  //     patientNotes: _problemController.text.trim(),
  //
  //     doctorNotes: 'سيتم التواصل معك وتحديد أقرب موعد متاح.',
  //
  //     emergencyDescription: _problemController.text.trim(),
  //
  //     requiresCall: _requiresCall,
  //
  //     location: 'عيادة DT.Teeth',
  //
  //     durationMinutes: 30,
  //
  //     createdAt: DateTime.now(),
  //   );
  //
  //   AppointmentsStore.instance.addAppointment(appointment);
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('تم إرسال طلب الطوارئ بنجاح.')),
  //   );
  //
  //   context.pop();
  // }

  bool get _canSubmit {
    return _problemController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.background,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),

          children: [
            const AppTopBar(title: 'حالة طارئة'),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: colors.danger.withValues(alpha: 0.08),

                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: colors.danger.withValues(alpha: 0.18),
                ),
              ),

              child: Text(
                'إذا كان هناك نزيف شديد أو تورم خطير يرجى التواصل مباشرة مع العيادة.',

                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textPrimary,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'ما المشكلة؟',

              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _problemController,

              maxLines: 5,

              decoration: InputDecoration(
                hintText: 'اشرح الحالة أو الألم الذي تعاني منه',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SwitchListTile(
              value: _requiresCall,

              onChanged: (value) {
                setState(() {
                  _requiresCall = value;
                });
              },

              title: const Text('أحتاج اتصال مباشر من العيادة'),

              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton.icon(
                onPressed: _callClinic,

                icon: const Icon(Icons.call_rounded),

                label: const Text('اتصال مباشر بالعيادة'),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,

              // child: ElevatedButton.icon(
              //   onPressed: _canSubmit ? _submitEmergencyRequest : null,
              //
              //   icon: const Icon(Icons.emergency_rounded),
              //
              //   label: const Text('طلب أقرب موعد فوري'),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
