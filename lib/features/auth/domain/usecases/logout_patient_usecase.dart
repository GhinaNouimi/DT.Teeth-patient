import '../../data/repositories/auth_repository.dart';


class LogoutPatientUseCase {
  final AuthRepository repository;

  LogoutPatientUseCase({required this.repository});

  Future<void> call() {
    return repository.logoutPatient();
  }
}