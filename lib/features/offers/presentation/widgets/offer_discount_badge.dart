import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

class OfferDiscountBadge
    extends StatelessWidget {
  final double discountPercentage;

  const OfferDiscountBadge({
    super.key,
    required this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: colors.surface.withValues(
          alpha: 0.75,
        ),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        l10n.offerDiscountPercentage(
          _formatDiscount(
            discountPercentage,
          ),
        ),
        style:
        theme.textTheme.labelMedium?.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _formatDiscount(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }
}