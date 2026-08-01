import 'package:flutter/material.dart';

import '../../domain/entities/offer_entity.dart';
import 'offer_card_content.dart';
import 'offer_card_image.dart';

class OfferListCard extends StatelessWidget {
  final OfferEntity offer;
  final VoidCallback onTap;

  const OfferListCard({
    super.key,
    required this.offer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin:
              AlignmentDirectional.topStart,
              end:
              AlignmentDirectional.bottomEnd,
              colors: [
                colors.primaryContainer.withValues(
                  alpha: 0.72,
                ),
                colors.secondaryContainer.withValues(
                  alpha: 0.55,
                ),
              ],
            ),
            border: Border.all(
              color:
              colors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: OfferCardContent(
                    offer: offer,
                  ),
                ),
                const SizedBox(width: 14),
                OfferCardImage(
                  imagePath: offer.photoPath,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}