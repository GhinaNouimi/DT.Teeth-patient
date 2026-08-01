import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../bloc/offers_bloc.dart';
import '../bloc/offers_event.dart';
import '../bloc/offers_state.dart';
import 'applicable_treatment_card.dart';

class ApplicableTreatmentsList
    extends StatelessWidget {
  final int offerId;
  final OffersState state;
  final bool isOnline;

  const ApplicableTreatmentsList({
    super.key,
    required this.offerId,
    required this.state,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (state.actionStatus ==
        OfferActionStatus.loadingTreatments) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.selectedTreatmentTypeId == null) {
      return const SizedBox.shrink();
    }

    if (state.applicableTreatments.isEmpty) {
      return Text(
        l10n.noApplicableTreatments,
        style: Theme.of(context)
            .textTheme
            .bodyMedium,
      );
    }

    return Column(
      children: [
        ...state.applicableTreatments.map(
              (treatment) {
            return Padding(
              padding:
              const EdgeInsets.only(bottom: 12),
              child: ApplicableTreatmentCard(
                treatment: treatment,
                isSelected:
                state.selectedTreatmentId ==
                    treatment.id,
                onTap: isOnline
                    ? () {
                  context
                      .read<OffersBloc>()
                      .add(
                    SelectApplicableTreatmentRequested(
                      treatmentId:
                      treatment.id,
                    ),
                  );
                }
                    : null,
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canApply
                ? () {
              _apply(context);
            }
                : null,
            child: state.actionStatus ==
                OfferActionStatus.applying
                ? const SizedBox(
              width: 22,
              height: 22,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : Text(
              l10n.applyToOfferButton,
            ),
          ),
        ),
      ],
    );
  }

  bool get _canApply {
    return isOnline &&
        state.selectedTreatmentId != null &&
        state.actionStatus !=
            OfferActionStatus.applying;
  }

  void _apply(BuildContext context) {
    final treatmentId =
        state.selectedTreatmentId;

    if (!isOnline || treatmentId == null) {
      return;
    }

    context.read<OffersBloc>().add(
      ApplyToOfferRequested(
        offerId: offerId,
        treatmentId: treatmentId,
        languageCode:
        Localizations.localeOf(context)
            .languageCode,
      ),
    );
  }
}