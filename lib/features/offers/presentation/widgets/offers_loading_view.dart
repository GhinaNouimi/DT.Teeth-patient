import 'package:flutter/material.dart';

import '../../../../core/widgets/loading/app_skeleton.dart';
import '../../domain/entities/offer_entity.dart';
import 'offer_list_card.dart';

class OffersLoadingView extends StatelessWidget {
  const OffersLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsetsDirectional.fromSTEB(
          20,
          18,
          20,
          28,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return OfferListCard(
            offer: _createPlaceholderOffer(index),
            onTap: () {},
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 14);
        },
      ),
    );
  }

  OfferEntity _createPlaceholderOffer(int index) {
    final currentDate = DateTime.now();

    return OfferEntity(
      id: index,
      title: 'Loading offer title',
      description:
      'Loading offer description placeholder text',
      startDate: currentDate,
      endDate: currentDate,
      conditions: '',
      discountPercentage: 25,
      photoPath: null,
      treatmentTypes: const [],
    );
  }
}