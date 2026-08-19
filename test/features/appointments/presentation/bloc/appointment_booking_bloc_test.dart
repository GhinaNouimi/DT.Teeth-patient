import 'package:bloc_test/bloc_test.dart';
import 'package:dt_teeth/core/cache/cached_result.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_action_result_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_booking_dentist_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_type_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/bookable_treatment_entity.dart';
import 'package:dt_teeth/features/appointments/domain/entities/dentist_schedule_entity.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/add_appointment_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/get_bookable_treatments_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_appointment_types_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_dentist_schedule_use_case.dart';
import 'package:dt_teeth/features/appointments/domain/usecases/show_dentists_by_appointment_type_use_case.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointment_booking/appointment_booking_bloc.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointment_booking/appointment_booking_event.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointment_booking/appointment_booking_state.dart';
import 'package:flutter_test/flutter_test.dart';
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

const treatment = BookableTreatmentEntity(
  id: 9,
  treatmentTypeName: 'تقويم',
  treatmentTypeNameEn: 'Orthodontics',
  dentistId: 4,
  dentistName: 'Dr. Lina',
  totalSessionsNeeded: 10,
  sessionsCompleted: 4,
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

void main() {
  late MockShowAppointmentTypesUseCase showTypes;
  late MockShowDentistsByAppointmentTypeUseCase showDentists;
  late MockShowDentistScheduleUseCase showSchedule;
  late MockGetBookableTreatmentsUseCase getTreatments;
  late MockAddAppointmentUseCase addAppointment;

  AppointmentBookingBloc buildBloc() {
    return AppointmentBookingBloc(
      showAppointmentTypesUseCase: showTypes,
      showDentistsByAppointmentTypeUseCase: showDentists,
      showDentistScheduleUseCase: showSchedule,
      getBookableTreatmentsUseCase: getTreatments,
      addAppointmentUseCase: addAppointment,
    );
  }

  setUp(() {
    showTypes = MockShowAppointmentTypesUseCase();
    showDentists = MockShowDentistsByAppointmentTypeUseCase();
    showSchedule = MockShowDentistScheduleUseCase();
    getTreatments = MockGetBookableTreatmentsUseCase();
    addAppointment = MockAddAppointmentUseCase();
  });

  blocTest<AppointmentBookingBloc, AppointmentBookingState>(
    'BT-BOOK-01 loads appointment types successfully',
    setUp: () {
      when(() => showTypes(languageCode: 'ar')).thenAnswer(
        (_) async => const CachedResult<List<AppointmentTypeEntity>>.remote(
          <AppointmentTypeEntity>[appointmentType],
        ),
      );
    },
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const LoadAppointmentTypesRequested(languageCode: 'ar')),
    expect: () => <dynamic>[
      isA<AppointmentBookingLoading>(),
      isA<AppointmentBookingLoaded>()
          .having((state) => state.appointmentTypes, 'types', hasLength(1))
          .having(
            (state) => state.appointmentTypesFromCache,
            'cache flag',
            isFalse,
          ),
    ],
  );

  blocTest<AppointmentBookingBloc, AppointmentBookingState>(
    'BT-BOOK-02 emits Empty and preserves cache flag for an empty cached list',
    setUp: () {
      when(() => showTypes(languageCode: 'en')).thenAnswer(
        (_) async => const CachedResult<List<AppointmentTypeEntity>>.cache(
          <AppointmentTypeEntity>[],
        ),
      );
    },
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const LoadAppointmentTypesRequested(languageCode: 'en')),
    expect: () => <dynamic>[
      isA<AppointmentBookingLoading>(),
      isA<AppointmentBookingEmpty>().having(
        (state) => state.isFromCache,
        'cache flag',
        isTrue,
      ),
    ],
  );

  blocTest<AppointmentBookingBloc, AppointmentBookingState>(
    'BT-BOOK-03 emits Error when loading appointment types fails',
    setUp: () {
      when(
        () => showTypes(languageCode: 'ar'),
      ).thenThrow(Exception('Unable to load appointment types'));
    },
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const LoadAppointmentTypesRequested(languageCode: 'ar')),
    expect: () => <dynamic>[
      isA<AppointmentBookingLoading>(),
      isA<AppointmentBookingError>().having(
        (state) => state.message,
        'message',
        'Unable to load appointment types',
      ),
    ],
  );

  blocTest<AppointmentBookingBloc, AppointmentBookingState>(
    'BT-BOOK-04 selecting continue treatment loads bookable treatments',
    setUp: () {
      when(() => getTreatments(languageCode: 'ar')).thenAnswer(
        (_) async => const CachedResult<List<BookableTreatmentEntity>>.remote(
          <BookableTreatmentEntity>[treatment],
        ),
      );
    },
    build: buildBloc,
    seed: () => const AppointmentBookingLoaded(
      appointmentTypes: <AppointmentTypeEntity>[appointmentType],
      appointmentTypesFromCache: false,
    ),
    act: (bloc) => bloc.add(
      const AppointmentBookingTypeSelected(
        bookingType: AppointmentBookingType.continueTreatment,
        languageCode: 'ar',
      ),
    ),
    expect: () => <dynamic>[
      isA<AppointmentBookingLoaded>()
          .having(
            (state) => state.selectedBookingType,
            'booking type',
            AppointmentBookingType.continueTreatment,
          )
          .having(
            (state) => state.isLoadingBookableTreatments,
            'loading treatments',
            isTrue,
          ),
      isA<AppointmentBookingLoaded>()
          .having(
            (state) => state.bookableTreatments,
            'treatments',
            hasLength(1),
          )
          .having(
            (state) => state.isLoadingBookableTreatments,
            'loading treatments',
            isFalse,
          ),
    ],
  );

  blocTest<AppointmentBookingBloc, AppointmentBookingState>(
    'BT-BOOK-05 selecting appointment type loads matching dentists',
    setUp: () {
      when(
        () => showDentists(appointmentTypeId: 1, languageCode: 'en'),
      ).thenAnswer(
        (_) async =>
            const CachedResult<List<AppointmentBookingDentistEntity>>.remote(
              <AppointmentBookingDentistEntity>[dentist],
            ),
      );
    },
    build: buildBloc,
    seed: () => const AppointmentBookingLoaded(
      appointmentTypes: <AppointmentTypeEntity>[appointmentType],
      appointmentTypesFromCache: false,
      selectedBookingType: AppointmentBookingType.newTreatment,
    ),
    act: (bloc) => bloc.add(
      const AppointmentTypeSelected(appointmentTypeId: 1, languageCode: 'en'),
    ),
    expect: () => <dynamic>[
      isA<AppointmentBookingLoaded>()
          .having((state) => state.selectedAppointmentTypeId, 'type id', 1)
          .having((state) => state.isLoadingDentists, 'loading', isTrue),
      isA<AppointmentBookingLoaded>()
          .having((state) => state.dentists, 'dentists', hasLength(1))
          .having((state) => state.isLoadingDentists, 'loading', isFalse),
    ],
  );

  blocTest<AppointmentBookingBloc, AppointmentBookingState>(
    'BT-BOOK-06 selecting dentist loads the dentist schedule',
    setUp: () {
      when(() => showSchedule(dentistId: 4, languageCode: 'ar')).thenAnswer(
        (_) async => CachedResult<DentistScheduleEntity>.remote(schedule()),
      );
    },
    build: buildBloc,
    seed: () => const AppointmentBookingLoaded(
      appointmentTypes: <AppointmentTypeEntity>[appointmentType],
      appointmentTypesFromCache: false,
      selectedBookingType: AppointmentBookingType.newTreatment,
      selectedAppointmentTypeId: 1,
      dentists: <AppointmentBookingDentistEntity>[dentist],
    ),
    act: (bloc) => bloc.add(
      const AppointmentDentistSelected(dentistId: 4, languageCode: 'ar'),
    ),
    expect: () => <dynamic>[
      isA<AppointmentBookingLoaded>()
          .having((state) => state.selectedDentistId, 'dentist id', 4)
          .having((state) => state.isLoadingDentistSchedule, 'loading', isTrue),
      isA<AppointmentBookingLoaded>()
          .having((state) => state.dentistSchedule, 'schedule', isNotNull)
          .having(
            (state) => state.isLoadingDentistSchedule,
            'loading',
            isFalse,
          ),
    ],
  );

  blocTest<AppointmentBookingBloc, AppointmentBookingState>(
    'BT-BOOK-07 submits a complete booking and emits success',
    setUp: () {
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
    },
    build: buildBloc,
    seed: () => AppointmentBookingLoaded(
      appointmentTypes: const <AppointmentTypeEntity>[appointmentType],
      appointmentTypesFromCache: false,
      selectedBookingType: AppointmentBookingType.newTreatment,
      selectedAppointmentTypeId: 1,
      dentists: const <AppointmentBookingDentistEntity>[dentist],
      selectedDentistId: 4,
      dentistSchedule: schedule(),
      selectedAppointmentTime: selectedTime,
    ),
    act: (bloc) => bloc.add(
      const AddAppointmentRequested(notes: 'Patient note', languageCode: 'en'),
    ),
    expect: () => <dynamic>[
      isA<AppointmentBookingLoaded>().having(
        (state) => state.submissionStatus,
        'status',
        AppointmentSubmissionStatus.submitting,
      ),
      isA<AppointmentBookingLoaded>()
          .having(
            (state) => state.submissionStatus,
            'status',
            AppointmentSubmissionStatus.success,
          )
          .having(
            (state) => state.submissionResult?.message,
            'message',
            'Booking request sent',
          ),
    ],
  );

  blocTest<AppointmentBookingBloc, AppointmentBookingState>(
    'BT-BOOK-08 converts booking exception into submission failure',
    setUp: () {
      when(
        () => addAppointment(
          dentistId: 4,
          appointmentTypeId: 1,
          appointmentTime: selectedTime,
          type: AppointmentBookingType.newTreatment,
          treatmentId: null,
          notes: null,
          languageCode: 'ar',
        ),
      ).thenThrow(Exception('Booking failed'));
    },
    build: buildBloc,
    seed: () => AppointmentBookingLoaded(
      appointmentTypes: const <AppointmentTypeEntity>[appointmentType],
      appointmentTypesFromCache: false,
      selectedBookingType: AppointmentBookingType.newTreatment,
      selectedAppointmentTypeId: 1,
      dentists: const <AppointmentBookingDentistEntity>[dentist],
      selectedDentistId: 4,
      dentistSchedule: schedule(),
      selectedAppointmentTime: selectedTime,
    ),
    act: (bloc) => bloc.add(const AddAppointmentRequested(languageCode: 'ar')),
    expect: () => <dynamic>[
      isA<AppointmentBookingLoaded>().having(
        (state) => state.submissionStatus,
        'status',
        AppointmentSubmissionStatus.submitting,
      ),
      isA<AppointmentBookingLoaded>()
          .having(
            (state) => state.submissionStatus,
            'status',
            AppointmentSubmissionStatus.failure,
          )
          .having(
            (state) => state.submissionErrorMessage,
            'message',
            'Booking failed',
          ),
    ],
  );

  blocTest<AppointmentBookingBloc, AppointmentBookingState>(
    'BT-BOOK-09 cached booking data prevents write submission',
    build: buildBloc,
    seed: () => AppointmentBookingLoaded(
      appointmentTypes: const <AppointmentTypeEntity>[appointmentType],
      appointmentTypesFromCache: true,
      selectedBookingType: AppointmentBookingType.newTreatment,
      selectedAppointmentTypeId: 1,
      dentists: const <AppointmentBookingDentistEntity>[dentist],
      selectedDentistId: 4,
      dentistSchedule: schedule(),
      selectedAppointmentTime: selectedTime,
    ),
    act: (bloc) => bloc.add(const AddAppointmentRequested(languageCode: 'en')),
    expect: () => <dynamic>[],
    verify: (_) => verifyZeroInteractions(addAppointment),
  );
}
