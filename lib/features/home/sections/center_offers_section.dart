import 'package:flutter/material.dart';

import '../../../generated/assets.dart';
import '../widgets/home_section_title.dart';
import '../widgets/offer_card.dart';

class CenterOffersSection extends StatelessWidget {
  const CenterOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final offers = [
      const _OfferItem(
        title: 'خصم 20% على التبييض',
        subtitle: 'لفترة محدودة هذا الأسبوع',
        imagePath: Assets.offerDiscount,
      ),
      const _OfferItem(
        title: 'عرض تنظيف الأسنان',
        subtitle: 'احجز موعدك الآن واستفد من العرض',
        imagePath: Assets.offerDiscount,
      ),
      const _OfferItem(
        title: 'خصم على جلسة الفحص',
        subtitle: 'اطمئن على صحة أسنانك بسهولة',
        imagePath: Assets.offerDiscount,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(title: 'عروض مميزة'),
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