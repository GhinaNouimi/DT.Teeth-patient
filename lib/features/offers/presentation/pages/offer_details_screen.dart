import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/offer_entity.dart';
import '../bloc/offers_bloc.dart';
import '../bloc/offers_event.dart';
import '../bloc/offers_state.dart';
import '../widgets/offer_details_content.dart';

class OfferDetailsScreen extends StatelessWidget {
  final OfferEntity offer;

  const OfferDetailsScreen({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return BlocListener<OffersBloc, OffersState>(
      listenWhen: (previous, current) {
        return previous.actionStatus !=
            current.actionStatus;
      },
      listener: (context, state) async {
        if (state.actionStatus ==
            OfferActionStatus.applySuccess) {
          await showSuccessBottomSheet(
            context,
            title: l10n.offerApplicationSuccessTitle,
            message:
            state.successMessage ??
                l10n.offerApplicationSuccessMessage,
            buttonText: l10n.done,
            onPressed: () {
              context.read<OffersBloc>().add(
                const ResetOfferActionStateRequested(),
              );
            },
          );
        }

        if (state.actionStatus ==
            OfferActionStatus.failure) {
          await showErrorBottomSheet(
            context,
            title: l10n.offerApplicationErrorTitle,
            message:
            state.actionErrorMessage ??
                l10n.offerApplicationErrorMessage,
            buttonText: l10n.retryOffers,
            onPressed: () {
              context.read<OffersBloc>().add(
                const ResetOfferActionStateRequested(),
              );
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  0,
                ),
                child: AppTopBar(
                  title: l10n.offerDetailsTitle,
                ),
              ),
              Expanded(
                child: OfferDetailsContent(
                  offer: offer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}