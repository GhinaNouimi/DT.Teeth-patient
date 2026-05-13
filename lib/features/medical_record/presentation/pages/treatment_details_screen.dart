import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../medical_record_di.dart';
import '../../domain/entities/treatment_entity.dart';
import '../utils/medical_record_accent.dart';
import '../widgets/medical_record_empty_state.dart';
import '../widgets/treatment_progress_ring.dart';
import '../widgets/treatment_status_chip.dart';
import '../widgets/treatment_timeline_tile.dart';

class TreatmentDetailsScreen extends StatefulWidget {
  final String treatmentId;

  const TreatmentDetailsScreen({
    super.key,
    required this.treatmentId,
  });

  @override
  State<TreatmentDetailsScreen> createState() => _TreatmentDetailsScreenState();
}

class _TreatmentDetailsScreenState extends State<TreatmentDetailsScreen> {
  TreatmentEntity? _treatment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTreatment();
  }

  Future<void> _loadTreatment() async {
    final treatment = await MedicalRecordDi.getTreatmentByIdUseCase(
      widget.treatmentId,
    );

    if (!mounted) return;
    setState(() {
      _treatment = treatment;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(title: 'تفاصيل العلاج'),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_treatment == null)
                  ? const Padding(
                padding: EdgeInsets.all(20),
                child: MedicalRecordEmptyState(
                  title: 'لم نعثر على تفاصيل العلاج',
                  subtitle:
                  'قد تكون البيانات غير متاحة حاليًا، حاول مرة أخرى لاحقًا.',
                  icon: Icons.error_outline_rounded,
                ),
              )
                  : _TreatmentDetailsBody(treatment: _treatment!),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreatmentDetailsBody extends StatelessWidget {
  final TreatmentEntity treatment;

  const _TreatmentDetailsBody({
    required this.treatment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final blue = context.medicalAccent;
    final pinkSoft = context.medicalPinkSoft;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: colors.borderSoft,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatment.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      treatment.doctorName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TreatmentStatusChip(
                      status: treatment.status,
                      label: treatment.statusLabel,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'بدأ العلاج: ${treatment.startedAtLabel}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              TreatmentProgressRing(
                percent: treatment.progressPercent,
                size: 86,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _InfoGrid(treatment: treatment),
        const SizedBox(height: 20),
        _SectionCard(
          title: 'الرحلة العلاجية',
          child: Column(
            children: List.generate(
              treatment.timeline.length,
                  (index) => TreatmentTimelineTile(
                step: treatment.timeline[index],
                isLast: index == treatment.timeline.length - 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionCard(
          title: 'المواعيد المرتبطة بالعلاج',
          trailingText: 'حجز متابعة',
          child: Column(
            children: treatment.relatedAppointments.map((appointment) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: pinkSoft.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colors.borderSoft,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      appointment.isUpcoming
                          ? Icons.upcoming_rounded
                          : Icons.check_circle_rounded,
                      color: appointment.isUpcoming ? blue : colors.success,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${appointment.dateLabel} - ${appointment.timeLabel}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        _TextListSection(
          title: 'الإجراءات المنفذة',
          items: treatment.completedProcedures,
        ),
        const SizedBox(height: 20),
        _TextListSection(
          title: 'إرشادات العناية',
          items: treatment.careInstructions,
        ),
        const SizedBox(height: 20),
        _TextListSection(
          title: 'ملاحظات الطبيب',
          items: treatment.doctorNotes,
          footer: InkWell(
            onTap: () {
              context.push(
                AppRoutes.medicalRecordAttachments,
                extra: treatment.id,
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_file_rounded,
                    color: blue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'الملفات والمرفقات: ${treatment.attachmentsCount} عناصر مرتبطة بهذا العلاج.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    'عرض',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final TreatmentEntity treatment;

  const _InfoGrid({
    required this.treatment,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    Widget tile(String label, String value) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        tile('التقدم الحالي', treatment.progressLabel),
        const SizedBox(height: 12),
        tile(
          'الجلسة القادمة',
          treatment.nextSessionLabel ?? 'لا توجد جلسات مجدولة',
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? trailingText;
  final Widget child;

  const _SectionCard({
    required this.title,
    this.trailingText,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final blue = context.medicalAccent;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (trailingText != null)
                Text(
                  trailingText!,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: blue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _TextListSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Widget? footer;

  const _TextListSection({
    required this.title,
    required this.items,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final blue = context.medicalAccent;

    return _SectionCard(
      title: title,
      child: Column(
        children: [
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 20,
                    color: blue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: 4),
            footer!,
          ],
        ],
      ),
    );
  }
}
