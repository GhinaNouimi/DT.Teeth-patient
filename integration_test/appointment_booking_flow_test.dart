import 'package:dt_teeth/core/cache/cached_result.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_action_result_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_booking_dentist_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_type_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/dentist_schedule_entity.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/add_appointment_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/get_bookable_treatments_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_appointment_types_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_dentist_schedule_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_dentists_by_appointment_type_use_case.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointment_booking/appointment_booking_bloc.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointment_booking/appointment_booking_event.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointment_booking/appointment_booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShowAppointmentTypesUseCase extends Mock
    implements ShowAppointmentTypesUseCase {}

class MockShowDentistsByAppointmentTypeUseCase extends Mock
    implements ShowDentistsByAppointmentTypeUseCase {}

class MockShowDentistScheduleUseCase extends Mock
    implements ShowDentistScheduleUseCase {}

class MockGetBookableTreatmentsUseCase extends Mock
    implements GetBookableTreatmentsUseCase {}

class MockAddAppointmentUseCase extends Mock implements AddAppointmentUseCase {}

const appointmentType = AppointmentTypeEntity(
  id: 1,
  name: 'كشف عام',
  nameEn: 'General Checkup',
  specializations: <AppointmentTypeSpecializationEntity>[],
);

const dentist = AppointmentBookingDentistEntity(
  id: 4,
  name: 'Dr. Lina',
  specializationName: 'طب أسنان الأطفال',
  specializationNameEn: 'Pediatric Dentistry',
  yearsOfExperience: 7,
  averageRating: 3.8,
);

final selectedTime = DateTime(2026, 8, 26, 10);

DentistScheduleEntity schedule() {
  return DentistScheduleEntity(
    dentistId: 4,
    days: <DentistScheduleDayEntity>[
      DentistScheduleDayEntity(
        date: DateTime(2026, 8, 26),
        day: 'Wednesday',
        slots: <AppointmentSlotEntity>[
          AppointmentSlotEntity(time: '10:00', dateTime: selectedTime),
        ],
      ),
    ],
  );
}

AppointmentEntity createdAppointment() {
  return AppointmentEntity(
    id: 23,
    dentistId: 4,
    dentistName: 'Dr. Lina',
    appointmentTypeName: 'كشف عام',
    appointmentTypeNameEn: 'General Checkup',
    type: AppointmentBookingType.newTreatment,
    status: AppointmentStatus.pending,
    appointmentTime: selectedTime,
  );
}

Future<AppointmentBookingLoaded> waitForLoaded(
  AppointmentBookingBloc bloc,
  bool Function(AppointmentBookingLoaded state) predicate,
) {
  final current = bloc.state;
  if (current is AppointmentBookingLoaded && predicate(current)) {
    return Future<AppointmentBookingLoaded>.value(current);
  }

  return bloc.stream
      .where((state) => state is AppointmentBookingLoaded)
      .cast<AppointmentBookingLoaded>()
      .firstWhere(predicate);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('IT-BOOK-01 complete appointment booking flow', (tester) async {
    final showTypes = MockShowAppointmentTypesUseCase();
    final showDentists = MockShowDentistsByAppointmentTypeUseCase();
    final showSchedule = MockShowDentistScheduleUseCase();
    final getTreatments = MockGetBookableTreatmentsUseCase();
    final addAppointment = MockAddAppointmentUseCase();

    when(() => showTypes(languageCode: 'en')).thenAnswer(
      (_) async => const CachedResult<List<AppointmentTypeEntity>>.remote(
        <AppointmentTypeEntity>[appointmentType],
      ),
    );
    when(
      () => showDentists(appointmentTypeId: 1, languageCode: 'en'),
    ).thenAnswer(
      (_) async =>
          const CachedResult<List<AppointmentBookingDentistEntity>>.remote(
            <AppointmentBookingDentistEntity>[dentist],
          ),
    );
    when(() => showSchedule(dentistId: 4, languageCode: 'en')).thenAnswer(
      (_) async => CachedResult<DentistScheduleEntity>.remote(schedule()),
    );
    when(
      () => addAppointment(
        dentistId: 4,
        appointmentTypeId: 1,
        appointmentTime: selectedTime,
        type: AppointmentBookingType.newTreatment,
        treatmentId: null,
        notes: 'Patient note',
        languageCode: 'en',
      ),
    ).thenAnswer(
      (_) async => AppointmentActionResultEntity(
        message: 'Booking request sent',
        appointment: createdAppointment(),
      ),
    );

    final bloc = AppointmentBookingBloc(
      showAppointmentTypesUseCase: showTypes,
      showDentistsByAppointmentTypeUseCase: showDentists,
      showDentistScheduleUseCase: showSchedule,
      getBookableTreatmentsUseCase: getTreatments,
      addAppointmentUseCase: addAppointment,
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: Scaffold(
            body: BlocBuilder<AppointmentBookingBloc, AppointmentBookingState>(
              builder: (context, state) {
                if (state is AppointmentBookingLoaded &&
                    state.isSubmissionSuccess) {
                  return const Text('booking-success');
                }
                if (state is AppointmentBookingLoaded) {
                  return Text(
                    'booking-ready-${state.selectedAppointmentTime != null}',
                  );
                }
                if (state is AppointmentBookingError) {
                  return Text('booking-error-${state.message}');
                }
                return const Text('booking-loading');
              },
            ),
          ),
        ),
      ),
    );

    bloc.add(const LoadAppointmentTypesRequested(languageCode: 'en'));
    await waitForLoaded(bloc, (state) => state.appointmentTypes.isNotEmpty);

    bloc.add(
      const AppointmentBookingTypeSelected(
        bookingType: AppointmentBookingType.newTreatment,
        languageCode: 'en',
      ),
    );
    await waitForLoaded(
      bloc,
      (state) =>
          state.selectedBookingType == AppointmentBookingType.newTreatment,
    );

    bloc.add(
      const AppointmentTypeSelected(appointmentTypeId: 1, languageCode: 'en'),
    );
    await waitForLoaded(bloc, (state) => state.dentists.isNotEmpty);

    bloc.add(
      const AppointmentDentistSelected(dentistId: 4, languageCode: 'en'),
    );
    await waitForLoaded(bloc, (state) => state.dentistSchedule != null);

    bloc.add(AppointmentSlotSelected(appointmentTime: selectedTime));
    await waitForLoaded(
      bloc,
      (state) => state.selectedAppointmentTime == selectedTime,
    );

    bloc.add(
      const AddAppointmentRequested(notes: 'Patient note', languageCode: 'en'),
    );
    await waitForLoaded(bloc, (state) => state.isSubmissionSuccess);
    await tester.pump();

    expect(find.text('booking-success'), findsOneWidget);
    expect(
      (bloc.state as AppointmentBookingLoaded).submissionResult?.appointment.id,
      23,
    );
    verify(
      () => addAppointment(
        dentistId: 4,
        appointmentTypeId: 1,
        appointmentTime: selectedTime,
        type: AppointmentBookingType.newTreatment,
        treatmentId: null,
        notes: 'Patient note',
        languageCode: 'en',
      ),
    ).called(1);
    expect(tester.takeException(), isNull);
  });
}
