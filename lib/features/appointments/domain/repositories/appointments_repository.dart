import '../../../../core/cache/cached_result.dart';
import '../entities/appointment_action_result_entity.dart';
import '../entities/appointment_booking_dentist_entity.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_type_entity.dart';
import '../entities/dentist_schedule_entity.dart';

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

  Future<CachedResult<List<AppointmentTypeEntity>>>
  showAppointmentTypes({
    required String languageCode,
  });

  Future<CachedResult<List<AppointmentBookingDentistEntity>>>
  showDentistsByAppointmentType({
    required int appointmentTypeId,
    required String languageCode,
  });

  Future<CachedResult<DentistScheduleEntity>>
  showDentistSchedule({
    required int dentistId,
    required String languageCode,
  });

  Future<AppointmentActionResultEntity> addAppointment({
    required int dentistId,
    required int appointmentTypeId,
    required DateTime appointmentTime,
    required AppointmentBookingType type,
    int? treatmentId,
    String? notes,
    required String languageCode,
  });

  Future<AppointmentActionResultEntity> updateAppointment({
    required int appointmentId,
    required DateTime appointmentTime,
    String? notes,
    required String languageCode,
  });

  Future<String> cancelAppointment({
    required int appointmentId,
    required String languageCode,
  });
}