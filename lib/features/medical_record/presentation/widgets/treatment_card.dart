import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/treatment_entity.dart';
import '../utils/medical_record_accent.dart';
import 'treatment_progress_ring.dart';
import 'treatment_status_chip.dart';

class TreatmentCard extends StatelessWidget {
  final TreatmentEntity treatment;
  final VoidCallback onTap;

  const TreatmentCard({
    super.key,
    required this.treatment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final accent = context.medicalAccent;
    final pink = context.medicalPinkAccent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: colors.borderSoft),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.07),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // _TreatmentAvatar(type: treatment.type),
                // const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        treatment.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        treatment.doctorName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TreatmentProgressRing(percent: treatment.progressPercent),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TreatmentStatusChip(
                  status: treatment.status,
                  label: treatment.statusLabel,
                ),
                const Spacer(),
                Text(
                  treatment.progressLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: pink.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: pink.withValues(alpha: 0.55)),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_available_rounded, color: accent, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          treatment.nextSessionLabel == null
                              ? 'آخر جلسة مكتملة'
                              : 'الجلسة القادمة',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          treatment.nextSessionLabel ??
                              treatment.startedAtLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    treatment.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                  label: const Text('التفاصيل'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class _TreatmentAvatar extends StatelessWidget {
//   final TreatmentType type;
//
//   const _TreatmentAvatar({
//     required this.type,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//
//     return Container(
//       width: 72,
//       height: 72,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(22),
//         color: colors.surfaceMuted,
//         border: Border.all(color: colors.borderSoft),
//       ),
//       child: Icon(
//         switch (type) {
//           TreatmentType.braces => Icons.grain_rounded,
//           TreatmentType.rootCanal => Icons.bolt_rounded,
//           TreatmentType.whitening => Icons.auto_awesome_rounded,
//           TreatmentType.implant => Icons.shield_moon_rounded,
//         },
//         color: colors.navBarItem,
//         size: 30,
//       ),
//     );
//   }
// }
