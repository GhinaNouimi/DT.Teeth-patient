import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/payment_record_entity.dart';
import '../utils/medical_record_accent.dart';

class PaymentRecordCard extends StatelessWidget {
  final PaymentRecordEntity record;

  const PaymentRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: record.isCompleted
                  ? colors.reservedState
                  : context.medicalAccentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              record.isCompleted ? Icons.check_rounded : Icons.schedule_rounded,
              color: record.isCompleted
                  ? colors.success
                  : context.medicalAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${record.dateLabel} • ${record.methodLabel}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            record.amountLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              color: record.isCompleted
                  ? colors.success
                  : context.medicalAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
