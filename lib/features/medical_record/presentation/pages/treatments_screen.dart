import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/treatment/treatment_entity.dart';
import '../../medical_record_di.dart';
import '../bloc/treatment/treatment_bloc.dart';
import '../bloc/treatment/treatment_event.dart';
import '../bloc/treatment/treatment_state.dart';
import '../widgets/medical_record_empty_state.dart';
import '../widgets/medical_record_tab_bar.dart';
import '../widgets/treatment_card.dart';

class TreatmentsScreen extends StatelessWidget {
  const TreatmentsScreen({
    super.key,
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
        LoadTreatmentsRequested(
          languageCode: languageCode,
        ),
      ),
      child: const _TreatmentsView(),
    );
  }
}

class _TreatmentsView extends StatefulWidget {
  const _TreatmentsView();

  @override
  State<_TreatmentsView> createState() =>
      _TreatmentsViewState();
}

class _TreatmentsViewState extends State<_TreatmentsView> {
  int _currentTabIndex = 0;

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
                title: l10n.treatments,
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
                        title: l10n.treatmentLoadFailed,
                        subtitle: state.message,
                        icon: Icons.medical_services_outlined,
                      ),
                    );
                  }

                  final treatments = state is TreatmentsLoaded
                      ? state.treatments
                      : _fakeTreatments;

                  final isFromCache =
                      state is TreatmentsLoaded &&
                          state.isFromCache;

                  final ongoingTreatments = treatments
                      .where(
                        (treatment) => treatment.isOngoing,
                  )
                      .toList();

                  final treatmentHistory = treatments
                      .where(
                        (treatment) =>
                    treatment.isCompleted ||
                        treatment.isCancelled,
                  )
                      .toList();

                  final displayedTreatments =
                  _currentTabIndex == 0
                      ? ongoingTreatments
                      : treatmentHistory;

                  return AppSkeleton(
                    enabled: isLoading,
                    child: ListView(
                      physics:
                      const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        16,
                        20,
                        24,
                      ),
                      children: [
                        if (isFromCache) ...[
                          OfflineCachedBanner(
                            message:
                            l10n.offlineCachedDataMessage,
                          ),
                          const SizedBox(height: 16),
                        ],
                        MedicalRecordTabBar(
                          labels: [
                            l10n.current,
                            l10n.treatmentHistory,
                          ],
                          counts: [
                            ongoingTreatments.length,
                            treatmentHistory.length,
                          ],
                          currentIndex: _currentTabIndex,
                          onChanged: (index) {
                            setState(() {
                              _currentTabIndex = index;
                            });
                          },
                        ),
                        const SizedBox(height: 18),
                        if (displayedTreatments.isEmpty &&
                            !isLoading)
                          MedicalRecordEmptyState(
                            title: _currentTabIndex == 0
                                ? l10n.noCurrentTreatmentsTitle
                                : l10n.noTreatmentHistoryTitle,
                            subtitle: _currentTabIndex == 0
                                ? l10n
                                .noCurrentTreatmentsSubtitle
                                : l10n
                                .noTreatmentHistorySubtitle,
                            icon:
                            Icons.medical_services_outlined,
                          )
                        else
                          ...displayedTreatments.map(
                                (treatment) => Padding(
                              padding:
                              const EdgeInsets.only(
                                bottom: 14,
                              ),
                              child: TreatmentCard(
                                treatment: treatment,
                                onTap: () {
                                  if (isLoading) {
                                    return;
                                  }

                                  context.push(
                                    AppRoutes
                                        .medicalRecordTreatmentDetails,
                                    extra: treatment.id,
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

const List<TreatmentEntity> _fakeTreatments = [];