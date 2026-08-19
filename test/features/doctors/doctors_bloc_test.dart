import 'package:bloc_test/bloc_test.dart';
import 'package:dt_teeth/core/cache/cached_result.dart';
import 'package:dt_teeth/features/doctors/domain/entities/dentist_details_entity.dart';
import 'package:dt_teeth/features/doctors/domain/entities/dentist_entity.dart';
import 'package:dt_teeth/features/doctors/domain/usecases/add_dentist_rate_usecase.dart';
import 'package:dt_teeth/features/doctors/domain/usecases/show_all_dentists_usecase.dart';
import 'package:dt_teeth/features/doctors/domain/usecases/show_dentist_details_usecase.dart';
import 'package:dt_teeth/features/doctors/domain/usecases/show_dentist_rate_usecase.dart';
import 'package:dt_teeth/features/doctors/domain/usecases/show_dentists_by_specialization_usecase.dart';
import 'package:dt_teeth/features/doctors/presentation/bloc/dentist_details/dentist_details_bloc.dart';
import 'package:dt_teeth/features/doctors/presentation/bloc/dentist_details/dentist_details_event.dart';
import 'package:dt_teeth/features/doctors/presentation/bloc/dentist_details/dentist_details_state.dart';
import 'package:dt_teeth/features/doctors/presentation/bloc/dentist_rate/dentist_rate_bloc.dart';
import 'package:dt_teeth/features/doctors/presentation/bloc/dentist_rate/dentist_rate_event.dart';
import 'package:dt_teeth/features/doctors/presentation/bloc/dentist_rate/dentist_rate_state.dart';
import 'package:dt_teeth/features/doctors/presentation/bloc/doctors/doctors_bloc.dart';
import 'package:dt_teeth/features/doctors/presentation/bloc/doctors/doctors_event.dart';
import 'package:dt_teeth/features/doctors/presentation/bloc/doctors/doctors_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAll extends Mock implements ShowAllDentistsUseCase {}

class MockBySpecialty extends Mock
    implements ShowDentistsBySpecializationUseCase {}

class MockDetails extends Mock implements ShowDentistDetailsUseCase {}

class MockShowRate extends Mock implements ShowDentistRateUseCase {}

class MockAddRate extends Mock implements AddDentistRateUseCase {}

const dentist = DentistEntity(
  id: 4,
  userId: 10,
  name: 'Dr. Lina',
  email: 'lina@test.com',
  phone: '0999',
  role: 2,
  specializationName: 'طب أطفال',
  specializationNameEn: 'Pediatric',
);
const details = DentistDetailsEntity(
  id: 4,
  name: 'Dr. Lina',
  profilePicture: null,
  specializationAr: 'طب أطفال',
  specializationEn: 'Pediatric',
  yearsOfExperience: 7,
  averageRating: '3.8',
  bio: 'Bio',
);

