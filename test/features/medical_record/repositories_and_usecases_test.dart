import 'package:dt_teeth/core/cache/cached_result.dart';
import 'package:dt_teeth/core/network/network_error_messages.dart';
import 'package:dt_teeth/core/network/network_info.dart';
import 'package:dt_teeth/features/medical_record/data/datasources/local/prescription_local_data_source.dart';
import 'package:dt_teeth/features/medical_record/data/datasources/local/treatment_local_data_source.dart';
import 'package:dt_teeth/features/medical_record/data/datasources/remote/prescription_remote_data_source.dart';
import 'package:dt_teeth/features/medical_record/data/datasources/remote/treatment_remote_data_source.dart';
import 'package:dt_teeth/features/medical_record/data/models/prescription/prescription_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_dentist_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_type_model.dart';
import 'package:dt_teeth/features/medical_record/data/repositories/prescription_repository_impl.dart';
import 'package:dt_teeth/features/medical_record/data/repositories/treatment_repository_impl.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/prescription/medication_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/prescription/prescription_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_session_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/repositories/prescription_repository.dart';
import 'package:dt_teeth/features/medical_record/domain/repositories/treatment_repository.dart';
import 'package:dt_teeth/features/medical_record/domain/usecases/prescription/get_all_prescriptions_use_case.dart';
import 'package:dt_teeth/features/medical_record/domain/usecases/prescription/get_prescription_details_use_case.dart';
import 'package:dt_teeth/features/medical_record/domain/usecases/treatment/get_all_treatments_use_case.dart';
import 'package:dt_teeth/features/medical_record/domain/usecases/treatment/get_treatment_details_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPrescriptionRemote extends Mock
    implements PrescriptionRemoteDataSource {}

class MockPrescriptionLocal extends Mock
    implements PrescriptionLocalDataSource {}

class MockTreatmentRemote extends Mock implements TreatmentRemoteDataSource {}

class MockTreatmentLocal extends Mock implements TreatmentLocalDataSource {}

class MockNetwork extends Mock implements NetworkInfo {}

class MockPrescriptionRepository extends Mock
    implements PrescriptionRepository {}

