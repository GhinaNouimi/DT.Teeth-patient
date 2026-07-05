import 'package:dio/dio.dart';

import '../../../../../core/network/api_constants.dart';
import '../../models/add_dentist_rate_response_model.dart';
import '../../models/show_all_dentists_response_model.dart';
import '../../models/show_dentist_details_response_model.dart';
import '../../models/show_dentist_rate_response_model.dart';
import '../../models/show_dentists_by_specialization_response_model.dart';

abstract class DoctorsRemoteDataSource {
  Future<ShowAllDentistsResponseModel> showAllDentists();

  Future<ShowDentistDetailsResponseModel> showDentistDetails(
      int dentistId,
      );

  Future<ShowDentistsBySpecializationResponseModel>
  showDentistsBySpecialization(
      int specializationId,
      );

  Future<ShowDentistRateResponseModel> showDentistRate(
      int dentistId,
      );

  Future<AddDentistRateResponseModel> addDentistRate({
    required int dentistId,
    required int rating,
  });
}

class DoctorsRemoteDataSourceImpl
    implements DoctorsRemoteDataSource {
  final Dio dio;

  DoctorsRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<ShowAllDentistsResponseModel> showAllDentists() async {
    final response = await dio.get(
      ApiConstants.patientShowAllDentists,
    );

    return ShowAllDentistsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ShowDentistDetailsResponseModel> showDentistDetails(
      int dentistId,
      ) async {
    final response = await dio.get(
      ApiConstants.patientShowDentistDetails(
        dentistId,
      ),
    );

    return ShowDentistDetailsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ShowDentistsBySpecializationResponseModel>
  showDentistsBySpecialization(
      int specializationId,
      ) async {
    final response = await dio.get(
      ApiConstants.patientShowDentistsBySpecialization(
        specializationId,
      ),
    );

    return ShowDentistsBySpecializationResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ShowDentistRateResponseModel> showDentistRate(
      int dentistId,
      ) async {
    final response = await dio.get(
      ApiConstants.patientShowDentistRate(dentistId),
    );

    return ShowDentistRateResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<AddDentistRateResponseModel> addDentistRate({
    required int dentistId,
    required int rating,
  }) async {
    final response = await dio.post(
      ApiConstants.patientAddDentistRate(dentistId),
      data: {
        'rating': rating,
      },
    );

    return AddDentistRateResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}