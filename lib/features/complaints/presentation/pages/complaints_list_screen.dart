import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../complaints_di.dart';
import '../bloc/complaints/complaints_bloc.dart';
import '../bloc/complaints/complaints_event.dart';
import '../bloc/complaints/complaints_state.dart';
import '../sections/complaints_header_section.dart';
import '../widgets/complaint_card.dart';
import '../widgets/complaints_empty_state.dart';
import '../widgets/complaints_filter_tabs.dart';

class ComplaintsListScreen extends StatelessWidget {
  const ComplaintsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComplaintsBloc(
        getComplaintsUseCase: ComplaintsDi.getComplaintsUseCase,
      )..add(const LoadComplaintsRequested()),
      child: const _ComplaintsListView(),
    );
  }
}

class _ComplaintsListView extends StatelessWidget {
  const _ComplaintsListView();

  Future<void> _openCreateComplaint(BuildContext context) async {
    final result = await context.push(AppRoutes.createComplaint);
    if (result == true && context.mounted) {
      context.read<ComplaintsBloc>().add(const LoadComplaintsRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateComplaint(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('شكوى جديدة'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(
                title: 'الشكاوى والدعم',
                showBackButton: true,
              ),
            ),
            Expanded(
              child: BlocBuilder<ComplaintsBloc, ComplaintsState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ComplaintsBloc>().add(
                        const RefreshComplaintsRequested(),
                      );
                    },
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 2, 20, 120),
                      children: [
                        const SizedBox(height: 20),
                        ComplaintsFilterTabs(
                          selectedFilter: state.selectedFilter,
                          onChanged: (filter) {
                            context.read<ComplaintsBloc>().add(
                              ComplaintFilterChanged(filter),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        if (state.status == ComplaintsStatus.loading &&
                            state.complaints.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state.status == ComplaintsStatus.failure &&
                            state.complaints.isEmpty)
                          _ComplaintsErrorState(
                            message: state.errorMessage ?? 'حدث خطأ غير متوقع',
                            onRetry: () {
                              context.read<ComplaintsBloc>().add(
                                const LoadComplaintsRequested(),
                              );
                            },
                          )
                        else if (state.filteredComplaints.isEmpty)
                            ComplaintsEmptyState(
                              onCreateTap: () => _openCreateComplaint(context),
                            )
                          else
                            ...state.filteredComplaints.map(
                                  (complaint) => Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: ComplaintCard(
                                  complaint: complaint,
                                  onTap: () {
                                    context.push(
                                      AppRoutes.complaintDetails,
                                      extra: complaint.id,
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 42,
            color: colors.danger,
          ),
          const SizedBox(height: 14),
          Text(
            'تعذر تحميل الشكاوى',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ),
        ],
      ),
    );
  }
}