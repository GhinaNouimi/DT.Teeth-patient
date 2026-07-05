import '../repositories/doctors_repository.dart';

class AddDentistRateUseCase {
  final DoctorsRepository repository;

  const AddDentistRateUseCase({
    required this.repository,
  });

  Future<int> call({
    required int dentistId,
    required int rating,
    required String languageCode,
  }) {
    return repository.addDentistRate(
      dentistId: dentistId,
      rating: rating,
      languageCode: languageCode,
    );
  }
}