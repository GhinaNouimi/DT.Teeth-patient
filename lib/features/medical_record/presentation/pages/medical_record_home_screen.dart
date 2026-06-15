import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../medical_record_di.dart';
import '../../domain/entities/payment_plan_entity.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/entities/treatment_entity.dart';
import '../sections/medical_record_header_section.dart';
import '../widgets/medical_record_category_card.dart';
import '../widgets/treatment_card.dart';

class MedicalRecordHomeScreen extends StatefulWidget {
  const MedicalRecordHomeScreen({super.key});

  @override
  State<MedicalRecordHomeScreen> createState() =>
      _MedicalRecordHomeScreenState();
}

class _MedicalRecordHomeScreenState extends State<MedicalRecordHomeScreen> {
  List<TreatmentEntity> _treatments = const [];
  List<PrescriptionEntity> _prescriptions = const [];
  PaymentPlanEntity? _paymentPlan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTreatments();
  }

  Future<void> _loadTreatments() async {
    final results = await Future.wait([
      MedicalRecordDi.getTreatmentsUseCase(),
      MedicalRecordDi.getPrescriptionsUseCase(),
      MedicalRecordDi.getPaymentPlanUseCase(),
    ]);

    final treatments = results[0] as List<TreatmentEntity>;
    final prescriptions = results[1] as List<PrescriptionEntity>;
    final paymentPlan = results[2] as PaymentPlanEntity?;

    if (!mounted) return;
    setState(() {
      _treatments = treatments;
      _prescriptions = prescriptions;
      _paymentPlan = paymentPlan;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final activeTreatments = _treatments
        .where((treatment) => treatment.isActive)
        .toList();
    final completedTreatments = _treatments
        .where((treatment) => treatment.isCompleted)
        .toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child:
              MedicalRecordHeaderSection(
                title: 'الملف الطبي',
                subtitle:
                    'تابع رحلة علاجك، مواعيد الجلسات، والملاحظات الطبية من مكان واحد.',
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                      children: [
                        const SizedBox(height: 16),

                        MedicalRecordCategoryCard(
                          title: 'علاجاتي',
                          subtitle: '${activeTreatments.length} حالات نشطة',
                          icon: Icons.medical_information_outlined,
                          isPrimary: true,
                          onTap: () =>
                              context.push(AppRoutes.medicalRecordTreatments),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: MedicalRecordCategoryCard(
                                title: 'وصفات',
                                subtitle:
                                    '${_prescriptions.where((item) => item.isActive).length} حالية',
                                icon: Icons.receipt_long_rounded,
                                onTap: () => context.push(
                                  AppRoutes.medicalRecordPrescriptions,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MedicalRecordCategoryCard(
                                title: 'دفعات',
                                subtitle:
                                    _paymentPlan?.remainingAmountLabel ??
                                    'بدون بيانات',
                                icon: Icons.wallet_rounded,
                                onTap: () => context.push(
                                  AppRoutes.medicalRecordPayments,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _OverviewPanel(
                          activeCount: activeTreatments.length,
                          completedCount: completedTreatments.length,
                          attachmentsCount: _treatments.fold<int>(
                            0,
                            (total, item) => total + item.attachmentsCount,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'علاجاتي الحالية',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push(AppRoutes.medicalRecordTreatments);
                              },
                              child: const Text('عرض الكل'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ...activeTreatments
                            .take(2)
                            .map(
                              (treatment) => Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: TreatmentCard(
                                  treatment: treatment,
                                  onTap: () {
                                    context.push(
                                      AppRoutes.medicalRecordTreatmentDetails,
                                      extra: treatment.id,
                                    );
                                  },
                                ),
                              ),
                            ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewPanel extends StatelessWidget {
  final int activeCount;
  final int completedCount;
  final int attachmentsCount;

  const _OverviewPanel({
    required this.activeCount,
    required this.completedCount,
    required this.attachmentsCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Row(
        children: [
          Expanded(
            child: _OverviewStat(
              label: 'علاجات نشطة',
              value: '$activeCount',
              icon: Icons.bolt_rounded,
            ),
          ),
          Container(width: 1, height: 54, color: colors.borderSoft),
          Expanded(
            child: _OverviewStat(
              label: 'علاجات مكتملة',
              value: '$completedCount',
              icon: Icons.task_alt_rounded,
            ),
          ),
          Container(width: 1, height: 54, color: colors.borderSoft),
          Expanded(
            child: _OverviewStat(
              label: 'مرفقات',
              value: '$attachmentsCount',
              icon: Icons.perm_media_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _OverviewStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 10),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
