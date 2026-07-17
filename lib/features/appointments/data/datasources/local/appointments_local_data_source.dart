import 'dart:convert';

import '../../../../../core/cache/cache_keys.dart';
import '../../../../../core/cache/cache_service.dart';
import '../../models/show_appointment_details_response_model.dart';
import '../../models/show_appointments_response_model.dart';

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
      key: _appointmentDetailsKey(appointmentId),
      value: jsonEncode(response.toJson()),
    );
  }

  @override
  Future<ShowAppointmentDetailsResponseModel>
  getCachedAppointmentDetails(
      int appointmentId,
      ) async {
    final cachedData = await CacheService.getString(
      key: _appointmentDetailsKey(appointmentId),
    );

    final decodedData = jsonDecode(cachedData);

    return ShowAppointmentDetailsResponseModel.fromJson(
      decodedData as Map<String, dynamic>,
    );
  }

  String _appointmentDetailsKey(int appointmentId) {
    return '${CacheKeys.appointmentDetailsPrefix}$appointmentId';
  }
}