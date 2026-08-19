import 'package:dt_teeth/features/appointments/data/models/add_appointment_request_model.dart';
import 'package:dt_teeth/features/appointments/data/models/appointment_action_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/appointment_model.dart';
import 'package:dt_teeth/features/appointments/data/models/show_appointment_details_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/show_appointment_types_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/show_appointments_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/show_dentist_schedule_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/show_dentists_by_appointment_type_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/update_appointment_request_model.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_entity.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> validAppointmentJson({
  dynamic id = 23,
  dynamic status = 'pending',
  dynamic type = 'new_treatment',
  dynamic appointmentTime = '2026-08-26 10:00:00',
}) {
  return <String, dynamic>{
    'id': id,
    'dentist': <String, dynamic>{
      'id': '4',
      'name': ' Dr. Lina ',
      'photo': ' https://example.com/doctor.png ',
    },
    'appointment_type': <String, dynamic>{
      'ar': ' كشف عام ',
      'en': ' General Checkup ',
    },
    'type': type,
    'status': status,
    'appointment_time': appointmentTime,
    'rejection_reason': null,
    'notes': ' Patient note ',
    'treatment': null,
  };
}

void main() {
  group('AppointmentModel.fromJson', () {
    test('UT-MOD-APP-01 parses the current nested backend response', () {
      final model = AppointmentModel.fromJson(validAppointmentJson(id: '23'));

      expect(model.id, 23);
      expect(model.dentistId, 4);
      expect(model.dentistName, 'Dr. Lina');
      expect(model.dentistPhoto, 'https://example.com/doctor.png');
      expect(model.appointmentTypeName, 'كشف عام');
      expect(model.appointmentTypeNameEn, 'General Checkup');
      expect(model.type, AppointmentBookingType.newTreatment);
      expect(model.status, AppointmentStatus.pending);
      expect(model.appointmentTime, DateTime(2026, 8, 26, 10));
      expect(model.notes, 'Patient note');
    });

    test(
      'UT-MOD-APP-02 supports legacy dentist fields when nested data is absent',
      () {
        final json = validAppointmentJson()
          ..remove('dentist')
          ..addAll(<String, dynamic>{
            'dentist_id': '7',
            'dentist_name': 'Legacy Dentist',
            'dentist_photo': 'legacy.png',
          });

        final model = AppointmentModel.fromJson(json);

        expect(model.dentistId, 7);
        expect(model.dentistName, 'Legacy Dentist');
        expect(model.dentistPhoto, 'legacy.png');
      },
    );

    test(
      'UT-MOD-APP-03 converts null-like strings and invalid values safely',
      () {
        final json = validAppointmentJson(
          id: 'invalid',
          status: 'unexpected_status',
          type: 'unexpected_type',
          appointmentTime: 'not-a-date',
        );
        final dentist = json['dentist']! as Map<String, dynamic>;
        dentist['photo'] = ' null ';
        json['notes'] = '   ';
        json['rejection_reason'] = 'null';

        final model = AppointmentModel.fromJson(json);

        expect(model.id, 0);
        expect(model.status, AppointmentStatus.unknown);
        expect(model.type, AppointmentBookingType.unknown);
        expect(model.appointmentTime.millisecondsSinceEpoch, 0);
        expect(model.dentistPhoto, isNull);
        expect(model.notes, isNull);
        expect(model.rejectionReason, isNull);
      },
    );

    test('UT-MOD-APP-04 normalizes backend aliases for status and type', () {
      final confirmed = AppointmentModel.fromJson(
        validAppointmentJson(status: ' confirmed ', type: 'walkin'),
      );
      final canceled = AppointmentModel.fromJson(
        validAppointmentJson(status: 'canceled', type: 'continue-treatment'),
      );

      expect(confirmed.status, AppointmentStatus.approved);
      expect(confirmed.type, AppointmentBookingType.walkIn);
      expect(canceled.status, AppointmentStatus.cancelled);
      expect(canceled.type, AppointmentBookingType.continueTreatment);
    });

    test('UT-MOD-APP-05 parses nested treatment and numeric strings', () {
      final json = validAppointmentJson();
      json['treatment'] = <String, dynamic>{
        'id': '9',
        'treatment_type': <String, dynamic>{
          'ar': 'تقويم',
          'en': 'Orthodontics',
        },
        'status': 'ongoing',
        'total_sessions_needed': '10',
        'sessions_completed': '4',
        'notes': ' Follow-up ',
      };

      final model = AppointmentModel.fromJson(json);

      expect(model.treatment, isNotNull);
      expect(model.treatment!.id, 9);
      expect(model.treatment!.totalSessionsNeeded, 10);
      expect(model.treatment!.sessionsCompleted, 4);
      expect(model.treatment!.notes, 'Follow-up');
    });

    test(
      'UT-MOD-APP-06 toJson/fromJson preserves important appointment data',
      () {
        final original = AppointmentModel.fromJson(validAppointmentJson());

        final restored = AppointmentModel.fromJson(original.toJson());

        expect(restored.id, original.id);
        expect(restored.dentistId, original.dentistId);
        expect(restored.dentistName, original.dentistName);
        expect(restored.type, original.type);
        expect(restored.status, original.status);
        expect(restored.appointmentTime, original.appointmentTime);
      },
    );
  });

  group('appointment response models', () {
    test('UT-MOD-APP-07 list response parses items and numeric count', () {
      final response = ShowAppointmentsResponseModel.fromJson(<String, dynamic>{
        'success': true,
        'count': '1',
        'data': <dynamic>[validAppointmentJson()],
      });

      expect(response.success, isTrue);
      expect(response.count, 1);
      expect(response.appointments, hasLength(1));
    });

    test(
      'UT-MOD-APP-08 list response safely falls back for malformed list data',
      () {
        final response = ShowAppointmentsResponseModel.fromJson(
          <String, dynamic>{
            'success': false,
            'count': 'invalid',
            'data': 'not-a-list',
          },
        );

        expect(response.success, isFalse);
        expect(response.count, 0);
        expect(response.appointments, isEmpty);
      },
    );

    test('UT-MOD-APP-09 details response rejects missing object data', () {
      expect(
        () => ShowAppointmentDetailsResponseModel.fromJson(<String, dynamic>{
          'success': true,
          'data': null,
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test(
      'UT-MOD-APP-10 action response rejects malformed appointment data',
      () {
        expect(
          () => AppointmentActionResponseModel.fromJson(<String, dynamic>{
            'success': true,
            'message': 'Created',
            'data': <dynamic>[],
          }),
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  test(
    'UT-MOD-APP-11 appointment types parse specializations and trim names',
    () {
      final response = ShowAppointmentTypesResponseModel.fromJson(
        <String, dynamic>{
          'success': true,
          'data': <dynamic>[
            <String, dynamic>{
              'id': '1',
              'name': ' كشف عام ',
              'name_en': ' General Checkup ',
              'specializations': <dynamic>[
                <String, dynamic>{'id': '6', 'name': 'General Dentistry'},
              ],
            },
          ],
        },
      );

      expect(response.appointmentTypes, hasLength(1));
      expect(response.appointmentTypes.first.id, 1);
      expect(response.appointmentTypes.first.name, 'كشف عام');
      expect(response.appointmentTypes.first.nameEn, 'General Checkup');
      expect(response.appointmentTypes.first.specializations.first.id, 6);
    },
  );

  test('UT-MOD-APP-12 dentists parse string numbers and null-like fields', () {
    final response = ShowDentistsByAppointmentTypeResponseModel.fromJson(
      <String, dynamic>{
        'success': true,
        'data': <dynamic>[
          <String, dynamic>{
            'id': '4',
            'name': ' Dr. Lina ',
            'profile_picture': 'null',
            'specialization': <String, dynamic>{
              'ar': 'طب أسنان الأطفال',
              'en': 'Pediatric Dentistry',
            },
            'years_of_experience': '7',
            'average_rating': '3.80',
            'bio': '   ',
          },
        ],
      },
    );

    final dentist = response.dentists.single;
    expect(dentist.id, 4);
    expect(dentist.name, 'Dr. Lina');
    expect(dentist.profilePicture, isNull);
    expect(dentist.yearsOfExperience, 7);
    expect(dentist.averageRating, 3.8);
    expect(dentist.bio, isNull);
  });

  group('dentist schedule model', () {
    test('UT-MOD-APP-13 parses days, slots, and backend date formats', () {
      final response = ShowDentistScheduleResponseModel.fromJson(
        <String, dynamic>{
          'success': true,
          'dentist_id': '4',
          'data': <dynamic>[
            <String, dynamic>{
              'date': '2026-08-26',
              'day': 'Wednesday',
              'slots': <dynamic>[
                <String, dynamic>{
                  'time': '10:00',
                  'datetime': '2026-08-26 10:00:00',
                },
              ],
            },
          ],
        },
      );

      expect(response.schedule.dentistId, 4);
      expect(response.schedule.days, hasLength(1));
      expect(response.schedule.days.single.date, DateTime(2026, 8, 26));
      expect(
        response.schedule.days.single.slots.single.dateTime,
        DateTime(2026, 8, 26, 10),
      );
    });

    test('UT-MOD-APP-14 rejects a schedule whose data is not a list', () {
      expect(
        () => ShowDentistScheduleResponseModel.fromJson(<String, dynamic>{
          'success': true,
          'data': null,
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('appointment request models', () {
    test('UT-MOD-APP-15 add request formats time, enum, and notes', () {
      final request = AddAppointmentRequestModel(
        dentistId: 4,
        appointmentTypeId: 1,
        appointmentTime: DateTime(2026, 8, 26, 9, 5, 7),
        type: AppointmentBookingType.continueTreatment,
        treatmentId: 9,
        notes: ' Follow-up ',
      );

      expect(request.toJson(), <String, dynamic>{
        'dentist_id': 4,
        'appointment_type_id': 1,
        'appointment_time': '2026-08-26 09:05:07',
        'type': 'continue_treatment',
        'treatment_id': 9,
        'notes': 'Follow-up',
      });
    });

    test('UT-MOD-APP-16 update request converts blank notes to null', () {
      final request = UpdateAppointmentRequestModel(
        appointmentTime: DateTime(2026, 8, 27, 11),
        notes: '   ',
      );

      expect(request.toJson(), <String, dynamic>{
        'appointment_time': '2026-08-27 11:00:00',
        'notes': null,
      });
    });
  });
}
