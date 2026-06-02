import 'package:flutter/material.dart';

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
    final blue = context.medicalAccent;
    final pinkSoft = context.medicalPinkSoft;
    final ink = context.medicalInk;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary ? colors.surfaceMuted : colors.surfacePrimary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPrimary ? blue.withValues(alpha: 0.32) : colors.borderSoft,
          ),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? blue.withValues(alpha: 0.08)
                  : colors.shadow.withValues(alpha: 0.06),
              blurRadius: isPrimary ? 24 : 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isPrimary ? colors.surfacePrimary : pinkSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: ink),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isEnabled ? 'استعراض' : 'قريبًا',
              style: theme.textTheme.labelLarge?.copyWith(
                color: ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
