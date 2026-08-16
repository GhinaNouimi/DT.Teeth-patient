class UpdateAppointmentRequestModel {
  final DateTime appointmentTime;
  final String? notes;

  const UpdateAppointmentRequestModel({
    required this.appointmentTime,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointment_time': _formatDateTime(
        appointmentTime,
      ),
      'notes': _normalizeNullableString(notes),
    };
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