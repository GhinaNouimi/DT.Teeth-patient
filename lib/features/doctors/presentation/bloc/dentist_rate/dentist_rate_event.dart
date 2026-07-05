abstract class DentistRateEvent {
  const DentistRateEvent();
}

class ShowDentistRateRequested extends DentistRateEvent {
  final int dentistId;
  final String languageCode;

  const ShowDentistRateRequested({
    required this.dentistId,
    required this.languageCode,
  });
}

class AddDentistRateRequested extends DentistRateEvent {
  final int dentistId;
  final int rating;
  final String languageCode;

  const AddDentistRateRequested({
    required this.dentistId,
    required this.rating,
    required this.languageCode,
  });
}