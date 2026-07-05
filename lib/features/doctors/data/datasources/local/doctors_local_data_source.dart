import 'dart:convert';

import '../../../../../core/cache/cache_keys.dart';
import '../../../../../core/cache/cache_service.dart';
import '../../models/show_all_dentists_response_model.dart';
import '../../models/show_dentist_details_response_model.dart';
import '../../models/show_dentists_by_specialization_response_model.dart';

abstract class DoctorsLocalDataSource {
  Future<void> cacheDentists(
      ShowAllDentistsResponseModel response,
      );

  Future<ShowAllDentistsResponseModel> getCachedDentists();

  Future<void> cacheDentistDetails(
      int dentistId,
      ShowDentistDetailsResponseModel response,
      );

  Future<ShowDentistDetailsResponseModel> getCachedDentistDetails(
      int dentistId,
      );

  Future<void> cacheDentistsBySpecialization(
      int specializationId,
      ShowDentistsBySpecializationResponseModel response,
      );

  Future<ShowDentistsBySpecializationResponseModel>
  getCachedDentistsBySpecialization(
      int specializationId,
      );
}

class DoctorsLocalDataSourceImpl implements DoctorsLocalDataSource {
  const DoctorsLocalDataSourceImpl();

  @override
  Future<void> cacheDentists(
      ShowAllDentistsResponseModel response,
      ) async {
    await CacheService.saveString(
      key: CacheKeys.doctors,
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowAllDentistsResponseModel> getCachedDentists() async {
    final cachedData = await CacheService.getString(
      key: CacheKeys.doctors,
    );

    final decodedData = jsonDecode(cachedData);

    return ShowAllDentistsResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cacheDentistDetails(
      int dentistId,
      ShowDentistDetailsResponseModel response,
      ) async {
    await CacheService.saveString(
      key: _dentistDetailsKey(dentistId),
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowDentistDetailsResponseModel> getCachedDentistDetails(
      int dentistId,
      ) async {
    final cachedData = await CacheService.getString(
      key: _dentistDetailsKey(dentistId),
    );

    final decodedData = jsonDecode(cachedData);

    return ShowDentistDetailsResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cacheDentistsBySpecialization(
      int specializationId,
      ShowDentistsBySpecializationResponseModel response,
      ) async {
    await CacheService.saveString(
      key: _dentistsBySpecializationKey(specializationId),
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowDentistsBySpecializationResponseModel>
  getCachedDentistsBySpecialization(
      int specializationId,
      ) async {
    final cachedData = await CacheService.getString(
      key: _dentistsBySpecializationKey(specializationId),
    );

    final decodedData = jsonDecode(cachedData);

    return ShowDentistsBySpecializationResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  String _dentistDetailsKey(int dentistId) {
    return '${CacheKeys.dentistDetailsPrefix}$dentistId';  }

  String _dentistsBySpecializationKey(int specializationId) {
    return '${CacheKeys.doctorsBySpecialtyPrefix}$specializationId';
  }
}