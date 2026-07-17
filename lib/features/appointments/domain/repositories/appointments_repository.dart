import '../../../../core/cache/cached_result.dart';
import '../entities/appointment_entity.dart';

abstract class AppointmentsRepository {
  Future<CachedResult<List<AppointmentEntity>>> showAppointments({
    required String languageCode,
  });

  Future<CachedResult<List<AppointmentEntity>>>
  showPreviousAppointments({
    required String languageCode,
  });

  Future<CachedResult<AppointmentEntity>> showAppointmentDetails({
    required int appointmentId,
    required String languageCode,
  });

  Future<String> cancelAppointment({
    required int appointmentId,
    required String languageCode,
  });
}