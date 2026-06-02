import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/register_patient_request_model.dart';
import '../../data/models/register_response_model.dart';
import '../../data/models/send_verification_request_model.dart';
import '../../data/models/send_verification_response_model.dart';
import '../../data/models/verify_email_request_model.dart';
import '../../data/models/verify_email_response_model.dart';

abstract class AuthRepository {
  Future<RegisterResponseModel> registerPatient(
      RegisterPatientRequestModel request,
      );

  Future<VerifyEmailResponseModel> verifyEmail(
      VerifyEmailRequestModel request,
      );

  Future<SendVerificationResponseModel> sendVerification(
      SendVerificationRequestModel request,
      );

  Future<LoginResponseModel> loginPatient(
      LoginRequestModel request,
      );
}