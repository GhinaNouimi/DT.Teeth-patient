import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/offer_entity.dart';

class OfferDetailsHeader extends StatelessWidget {
  final OfferEntity offer;

  const OfferDetailsHeader({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            colors.heroStart,
            colors.heroEnd,
          ],
        ),
        border: Border.all(
          color: colors.heroBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _OfferHeaderImage(
            imagePath: offer.photoPath,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                if (offer.discountPercentage > 0) ...[
                  _ProminentDiscountBadge(
                    percentage:
                    offer.discountPercentage,
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  offer.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                  theme.textTheme.titleLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                    height: 1.3,
                  ),
                ),
                if (offer.description
                    .trim()
                    .isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    offer.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style:
                    theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProminentDiscountBadge extends StatelessWidget {
  final double percentage;

  const _ProminentDiscountBadge({
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: colors.navBarItem,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.navBarItem.withValues(
              alpha: 0.2,
            ),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        '${_formatDiscount(percentage)}%',
        style: theme.textTheme.titleMedium?.copyWith(
          color: colors.textInverse,
          fontWeight: FontWeight.w900,
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

class _OfferHeaderImage extends StatelessWidget {
  final String? imagePath;

  const _OfferHeaderImage({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final normalizedPath = imagePath?.trim();

    final hasBackendImage =
        normalizedPath != null &&
            normalizedPath.isNotEmpty;

    return Container(
      width: 112,
      height: 112,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surfacePrimary.withValues(
          alpha: 0.72,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasBackendImage
          ? Image.network(
        normalizedPath,
        fit: BoxFit.contain,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return const _DefaultOfferImage();
        },
      )
          : const _DefaultOfferImage(),
    );
  }
}

class _DefaultOfferImage extends StatelessWidget {
  const _DefaultOfferImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.offerDiscount,
      fit: BoxFit.contain,
    );
  }
}