import '../../../../core/cache/cached_result.dart';
import '../entities/appointment_booking_dentist_entity.dart';
import '../repositories/appointments_repository.dart';

class ShowDentistsByAppointmentTypeUseCase {
  final AppointmentsRepository repository;

  const ShowDentistsByAppointmentTypeUseCase({
    required this.repository,
  });

  Future<CachedResult<List<AppointmentBookingDentistEntity>>> call({
    required int appointmentTypeId,
    required String languageCode,
  }) {
    return repository.showDentistsByAppointmentType(
      appointmentTypeId: appointmentTypeId,
      languageCode: languageCode,
    );
  }
}