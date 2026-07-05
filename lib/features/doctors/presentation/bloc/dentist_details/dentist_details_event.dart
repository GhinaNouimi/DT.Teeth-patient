abstract class DentistDetailsEvent {
  const DentistDetailsEvent();
}

class ShowDentistDetailsRequested extends DentistDetailsEvent {
  final int dentistId;
  final String languageCode;

  const ShowDentistDetailsRequested({
    required this.dentistId,
    required this.languageCode,
  });
}