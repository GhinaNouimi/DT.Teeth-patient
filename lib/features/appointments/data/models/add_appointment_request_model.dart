import '../../domain/entities/appointment_entity.dart';

class AddAppointmentRequestModel {
  final int dentistId;
  final int appointmentTypeId;
  final DateTime appointmentTime;
  final AppointmentBookingType type;
  final int? treatmentId;
  final String? notes;

  const AddAppointmentRequestModel({
    required this.dentistId,
    required this.appointmentTypeId,
    required this.appointmentTime,
    required this.type,
    this.treatmentId,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'dentist_id': dentistId,
      'appointment_type_id': appointmentTypeId,
      'appointment_time': _formatDateTime(
        appointmentTime,
      ),
      'type': _bookingTypeToJson(type),
      'treatment_id': treatmentId,
      'notes': _normalizeNullableString(notes),
    };
  }

  static String _bookingTypeToJson(
      AppointmentBookingType type,
      ) {
    switch (type) {
      case AppointmentBookingType.emergency:
        return 'emergency';

      case AppointmentBookingType.newTreatment:
        return 'new_treatment';

      case AppointmentBookingType.continueTreatment:
        return 'continue_treatment';

      case AppointmentBookingType.walkIn:
        return 'walk_in';

      case AppointmentBookingType.unknown:
        return 'unknown';
    }
  }

  static String _formatDateTime(
      DateTime value,
      ) {
    final year =
    value.year.toString().padLeft(4, '0');
    final month =
    value.month.toString().padLeft(2, '0');
    final day =
    value.day.toString().padLeft(2, '0');
    final hour =
    value.hour.toString().padLeft(2, '0');
    final minute =
    value.minute.toString().padLeft(2, '0');
    final second =
    value.second.toString().padLeft(2, '0');

    return '$year-$month-$day '
        '$hour:$minute:$second';
  }

  static String? _normalizeNullableString(
      String? value,
      ) {
    final normalized = value?.trim();

    if (normalized == null ||
        normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}