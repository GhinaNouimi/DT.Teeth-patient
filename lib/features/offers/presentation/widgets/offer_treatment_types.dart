import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../medical_record/domain/entities/treatment/treatment_type_entity.dart';
import '../bloc/offers_bloc.dart';
import '../bloc/offers_event.dart';
import '../bloc/offers_state.dart';

class OfferTreatmentTypes extends StatelessWidget {
  final List<TreatmentTypeEntity> treatmentTypes;
  final bool isEnabled;

  const OfferTreatmentTypes({
    super.key,
    required this.treatmentTypes,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return BlocBuilder<OffersBloc, OffersState>(
      buildWhen: (previous, current) {
        return previous.selectedTreatmentTypeId !=
            current.selectedTreatmentTypeId;
      },
      builder: (context, state) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: treatmentTypes.map((type) {
            final isSelected =
                state.selectedTreatmentTypeId ==
                    type.id;

            return ChoiceChip(
              selected: isSelected,
              label: Text(
                type.localizedName(languageCode),
              ),
              onSelected: isEnabled
                  ? (_) {
                context.read<OffersBloc>().add(
                  LoadApplicableTreatmentsRequested(
                    treatmentTypeId:
                    type.id,
                    languageCode:
                    languageCode,
                  ),
                );
              }
                  : null,
            );
          }).toList(),
        );
      },
    );
  }
}