import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/loading/app_skeleton.dart';
import '../../offers/domain/entities/offer_entity.dart';
import '../../offers/presentation/bloc/offers_bloc.dart';
import '../../offers/presentation/bloc/offers_state.dart';
import '../widgets/home_section_title.dart';
import '../widgets/offer_card.dart';

class CenterOffersSection extends StatelessWidget {
  const CenterOffersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OffersBloc, OffersState>(
      buildWhen: (previous, current) {
        return previous.offersStatus !=
            current.offersStatus ||
            previous.offers != current.offers;
      },
      builder: (context, state) {
        switch (state.offersStatus) {
          case OffersStatus.initial:
          case OffersStatus.loading:
            return const _OffersLoadingSection();

          case OffersStatus.failure:
            return const SizedBox.shrink();

          case OffersStatus.success:
            if (state.offers.isEmpty) {
              return const SizedBox.shrink();
            }

            return _LoadedOffersSection(
              offers: state.offers.take(3).toList(),
            );
        }
      },
    );
  }
}

class _LoadedOffersSection extends StatelessWidget {
  final List<OfferEntity> offers;

  const _LoadedOffersSection({
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: HomeSectionTitle(
                title: l10n.featuredOffers,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(AppRoutes.offers);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.viewAll,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 165,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (context, index) {
              final offer = offers[index];

              return OfferCard(
                offer: offer,
                onTap: () {
                  context.push(
                    AppRoutes.offerDetails,
                    extra: offer,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OffersLoadingSection
    extends StatelessWidget {
  const _OffersLoadingSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(
          title: l10n.featuredOffers,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 165,
          child: AppSkeleton(
            enabled: true,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 12);
              },
              itemBuilder: (context, index) {
                return OfferCard(
                  offer: _placeholderOffer(index),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  OfferEntity _placeholderOffer(int index) {
    return OfferEntity(
      id: index,
      title: 'Loading offer',
      description:
      'Loading offer description',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      conditions: '',
      discountPercentage: 25,
      photoPath: null,
      treatmentTypes: const [],
    );
  }
}