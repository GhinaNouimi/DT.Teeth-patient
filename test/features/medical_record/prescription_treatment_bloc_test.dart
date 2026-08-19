import 'package:bloc_test/bloc_test.dart';
import 'package:dt_teeth/core/cache/cached_result.dart';
import 'package:dt_teeth/features/medical_record/data/models/prescription/prescription_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_dentist_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_type_model.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/prescription/medication_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/prescription/prescription_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_session_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/usecases/prescription/get_all_prescriptions_use_case.dart';
import 'package:dt_teeth/features/medical_record/domain/usecases/prescription/get_prescription_details_use_case.dart';
import 'package:dt_teeth/features/medical_record/domain/usecases/treatment/get_all_treatments_use_case.dart';
import 'package:dt_teeth/features/medical_record/domain/usecases/treatment/get_treatment_details_use_case.dart';
import 'package:dt_teeth/features/medical_record/presentation/bloc/prescription/prescription_bloc.dart';
import 'package:dt_teeth/features/medical_record/presentation/bloc/prescription/prescription_event.dart';
import 'package:dt_teeth/features/medical_record/presentation/bloc/prescription/prescription_state.dart';
import 'package:dt_teeth/features/medical_record/presentation/bloc/treatment/treatment_bloc.dart';
import 'package:dt_teeth/features/medical_record/presentation/bloc/treatment/treatment_event.dart';
import 'package:dt_teeth/features/medical_record/presentation/bloc/treatment/treatment_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAllPrescriptions extends Mock implements GetAllPrescriptionsUseCase {}

class MockPrescriptionDetails extends Mock
    implements GetPrescriptionDetailsUseCase {}

class MockAllTreatments extends Mock implements GetAllTreatmentsUseCase {}

class MockTreatmentDetails extends Mock implements GetTreatmentDetailsUseCase {}

const prescription = PrescriptionModel(
  id: 7,
  dentistName: 'Dr. Lina',
  notes: 'note',
  createdAt: '2026-07-04',
  medications: <MedicationEntity>[],
);
const treatment = TreatmentModel(
  id: 8,
  treatmentType: TreatmentTypeModel(
    id: 2,
    name: 'تقويم',
    nameEn: 'Orthodontics',
  ),
  dentist: TreatmentDentistModel(id: 4, name: 'Dr. Lina'),
  status: 'ongoing',
  totalSessionsNeeded: 10,
  sessionsCompleted: 4,
  notes: 'note',
  createdAt: '2026-07-04',
  sessions: <TreatmentSessionEntity>[],
);

