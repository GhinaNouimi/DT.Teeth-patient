import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/offer_entity.dart';
import 'offer_date_range.dart';
import 'offer_discount_badge.dart';

class OfferCardContent extends StatelessWidget {
  final OfferEntity offer;

  const OfferCardContent({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        if (offer.discountPercentage > 0) ...[
          OfferDiscountBadge(
            discountPercentage:
            offer.discountPercentage,
          ),
          const SizedBox(height: 10),
        ],
        Text(
          offer.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
          theme.textTheme.titleMedium?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          offer.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
          theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 14),
        OfferDateRange(
          startDate: offer.startDate,
          endDate: offer.endDate,
        ),
        const SizedBox(height: 14),
        Align(
          alignment:
          AlignmentDirectional.centerEnd,
          child: Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: colors.surface.withValues(
                alpha: 0.75,
              ),
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.viewOfferDetails,
                  style: theme
                      .textTheme.labelLarge
                      ?.copyWith(
                    color: colors.primary,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: colors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}