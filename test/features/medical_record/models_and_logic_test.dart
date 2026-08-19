import 'package:dt_teeth/features/medical_record/data/models/prescription/medication_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/prescription/prescription_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/tooth_treatment_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_procedure_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_session_model.dart';
import 'package:dt_teeth/features/medical_record/data/models/treatment/treatment_type_model.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_dentist_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_session_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_type_entity.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> prescriptionJson() => <String, dynamic>{
  'id': '7',
  'dentist_name': 'Dr. Lina',
  'notes': 'After food',
  'created_at': '2026-07-04 14:52:26',
  'medications': <dynamic>[
    <String, dynamic>{
      'name': 'Amoxicillin',
      'dosage': '500mg',
      'frequency': '3/day',
      'duration': '7 days',
      'notes': null,
    },
    'malformed',
  ],
};

Map<String, dynamic> treatmentJson() => <String, dynamic>{
  'id': '8',
  'treatment_type': <String, dynamic>{
    'id': 2,
    'name': 'تقويم',
    'name_en': 'Orthodontics',
  },
  'dentist': <String, dynamic>{'id': '4', 'name': 'Dr. Lina'},
  'status': 'ongoing',
  'total_sessions_needed': '10',
  'sessions_completed': 4,
  'notes': 'Continue treatment',
  'created_at': '2026-07-04',
  'sessions': <dynamic>[
    <String, dynamic>{
      'id': 20,
      'treatment_id': '8',
      'session_number': '1',
      'status': 'completed',
      'actual_start_time': '10:00',
      'actual_end_time': '10:30',
      'dentist': <String, dynamic>{'id': 4, 'name': 'Dr. Lina'},
      'session_cost': '150000.5',
      'tooth_treatments': <dynamic>[
        <String, dynamic>{
          'id': 3,
          'tooth_number': '11',
          'procedure': <String, dynamic>{
            'id': 5,
            'name': 'تنظيف',
            'name_en': 'Cleaning',
            'price': 50000,
          },
          'notes': 'ok',
        },
      ],
    },
    false,
  ],
};

TreatmentEntity treatmentEntity({
  String status = 'ongoing',
  int total = 10,
  int completed = 4,
  String? notes = 'note',
}) => TreatmentEntity(
  id: 8,
  treatmentType: const TreatmentTypeEntity(
    id: 2,
    name: 'تقويم',
    nameEn: 'Orthodontics',
  ),
  dentist: const TreatmentDentistEntity(id: 4, name: 'Dr. Lina'),
  status: status,
  totalSessionsNeeded: total,
  sessionsCompleted: completed,
  notes: notes,
  createdAt: '2026-07-04',
  sessions: const <TreatmentSessionEntity>[],
);

