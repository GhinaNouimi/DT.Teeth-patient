import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/multipart_helper.dart';
import '../models/profile_model.dart';
import '../models/update_profile_request_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile(UpdateProfileRequestModel request);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileModel> getProfile() async {
    final response = await DioClient.dio.get(ApiConstants.patientShowProfile);
    return ProfileModel.fromApiJson(response.data);
  }

  @override
  Future<ProfileModel> updateProfile(UpdateProfileRequestModel request) async {
    final profilePicture = await MultipartHelper.imageFileToMultipart(
      file: request.profilePicture,
    );

    final formData = FormData.fromMap({
      ...request.toJson(),
      if (profilePicture != null) 'profile_picture': profilePicture,
    });

    final response = await DioClient.dio.post(
      ApiConstants.patientEditProfile,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return ProfileModel.fromApiJson(response.data);
  }
}