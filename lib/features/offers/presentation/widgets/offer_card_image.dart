import 'package:flutter/material.dart';

import '../../../../generated/assets.dart';

class OfferCardImage extends StatelessWidget {
  final String? imagePath;

  const OfferCardImage({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    final normalizedImagePath =
    imagePath?.trim();

    final hasBackendImage =
        normalizedImagePath != null &&
            normalizedImagePath.isNotEmpty;

    return Container(
      width: 96,
      height: 110,
      decoration: BoxDecoration(
        color: colors.surface.withValues(
          alpha: 0.75,
        ),
        borderRadius:
        BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasBackendImage
          ? Image.network(
        normalizedImagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
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
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}