import '../../data/models/send_verification_request_model.dart';
import '../../data/models/send_verification_response_model.dart';
import '../../data/repositories/auth_repository.dart';

class SendVerificationUseCase {
  final AuthRepository repository;

  SendVerificationUseCase({required this.repository});

  Future<SendVerificationResponseModel> call(
      SendVerificationRequestModel request,
      ) {
    return repository.sendVerification(request);
  }
}