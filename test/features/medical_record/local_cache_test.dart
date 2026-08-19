import 'package:dt_teeth/core/cache/cache_exception.dart';
import 'package:dt_teeth/core/cache/cache_keys.dart';
import 'package:dt_teeth/features/medical_record/data/datasources/local/prescription_local_data_source_impl.dart';
import 'package:dt_teeth/features/medical_record/data/datasources/local/treatment_local_data_source_impl.dart';
import 'package:dt_teeth/features/medical_record/data/models/prescription/prescription_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_dentist_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_type_model.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/prescription/medication_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_session_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  group('Prescription local cache', () {
    final source = PrescriptionLocalDataSourceImpl();

    test('UT-MR-CACHE-01 list cache round-trip', () async {
      await source.cachePrescriptions(const <PrescriptionModel>[prescription]);
      final result = await source.getCachedPrescriptions();
      expect(result, hasLength(1));
      expect(result.single.id, 7);
    });

    test('UT-MR-CACHE-02 details use prescription-specific key', () async {
      await source.cachePrescriptionDetails(prescription);
      expect(
        (await source.getCachedPrescriptionDetails(7))?.dentistName,
        'Dr. Lina',
      );
      expect(
        source.getCachedPrescriptionDetails(8),
        throwsA(isA<CacheException>()),
      );
    });

    test(
      'UT-MR-CACHE-03 malformed non-list cache returns empty list',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{
          CacheKeys.prescriptions: '{"not":"list"}',
        });
        expect(await source.getCachedPrescriptions(), isEmpty);
      },
    );

    test('UT-MR-CACHE-04 list decoder filters malformed elements', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        CacheKeys.prescriptions: '[{"id":7},"bad",4]',
      });
      expect(await source.getCachedPrescriptions(), hasLength(1));
    });
  });

  group('Treatment local cache', () {
    final source = TreatmentLocalDataSourceImpl();

    test('UT-MR-CACHE-05 list cache round-trip', () async {
      await source.cacheTreatments(const <TreatmentModel>[treatment]);
      final result = await source.getCachedTreatments();
      expect(result.single.id, 8);
      expect(result.single.sessionsCompleted, 4);
    });

    test('UT-MR-CACHE-06 details use treatment-specific key', () async {
      await source.cacheTreatmentDetails(treatment);
      expect((await source.getCachedTreatmentDetails(8))?.status, 'ongoing');
      expect(
        source.getCachedTreatmentDetails(9),
        throwsA(isA<CacheException>()),
      );
    });

    test(
      'UT-MR-CACHE-07 malformed non-list treatment cache returns empty',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{
          CacheKeys.treatments: '{"not":"list"}',
        });
        expect(await source.getCachedTreatments(), isEmpty);
      },
    );

    test('UT-MR-CACHE-08 missing cache is explicitly reported', () {
      expect(source.getCachedTreatments(), throwsA(isA<CacheException>()));
    });
  });
}
