import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../complaints_di.dart';
import '../../domain/entities/complaint_entity.dart';
import '../bloc/complaints/complaints_bloc.dart';
import '../bloc/complaints/complaints_event.dart';
import '../bloc/complaints/complaints_state.dart';
import '../models/complaint_filter.dart';
import '../widgets/complaint_card.dart';
import '../widgets/complaints_empty_state.dart';
import '../widgets/complaints_filter_tabs.dart';
import '../widgets/complaints_list_skeleton.dart';

class ComplaintsListScreen extends StatelessWidget {
  const ComplaintsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => ComplaintsBloc(
        getComplaintsUseCase:
        ComplaintsDi.getComplaintsUseCase,
      )..add(
        LoadComplaintsRequested(
          languageCode: languageCode,
        ),
      ),
      child: const _ComplaintsListView(),
    );
  }
}

class _ComplaintsListView extends StatelessWidget {
  const _ComplaintsListView();

  String _languageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  Future<void> _openCreateComplaint(
      BuildContext context,
      ) async {
    final result = await context.push<ComplaintEntity>(
      AppRoutes.createComplaint,
    );

    if (result != null && context.mounted) {
      context.read<ComplaintsBloc>().add(
        LoadComplaintsRequested(
          languageCode: _languageCode(context),
        ),
      );
    }
  }

  void _openComplaintDetails(
      BuildContext context,
      ComplaintEntity complaint,
      ) {
    context.push(
      AppRoutes.complaintDetails,
      extra: complaint,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateComplaint(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newComplaint),
      ),
      body: SafeArea(
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
                title: l10n.complaintsAndSupport,
                showBackButton: true,
              ),
            ),
            Expanded(
              child:
              BlocBuilder<ComplaintsBloc, ComplaintsState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ComplaintsBloc>().add(
                        RefreshComplaintsRequested(
                          languageCode:
                          _languageCode(context),
                        ),
                      );
                    },
                    child: ListView(
                      physics:
                      const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        120,
                      ),
                      children: [
                        if (state.isFromCache) ...[
                          OfflineCachedBanner(
                            message: context.l10n.offlineCachedDataMessage,
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        Text(
                          l10n.complaintsSubtitle,
                          style:
                          Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: colors.textSecondary,
                            height: 1.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ComplaintsFilterTabs(
                          selectedFilter:
                          state.selectedFilter,
                          onChanged: (filter) {
                            context
                                .read<ComplaintsBloc>()
                                .add(
                              ComplaintFilterChanged(
                                filter: filter,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (state.isInitialLoading)
                          const ComplaintsListSkeleton()
                        else if (state.hasErrorWithoutData)
                          _ComplaintsErrorState(
                            message: state.errorMessage ??
                                l10n.unknownErrorMessage,
                            onRetry: () {
                              context
                                  .read<ComplaintsBloc>()
                                  .add(
                                LoadComplaintsRequested(
                                  languageCode:
                                  _languageCode(context),
                                ),
                              );
                            },
                          )
                        else if (state.filteredComplaints.isEmpty)
                            ComplaintsEmptyState(
                              isFiltered:
                              state.complaints.isNotEmpty &&
                                  state.selectedFilter !=
                                      ComplaintFilter.all,
                              onCreateTap: () =>
                                  _openCreateComplaint(context),
                            )
                          else
                            ...state.filteredComplaints.map(
                                  (complaint) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                child: ComplaintCard(
                                  complaint: complaint,
                                  onTap: () =>
                                      _openComplaintDetails(
                                        context,
                                        complaint,
                                      ),
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

class _ComplaintsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ComplaintsErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 44,
            color: colors.danger,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.complaintsLoadFailed,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
            ),
          ),
        ],
      ),
    );
  }
}