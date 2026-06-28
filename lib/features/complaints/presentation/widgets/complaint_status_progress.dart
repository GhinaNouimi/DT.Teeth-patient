import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintStatusProgress extends StatelessWidget {
  final ComplaintStatus status;

  const ComplaintStatusProgress({
    super.key,
    required this.status,
  });

  int get _currentStep {
    switch (status) {
      case ComplaintStatus.open:
        return 0;
      case ComplaintStatus.inProgress:
        return 1;
      case ComplaintStatus.resolved:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      radius: AppRadius.xl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حالة الشكوى',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProgressStep(
            title: 'تم الاستلام',
            description: 'تم تسجيل الشكوى في النظام بنجاح.',
            isActive: _currentStep == 0,
            isCompleted: _currentStep > 0,
          ),
          _ProgressStep(
            title: 'قيد المعالجة',
            description: 'تتم متابعة الشكوى من قبل الفريق المختص.',
            isActive: _currentStep == 1,
            isCompleted: _currentStep > 1,
          ),
          _ProgressStep(
            title: 'تم الحل',
            description: 'تم الانتهاء من معالجة الشكوى وإغلاقها.',
            isActive: _currentStep == 2,
            isCompleted: false,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  final String title;
  final String description;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;

  const _ProgressStep({
    required this.title,
    required this.description,
    required this.isActive,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    final stepColor = isCompleted || isActive
        ? colors.navBarItem
        : colors.borderSoft;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? colors.navBarItem
                    : colors.surfaceMuted,
                shape: BoxShape.circle,
                border: Border.all(color: stepColor),
              ),
              child: Icon(
                isCompleted ? Icons.check_rounded : Icons.circle_rounded,
                size: isCompleted ? 18 : 10,
                color: isCompleted || isActive
                    ? colors.textInverse
                    : colors.textSecondary,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 42,
                color: isCompleted ? colors.navBarItem : colors.borderSoft,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isCompleted || isActive
                        ? colors.textPrimary
                        : colors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}