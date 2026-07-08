abstract class TreatmentEvent {
  const TreatmentEvent();
}

class LoadTreatmentsRequested extends TreatmentEvent {
  final String languageCode;

  const LoadTreatmentsRequested({
    required this.languageCode,
  });
}

class LoadTreatmentDetailsRequested extends TreatmentEvent {
  final int treatmentId;
  final String languageCode;

  const LoadTreatmentDetailsRequested({
    required this.treatmentId,
    required this.languageCode,
  });
}