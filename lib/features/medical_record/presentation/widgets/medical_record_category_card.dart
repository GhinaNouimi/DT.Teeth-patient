import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../utils/medical_record_accent.dart';

class MedicalRecordCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isPrimary;
  final bool isEnabled;
  final VoidCallback? onTap;

  const MedicalRecordCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isPrimary = false,
    this.isEnabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final accent = context.medicalAccent;
    final pinkSoft = context.medicalPinkSoft;
    final ink = context.medicalInk;
    final l10n = context.l10n;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isPrimary ? colors.surfaceMuted : colors.surfacePrimary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPrimary
                ? accent.withValues(alpha: .28)
                : colors.borderSoft,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isPrimary ? colors.surfacePrimary : pinkSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: ink, size: 24),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    isEnabled ? l10n.view : l10n.comingSoon,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: accent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}