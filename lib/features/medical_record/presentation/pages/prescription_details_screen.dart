import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../medical_record_di.dart';
import '../../domain/entities/prescription_entity.dart';
import '../utils/medical_record_accent.dart';
import '../widgets/medical_record_empty_state.dart';

class PrescriptionDetailsScreen extends StatefulWidget {
  final String prescriptionId;

  const PrescriptionDetailsScreen({
    super.key,
    required this.prescriptionId,
  });

  @override
  State<PrescriptionDetailsScreen> createState() =>
      _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  PrescriptionEntity? _prescription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrescription();
  }

  Future<void> _loadPrescription() async {
    final prescription = await MedicalRecordDi.getPrescriptionByIdUseCase(
      widget.prescriptionId,
    );
    if (!mounted) return;
    setState(() {
      _prescription = prescription;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(title: 'تفاصيل الوصفة'),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_prescription == null)
                  ? const Padding(
                padding: EdgeInsets.all(20),
                child: MedicalRecordEmptyState(
                  title: 'تعذر تحميل تفاصيل الوصفة',
                  subtitle: 'حاولي مرة أخرى بعد قليل.',
                  icon: Icons.medication_outlined,
                ),
              )
                  : _PrescriptionDetailsBody(prescription: _prescription!),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrescriptionDetailsBody extends StatelessWidget {
  final PrescriptionEntity prescription;

  const _PrescriptionDetailsBody({
    required this.prescription,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final blue = context.medicalAccent;

    Widget row(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: colors.surfaceMuted,
            border: Border.all(
              color: colors.borderSoft,
            ),
          ),
          child: Column(
            children: [
              Text(
                prescription.visualEmoji,
                style: const TextStyle(fontSize: 46),
              ),
              const SizedBox(height: 10),
              Text(
                prescription.medicineName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                prescription.concentration,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Column(
            children: [
              row('الجرعة', prescription.dosage),
              const Divider(height: 1),
              row('طريقة الاستخدام', prescription.instructions),
              const Divider(height: 1),
              row('المدة', prescription.duration),
              const Divider(height: 1),
              row('تاريخ الإصدار', prescription.prescribedAtLabel),
              const Divider(height: 1),
              row('الطبيب', prescription.doctorName),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.surfaceSecondary,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.borderSoft,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تعليمات إضافية',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                prescription.notes,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  height: 1.7,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
