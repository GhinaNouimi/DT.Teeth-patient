import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
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
    final languageCode = Localizations.localeOf(context).languageCode;

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
                        title: l10n.treatmentDetailsLoadFailed,
                        subtitle: state.message,
                        icon: Icons.medical_services_outlined,
                      ),
                    );
                  }

                  final treatment = state is TreatmentDetailsLoaded
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
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: colors.borderSoft,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatmentName,
                      style:
                      theme.textTheme.headlineSmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      treatment.dentist.name,
                      style:
                      theme.textTheme.titleMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TreatmentStatusChip(
                      status: treatment.status,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${l10n.treatmentCreatedAt}: '
                          '${treatment.createdAt}',
                      style:
                      theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              TreatmentProgressRing(
                percent: _progressPercent,
                size: 86,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _InfoCard(
          children: [
            _InfoRow(
              label: progressLabel,
              value: l10n.completedSessions(
                treatment.sessionsCompleted,
                treatment.totalSessionsNeeded,
              ),
            ),
            _InfoRow(
              label: l10n.notes,
              value:
              (treatment.notes ?? '').trim().isEmpty
                  ? l10n.noNotes
                  : treatment.notes!,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          l10n.treatmentSessions,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
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
              Expanded(
                child: Text(
                  l10n.sessionNumber(
                    session.sessionNumber,
                  ),
                  style:
                  theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TreatmentStatusChip(
                status: session.status,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoCard(
            children: [
              if (session.actualStartTime != null &&
                  session.actualStartTime!.trim().isNotEmpty)
                _InfoRow(
                  label: l10n.sessionStartTime,
                  value: session.actualStartTime!,
                ),
              if (session.actualEndTime != null &&
                  session.actualEndTime!.trim().isNotEmpty)
                _InfoRow(
                  label: l10n.sessionEndTime,
                  value: session.actualEndTime!,
                ),
              _InfoRow(
                label: l10n.sessionCost,
                value: session.sessionCost.toString(),
              ),
              _InfoRow(
                label: l10n.notes,
                value:
                (session.notes ?? '').trim().isEmpty
                    ? l10n.noNotes
                    : session.notes!,
              ),
            ],
          ),
          if (session.toothTreatments.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.procedure,
              style:
              theme.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ...session.toothTreatments.map(
                  (toothTreatment) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _ToothTreatmentCard(
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

class _ToothTreatmentCard extends StatelessWidget {
  final ToothTreatmentEntity toothTreatment;

  const _ToothTreatmentCard({
    required this.toothTreatment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final accent = context.medicalAccent;
    final l10n = context.l10n;
    final languageCode =
        Localizations.localeOf(context).languageCode;

    final procedureName =
    toothTreatment.procedure.localizedName(
      languageCode,
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.toothNumber}: '
                '${toothTreatment.toothNumber}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            procedureName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            toothTreatment.procedure.price,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if ((toothTreatment.notes ?? '')
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              toothTreatment.notes!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        children: [
          for (
          int index = 0;
          index < children.length;
          index++
          ) ...[
            children[index],
            if (index != children.length - 1)
              const Divider(
                height: 1,
              ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
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
              style: theme.textTheme.bodyMedium?.copyWith(
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