import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../complaints_di.dart';
import '../bloc/complaint_details/complaint_details_bloc.dart';
import '../bloc/complaint_details/complaint_details_event.dart';
import '../bloc/complaint_details/complaint_details_state.dart';
import '../widgets/complaint_details_card.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final String complaintId;

  const ComplaintDetailsScreen({
    super.key,
    required this.complaintId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComplaintDetailsBloc(
        getComplaintDetailsUseCase: ComplaintsDi.getComplaintDetailsUseCase,
      )..add(LoadComplaintDetailsRequested(complaintId)),
      child: _ComplaintDetailsView(
        complaintId: complaintId,
      ),
    );
  }
}

class _ComplaintDetailsView extends StatelessWidget {
  final String complaintId;

  const _ComplaintDetailsView({
    required this.complaintId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(
                title: 'تفاصيل الشكوى',
                showBackButton: true,
              ),
            ),
            Expanded(
              child: BlocBuilder<ComplaintDetailsBloc, ComplaintDetailsState>(
                builder: (context, state) {
                  if (state.status == ComplaintDetailsStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.status == ComplaintDetailsStatus.failure) {
                    return _ComplaintDetailsErrorState(
                      message:
                      state.errorMessage ?? 'تعذر تحميل تفاصيل الشكوى',
                      onRetry: () {
                        context.read<ComplaintDetailsBloc>().add(
                          LoadComplaintDetailsRequested(complaintId),
                        );
                      },
                    );
                  }

                  final complaint = state.complaint;
                  if (complaint == null) {
                    return const SizedBox.shrink();
                  }

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                    children: [
                      ComplaintDetailsCard(complaint: complaint),
                    ],
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

class _ComplaintDetailsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ComplaintDetailsErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AppSectionCard(
          radius: AppRadius.xl,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 42,
                color: colors.danger,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'تعذر تحميل التفاصيل',
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
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('إعادة المحاولة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}