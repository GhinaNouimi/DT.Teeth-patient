import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/complaint_entity.dart';
import '../widgets/complaint_update_timeline_tile.dart';

class ComplaintUpdatesSection extends StatelessWidget {
  final List<ComplaintUpdateEntity> updates;

  const ComplaintUpdatesSection({
    super.key,
    required this.updates,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التحديثات',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          if (updates.isEmpty)
            Text(
              'لا توجد تحديثات بعد على هذه الشكوى.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            ...updates.asMap().entries.map(
                  (entry) => ComplaintUpdateTimelineTile(
                update: entry.value,
                isLast: entry.key == updates.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}