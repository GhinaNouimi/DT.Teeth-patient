import 'package:dt_teeth/core/cache/cached_result.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_action_result_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_entity.dart';
import 'package:dt_teeth/features/appointments/domain/repositories/appointments_repository.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/add_appointment_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/cancel_appointment_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_appointment_details_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_appointments_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_previous_appointments_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/update_appointment_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentsRepository extends Mock
    implements AppointmentsRepository {}

AppointmentEntity fixtureAppointment() {
  return AppointmentEntity(
    id: 23,
    dentistId: 4,
    dentistName: 'Dr. Lina',
    appointmentTypeName: 'كشف عام',
    appointmentTypeNameEn: 'General Checkup',
    type: AppointmentBookingType.newTreatment,
    status: AppointmentStatus.pending,
    appointmentTime: DateTime(2026, 8, 26, 10),
  );
}

void main() {
  late MockAppointmentsRepository repository;

  setUp(() {
    repository = MockAppointmentsRepository();
  });

  test(
    'UT-APP-01 ShowAppointmentsUseCase forwards language and result',
    () async {
      final expected = CachedResult<List<AppointmentEntity>>.remote(
        <AppointmentEntity>[fixtureAppointment()],
      );
      when(
        () => repository.showAppointments(languageCode: 'ar'),
      ).thenAnswer((_) async => expected);

      final result = await ShowAppointmentsUseCase(repository: repository)(
        languageCode: 'ar',
      );

      expect(result, same(expected));
      verify(() => repository.showAppointments(languageCode: 'ar')).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'UT-APP-02 ShowPreviousAppointmentsUseCase forwards language and result',
    () async {
      final expected = CachedResult<List<AppointmentEntity>>.cache(
        <AppointmentEntity>[fixtureAppointment()],
      );
      when(
        () => repository.showPreviousAppointments(languageCode: 'en'),
      ).thenAnswer((_) async => expected);

      final result = await ShowPreviousAppointmentsUseCase(
        repository: repository,
      )(languageCode: 'en');

      expect(result, same(expected));
      verify(
        () => repository.showPreviousAppointments(languageCode: 'en'),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'UT-APP-03 ShowAppointmentDetailsUseCase forwards id and language',
    () async {
      final expected = CachedResult<AppointmentEntity>.remote(
        fixtureAppointment(),
      );
      when(
        () => repository.showAppointmentDetails(
          appointmentId: 23,
          languageCode: 'ar',
        ),
      ).thenAnswer((_) async => expected);

      final result = await ShowAppointmentDetailsUseCase(
        repository: repository,
      )(appointmentId: 23, languageCode: 'ar');

      expect(result, same(expected));
      verify(
        () => repository.showAppointmentDetails(
          appointmentId: 23,
          languageCode: 'ar',
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'UT-APP-04 AddAppointmentUseCase forwards the complete booking request',
    () async {
      final time = DateTime(2026, 8, 26, 10);
      final expected = AppointmentActionResultEntity(
        message: 'Booking request sent',
        appointment: fixtureAppointment(),
      );
      when(
        () => repository.addAppointment(
          dentistId: 4,
          appointmentTypeId: 1,
          appointmentTime: time,
          type: AppointmentBookingType.continueTreatment,
          treatmentId: 9,
          notes: 'Morning appointment',
          languageCode: 'en',
        ),
      ).thenAnswer((_) async => expected);

      final result = await AddAppointmentUseCase(repository: repository)(
        dentistId: 4,
        appointmentTypeId: 1,
        appointmentTime: time,
        type: AppointmentBookingType.continueTreatment,
        treatmentId: 9,
        notes: 'Morning appointment',
        languageCode: 'en',
      );

      expect(result, same(expected));
      verify(
        () => repository.addAppointment(
          dentistId: 4,
          appointmentTypeId: 1,
          appointmentTime: time,
          type: AppointmentBookingType.continueTreatment,
          treatmentId: 9,
          notes: 'Morning appointment',
          languageCode: 'en',
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test('UT-APP-05 UpdateAppointmentUseCase forwards changed values', () async {
    final time = DateTime(2026, 8, 27, 11);
    final expected = AppointmentActionResultEntity(
      message: 'Update request sent',
      appointment: fixtureAppointment(),
    );
    when(
      () => repository.updateAppointment(
        appointmentId: 23,
        appointmentTime: time,
        notes: 'Updated note',
        languageCode: 'ar',
      ),
    ).thenAnswer((_) async => expected);

    final result = await UpdateAppointmentUseCase(repository: repository)(
      appointmentId: 23,
      appointmentTime: time,
      notes: 'Updated note',
      languageCode: 'ar',
    );

    expect(result, same(expected));
    verify(
      () => repository.updateAppointment(
        appointmentId: 23,
        appointmentTime: time,
        notes: 'Updated note',
        languageCode: 'ar',
      ),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('UT-APP-06 CancelAppointmentUseCase forwards id and language', () async {
    when(
      () => repository.cancelAppointment(appointmentId: 23, languageCode: 'ar'),
    ).thenAnswer((_) async => 'Appointment cancelled');

    final result = await CancelAppointmentUseCase(repository: repository)(
      appointmentId: 23,
      languageCode: 'ar',
    );

    expect(result, 'Appointment cancelled');
    verify(
      () => repository.cancelAppointment(appointmentId: 23, languageCode: 'ar'),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });
}
