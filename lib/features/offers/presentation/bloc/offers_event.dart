abstract class OffersEvent {
  const OffersEvent();
}

class LoadOffersRequested extends OffersEvent {
  final String languageCode;

  const LoadOffersRequested({
    required this.languageCode,
  });
}

class LoadApplicableTreatmentsRequested
    extends OffersEvent {
  final int treatmentTypeId;
  final String languageCode;

  const LoadApplicableTreatmentsRequested({
    required this.treatmentTypeId,
    required this.languageCode,
  });
}

class SelectApplicableTreatmentRequested
    extends OffersEvent {
  final int treatmentId;

  const SelectApplicableTreatmentRequested({
    required this.treatmentId,
  });
}

class ApplyToOfferRequested extends OffersEvent {
  final int offerId;
  final int treatmentId;
  final String languageCode;

  const ApplyToOfferRequested({
    required this.offerId,
    required this.treatmentId,
    required this.languageCode,
  });
}

class ResetOfferActionStateRequested
    extends OffersEvent {
  const ResetOfferActionStateRequested();
}