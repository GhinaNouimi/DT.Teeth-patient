import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../generated/assets.dart';
import '../widgets/home_section_title.dart';
import '../widgets/offer_card.dart';

class CenterOffersSection extends StatelessWidget {
  const CenterOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final offers = [
      _OfferItem(
        title: l10n.offerWhiteningTitle,
        subtitle: l10n.offerWhiteningSubtitle,
        imagePath: Assets.offerDiscount,
      ),
      _OfferItem(
        title: l10n.offerCleaningTitle,
        subtitle: l10n.offerCleaningSubtitle,
        imagePath: Assets.offerDiscount,
      ),
      _OfferItem(
        title: l10n.offerCheckupTitle,
        subtitle: l10n.offerCheckupSubtitle,
        imagePath: Assets.offerDiscount,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(
          title: l10n.featuredOffers,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 165,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final offer = offers[index];

              return OfferCard(
                title: offer.title,
                subtitle: offer.subtitle,
                imagePath: offer.imagePath,
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OfferItem {
  final String title;
  final String subtitle;
  final String imagePath;

  const _OfferItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}