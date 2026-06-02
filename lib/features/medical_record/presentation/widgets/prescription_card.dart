import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/prescription_entity.dart';
import '../utils/medical_record_accent.dart';

class PrescriptionCard extends StatelessWidget {
  final PrescriptionEntity prescription;
  final VoidCallback onTap;

  const PrescriptionCard({
    super.key,
    required this.prescription,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final blue = context.medicalAccent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.borderSoft),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  prescription.visualEmoji,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          prescription.medicineName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _PrescriptionStatusBadge(status: prescription.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    prescription.concentration,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prescription.instructions,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تاريخ الوصفة: ${prescription.prescribedAtLabel}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrescriptionStatusBadge extends StatelessWidget {
  final PrescriptionStatus status;

  const _PrescriptionStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isActive = status == PrescriptionStatus.active;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isActive ? colors.surfaceMuted : colors.reservedState,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        isActive ? 'الحالية' : 'سابقة',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isActive ? context.medicalAccent : colors.success,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