void main() {
  group('DoctorsBloc', () {
    late MockAll all;
    late MockBySpecialty bySpecialty;
    DoctorsBloc build() => DoctorsBloc(
      showAllDentistsUseCase: all,
      showDentistsBySpecializationUseCase: bySpecialty,
    );
    setUp(() {
      all = MockAll();
      bySpecialty = MockBySpecialty();
    });

    blocTest<DoctorsBloc, DoctorsState>(
      'BT-DOC-01 loads all doctors and preserves remote source flag',
      setUp: () => when(() => all(languageCode: 'ar')).thenAnswer(
        (_) async => const CachedResult<List<DentistEntity>>.remote(
          <DentistEntity>[dentist],
        ),
      ),
      build: build,
      act: (bloc) =>
          bloc.add(const ShowAllDentistsRequested(languageCode: 'ar')),
      expect: () => <dynamic>[
        isA<DoctorsLoading>(),
        isA<DoctorsLoaded>()
            .having((s) => s.dentists.data, 'list', hasLength(1))
            .having((s) => s.dentists.isFromCache, 'cache flag', isFalse),
      ],
    );

    blocTest<DoctorsBloc, DoctorsState>(
      'BT-DOC-02 loads doctors by specialization from cache',
      setUp: () =>
          when(
            () => bySpecialty(specializationId: 2, languageCode: 'en'),
          ).thenAnswer(
            (_) async => const CachedResult<List<DentistDetailsEntity>>.cache(
              <DentistDetailsEntity>[details],
            ),
          ),
      build: build,
      act: (bloc) => bloc.add(
        const ShowDentistsBySpecializationRequested(
          specializationId: 2,
          languageCode: 'en',
        ),
      ),
      expect: () => <dynamic>[
        isA<DoctorsLoading>(),
        isA<DentistsBySpecializationLoaded>()
            .having((s) => s.dentists.data.single.id, 'dentist id', 4)
            .having((s) => s.dentists.isFromCache, 'cache flag', isTrue),
      ],
    );

    blocTest<DoctorsBloc, DoctorsState>(
      'BT-DOC-03 removes Exception prefix from visible failure',
      setUp: () => when(
        () => all(languageCode: 'ar'),
      ).thenThrow(Exception('تعذر تحميل الأطباء')),
      build: build,
      act: (bloc) =>
          bloc.add(const ShowAllDentistsRequested(languageCode: 'ar')),
      expect: () => <dynamic>[
        isA<DoctorsLoading>(),
        isA<DoctorsFailure>().having(
          (s) => s.message,
          'clean message',
          'تعذر تحميل الأطباء',
        ),
      ],
    );
  });

  group('DentistDetailsBloc', () {
    late MockDetails useCase;
    DentistDetailsBloc build() =>
        DentistDetailsBloc(showDentistDetailsUseCase: useCase);
    setUp(() => useCase = MockDetails());

    blocTest<DentistDetailsBloc, DentistDetailsState>(
      'BT-DOC-04 emits Loading then cached DetailsLoaded',
      setUp: () =>
          when(() => useCase(dentistId: 4, languageCode: 'ar')).thenAnswer(
            (_) async =>
                const CachedResult<DentistDetailsEntity>.cache(details),
          ),
      build: build,
      act: (bloc) => bloc.add(
        const ShowDentistDetailsRequested(dentistId: 4, languageCode: 'ar'),
      ),
      expect: () => <dynamic>[
        isA<DentistDetailsLoading>(),
        isA<DentistDetailsLoaded>()
            .having((s) => s.dentist.data.name, 'name', 'Dr. Lina')
            .having((s) => s.dentist.isFromCache, 'cache flag', isTrue),
      ],
    );

    blocTest<DentistDetailsBloc, DentistDetailsState>(
      'BT-DOC-05 details error emits clean Failure',
      setUp: () => when(
        () => useCase(dentistId: 4, languageCode: 'en'),
      ).thenThrow(Exception('No details')),
      build: build,
      act: (bloc) => bloc.add(
        const ShowDentistDetailsRequested(dentistId: 4, languageCode: 'en'),
      ),
      expect: () => <dynamic>[
        isA<DentistDetailsLoading>(),
        isA<DentistDetailsFailure>().having(
          (s) => s.message,
          'message',
          'No details',
        ),
      ],
    );
  });

  group('DentistRateBloc', () {
    late MockShowRate showRate;
    late MockAddRate addRate;
    DentistRateBloc build() => DentistRateBloc(
      showDentistRateUseCase: showRate,
      addDentistRateUseCase: addRate,
    );
    setUp(() {
      showRate = MockShowRate();
      addRate = MockAddRate();
    });

    blocTest<DentistRateBloc, DentistRateState>(
      'BT-DOC-06 loads current patient rating',
      setUp: () => when(
        () => showRate(dentistId: 4, languageCode: 'ar'),
      ).thenAnswer((_) async => 4),
      build: build,
      act: (bloc) => bloc.add(
        const ShowDentistRateRequested(dentistId: 4, languageCode: 'ar'),
      ),
      expect: () => <dynamic>[
        isA<DentistRateLoading>(),
        isA<DentistRateLoaded>().having((s) => s.rating, 'rating', 4),
      ],
    );

    blocTest<DentistRateBloc, DentistRateState>(
      'BT-DOC-07 submits rating and exposes updated average',
      setUp: () => when(
        () => addRate(dentistId: 4, rating: 5, languageCode: 'en'),
      ).thenAnswer((_) async => 4),
      build: build,
      act: (bloc) => bloc.add(
        const AddDentistRateRequested(
          dentistId: 4,
          rating: 5,
          languageCode: 'en',
        ),
      ),
      expect: () => <dynamic>[
        isA<DentistRateSubmitting>().having(
          (s) => s.currentRating,
          'selected',
          5,
        ),
        isA<DentistRateSubmitted>().having(
          (s) => s.averageRating,
          'average',
          4,
        ),
      ],
    );

    blocTest<DentistRateBloc, DentistRateState>(
      'BT-DOC-08 rating submission failure does not emit false success',
      setUp: () => when(
        () => addRate(dentistId: 4, rating: 5, languageCode: 'ar'),
      ).thenThrow(Exception('لا يمكن التقييم دون إنترنت')),
      build: build,
      act: (bloc) => bloc.add(
        const AddDentistRateRequested(
          dentistId: 4,
          rating: 5,
          languageCode: 'ar',
        ),
      ),
      expect: () => <dynamic>[
        isA<DentistRateSubmitting>(),
        isA<DentistRateFailure>().having(
          (s) => s.message,
          'message',
          'لا يمكن التقييم دون إنترنت',
        ),
      ],
    );
  });
}
