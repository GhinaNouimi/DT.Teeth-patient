import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

class OfferDateRange extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const OfferDateRange({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = context.l10n;

    return Row(
      children: [
        Icon(
          Icons.calendar_month_outlined,
          size: 17,
          color: colors.primary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            l10n.offerDateRange(
              _formatDate(
                context,
                startDate,
              ),
              _formatDate(
                context,
                endDate,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
            theme.textTheme.bodySmall?.copyWith(
              color:
              colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(
      BuildContext context,
      DateTime? date,
      ) {
    if (date == null) {
      return context.l10n.notAvailable;
    }

    return MaterialLocalizations.of(
      context,
    ).formatCompactDate(date);
  }
}