import '../../../../core/cache/cached_result.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/network_error_messages.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/appointment_action_result_entity.dart';
import '../../domain/entities/appointment_booking_dentist_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_type_entity.dart';
import '../../domain/entities/dentist_schedule_entity.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/local/appointments_local_data_source.dart';
import '../datasources/remote/appointments_remote_data_source.dart';
import '../models/add_appointment_request_model.dart';
import '../models/update_appointment_request_model.dart';

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
  Future<CachedResult<List<AppointmentEntity>>>
  showAppointments({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response =
        await remoteDataSource.showAppointments();

        await localDataSource
            .cacheUpcomingAppointments(
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
      await localDataSource
          .getCachedUpcomingAppointments();

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
        await remoteDataSource
            .showPreviousAppointments();

        await localDataSource
            .cachePreviousAppointments(
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
      await localDataSource
          .getCachedPreviousAppointments();

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
        await remoteDataSource
            .showAppointmentDetails(
          appointmentId,
        );

        await localDataSource
            .cacheAppointmentDetails(
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
      await localDataSource
          .getCachedAppointmentDetails(
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
  Future<CachedResult<List<AppointmentTypeEntity>>>
  showAppointmentTypes({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response =
        await remoteDataSource
            .showAppointmentTypes();

        await localDataSource
            .cacheAppointmentTypes(
          response,
        );

        return CachedResult.remote(
          response.appointmentTypes,
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
      await localDataSource
          .getCachedAppointmentTypes();

      return CachedResult.cache(
        cachedResponse.appointmentTypes,
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
  Future<
      CachedResult<
          List<AppointmentBookingDentistEntity>>>
  showDentistsByAppointmentType({
    required int appointmentTypeId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response =
        await remoteDataSource
            .showDentistsByAppointmentType(
          appointmentTypeId,
        );

        await localDataSource
            .cacheDentistsByAppointmentType(
          appointmentTypeId,
          response,
        );

        return CachedResult.remote(
          response.dentists,
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
      await localDataSource
          .getCachedDentistsByAppointmentType(
        appointmentTypeId,
      );

      return CachedResult.cache(
        cachedResponse.dentists,
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
  Future<CachedResult<DentistScheduleEntity>>
  showDentistSchedule({
    required int dentistId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response =
        await remoteDataSource
            .showDentistSchedule(
          dentistId,
        );

        await localDataSource
            .cacheDentistSchedule(
          dentistId,
          response,
        );

        return CachedResult.remote(
          response.schedule,
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
      await localDataSource
          .getCachedDentistSchedule(
        dentistId,
      );

      return CachedResult.cache(
        cachedResponse.schedule,
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
  Future<AppointmentActionResultEntity>
  addAppointment({
    required int dentistId,
    required int appointmentTypeId,
    required DateTime appointmentTime,
    required AppointmentBookingType type,
    int? treatmentId,
    String? notes,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      throw Exception(
        NetworkErrorMessages
            .offlineActionNotAllowed(
          languageCode,
        ),
      );
    }

    try {
      final request = AddAppointmentRequestModel(
        dentistId: dentistId,
        appointmentTypeId: appointmentTypeId,
        appointmentTime: appointmentTime,
        type: type,
        treatmentId: treatmentId,
        notes: notes,
      );

      final response =
      await remoteDataSource.addAppointment(
        request,
      );

      if (!response.success) {
        throw Exception(response.message);
      }

      await _refreshAppointmentsCacheAfterWrite(
        appointmentId:
        response.appointment.id,
        dentistId: dentistId,
      );

      return AppointmentActionResultEntity(
        message: response.message,
        appointment: response.appointment,
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

  @override
  Future<AppointmentActionResultEntity>
  updateAppointment({
    required int appointmentId,
    required DateTime appointmentTime,
    String? notes,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      throw Exception(
        NetworkErrorMessages
            .offlineActionNotAllowed(
          languageCode,
        ),
      );
    }

    try {
      final request =
      UpdateAppointmentRequestModel(
        appointmentTime: appointmentTime,
        notes: notes,
      );

      final response =
      await remoteDataSource.updateAppointment(
        appointmentId,
        request,
      );

      if (!response.success) {
        throw Exception(response.message);
      }

      await _refreshAppointmentsCacheAfterWrite(
        appointmentId: appointmentId,
      );

      return AppointmentActionResultEntity(
        message: response.message,
        appointment: response.appointment,
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

  @override
  Future<String> cancelAppointment({
    required int appointmentId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      throw Exception(
        NetworkErrorMessages
            .offlineActionNotAllowed(
          languageCode,
        ),
      );
    }

    try {
      final response =
      await remoteDataSource
          .cancelAppointment(
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

  Future<void> _refreshAppointmentsCacheAfterWrite({
    required int appointmentId,
    int? dentistId,
  }) async {
    try {
      final upcomingResponse =
      await remoteDataSource.showAppointments();

      await localDataSource
          .cacheUpcomingAppointments(
        upcomingResponse,
      );
    } catch (_) {
      // نجاح العملية الأساسية لا يعتمد
      // على نجاح تحديث كاش المواعيد القادمة.
    }

    try {
      final previousResponse =
      await remoteDataSource
          .showPreviousAppointments();

      await localDataSource
          .cachePreviousAppointments(
        previousResponse,
      );
    } catch (_) {
      // فشل تحديث كاش المواعيد السابقة
      // لا يحول العملية الأساسية إلى فشل.
    }

    try {
      final detailsResponse =
      await remoteDataSource
          .showAppointmentDetails(
        appointmentId,
      );

      await localDataSource
          .cacheAppointmentDetails(
        appointmentId,
        detailsResponse,
      );
    } catch (_) {
      // قد لا تصبح التفاصيل متاحة مباشرة
      // بعد إرسال طلب الحجز أو التعديل.
    }

    if (dentistId == null) {
      return;
    }

    try {
      final scheduleResponse =
      await remoteDataSource
          .showDentistSchedule(
        dentistId,
      );

      await localDataSource
          .cacheDentistSchedule(
        dentistId,
        scheduleResponse,
      );
    } catch (_) {
      // فشل تحديث جدول الطبيب لا يلغي
      // نجاح عملية الحجز.
    }
  }

  Future<void>
  _refreshAppointmentsCacheAfterCancellation(
      int appointmentId,
      ) async {
    try {
      final upcomingResponse =
      await remoteDataSource.showAppointments();

      await localDataSource
          .cacheUpcomingAppointments(
        upcomingResponse,
      );

      final previousResponse =
      await remoteDataSource
          .showPreviousAppointments();

      await localDataSource
          .cachePreviousAppointments(
        previousResponse,
      );

      final detailsResponse =
      await remoteDataSource
          .showAppointmentDetails(
        appointmentId,
      );

      await localDataSource
          .cacheAppointmentDetails(
        appointmentId,
        detailsResponse,
      );
    } catch (_) {
      // إلغاء الموعد نجح بالفعل.
      // فشل تحديث الكاش لا يجب أن يحول
      // العملية إلى فشل للمستخدم.
    }
  }
}