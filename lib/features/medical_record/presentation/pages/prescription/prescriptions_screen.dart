import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/routing/app_routes.dart';
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
import '../../widgets/medical_record_empty_state.dart';
import '../../widgets/prescription/prescription_card.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => PrescriptionBloc(
        getAllPrescriptionsUseCase:
        MedicalRecordDi.getAllPrescriptionsUseCase,
        getPrescriptionDetailsUseCase:
        MedicalRecordDi.getPrescriptionDetailsUseCase,
      )..add(
        LoadPrescriptionsRequested(languageCode: languageCode),
      ),
      child: const _PrescriptionsView(),
    );
  }
}

class _PrescriptionsView extends StatelessWidget {
  const _PrescriptionsView();

  List<PrescriptionEntity> _fakePrescriptions() {
    return const [
      PrescriptionEntity(
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
        ],
      ),
      PrescriptionEntity(
        id: 1,
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
        ],
      ),
    ];
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(title: l10n.prescriptions),
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
                        title: l10n.prescriptionLoadFailed,
                        subtitle: state.message,
                        icon: Icons.medication_outlined,
                      ),
                    );
                  }

                  final prescriptions = state is PrescriptionsLoaded
                      ? state.prescriptions
                      : _fakePrescriptions();

                  final isFromCache =
                      state is PrescriptionsLoaded && state.isFromCache;

                  return AppSkeleton(
                    enabled: isLoading,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      children: [
                        if (isFromCache) ...[
                          OfflineCachedBanner(
                            message: l10n.offlineCachedDataMessage,
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (prescriptions.isEmpty && !isLoading)
                          MedicalRecordEmptyState(
                            title: l10n.noPrescriptionsTitle,
                            subtitle: l10n.noPrescriptionsSubtitle,
                            icon: Icons.receipt_long_rounded,
                          )
                        else
                          ...prescriptions.map(
                                (prescription) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: PrescriptionCard(
                                prescription: prescription,
                                onTap: () {
                                  if (isLoading) return;

                                  context.push(
                                    AppRoutes
                                        .medicalRecordPrescriptionDetails,
                                    extra: prescription.id,
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
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