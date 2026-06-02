import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';

import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_patient_request_model.dart';
import '../models/register_response_model.dart';
import '../models/send_verification_request_model.dart';
import '../models/send_verification_response_model.dart';
import '../models/verify_email_request_model.dart';
import '../models/verify_email_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseModel> registerPatient(
      RegisterPatientRequestModel request,
      );

  Future<VerifyEmailResponseModel> verifyEmail(
      VerifyEmailRequestModel request,
      );

  Future<SendVerificationResponseModel> sendVerification(
      SendVerificationRequestModel request,
      );

  Future<LoginResponseModel> loginPatient(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<RegisterResponseModel> registerPatient(
      RegisterPatientRequestModel request,
      ) async {
    final response = await DioClient.dio.post(
      ApiConstants.patientRegister,
      data: request.toJson(),
    );

    return RegisterResponseModel.fromJson(response.data);
  }

  @override
  Future<VerifyEmailResponseModel> verifyEmail(
      VerifyEmailRequestModel request,
      ) async {
    final response = await DioClient.dio.post(
      ApiConstants.patientVerifyEmail,
      data: request.toJson(),
    );

    return VerifyEmailResponseModel.fromJson(response.data);
  }

  @override
  Future<SendVerificationResponseModel> sendVerification(
      SendVerificationRequestModel request,
      ) async {
    final response = await DioClient.dio.post(
      ApiConstants.patientSendVerification,
      data: request.toJson(),
    );

    return SendVerificationResponseModel.fromJson(response.data);
  }

  @override
  Future<LoginResponseModel> loginPatient(LoginRequestModel request) async {
    final response = await DioClient.dio.post(
      ApiConstants.patientLogin,
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(response.data);
  }
}