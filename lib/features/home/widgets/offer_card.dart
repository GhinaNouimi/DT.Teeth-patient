import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../generated/assets.dart';
import '../../offers/domain/entities/offer_entity.dart';

class OfferCard extends StatelessWidget {
  final OfferEntity offer;
  final VoidCallback? onTap;

  const OfferCard({
    super.key,
    required this.offer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(14),
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
            children: [
              Expanded(
                child: _OfferContent(
                  offer: offer,
                ),
              ),
              const SizedBox(width: 8),
              _OfferImage(
                imagePath: offer.photoPath,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfferContent extends StatelessWidget {
  final OfferEntity offer;

  const _OfferContent({
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        if (offer.discountPercentage > 0) ...[
          _DiscountBadge(
            percentage:
            offer.discountPercentage,
          ),
          const SizedBox(height: 8),
        ],
        Text(
          offer.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
          theme.textTheme.titleMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          offer.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
          theme.textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const _DetailsChip(),
      ],
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final double percentage;

  const _DiscountBadge({
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Text(
        l10n.offerDiscountPercentage(
          _formatDiscount(percentage),
        ),
        style:
        theme.textTheme.labelSmall?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w800,
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

class _DetailsChip extends StatelessWidget {
  const _DetailsChip();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Text(
        l10n.viewDetails,
        style:
        theme.textTheme.bodySmall?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _OfferImage extends StatelessWidget {
  final String? imagePath;

  const _OfferImage({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedImagePath =
    imagePath?.trim();

    final hasBackendImage =
        normalizedImagePath != null &&
            normalizedImagePath.isNotEmpty;

    return SizedBox(
      width: 86,
      height: 86,
      child: hasBackendImage
          ? Image.network(
        normalizedImagePath,
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

class _DefaultOfferImage
    extends StatelessWidget {
  const _DefaultOfferImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.offerDiscount,
      width: 86,
      height: 86,
      fit: BoxFit.contain,
    );
  }
}