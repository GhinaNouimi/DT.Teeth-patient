import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';
import '../../domain/entities/prescription/prescription_entity.dart';
import '../../domain/entities/treatment/treatment_entity.dart';
import '../../domain/entities/treatment/treatment_session_entity.dart';
import '../../medical_record_di.dart';
import '../utils/medical_record_accent.dart';
import '../widgets/medical_record_category_card.dart';
import '../widgets/treatment_progress_ring.dart';
import '../widgets/treatment_status_chip.dart';

class MedicalRecordHomeScreen extends StatefulWidget {
  const MedicalRecordHomeScreen({super.key});

  @override
  State<MedicalRecordHomeScreen> createState() =>
      _MedicalRecordHomeScreenState();
}

class _MedicalRecordHomeScreenState extends State<MedicalRecordHomeScreen> {
  List<TreatmentEntity> _treatments = const [];
  List<PrescriptionEntity> _prescriptions = const [];

  bool _isLoading = true;
  bool _isFromCache = false;
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didLoad) return;
    _didLoad = true;

    _loadMedicalRecord(
      Localizations.localeOf(context).languageCode,
    );
  }

  Future<void> _loadMedicalRecord(String languageCode) async {
    try {
      final treatmentsResult = await MedicalRecordDi.getAllTreatmentsUseCase(
        languageCode: languageCode,
      );

      final prescriptionsResult =
      await MedicalRecordDi.getAllPrescriptionsUseCase(
        languageCode: languageCode,
      );

      if (!mounted) return;

      setState(() {
        _treatments = treatmentsResult.data;
        _prescriptions = prescriptionsResult.data;
        _isFromCache =
            treatmentsResult.isFromCache || prescriptionsResult.isFromCache;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('🟥 Medical record home error: $error');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  String _t(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context)
        .languageCode
        .toLowerCase()
        .startsWith('ar')
        ? ar
        : en;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final activeTreatments =
    _treatments.where((treatment) => treatment.isActive).toList();

    final completedTreatments =
    _treatments.where((treatment) => treatment.isCompleted).toList();

    final featuredTreatment = activeTreatments.isNotEmpty
        ? activeTreatments.first
        : _treatments.isNotEmpty
        ? _treatments.first
        : null;

    final lastSession = _findLastSession();

    final totalSessions = _treatments.fold<int>(
      0,
          (total, treatment) => total + treatment.sessions.length,
    );

    final treatedTeethCount = _treatments.fold<int>(
      0,
          (total, treatment) {
        return total +
            treatment.sessions.fold<int>(
              0,
                  (sessionTotal, session) =>
              sessionTotal + session.toothTreatments.length,
            );
      },
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: AppSkeleton(
          enabled: _isLoading,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 3, 20, 120),
            children: [
              const SizedBox(height: 16),

              if (_isFromCache) ...[
                OfflineCachedBanner(
                  message: l10n.offlineCachedDataMessage,
                ),
                const SizedBox(height: 16),
              ],

              if (featuredTreatment != null)
                _FeaturedTreatmentCard(
                  treatment: featuredTreatment,
                  title: activeTreatments.isNotEmpty
                      ? _t(context, 'علاجي الحالي', 'Current Treatment')
                      : _t(context, 'آخر علاج', 'Latest Treatment'),
                )
              else
                _EmptyMedicalRecordCard(
                  title: _t(
                    context,
                    'لا توجد علاجات بعد',
                    'No treatments yet',
                  ),
                  subtitle: _t(
                    context,
                    'ستظهر خطة العلاج هنا بعد إضافتها من الطبيب.',
                    'Your treatment plan will appear here after your dentist adds it.',
                  ),
                ),

              const SizedBox(height: 12),

              MedicalRecordCategoryCard(
                title: _t(context, 'علاجاتي', 'Treatments'),
                subtitle: _t(
                  context,
                  '${_treatments.length} علاج • $totalSessions جلسات',
                  '${_treatments.length} treatments • $totalSessions sessions',
                ),
                icon: Icons.medical_information_outlined,
                isPrimary: true,
                onTap: () {
                  context.push(AppRoutes.medicalRecordTreatments);
                },
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: MedicalRecordCategoryCard(
                      title: l10n.prescriptions,
                      subtitle: _prescriptions.isEmpty
                          ? _t(context, 'لا توجد وصفات', 'No prescriptions')
                          : _t(
                        context,
                        '${_prescriptions.length} وصفات',
                        '${_prescriptions.length} prescriptions',
                      ),
                      icon: Icons.receipt_long_rounded,
                      onTap: () {
                        context.push(AppRoutes.medicalRecordPrescriptions);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MedicalRecordCategoryCard(
                      title: l10n.payments,
                      subtitle: l10n.financialSummary,
                      icon: Icons.wallet_rounded,
                      onTap: () {
                        context.push(
                          AppRoutes.medicalRecordPayments,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _OverviewPanel(
                treatmentsCount: _treatments.length,
                sessionsCount: totalSessions,
                treatedTeethCount: treatedTeethCount,
                completedCount: completedTreatments.length,
              ),

              if (lastSession != null) ...[
                const SizedBox(height: 24),
                _LastSessionCard(session: lastSession),
              ],
            ],
          ),
        ),
      ),
    );
  }

  TreatmentSessionEntity? _findLastSession() {
    final sessions = _treatments
        .expand((treatment) => treatment.sessions)
        .where((session) => session.actualStartTime != null)
        .toList();

    if (sessions.isEmpty) return null;

    sessions.sort(
          (a, b) => (b.actualStartTime ?? '').compareTo(a.actualStartTime ?? ''),
    );

    return sessions.first;
  }
}

class _FeaturedTreatmentCard extends StatelessWidget {
  final TreatmentEntity treatment;
  final String title;

  const _FeaturedTreatmentCard({
    required this.treatment,
    required this.title,
  });

  int get progressPercent {
    if (treatment.totalSessionsNeeded == 0) return 0;

    return ((treatment.sessionsCompleted / treatment.totalSessionsNeeded) * 100)
        .round()
        .clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;

    final treatmentName = treatment.treatmentType.localizedName(languageCode);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TreatmentStatusChip(status: treatment.status),
              const Spacer(),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatmentName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      treatment.dentist.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.completedSessions(
                        treatment.sessionsCompleted,
                        treatment.totalSessionsNeeded,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              TreatmentProgressRing(
                percent: progressPercent,
                size: 82,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                context.push(
                  AppRoutes.medicalRecordTreatmentDetails,
                  extra: treatment.id,
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              label: Text(
                Localizations.localeOf(context).languageCode.startsWith('ar')
                    ? 'عرض تفاصيل العلاج'
                    : 'View treatment details',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewPanel extends StatelessWidget {
  final int treatmentsCount;
  final int sessionsCount;
  final int treatedTeethCount;
  final int completedCount;

  const _OverviewPanel({
    required this.treatmentsCount,
    required this.sessionsCount,
    required this.treatedTeethCount,
    required this.completedCount,
  });

  String _t(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode.startsWith('ar')
        ? ar
        : en;
  }

  @override
  Widget build(BuildContext context) {
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
              label: _t(context, 'العلاجات', 'Treatments'),
              value: '$treatmentsCount',
              icon: Icons.medical_information_outlined,
            ),
          ),
          Container(width: 1, height: 54, color: colors.borderSoft),
          Expanded(
            child: _OverviewStat(
              label: _t(context, 'الجلسات', 'Sessions'),
              value: '$sessionsCount',
              icon: Icons.event_note_rounded,
            ),
          ),
          Container(width: 1, height: 54, color: colors.borderSoft),
          Expanded(
            child: _OverviewStat(
              label: _t(context, 'الأسنان', 'Teeth'),
              value: '$treatedTeethCount',
              icon: Icons.auto_awesome_rounded,
            ),
          ),
          Container(width: 1, height: 54, color: colors.borderSoft),
          Expanded(
            child: _OverviewStat(
              label: _t(context, 'مكتملة', 'Done'),
              value: '$completedCount',
              icon: Icons.task_alt_rounded,
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
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LastSessionCard extends StatelessWidget {
  final TreatmentSessionEntity session;

  const _LastSessionCard({
    required this.session,
  });

  String _t(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode.startsWith('ar')
        ? ar
        : en;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final languageCode = Localizations.localeOf(context).languageCode;

    final firstProcedure = session.toothTreatments.isNotEmpty
        ? session.toothTreatments.first.procedure.localizedName(languageCode)
        : _t(context, 'لا يوجد إجراء محدد', 'No procedure');

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
          Text(
            _t(context, 'آخر جلسة', 'Last Session'),
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.event_available_rounded, color: context.medicalAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _t(
                    context,
                    'الجلسة رقم ${session.sessionNumber}',
                    'Session #${session.sessionNumber}',
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TreatmentStatusChip(status: session.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            session.actualStartTime ?? '-',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            firstProcedure,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${_t(context, 'تكلفة الجلسة', 'Session cost')}: ${session.sessionCost}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMedicalRecordCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyMedicalRecordCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        children: [
          Icon(
            Icons.medical_information_outlined,
            size: 42,
            color: context.medicalAccent,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}