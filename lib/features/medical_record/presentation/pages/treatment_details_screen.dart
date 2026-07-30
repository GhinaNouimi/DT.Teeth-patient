import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/treatment/tooth_treatment_entity.dart';
import '../../domain/entities/treatment/treatment_dentist_entity.dart';
import '../../domain/entities/treatment/treatment_entity.dart';
import '../../domain/entities/treatment/treatment_procedure_entity.dart';
import '../../domain/entities/treatment/treatment_session_entity.dart';
import '../../domain/entities/treatment/treatment_type_entity.dart';
import '../../medical_record_di.dart';
import '../bloc/treatment/treatment_bloc.dart';
import '../bloc/treatment/treatment_event.dart';
import '../bloc/treatment/treatment_state.dart';
import '../utils/medical_record_accent.dart';
import '../widgets/medical_record_empty_state.dart';
import '../widgets/treatment_progress_ring.dart';
import '../widgets/treatment_status_chip.dart';

class TreatmentDetailsScreen extends StatelessWidget {
  final int treatmentId;

  const TreatmentDetailsScreen({
    super.key,
    required this.treatmentId,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => TreatmentBloc(
        getAllTreatmentsUseCase:
        MedicalRecordDi.getAllTreatmentsUseCase,
        getTreatmentDetailsUseCase:
        MedicalRecordDi.getTreatmentDetailsUseCase,
      )..add(
        LoadTreatmentDetailsRequested(
          treatmentId: treatmentId,
          languageCode: languageCode,
        ),
      ),
      child: const _TreatmentDetailsView(),
    );
  }
}

class _TreatmentDetailsView extends StatelessWidget {
  const _TreatmentDetailsView();

