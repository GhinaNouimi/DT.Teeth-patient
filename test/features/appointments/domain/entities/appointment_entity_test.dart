import 'package:dt_teeth/features/appointments/domain/entities/appointment_entity.dart';
import 'package:flutter_test/flutter_test.dart';

AppointmentEntity appointment({
  AppointmentStatus status = AppointmentStatus.pending,
  String? photo,
  String? notes,
  String? rejectionReason,
  String arabicType = 'كشف عام',
  String englishType = 'General Checkup',
}) {
  return AppointmentEntity(
    id: 23,
    dentistId: 4,
    dentistName: 'Dr. Lina',
    dentistPhoto: photo,
    appointmentTypeName: arabicType,
    appointmentTypeNameEn: englishType,
    type: AppointmentBookingType.newTreatment,
    status: status,
    appointmentTime: DateTime(2026, 8, 26, 10),
    rejectionReason: rejectionReason,
    notes: notes,
  );
}

void main() {
  group('AppointmentEntity localization', () {
    test(
      'returns Arabic or English appointment type for the active locale',
      () {
        final entity = appointment();

        expect(entity.localizedAppointmentType('ar'), 'كشف عام');
        expect(entity.localizedAppointmentType('ar_SY'), 'كشف عام');
        expect(entity.localizedAppointmentType('en'), 'General Checkup');
      },
    );

    test('falls back to the available localized name', () {
      expect(
        appointment(arabicType: '').localizedAppointmentType('ar'),
        'General Checkup',
      );
      expect(
        appointment(englishType: '').localizedAppointmentType('en'),
        'كشف عام',
      );
    });
  });

  group('AppointmentEntity optional values', () {
    test('treats null, empty, and whitespace values as absent', () {
      expect(appointment().hasDentistPhoto, isFalse);
      expect(appointment(photo: '   ').hasDentistPhoto, isFalse);
      expect(appointment(notes: '').hasNotes, isFalse);
      expect(appointment(rejectionReason: ' ').hasRejectionReason, isFalse);
    });

    test('recognizes present photo, notes, and rejection reason', () {
      final entity = appointment(
        photo: 'https://example.com/doctor.png',
        notes: 'Patient note',
        rejectionReason: 'Unavailable time',
      );

      expect(entity.hasDentistPhoto, isTrue);
      expect(entity.hasNotes, isTrue);
      expect(entity.hasRejectionReason, isTrue);
    });
  });

  group('AppointmentEntity status rules', () {
    test(
      'pending, pendingSecretary, and approved are upcoming and actionable',
      () {
        for (final status in <AppointmentStatus>[
          AppointmentStatus.pending,
          AppointmentStatus.pendingSecretary,
          AppointmentStatus.approved,
        ]) {
          final entity = appointment(status: status);
          expect(
            entity.isUpcoming,
            isTrue,
            reason: '$status should be upcoming',
          );
          expect(entity.isPast, isFalse);
          expect(entity.canAttemptCancellation, isTrue);
          expect(entity.canAttemptReschedule, isTrue);
        }
      },
    );

    test(
      'completed, cancelled, rejected, and no-show are past and not actionable',
      () {
        for (final status in <AppointmentStatus>[
          AppointmentStatus.completed,
          AppointmentStatus.cancelled,
          AppointmentStatus.rejected,
          AppointmentStatus.patientNoShow,
        ]) {
          final entity = appointment(status: status);
          expect(entity.isPast, isTrue, reason: '$status should be past');
          expect(entity.isUpcoming, isFalse);
          expect(entity.canAttemptCancellation, isFalse);
          expect(entity.canAttemptReschedule, isFalse);
        }
      },
    );
  });
}