void main() {
  group('Prescription models', () {
    test('UT-MR-MOD-01 parses medication and nullable notes', () {
      final model = MedicationModel.fromJson(<String, dynamic>{
        'name': 'Drug',
        'dosage': 500,
        'frequency': 3,
        'duration': '7 days',
        'notes': null,
      });
      expect(model.dosage, '500');
      expect(model.frequency, '3');
      expect(model.notes, isNull);
    });

    test('UT-MR-MOD-02 medication safely defaults absent fields', () {
      final model = MedicationModel.fromJson(<String, dynamic>{});
      expect(model.name, isEmpty);
      expect(model.duration, isEmpty);
    });

    test(
      'UT-MR-MOD-03 parses prescription id and filters malformed medication',
      () {
        final model = PrescriptionModel.fromJson(prescriptionJson());
        expect(model.id, 7);
        expect(model.medications, hasLength(1));
        expect(model.medications.single.name, 'Amoxicillin');
      },
    );

    test('UT-MR-MOD-04 invalid prescription id and list use safe defaults', () {
      final model = PrescriptionModel.fromJson(<String, dynamic>{
        'id': 'bad',
        'medications': <dynamic>[1, null],
      });
      expect(model.id, 0);
      expect(model.medications, isEmpty);
    });

    test('UT-MR-MOD-05 prescription cache round-trip preserves data', () {
      final original = PrescriptionModel.fromJson(prescriptionJson());
      final restored = PrescriptionModel.fromJson(original.toJson());
      expect(restored.toJson(), original.toJson());
    });
  });

  group('Treatment models and domain logic', () {
    test('UT-MR-MOD-06 parses full nested treatment graph', () {
      final model = TreatmentModel.fromJson(treatmentJson());
      expect(model.id, 8);
      expect(model.treatmentType.nameEn, 'Orthodontics');
      expect(model.dentist.id, 4);
      expect(model.sessions, hasLength(1));
      expect(model.sessions.single.sessionCost, 150000.5);
      expect(model.sessions.single.toothTreatments.single.toothNumber, 11);
    });

    test('UT-MR-MOD-07 treatment cache round-trip preserves nested graph', () {
      final original = TreatmentModel.fromJson(treatmentJson());
      final restored = TreatmentModel.fromJson(original.toJson());
      expect(restored.toJson(), original.toJson());
    });

    test('UT-MR-MOD-08 malformed nested treatment uses safe objects', () {
      final model = TreatmentModel.fromJson(<String, dynamic>{
        'id': 'x',
        'treatment_type': 'bad',
        'dentist': 4,
        'sessions': <dynamic>['bad'],
        'total_sessions_needed': 'x',
      });
      expect(model.id, 0);
      expect(model.treatmentType.id, 0);
      expect(model.dentist.name, isEmpty);
      expect(model.sessions, isEmpty);
      expect(model.totalSessionsNeeded, 0);
    });

    test(
      'UT-MR-MOD-09 session parses optional dentist and numeric string cost',
      () {
        final session = TreatmentSessionModel.fromJson(
          (treatmentJson()['sessions'] as List<dynamic>).first
              as Map<String, dynamic>,
        );
        expect(session.dentist?.name, 'Dr. Lina');
        expect(session.sessionCost, 150000.5);
        expect(session.actualEndTime, '10:30');
      },
    );

    test(
      'UT-MR-MOD-10 session defaults invalid ids, cost, and nested list',
      () {
        final session = TreatmentSessionModel.fromJson(<String, dynamic>{
          'id': 'bad',
          'session_cost': 'bad',
          'dentist': 'bad',
          'tooth_treatments': <dynamic>[1],
        });
        expect(session.id, 0);
        expect(session.sessionCost, 0);
        expect(session.dentist, isNull);
        expect(session.toothTreatments, isEmpty);
      },
    );

    test(
      'UT-MR-MOD-11 tooth treatment parses procedure and numeric strings',
      () {
        final tooth = ToothTreatmentModel.fromJson(<String, dynamic>{
          'id': '3',
          'tooth_number': '11',
          'procedure': <String, dynamic>{
            'id': '5',
            'name': 'تنظيف',
            'name_en': 'Cleaning',
            'price': 50000,
          },
        });
        expect(tooth.id, 3);
        expect(tooth.toothNumber, 11);
        expect(tooth.procedure.price, '50000');
      },
    );

    test('UT-MR-LOG-01 normalizes status before comparisons', () {
      expect(treatmentEntity(status: ' ONGOING ').isOngoing, isTrue);
      expect(treatmentEntity(status: 'Completed').isCompleted, isTrue);
      expect(treatmentEntity(status: 'CANCELED').isCancelled, isTrue);
      expect(treatmentEntity(status: 'cancelled').isCancelled, isTrue);
    });

    test('UT-MR-LOG-02 active means ongoing only', () {
      expect(treatmentEntity(status: 'ongoing').isActive, isTrue);
      expect(treatmentEntity(status: 'completed').isActive, isFalse);
    });

    test('UT-MR-LOG-03 notes must contain non-whitespace content', () {
      expect(treatmentEntity(notes: 'note').hasNotes, isTrue);
      expect(treatmentEntity(notes: '   ').hasNotes, isFalse);
      expect(treatmentEntity(notes: null).hasNotes, isFalse);
    });

    test(
      'UT-MR-LOG-04 progress handles normal, zero, overflow, and negative values',
      () {
        expect(treatmentEntity(total: 10, completed: 4).progress, 0.4);
        expect(treatmentEntity(total: 0, completed: 4).progress, 0);
        expect(treatmentEntity(total: 10, completed: 15).progress, 1);
        expect(treatmentEntity(total: 10, completed: -2).progress, 0);
      },
    );

    test('UT-MR-LOG-05 progress percentage rounds correctly', () {
      expect(treatmentEntity(total: 3, completed: 2).progressPercent, 67);
    });

    test(
      'UT-MR-LOG-06 treatment and procedure names follow language direction',
      () {
        const type = TreatmentTypeModel(
          id: 1,
          name: 'تنظيف',
          nameEn: 'Cleaning',
        );
        const procedure = TreatmentProcedureModel(
          id: 2,
          name: 'حشوة',
          nameEn: 'Filling',
          price: '100',
        );
        expect(type.localizedName('ar_SY'), 'تنظيف');
        expect(type.localizedName('en'), 'Cleaning');
        expect(procedure.localizedName('ar'), 'حشوة');
        expect(procedure.localizedName('en_US'), 'Filling');
      },
    );
  });
}
