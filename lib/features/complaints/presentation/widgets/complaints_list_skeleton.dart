import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';

class ComplaintsListSkeleton extends StatelessWidget {
  const ComplaintsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppSkeleton(
      enabled: true,
      child: Column(
        children: List.generate(
          4,
              (index) => Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.md,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.surfacePrimary,
                borderRadius: BorderRadius.circular(
                  AppRadius.xl,
                ),
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
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: colors.surfaceMuted,
                          borderRadius: BorderRadius.circular(
                            AppRadius.lg,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 15,
                              color: colors.surfaceMuted,
                            ),
                            const SizedBox(
                              height: AppSpacing.sm,
                            ),
                            Container(
                              width: 90,
                              height: 11,
                              color: colors.surfaceMuted,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: colors.surfaceMuted,
                  ),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  Container(
                    width: 220,
                    height: 12,
                    color: colors.surfaceMuted,
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: colors.surfaceMuted,
                          borderRadius: BorderRadius.circular(
                            AppRadius.pill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.sm,
                      ),
                      Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          color: colors.surfaceMuted,
                          borderRadius: BorderRadius.circular(
                            AppRadius.pill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}