  TreatmentEntity _fakeTreatment() {
    return const TreatmentEntity(
      id: 0,
      treatmentType: TreatmentTypeEntity(
        id: 0,
        name: 'اسم العلاج',
        nameEn: 'Treatment name',
      ),
      dentist: TreatmentDentistEntity(
        id: 0,
        name: 'Doctor name',
      ),
      status: 'ongoing',
      totalSessionsNeeded: 2,
      sessionsCompleted: 1,
      notes: 'Treatment notes',
      createdAt: '2026-07-08',
      sessions: [
        TreatmentSessionEntity(
          id: 0,
          treatmentId: 0,
          sessionNumber: 1,
          status: 'completed',
          actualStartTime: '2026-05-20 12:30:00',
          actualEndTime: '2026-05-20 13:04:00',
          notes: 'Session notes',
          sessionCost: 120000,
          toothTreatments: [
            ToothTreatmentEntity(
              id: 0,
              toothNumber: 23,
              procedure: TreatmentProcedureEntity(
                id: 0,
                name: 'إجراء علاجي',
                nameEn: 'Dental procedure',
                price: '120000.00',
              ),
              notes: 'Procedure notes',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                0,
              ),
              child: AppTopBar(
                title: l10n.treatmentDetails,
              ),
            ),
            Expanded(
              child: BlocBuilder<TreatmentBloc, TreatmentState>(
                builder: (context, state) {
                  final isLoading =
                      state is TreatmentInitial ||
                          state is TreatmentLoading;

                  if (state is TreatmentFailure) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: MedicalRecordEmptyState(
                        title:
                        l10n.treatmentDetailsLoadFailed,
                        subtitle: state.message,
                        icon:
                        Icons.medical_services_outlined,
                      ),
                    );
                  }

                  final treatment =
                  state is TreatmentDetailsLoaded
                      ? state.treatment
                      : _fakeTreatment();

                  final isFromCache =
                      state is TreatmentDetailsLoaded &&
                          state.isFromCache;

                  return AppSkeleton(
                    enabled: isLoading,
                    child: _TreatmentDetailsBody(
                      treatment: treatment,
                      isFromCache: isFromCache,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreatmentDetailsBody extends StatelessWidget {
  final TreatmentEntity treatment;
  final bool isFromCache;

  const _TreatmentDetailsBody({
    required this.treatment,
    required this.isFromCache,
  });

  int get _progressPercent {
    if (treatment.totalSessionsNeeded == 0) {
      return 0;
    }

    return ((treatment.sessionsCompleted /
        treatment.totalSessionsNeeded) *
        100)
        .round()
        .clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final languageCode =
        Localizations.localeOf(context).languageCode;

    final treatmentName =
    treatment.treatmentType.localizedName(
      languageCode,
    );

    final progressLabel = treatment.isCancelled
        ? l10n.progressBeforeCancellation
        : l10n.currentProgress;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        32,
      ),
      children: [
        if (isFromCache) ...[
          OfflineCachedBanner(
            message: l10n.offlineCachedDataMessage,
          ),
          const SizedBox(height: 16),
        ],

        _TreatmentHeaderCard(
          treatment: treatment,
          treatmentName: treatmentName,
          progressPercent: _progressPercent,
        ),

        const SizedBox(height: 16),

        _TreatmentOverviewCard(
          progressLabel: progressLabel,
          completedSessions: l10n.completedSessions(
            treatment.sessionsCompleted,
            treatment.totalSessionsNeeded,
          ),
          notes: (treatment.notes ?? '').trim().isEmpty
              ? l10n.noNotes
              : treatment.notes!,
        ),

        const SizedBox(height: 16),

        _TreatmentInvoiceActionCard(
          onTap: () {
            context.push(
              AppRoutes.medicalRecordTreatmentInvoice,
              extra: treatment.id,
            );
          },
        ),

        const SizedBox(height: 26),

        _SectionHeader(
          title: l10n.treatmentSessions,
          icon: Icons.event_note_rounded,
        ),

        const SizedBox(height: 12),

        if (treatment.sessions.isEmpty)
          MedicalRecordEmptyState(
            title: l10n.noTreatmentSessionsTitle,
            subtitle: l10n.noTreatmentSessionsSubtitle,
            icon: Icons.event_note_outlined,
          )
        else
          ...treatment.sessions.map(
                (session) => Padding(
              padding: const EdgeInsets.only(
                bottom: 14,
              ),
              child: _SessionCard(
                session: session,
              ),
            ),
          ),

        const SizedBox(height: 8),

        Text(
          '',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _TreatmentHeaderCard extends StatelessWidget {
  final TreatmentEntity treatment;
  final String treatmentName;
  final int progressPercent;

  const _TreatmentHeaderCard({
    required this.treatment,
    required this.treatmentName,
    required this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatmentName,
                      style: theme
                          .textTheme.headlineSmall
                          ?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 19,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            treatment.dentist.name,
                            style: theme
                                .textTheme.titleMedium
                                ?.copyWith(
                              color:
                              colors.textSecondary,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TreatmentStatusChip(
                      status: treatment.status,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              TreatmentProgressRing(
                percent: progressPercent,
                size: 88,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: colors.surfacePrimary,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colors.borderSoft,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: context.medicalAccent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.treatmentCreatedAt,
                    style:
                    theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  treatment.createdAt,
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentOverviewCard extends StatelessWidget {
  final String progressLabel;
  final String completedSessions;
  final String notes;

  const _TreatmentOverviewCard({
    required this.progressLabel,
    required this.completedSessions,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OverviewItem(
            icon: Icons.trending_up_rounded,
            label: progressLabel,
            value: completedSessions,
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: colors.borderSoft,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.notes_rounded,
                  size: 20,
                  color: context.medicalAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.notes,
                      style: theme
                          .textTheme.bodyMedium
                          ?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notes,
                      style: theme
                          .textTheme.bodyMedium
                          ?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _OverviewItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            size: 21,
            color: context.medicalAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TreatmentInvoiceActionCard extends StatelessWidget {
  final VoidCallback onTap;

  const _TreatmentInvoiceActionCard({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: colors.borderSoft,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: colors.infoBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 27,
                  color: colors.infoForeground,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.treatmentInvoice,
                      style: theme
                          .textTheme.titleMedium
                          ?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l10n.treatmentInvoiceSubtitle,
                      style:
                      theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colors.infoForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: context.medicalAccent,
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final TreatmentSessionEntity session;

  const _SessionCard({
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final hasStartTime =
        (session.actualStartTime ?? '').trim().isNotEmpty;

    final hasEndTime =
        (session.actualEndTime ?? '').trim().isNotEmpty;

    final hasNotes =
        (session.notes ?? '').trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.event_available_rounded,
                  size: 22,
                  color: context.medicalAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.sessionNumber(
                    session.sessionNumber,
                  ),
                  style:
                  theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TreatmentStatusChip(
                status: session.status,
              ),
            ],
          ),

          if (hasStartTime || hasEndTime) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colors.borderSoft,
                ),
              ),
              child: Column(
                children: [
                  if (hasStartTime)
                    _SessionInfoRow(
                      icon: Icons.play_circle_outline_rounded,
                      label: l10n.sessionStartTime,
                      value: session.actualStartTime!,
                    ),
                  if (hasStartTime && hasEndTime)
                    Divider(
                      height: 1,
                      color: colors.borderSoft,
                    ),
                  if (hasEndTime)
                    _SessionInfoRow(
                      icon: Icons.stop_circle_outlined,
                      label: l10n.sessionEndTime,
                      value: session.actualEndTime!,
                    ),
                ],
              ),
            ),
          ],

          if (hasNotes) ...[
            const SizedBox(height: 16),
            _SessionNotes(
              notes: session.notes!,
            ),
          ],

          if (session.toothTreatments.isNotEmpty) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(
                  Icons.medical_information_outlined,
                  size: 20,
                  color: context.medicalAccent,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.procedure,
                  style:
                  theme.textTheme.titleSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...session.toothTreatments.map(
                  (toothTreatment) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _ProcedureCard(
                  toothTreatment: toothTreatment,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SessionInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SessionInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: context.medicalAccent,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              label,
              style:
              theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style:
              theme.textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionNotes extends StatelessWidget {
  final String notes;

  const _SessionNotes({
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notes_rounded,
            size: 20,
            color: context.medicalAccent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.notes,
                  style:
                  theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  notes,
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcedureCard extends StatelessWidget {
  final ToothTreatmentEntity toothTreatment;

  const _ProcedureCard({
    required this.toothTreatment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final languageCode =
        Localizations.localeOf(context).languageCode;

    final procedureName =
    toothTreatment.procedure.localizedName(
      languageCode,
    );

    final hasNotes =
        (toothTreatment.notes ?? '').trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 19,
              color: context.medicalAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  procedureName,
                  style:
                  theme.textTheme.titleSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${l10n.toothNumber}: '
                      '${toothTreatment.toothNumber}',
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (hasNotes) ...[
                  const SizedBox(height: 8),
                  Text(
                    toothTreatment.notes!,
                    style:
                    theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}