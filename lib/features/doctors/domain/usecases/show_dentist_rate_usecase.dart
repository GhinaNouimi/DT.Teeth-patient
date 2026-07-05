import '../repositories/doctors_repository.dart';

class ShowDentistRateUseCase {
  final DoctorsRepository repository;

  const ShowDentistRateUseCase({
    required this.repository,
  });

  Future<int> call({
    required int dentistId,
    required String languageCode,
  }) {
    return repository.showDentistRate(
      dentistId: dentistId,
      languageCode: languageCode,
    );
  }
}