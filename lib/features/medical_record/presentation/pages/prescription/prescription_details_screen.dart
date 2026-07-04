import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../../core/widgets/loading/app_skeleton.dart';
import '../../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../domain/entities/prescription/medication_entity.dart';
import '../../../domain/entities/prescription/prescription_entity.dart';
import '../../../medical_record_di.dart';
import '../../bloc/prescription/prescription_bloc.dart';
import '../../bloc/prescription/prescription_event.dart';
import '../../bloc/prescription/prescription_state.dart';
import '../../utils/medical_record_accent.dart';
import '../../widgets/medical_record_empty_state.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  final String prescriptionId;

  const PrescriptionDetailsScreen({
    super.key,
    required this.prescriptionId,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final id = int.tryParse(prescriptionId) ?? 0;

    return BlocProvider(
      create: (_) => PrescriptionBloc(
        getAllPrescriptionsUseCase:
        MedicalRecordDi.getAllPrescriptionsUseCase,
        getPrescriptionDetailsUseCase:
        MedicalRecordDi.getPrescriptionDetailsUseCase,
      )..add(
        LoadPrescriptionDetailsRequested(
          prescriptionId: id,
          languageCode: languageCode,
        ),
      ),
      child: const _PrescriptionDetailsView(),
    );
  }
}

class _PrescriptionDetailsView extends StatelessWidget {
  const _PrescriptionDetailsView();

  PrescriptionEntity _fakePrescription() {
    return const PrescriptionEntity(
      id: 0,
      dentistName: 'Doctor name',
      notes: 'Prescription notes',
      createdAt: '2026-07-04 14:52:26',
      medications: [
        MedicationEntity(
          name: 'Medication name',
          dosage: 'Dosage',
          frequency: 'Frequency',
          duration: 'Duration',
        ),
        MedicationEntity(
          name: 'Medication name',
          dosage: 'Dosage',
          frequency: 'Frequency',
          duration: 'Duration',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(title: l10n.prescriptionDetails),
            ),
            Expanded(
              child: BlocBuilder<PrescriptionBloc, PrescriptionState>(
                builder: (context, state) {
                  final isLoading = state is PrescriptionInitial ||
                      state is PrescriptionLoading;

                  if (state is PrescriptionFailure) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: MedicalRecordEmptyState(
                        title: l10n.prescriptionDetailsLoadFailed,
                        subtitle: state.message,
                        icon: Icons.medication_outlined,
                      ),
                    );
                  }

                  final prescription = state is PrescriptionDetailsLoaded
                      ? state.prescription
                      : _fakePrescription();

                  final isFromCache =
                      state is PrescriptionDetailsLoaded && state.isFromCache;

                  return AppSkeleton(
                    enabled: isLoading,
                    child: _PrescriptionDetailsBody(
                      prescription: prescription,
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

class _PrescriptionDetailsBody extends StatelessWidget {
  final PrescriptionEntity prescription;
  final bool isFromCache;

  const _PrescriptionDetailsBody({
    required this.prescription,
    required this.isFromCache,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final accent = context.medicalAccent;
    final l10n = context.l10n;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        if (isFromCache) ...[
          OfflineCachedBanner(
            message: l10n.offlineCachedDataMessage,
          ),
          const SizedBox(height: 16),
        ],
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: colors.surfaceMuted,
            border: Border.all(color: colors.borderSoft),
          ),
          child: Column(
            children: [
              Icon(
                Icons.medication_liquid_rounded,
                size: 46,
                color: accent,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.prescriptionDetails,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                prescription.dentistName,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _InfoCard(
          children: [
            _InfoRow(label: l10n.doctor, value: prescription.dentistName),
            _InfoRow(
              label: l10n.prescriptionDate,
              value: prescription.createdAt,
            ),
            _InfoRow(
              label: l10n.notes,
              value: (prescription.notes ?? '').trim().isEmpty
                  ? l10n.noNotes
                  : prescription.notes!,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          l10n.medications,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        ...prescription.medications.map(
              (medication) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _MedicationCard(medication: medication),
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        children: [
          for (int index = 0; index < children.length; index++) ...[
            children[index],
            if (index != children.length - 1) const Divider(height: 1),
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

class _MedicationCard extends StatelessWidget {
  final MedicationEntity medication;

  const _MedicationCard({
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final accent = context.medicalAccent;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medication.name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(label: l10n.dosage, value: medication.dosage),
          const Divider(height: 1),
          _InfoRow(label: l10n.frequency, value: medication.frequency),
          const Divider(height: 1),
          _InfoRow(label: l10n.duration, value: medication.duration),
          if ((medication.notes ?? '').trim().isNotEmpty) ...[
            const Divider(height: 1),
            _InfoRow(label: l10n.notes, value: medication.notes!),
          ],
        ],
      ),
    );
  }
}