class MockTreatmentRepository extends Mock implements TreatmentRepository {}

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
  group('PrescriptionRepository', () {
    late MockPrescriptionRemote remote;
    late MockPrescriptionLocal local;
    late MockNetwork network;
    late PrescriptionRepositoryImpl repository;
    setUpAll(() {
      registerFallbackValue(<PrescriptionModel>[]);
      registerFallbackValue(prescription);
    });
    setUp(() {
      remote = MockPrescriptionRemote();
      local = MockPrescriptionLocal();
      network = MockNetwork();
      repository = PrescriptionRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
        networkInfo: network,
      );
    });

    test(
      'UT-MR-REP-01 online list returns remote and refreshes cache',
      () async {
        when(() => network.isConnected).thenAnswer((_) async => true);
        when(
          () => remote.getAllPrescriptions(),
        ).thenAnswer((_) async => <PrescriptionModel>[prescription]);
        when(() => local.cachePrescriptions(any())).thenAnswer((_) async {});
        final result = await repository.getAllPrescriptions(languageCode: 'ar');
        expect(result.data.single.id, 7);
        expect(result.isFromCache, isFalse);
        verify(() => local.cachePrescriptions(any())).called(1);
      },
    );

    test('UT-MR-REP-02 offline list returns cache without API', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(
        () => local.getCachedPrescriptions(),
      ).thenAnswer((_) async => <PrescriptionModel>[prescription]);
      final result = await repository.getAllPrescriptions(languageCode: 'en');
      expect(result.isFromCache, isTrue);
      verifyNever(() => remote.getAllPrescriptions());
    });

    test(
      'UT-MR-REP-03 empty offline list throws localized no-cache error',
      () async {
        when(() => network.isConnected).thenAnswer((_) async => false);
        when(
          () => local.getCachedPrescriptions(),
        ).thenAnswer((_) async => <PrescriptionModel>[]);
        expect(
          repository.getAllPrescriptions(languageCode: 'en'),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                NetworkErrorMessages.noCachedData('en'),
              ),
            ),
          ),
        );
      },
    );

    test(
      'UT-MR-REP-04 online details cache and return selected prescription',
      () async {
        when(() => network.isConnected).thenAnswer((_) async => true);
        when(
          () => remote.getPrescriptionDetails(7),
        ).thenAnswer((_) async => prescription);
        when(
          () => local.cachePrescriptionDetails(prescription),
        ).thenAnswer((_) async {});
        final result = await repository.getPrescriptionDetails(
          prescriptionId: 7,
          languageCode: 'ar',
        );
        expect(result.data.id, 7);
        expect(result.isFromCache, isFalse);
        verify(() => local.cachePrescriptionDetails(prescription)).called(1);
      },
    );

    test('UT-MR-REP-05 offline details use matching cached id', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(
        () => local.getCachedPrescriptionDetails(7),
      ).thenAnswer((_) async => prescription);
      final result = await repository.getPrescriptionDetails(
        prescriptionId: 7,
        languageCode: 'ar',
      );
      expect(result.isFromCache, isTrue);
      verifyNever(() => remote.getPrescriptionDetails(any()));
    });

    test('UT-MR-REP-06 missing offline details throws clear error', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(
        () => local.getCachedPrescriptionDetails(7),
      ).thenAnswer((_) async => null);
      expect(
        repository.getPrescriptionDetails(
          prescriptionId: 7,
          languageCode: 'ar',
        ),
        throwsA(predicate((e) => e.toString().contains('لا توجد بيانات'))),
      );
    });
  });

  group('TreatmentRepository', () {
    late MockTreatmentRemote remote;
    late MockTreatmentLocal local;
    late MockNetwork network;
    late TreatmentRepositoryImpl repository;
    setUpAll(() {
      registerFallbackValue(<TreatmentModel>[]);
      registerFallbackValue(treatment);
    });
    setUp(() {
      remote = MockTreatmentRemote();
      local = MockTreatmentLocal();
      network = MockNetwork();
      repository = TreatmentRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
        networkInfo: network,
      );
    });

    test(
      'UT-MR-REP-07 online list returns remote and refreshes cache',
      () async {
        when(() => network.isConnected).thenAnswer((_) async => true);
        when(
          () => remote.getAllTreatments(),
        ).thenAnswer((_) async => <TreatmentModel>[treatment]);
        when(() => local.cacheTreatments(any())).thenAnswer((_) async {});
        final result = await repository.getAllTreatments(languageCode: 'ar');
        expect(result.data.single.id, 8);
        expect(result.isFromCache, isFalse);
        verify(() => local.cacheTreatments(any())).called(1);
      },
    );

    test('UT-MR-REP-08 offline list returns cache only', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(
        () => local.getCachedTreatments(),
      ).thenAnswer((_) async => <TreatmentModel>[treatment]);
      final result = await repository.getAllTreatments(languageCode: 'en');
      expect(result.isFromCache, isTrue);
      verifyNever(() => remote.getAllTreatments());
    });

    test('UT-MR-REP-09 empty offline list throws localized error', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(
        () => local.getCachedTreatments(),
      ).thenAnswer((_) async => <TreatmentModel>[]);
      expect(
        repository.getAllTreatments(languageCode: 'en'),
        throwsA(
          predicate(
            (e) =>
                e.toString().contains(NetworkErrorMessages.noCachedData('en')),
          ),
        ),
      );
    });

    test('UT-MR-REP-10 online details caches response', () async {
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(
        () => remote.getTreatmentDetails(8),
      ).thenAnswer((_) async => treatment);
      when(
        () => local.cacheTreatmentDetails(treatment),
      ).thenAnswer((_) async {});
      final result = await repository.getTreatmentDetails(
        treatmentId: 8,
        languageCode: 'ar',
      );
      expect(result.data.sessionsCompleted, 4);
      expect(result.isFromCache, isFalse);
      verify(() => local.cacheTreatmentDetails(treatment)).called(1);
    });

    test('UT-MR-REP-11 offline details use cache without API', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(
        () => local.getCachedTreatmentDetails(8),
      ).thenAnswer((_) async => treatment);
      final result = await repository.getTreatmentDetails(
        treatmentId: 8,
        languageCode: 'ar',
      );
      expect(result.isFromCache, isTrue);
      verifyNever(() => remote.getTreatmentDetails(any()));
    });

    test('UT-MR-REP-12 missing offline details throws clear error', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(
        () => local.getCachedTreatmentDetails(8),
      ).thenAnswer((_) async => null);
      expect(
        repository.getTreatmentDetails(treatmentId: 8, languageCode: 'en'),
        throwsA(
          predicate(
            (e) =>
                e.toString().contains(NetworkErrorMessages.noCachedData('en')),
          ),
        ),
      );
    });
  });

  group('UseCases delegate parameters and results', () {
    test('UT-MR-UC-01 GetAllPrescriptions delegates language', () async {
      final repo = MockPrescriptionRepository();
      when(() => repo.getAllPrescriptions(languageCode: 'ar')).thenAnswer(
        (_) async => const CachedResult<List<PrescriptionEntity>>.remote(
          <PrescriptionEntity>[prescription],
        ),
      );
      final result = await GetAllPrescriptionsUseCase(repository: repo)(
        languageCode: 'ar',
      );
      expect(result.data.single.id, 7);
      verify(() => repo.getAllPrescriptions(languageCode: 'ar')).called(1);
    });

    test(
      'UT-MR-UC-02 GetPrescriptionDetails delegates id and language',
      () async {
        final repo = MockPrescriptionRepository();
        when(
          () => repo.getPrescriptionDetails(
            prescriptionId: 7,
            languageCode: 'en',
          ),
        ).thenAnswer(
          (_) async =>
              const CachedResult<PrescriptionEntity>.cache(prescription),
        );
        final result = await GetPrescriptionDetailsUseCase(repository: repo)(
          prescriptionId: 7,
          languageCode: 'en',
        );
        expect(result.isFromCache, isTrue);
      },
    );

    test('UT-MR-UC-03 GetAllTreatments delegates language', () async {
      final repo = MockTreatmentRepository();
      when(() => repo.getAllTreatments(languageCode: 'ar')).thenAnswer(
        (_) async => const CachedResult<List<TreatmentEntity>>.remote(
          <TreatmentEntity>[treatment],
        ),
      );
      final result = await GetAllTreatmentsUseCase(repository: repo)(
        languageCode: 'ar',
      );
      expect(result.data.single.id, 8);
    });

    test('UT-MR-UC-04 GetTreatmentDetails delegates id and language', () async {
      final repo = MockTreatmentRepository();
      when(
        () => repo.getTreatmentDetails(treatmentId: 8, languageCode: 'en'),
      ).thenAnswer(
        (_) async => const CachedResult<TreatmentEntity>.cache(treatment),
      );
      final result = await GetTreatmentDetailsUseCase(repository: repo)(
        treatmentId: 8,
        languageCode: 'en',
      );
      expect(result.isFromCache, isTrue);
    });
  });
}
