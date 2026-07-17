import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';

class AppointmentsListSkeleton extends StatelessWidget {
  const AppointmentsListSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          120,
        ),
        children: const [
          _AppointmentsTabsSkeleton(),

          SizedBox(height: AppSpacing.lg),

          _AppointmentCardSkeleton(),
          SizedBox(height: 14),

          _AppointmentCardSkeleton(),
          SizedBox(height: 14),

          _AppointmentCardSkeleton(),
        ],
      ),
    );
  }
}

class _AppointmentsTabsSkeleton extends StatelessWidget {
  const _AppointmentsTabsSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}

class _AppointmentCardSkeleton extends StatelessWidget {
  const _AppointmentCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppSectionCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colors.surfaceMuted,
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 88,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Container(
                  width: 150,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                Container(
                  width: 115,
                  height: 14,
                  decoration: BoxDecoration(
                    color: colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: colors.surfaceMuted,
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(width: AppSpacing.md),

                    Expanded(
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: colors.surfaceMuted,
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}