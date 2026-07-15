import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class ComplaintsEmptyState extends StatelessWidget {
  final VoidCallback onCreateTap;
  final bool isFiltered;

  const ComplaintsEmptyState({
    super.key,
    required this.onCreateTap,
    this.isFiltered = false,
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
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Icon(
              isFiltered
                  ? Icons.filter_alt_off_outlined
                  : Icons.chat_bubble_outline_rounded,
              size: 35,
              color: colors.navBarItem,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            isFiltered
                ? l10n.noFilteredComplaintsTitle
                : l10n.noComplaintsTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isFiltered
                ? l10n.noFilteredComplaintsSubtitle
                : l10n.noComplaintsSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!isFiltered) ...[
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCreateTap,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addComplaint),
              ),
            ),
          ],
        ],
      ),
    );
  }
}