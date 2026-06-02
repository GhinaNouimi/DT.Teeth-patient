import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/payment_plan_entity.dart';
import 'treatment_progress_ring.dart';

class PaymentProgressCard extends StatelessWidget {
  final PaymentPlanEntity plan;

  const PaymentProgressCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    Widget amountRow(String label, String value, Color valueColor) {
      return Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Row(
        children: [
          TreatmentProgressRing(percent: plan.progressPercent, size: 104),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ملخص الخطة العلاجية',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                amountRow(
                  'إجمالي الخطة',
                  plan.totalCostLabel,
                  colors.textPrimary,
                ),
                const SizedBox(height: 8),
                amountRow('المدفوع', plan.paidAmountLabel, colors.success),
                const SizedBox(height: 8),
                amountRow('المتبقي', plan.remainingAmountLabel, colors.danger),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
