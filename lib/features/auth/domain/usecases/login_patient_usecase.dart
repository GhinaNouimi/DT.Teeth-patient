import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';
import '../../data/repositories/auth_repository.dart';

class LoginPatientUseCase {
  final AuthRepository repository;

  LoginPatientUseCase({
    required this.repository,
  });

  Future<LoginResponseModel> call(LoginRequestModel request) {
    return repository.loginPatient(request);
  }
}