import 'dart:convert';

import '../../../../../core/cache/cache_keys.dart';
import '../../../../../core/cache/cache_service.dart';
import '../../models/show_appointment_details_response_model.dart';
import '../../models/show_appointment_types_response_model.dart';
import '../../models/show_appointments_response_model.dart';
import '../../models/show_dentist_schedule_response_model.dart';
import '../../models/show_dentists_by_appointment_type_response_model.dart';

abstract class AppointmentsLocalDataSource {
  Future<void> cacheUpcomingAppointments(
      ShowAppointmentsResponseModel response,
      );

  Future<ShowAppointmentsResponseModel>
  getCachedUpcomingAppointments();

  Future<void> cachePreviousAppointments(
      ShowAppointmentsResponseModel response,
      );

  Future<ShowAppointmentsResponseModel>
  getCachedPreviousAppointments();

  Future<void> cacheAppointmentDetails(
      int appointmentId,
      ShowAppointmentDetailsResponseModel response,
      );

  Future<ShowAppointmentDetailsResponseModel>
  getCachedAppointmentDetails(
      int appointmentId,
      );

  Future<void> cacheAppointmentTypes(
      ShowAppointmentTypesResponseModel response,
      );

  Future<ShowAppointmentTypesResponseModel>
  getCachedAppointmentTypes();

  Future<void> cacheDentistsByAppointmentType(
      int appointmentTypeId,
      ShowDentistsByAppointmentTypeResponseModel response,
      );

  Future<ShowDentistsByAppointmentTypeResponseModel>
  getCachedDentistsByAppointmentType(
      int appointmentTypeId,
      );

  Future<void> cacheDentistSchedule(
      int dentistId,
      ShowDentistScheduleResponseModel response,
      );

  Future<ShowDentistScheduleResponseModel>
  getCachedDentistSchedule(
      int dentistId,
      );
}

class AppointmentsLocalDataSourceImpl
    implements AppointmentsLocalDataSource {
  const AppointmentsLocalDataSourceImpl();

  @override
  Future<void> cacheUpcomingAppointments(
      ShowAppointmentsResponseModel response,
      ) async {
    await CacheService.saveString(
      key: CacheKeys.upcomingAppointments,
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowAppointmentsResponseModel>
  getCachedUpcomingAppointments() async {
    final cachedData = await CacheService.getString(
      key: CacheKeys.upcomingAppointments,
    );

    final decodedData = jsonDecode(cachedData);

    return ShowAppointmentsResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cachePreviousAppointments(
      ShowAppointmentsResponseModel response,
      ) async {
    await CacheService.saveString(
      key: CacheKeys.pastAppointments,
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowAppointmentsResponseModel>
  getCachedPreviousAppointments() async {
    final cachedData = await CacheService.getString(
      key: CacheKeys.pastAppointments,
    );

    final decodedData = jsonDecode(cachedData);

    return ShowAppointmentsResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cacheAppointmentDetails(
      int appointmentId,
      ShowAppointmentDetailsResponseModel response,
      ) async {
    await CacheService.saveString(
      key: _appointmentDetailsKey(
        appointmentId,
      ),
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowAppointmentDetailsResponseModel>
  getCachedAppointmentDetails(
      int appointmentId,
      ) async {
    final cachedData = await CacheService.getString(
      key: _appointmentDetailsKey(
        appointmentId,
      ),
    );

    final decodedData = jsonDecode(cachedData);

    return ShowAppointmentDetailsResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cacheDentistsByAppointmentType(
      int appointmentTypeId,
      ShowDentistsByAppointmentTypeResponseModel response,
      ) async {
    await CacheService.saveString(
      key: _dentistsByAppointmentTypeKey(
        appointmentTypeId,
      ),
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowDentistsByAppointmentTypeResponseModel>
  getCachedDentistsByAppointmentType(
      int appointmentTypeId,
      ) async {
    final cachedData = await CacheService.getString(
      key: _dentistsByAppointmentTypeKey(
        appointmentTypeId,
      ),
    );

    final decodedData = jsonDecode(cachedData);

    return ShowDentistsByAppointmentTypeResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  String _dentistsByAppointmentTypeKey(
      int appointmentTypeId,
      ) {
    return '${CacheKeys.dentistsByAppointmentTypePrefix}'
        '$appointmentTypeId';
  }

  @override
  Future<void> cacheAppointmentTypes(
      ShowAppointmentTypesResponseModel response,
      ) async {
    await CacheService.saveString(
      key: CacheKeys.appointmentTypes,
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowAppointmentTypesResponseModel>
  getCachedAppointmentTypes() async {
    final cachedData = await CacheService.getString(
      key: CacheKeys.appointmentTypes,
    );

    final decodedData = jsonDecode(cachedData);

    return ShowAppointmentTypesResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cacheDentistSchedule(
      int dentistId,
      ShowDentistScheduleResponseModel response,
      ) async {
    await CacheService.saveString(
      key: _dentistScheduleKey(
        dentistId,
      ),
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowDentistScheduleResponseModel>
  getCachedDentistSchedule(
      int dentistId,
      ) async {
    final cachedData = await CacheService.getString(
      key: _dentistScheduleKey(
        dentistId,
      ),
    );

    final decodedData = jsonDecode(cachedData);

    return ShowDentistScheduleResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  String _dentistScheduleKey(
      int dentistId,
      ) {
    return '${CacheKeys.dentistSchedulePrefix}'
        '$dentistId';
  }

  String _appointmentDetailsKey(
      int appointmentId,
      ) {
    return '${CacheKeys.appointmentDetailsPrefix}'
        '$appointmentId';
  }


}