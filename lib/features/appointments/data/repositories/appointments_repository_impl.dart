import '../../../../core/cache/cached_result.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/network_error_messages.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/local/appointments_local_data_source.dart';
import '../datasources/remote/appointments_remote_data_source.dart';

class AppointmentsRepositoryImpl
    implements AppointmentsRepository {
  final AppointmentsRemoteDataSource remoteDataSource;
  final AppointmentsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const AppointmentsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CachedResult<List<AppointmentEntity>>> showAppointments({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response =
        await remoteDataSource.showAppointments();

        await localDataSource.cacheUpcomingAppointments(
          response,
        );

        return CachedResult.remote(
          response.appointments,
        );
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    try {
      final cachedResponse =
      await localDataSource.getCachedUpcomingAppointments();

      return CachedResult.cache(
        cachedResponse.appointments,
      );
    } catch (_) {
      throw Exception(
        NetworkErrorMessages.noCachedData(
          languageCode,
        ),
      );
    }
  }

  @override
  Future<CachedResult<List<AppointmentEntity>>>
  showPreviousAppointments({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response =
        await remoteDataSource.showPreviousAppointments();

        await localDataSource.cachePreviousAppointments(
          response,
        );

        return CachedResult.remote(
          response.appointments,
        );
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    try {
      final cachedResponse =
      await localDataSource.getCachedPreviousAppointments();

      return CachedResult.cache(
        cachedResponse.appointments,
      );
    } catch (_) {
      throw Exception(
        NetworkErrorMessages.noCachedData(
          languageCode,
        ),
      );
    }
  }

  @override
  Future<CachedResult<AppointmentEntity>>
  showAppointmentDetails({
    required int appointmentId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response =
        await remoteDataSource.showAppointmentDetails(
          appointmentId,
        );

        await localDataSource.cacheAppointmentDetails(
          appointmentId,
          response,
        );

        return CachedResult.remote(
          response.appointment,
        );
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    try {
      final cachedResponse =
      await localDataSource.getCachedAppointmentDetails(
        appointmentId,
      );

      return CachedResult.cache(
        cachedResponse.appointment,
      );
    } catch (_) {
      throw Exception(
        NetworkErrorMessages.noCachedData(
          languageCode,
        ),
      );
    }
  }

  @override
  Future<String> cancelAppointment({
    required int appointmentId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      throw Exception(
        NetworkErrorMessages.offlineActionNotAllowed(
          languageCode,
        ),
      );
    }

    try {
      final response =
      await remoteDataSource.cancelAppointment(
        appointmentId,
      );

      if (!response.success) {
        throw Exception(response.message);
      }

      await _refreshAppointmentsCacheAfterCancellation(
        appointmentId,
      );

      return response.message;
    } catch (error) {
      throw Exception(
        ApiErrorHandler.handle(
          error,
          languageCode: languageCode,
        ),
      );
    }
  }

  Future<void> _refreshAppointmentsCacheAfterCancellation(
      int appointmentId,
      ) async {
    try {
      final upcomingResponse =
      await remoteDataSource.showAppointments();

      await localDataSource.cacheUpcomingAppointments(
        upcomingResponse,
      );

      final previousResponse =
      await remoteDataSource.showPreviousAppointments();

      await localDataSource.cachePreviousAppointments(
        previousResponse,
      );

      final detailsResponse =
      await remoteDataSource.showAppointmentDetails(
        appointmentId,
      );

      await localDataSource.cacheAppointmentDetails(
        appointmentId,
        detailsResponse,
      );
    } catch (_) {
      // إلغاء الموعد نجح بالفعل.
      // فشل تحديث الكاش لا يجب أن يحوّل العملية إلى فشل للمستخدم.
    }
  }
}