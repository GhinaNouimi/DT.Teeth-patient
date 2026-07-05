abstract class DoctorsEvent {
  const DoctorsEvent();
}

class ShowAllDentistsRequested extends DoctorsEvent {
  final String languageCode;

  const ShowAllDentistsRequested({
    required this.languageCode,
  });
}

class ShowDentistsBySpecializationRequested extends DoctorsEvent {
  final int specializationId;
  final String languageCode;

  const ShowDentistsBySpecializationRequested({
    required this.specializationId,
    required this.languageCode,
  });
}