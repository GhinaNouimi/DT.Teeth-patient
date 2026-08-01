import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../domain/entities/offer_entity.dart';
import '../widgets/offer_list_card.dart';

class OffersLoadedSection extends StatelessWidget {
  final List<OfferEntity> offers;
  final bool isFromCache;
  final Future<void> Function() onRefresh;
  final ValueChanged<OfferEntity> onOfferPressed;

  const OffersLoadedSection({
    super.key,
    required this.offers,
    required this.isFromCache,
    required this.onRefresh,
    required this.onOfferPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (isFromCache)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  20,
                  14,
                  20,
                  0,
                ),
                child: OfflineCachedBanner(
                  message: l10n.cachedOffersMessage,
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              20,
              16,
              20,
              28,
            ),
            sliver: SliverList.separated(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];

                return OfferListCard(
                  offer: offer,
                  onTap: () {
                    onOfferPressed(offer);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 14);
              },
            ),
          ),
        ],
      ),
    );
  }
}