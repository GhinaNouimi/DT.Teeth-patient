import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/connectivity/connectivity_bloc.dart';
import '../../../../core/connectivity/connectivity_state.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../domain/entities/offer_entity.dart';
import '../bloc/offers_bloc.dart';
import '../bloc/offers_state.dart';
import '../widgets/applicable_treatments_list.dart';
import '../widgets/offer_treatment_types.dart';

class OfferApplicationSection extends StatelessWidget {
  final OfferEntity offer;

  const OfferApplicationSection({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    if (offer.treatmentTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<
        ConnectivityBloc,
        ConnectivityState>(
      buildWhen: (previous, current) {
        return previous.runtimeType !=
            current.runtimeType;
      },
      builder: (context, connectivityState) {
        final isOnline =
        connectivityState is ConnectivityOnline;

        return _ApplicationCard(
          offer: offer,
          isOnline: isOnline,
        );
      },
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final OfferEntity offer;
  final bool isOnline;

  const _ApplicationCard({
    required this.offer,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary.withValues(
          alpha: 0.65,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.local_offer_outlined,
                  color: colors.navBarItem,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.applyToOfferTitle,
                  style:
                  theme.textTheme.titleLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.selectTreatmentTypeDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
          if (!isOnline) ...[
            const SizedBox(height: 16),
            OfflineCachedBanner(
              message:
              l10n.offlineOfferApplicationMessage,
            ),
          ],
          const SizedBox(height: 20),
          _StepTitle(
            number: 1,
            title: l10n.selectOfferTreatmentTypeStep,
          ),
          const SizedBox(height: 12),
          OfferTreatmentTypes(
            treatmentTypes: offer.treatmentTypes,
            isEnabled: isOnline,
          ),
          const SizedBox(height: 22),
          BlocBuilder<OffersBloc, OffersState>(
            buildWhen: (previous, current) {
              return previous.actionStatus !=
                  current.actionStatus ||
                  previous.applicableTreatments !=
                      current.applicableTreatments ||
                  previous.selectedTreatmentId !=
                      current.selectedTreatmentId ||
                  previous.selectedTreatmentTypeId !=
                      current.selectedTreatmentTypeId;
            },
            builder: (context, offersState) {
              if (offersState.selectedTreatmentTypeId ==
                  null) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _StepTitle(
                    number: 2,
                    title:
                    l10n.selectApplicableTreatmentStep,
                  ),
                  const SizedBox(height: 12),
                  ApplicableTreatmentsList(
                    offerId: offer.id,
                    state: offersState,
                    isOnline: isOnline,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StepTitle extends StatelessWidget {
  final int number;
  final String title;

  const _StepTitle({
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.navBarItem,
            shape: BoxShape.circle,
          ),
          child: Text(
            number.toString(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.textInverse,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style:
            theme.textTheme.titleSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}