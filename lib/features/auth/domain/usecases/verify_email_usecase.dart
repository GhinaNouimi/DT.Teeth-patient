import '../../data/models/verify_email_request_model.dart';
import '../../data/models/verify_email_response_model.dart';
import '../../data/repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;

  VerifyEmailUseCase({
    required this.repository,
  });

  Future<VerifyEmailResponseModel> call(
      VerifyEmailRequestModel request,
      ) {
    return repository.verifyEmail(request);
  }
}