void main() {
  group('PrescriptionBloc', () {
    late MockAllPrescriptions all;
    late MockPrescriptionDetails details;
    PrescriptionBloc build() => PrescriptionBloc(
      getAllPrescriptionsUseCase: all,
      getPrescriptionDetailsUseCase: details,
    );
    setUp(() {
      all = MockAllPrescriptions();
      details = MockPrescriptionDetails();
    });

    test('BT-MR-PRE-00 starts in PrescriptionInitial', () async {
      final bloc = build();
      expect(bloc.state, isA<PrescriptionInitial>());
      await bloc.close();
    });

    blocTest<PrescriptionBloc, PrescriptionState>(
      'BT-MR-PRE-01 loads remote prescription list',
      setUp: () => when(() => all(languageCode: 'ar')).thenAnswer(
        (_) async => const CachedResult<List<PrescriptionEntity>>.remote(
          <PrescriptionEntity>[prescription],
        ),
      ),
      build: build,
      act: (b) => b.add(const LoadPrescriptionsRequested(languageCode: 'ar')),
      expect: () => <dynamic>[
        isA<PrescriptionLoading>(),
        isA<PrescriptionsLoaded>()
            .having((s) => s.prescriptions, 'list', hasLength(1))
            .having((s) => s.isFromCache, 'cache flag', isFalse),
      ],
    );

    blocTest<PrescriptionBloc, PrescriptionState>(
      'BT-MR-PRE-02 empty list remains a valid loaded state',
      setUp: () => when(() => all(languageCode: 'en')).thenAnswer(
        (_) async => const CachedResult<List<PrescriptionEntity>>.remote(
          <PrescriptionEntity>[],
        ),
      ),
      build: build,
      act: (b) => b.add(const LoadPrescriptionsRequested(languageCode: 'en')),
      expect: () => <dynamic>[
        isA<PrescriptionLoading>(),
        isA<PrescriptionsLoaded>().having(
          (s) => s.prescriptions,
          'list',
          isEmpty,
        ),
      ],
    );

    blocTest<PrescriptionBloc, PrescriptionState>(
      'BT-MR-PRE-03 cached details preserve offline evidence',
      setUp: () =>
          when(() => details(prescriptionId: 7, languageCode: 'ar')).thenAnswer(
            (_) async =>
                const CachedResult<PrescriptionEntity>.cache(prescription),
          ),
      build: build,
      act: (b) => b.add(
        const LoadPrescriptionDetailsRequested(
          prescriptionId: 7,
          languageCode: 'ar',
        ),
      ),
      expect: () => <dynamic>[
        isA<PrescriptionLoading>(),
        isA<PrescriptionDetailsLoaded>()
            .having((s) => s.prescription.id, 'id', 7)
            .having((s) => s.isFromCache, 'cache flag', isTrue),
      ],
    );

    blocTest<PrescriptionBloc, PrescriptionState>(
      'BT-MR-PRE-04 failure removes technical Exception prefix',
      setUp: () => when(
        () => all(languageCode: 'ar'),
      ).thenThrow(Exception('لا توجد وصفات')),
      build: build,
      act: (b) => b.add(const LoadPrescriptionsRequested(languageCode: 'ar')),
      expect: () => <dynamic>[
        isA<PrescriptionLoading>(),
        isA<PrescriptionFailure>().having(
          (s) => s.message,
          'message',
          'لا توجد وصفات',
        ),
      ],
    );
  });

  group('TreatmentBloc', () {
    late MockAllTreatments all;
    late MockTreatmentDetails details;
    TreatmentBloc build() => TreatmentBloc(
      getAllTreatmentsUseCase: all,
      getTreatmentDetailsUseCase: details,
    );
    setUp(() {
      all = MockAllTreatments();
      details = MockTreatmentDetails();
    });

    test('BT-MR-TRT-00 starts in TreatmentInitial', () async {
      final bloc = build();
      expect(bloc.state, isA<TreatmentInitial>());
      await bloc.close();
    });

    blocTest<TreatmentBloc, TreatmentState>(
      'BT-MR-TRT-01 loads cached treatment list with source flag',
      setUp: () => when(() => all(languageCode: 'ar')).thenAnswer(
        (_) async => const CachedResult<List<TreatmentEntity>>.cache(
          <TreatmentEntity>[treatment],
        ),
      ),
      build: build,
      act: (b) => b.add(const LoadTreatmentsRequested(languageCode: 'ar')),
      expect: () => <dynamic>[
        isA<TreatmentLoading>(),
        isA<TreatmentsLoaded>()
            .having((s) => s.treatments.single.id, 'id', 8)
            .having((s) => s.isFromCache, 'cache flag', isTrue),
      ],
    );

    blocTest<TreatmentBloc, TreatmentState>(
      'BT-MR-TRT-02 empty remote list remains a valid loaded state',
      setUp: () => when(() => all(languageCode: 'en')).thenAnswer(
        (_) async => const CachedResult<List<TreatmentEntity>>.remote(
          <TreatmentEntity>[],
        ),
      ),
      build: build,
      act: (b) => b.add(const LoadTreatmentsRequested(languageCode: 'en')),
      expect: () => <dynamic>[
        isA<TreatmentLoading>(),
        isA<TreatmentsLoaded>().having((s) => s.treatments, 'list', isEmpty),
      ],
    );

    blocTest<TreatmentBloc, TreatmentState>(
      'BT-MR-TRT-03 loads remote treatment details',
      setUp: () =>
          when(() => details(treatmentId: 8, languageCode: 'en')).thenAnswer(
            (_) async => const CachedResult<TreatmentEntity>.remote(treatment),
          ),
      build: build,
      act: (b) => b.add(
        const LoadTreatmentDetailsRequested(treatmentId: 8, languageCode: 'en'),
      ),
      expect: () => <dynamic>[
        isA<TreatmentLoading>(),
        isA<TreatmentDetailsLoaded>()
            .having((s) => s.treatment.sessionsCompleted, 'completed', 4)
            .having((s) => s.isFromCache, 'cache flag', isFalse),
      ],
    );

    blocTest<TreatmentBloc, TreatmentState>(
      'BT-MR-TRT-04 failure emits user-safe nonempty message',
      setUp: () => when(
        () => details(treatmentId: 8, languageCode: 'en'),
      ).thenThrow(Exception('backend detail leaked')),
      build: build,
      act: (b) => b.add(
        const LoadTreatmentDetailsRequested(treatmentId: 8, languageCode: 'en'),
      ),
      expect: () => <dynamic>[
        isA<TreatmentLoading>(),
        isA<TreatmentFailure>()
            .having((s) => s.message, 'safe message', isNotEmpty)
            .having(
              (s) => s.message,
              'no backend leak',
              isNot(contains('backend detail leaked')),
            ),
      ],
    );
  });
}
