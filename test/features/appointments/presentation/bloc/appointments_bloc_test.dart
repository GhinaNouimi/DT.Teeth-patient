import 'package:bloc_test/bloc_test.dart';
import 'package:dt_teeth/core/cache/cached_result.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_entity.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/cancel_appointment_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_appointments_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_previous_appointments_use_case.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointments/appointments_bloc.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointments/appointments_event.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointments/appointments_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShowAppointmentsUseCase extends Mock
    implements ShowAppointmentsUseCase {}

class MockShowPreviousAppointmentsUseCase extends Mock
    implements ShowPreviousAppointmentsUseCase {}

class MockCancelAppointmentUseCase extends Mock
    implements CancelAppointmentUseCase {}

AppointmentEntity appointment({
  required int id,
  AppointmentStatus status = AppointmentStatus.pending,
}) {
  return AppointmentEntity(
    id: id,
    dentistId: 4,
    dentistName: 'Dr. Lina',
    appointmentTypeName: 'كشف عام',
    appointmentTypeNameEn: 'General Checkup',
    type: AppointmentBookingType.newTreatment,
    status: status,
    appointmentTime: DateTime(2026, 8, 26, 10),
  );
}

void main() {
  late MockShowAppointmentsUseCase showAppointments;
  late MockShowPreviousAppointmentsUseCase showPreviousAppointments;
  late MockCancelAppointmentUseCase cancelAppointment;

  AppointmentsBloc buildBloc() {
    return AppointmentsBloc(
      showAppointmentsUseCase: showAppointments,
      showPreviousAppointmentsUseCase: showPreviousAppointments,
      cancelAppointmentUseCase: cancelAppointment,
    );
  }

  setUp(() {
    showAppointments = MockShowAppointmentsUseCase();
    showPreviousAppointments = MockShowPreviousAppointmentsUseCase();
    cancelAppointment = MockCancelAppointmentUseCase();
  });

  test('BT-APP-00 starts with AppointmentsInitial', () {
    final bloc = buildBloc();

    expect(bloc.state, isA<AppointmentsInitial>());

    bloc.close();
  });

  blocTest<AppointmentsBloc, AppointmentsState>(
    'BT-APP-01 emits Loading then Loaded for successful remote lists',
    setUp: () {
      when(() => showAppointments(languageCode: 'ar')).thenAnswer(
        (_) async => CachedResult<List<AppointmentEntity>>.remote(
          <AppointmentEntity>[appointment(id: 1)],
        ),
      );
      when(() => showPreviousAppointments(languageCode: 'ar')).thenAnswer(
        (_) async =>
            CachedResult<List<AppointmentEntity>>.remote(<AppointmentEntity>[
              appointment(id: 2, status: AppointmentStatus.completed),
            ]),
      );
    },
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const LoadAppointmentsRequested(languageCode: 'ar')),
    expect: () => <dynamic>[
      isA<AppointmentsLoading>(),
      isA<AppointmentsLoaded>()
          .having(
            (state) => state.upcomingAppointments.length,
            'upcoming count',
            1,
          )
          .having((state) => state.pastAppointments.length, 'past count', 1)
          .having((state) => state.isFromCache, 'isFromCache', isFalse),
    ],
    verify: (_) {
      verify(() => showAppointments(languageCode: 'ar')).called(1);
      verify(() => showPreviousAppointments(languageCode: 'ar')).called(1);
    },
  );

  blocTest<AppointmentsBloc, AppointmentsState>(
    'BT-APP-02 preserves cache source flags when loading cached lists',
    setUp: () {
      when(() => showAppointments(languageCode: 'en')).thenAnswer(
        (_) async => CachedResult<List<AppointmentEntity>>.cache(
          <AppointmentEntity>[appointment(id: 1)],
        ),
      );
      when(() => showPreviousAppointments(languageCode: 'en')).thenAnswer(
        (_) async => const CachedResult<List<AppointmentEntity>>.cache(
          <AppointmentEntity>[],
        ),
      );
    },
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const LoadAppointmentsRequested(languageCode: 'en')),
    expect: () => <dynamic>[
      isA<AppointmentsLoading>(),
      isA<AppointmentsLoaded>()
          .having(
            (state) => state.isUpcomingFromCache,
            'upcoming cache',
            isTrue,
          )
          .having((state) => state.isPastFromCache, 'past cache', isTrue)
          .having((state) => state.isFromCache, 'combined cache flag', isTrue),
    ],
  );

  blocTest<AppointmentsBloc, AppointmentsState>(
    'BT-APP-03 emits Error without requesting past list when upcoming fails',
    setUp: () {
      when(
        () => showAppointments(languageCode: 'ar'),
      ).thenThrow(Exception('Unable to load appointments'));
    },
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const LoadAppointmentsRequested(languageCode: 'ar')),
    expect: () => <dynamic>[
      isA<AppointmentsLoading>(),
      isA<AppointmentsError>().having(
        (state) => state.message,
        'message',
        'Unable to load appointments',
      ),
    ],
    verify: (_) {
      verify(() => showAppointments(languageCode: 'ar')).called(1);
      verifyNever(
        () =>
            showPreviousAppointments(languageCode: any(named: 'languageCode')),
      );
    },
  );

  blocTest<AppointmentsBloc, AppointmentsState>(
    'BT-APP-04 keeps current data and emits RefreshFailure when refresh fails',
    setUp: () {
      when(
        () => showAppointments(languageCode: 'ar'),
      ).thenThrow(Exception('Refresh failed'));
    },
    build: buildBloc,
    seed: () => AppointmentsLoaded(
      upcomingAppointments: <AppointmentEntity>[appointment(id: 1)],
      pastAppointments: <AppointmentEntity>[
        appointment(id: 2, status: AppointmentStatus.completed),
      ],
      isUpcomingFromCache: true,
      isPastFromCache: false,
    ),
    act: (bloc) =>
        bloc.add(const RefreshAppointmentsRequested(languageCode: 'ar')),
    expect: () => <dynamic>[
      isA<AppointmentsRefreshFailure>()
          .having((state) => state.message, 'message', 'Refresh failed')
          .having(
            (state) => state.upcomingAppointments.length,
            'upcoming count',
            1,
          )
          .having((state) => state.pastAppointments.length, 'past count', 1)
          .having((state) => state.isUpcomingFromCache, 'cache flag', isTrue),
    ],
  );

  blocTest<AppointmentsBloc, AppointmentsState>(
    'BT-APP-05 emits cancelling state then success and refreshed lists',
    setUp: () {
      when(
        () => cancelAppointment(appointmentId: 1, languageCode: 'ar'),
      ).thenAnswer((_) async => 'Appointment cancelled');
      when(() => showAppointments(languageCode: 'ar')).thenAnswer(
        (_) async => const CachedResult<List<AppointmentEntity>>.remote(
          <AppointmentEntity>[],
        ),
      );
      when(() => showPreviousAppointments(languageCode: 'ar')).thenAnswer(
        (_) async =>
            CachedResult<List<AppointmentEntity>>.remote(<AppointmentEntity>[
              appointment(id: 1, status: AppointmentStatus.cancelled),
            ]),
      );
    },
    build: buildBloc,
    seed: () => AppointmentsLoaded(
      upcomingAppointments: <AppointmentEntity>[appointment(id: 1)],
      pastAppointments: const <AppointmentEntity>[],
      isUpcomingFromCache: false,
      isPastFromCache: false,
    ),
    act: (bloc) => bloc.add(
      const CancelAppointmentRequested(appointmentId: 1, languageCode: 'ar'),
    ),
    expect: () => <dynamic>[
      isA<AppointmentsLoaded>().having(
        (state) => state.cancellingAppointmentId,
        'cancelling id',
        1,
      ),
      isA<AppointmentCancellationSuccess>()
          .having((state) => state.message, 'message', 'Appointment cancelled')
          .having((state) => state.upcomingAppointments, 'upcoming', isEmpty)
          .having((state) => state.pastAppointments.length, 'past count', 1),
    ],
    verify: (_) {
      verify(
        () => cancelAppointment(appointmentId: 1, languageCode: 'ar'),
      ).called(1);
      verify(() => showAppointments(languageCode: 'ar')).called(1);
      verify(() => showPreviousAppointments(languageCode: 'ar')).called(1);
    },
  );
}
