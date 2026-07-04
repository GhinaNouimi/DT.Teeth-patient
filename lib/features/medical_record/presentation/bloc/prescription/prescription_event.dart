abstract class PrescriptionEvent {
  const PrescriptionEvent();
}

class LoadPrescriptionsRequested extends PrescriptionEvent {
  final String languageCode;

  const LoadPrescriptionsRequested({
    required this.languageCode,
  });
}

class LoadPrescriptionDetailsRequested extends PrescriptionEvent {
  final int prescriptionId;
  final String languageCode;

  const LoadPrescriptionDetailsRequested({
    required this.prescriptionId,
    required this.languageCode,
  });
}