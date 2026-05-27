import '../../data/models/register_patient_request_model.dart';
import '../../data/models/register_response_model.dart';
import '../../data/repositories/auth_repository.dart';

class RegisterPatientUseCase {
  final AuthRepository repository;

  RegisterPatientUseCase({
    required this.repository,
  });

  Future<RegisterResponseModel> call(
      RegisterPatientRequestModel request,
      ) {
    return repository.registerPatient(request);
  }
}