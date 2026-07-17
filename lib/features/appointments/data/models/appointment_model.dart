import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.dentistName,
    required super.appointmentTypeName,
    required super.appointmentTypeNameEn,
    required super.type,
    required super.status,
    required super.appointmentTime,
    super.rejectionReason,
    super.notes,
    super.treatment,
  });

  factory AppointmentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final appointmentType =
    _parseMap(json['appointment_type']);

    final treatmentJson =
    _parseNullableMap(json['treatment']);

    return AppointmentModel(
      id: _parseInt(json['id']),
      dentistName:
      json['dentist_name']?.toString().trim() ?? '',
      appointmentTypeName:
      appointmentType['ar']?.toString().trim() ?? '',
      appointmentTypeNameEn:
      appointmentType['en']?.toString().trim() ?? '',
      type: _mapBookingType(
        json['type']?.toString() ?? '',
      ),
      status: _mapStatus(
        json['status']?.toString() ?? '',
      ),
      appointmentTime: _parseDateTime(
        json['appointment_time'],
      ),
      rejectionReason: _parseNullableString(
        json['rejection_reason'],
      ),
      notes: _parseNullableString(
        json['notes'],
      ),
      treatment: treatmentJson == null
          ? null
          : AppointmentTreatmentModel.fromJson(
        treatmentJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final treatmentValue = treatment;

    return {
      'id': id,
      'dentist_name': dentistName,
      'appointment_type': {
        'ar': appointmentTypeName,
        'en': appointmentTypeNameEn,
      },
      'type': _bookingTypeToJson(type),
      'status': _statusToJson(status),
      'appointment_time':
      _formatDateTimeForCache(appointmentTime),
      'rejection_reason': rejectionReason,
      'notes': notes,
      'treatment': treatmentValue == null
          ? null
          : treatmentValue is AppointmentTreatmentModel
          ? treatmentValue.toJson()
          : {
        'id': treatmentValue.id,
        'treatment_type': {
          'ar': treatmentValue.treatmentTypeName,
          'en': treatmentValue.treatmentTypeNameEn,
        },
        'status': treatmentValue.status,
        'total_sessions_needed':
        treatmentValue.totalSessionsNeeded,
        'sessions_completed':
        treatmentValue.sessionsCompleted,
        'notes': treatmentValue.notes,
      },
    };
  }

  static AppointmentStatus _mapStatus(
      String value,
      ) {
    switch (_normalize(value)) {
      case 'pending':
        return AppointmentStatus.pending;

      case 'pending_secretary':
        return AppointmentStatus.pendingSecretary;

      case 'approved':
      case 'confirmed':
        return AppointmentStatus.approved;

      case 'rejected':
        return AppointmentStatus.rejected;

      case 'cancelled':
      case 'canceled':
        return AppointmentStatus.cancelled;

      case 'completed':
        return AppointmentStatus.completed;

      case 'patient_no_show':
        return AppointmentStatus.patientNoShow;

      default:
        return AppointmentStatus.unknown;
    }
  }

  static AppointmentBookingType _mapBookingType(
      String value,
      ) {
    switch (_normalize(value)) {
      case 'emergency':
        return AppointmentBookingType.emergency;

      case 'new_treatment':
        return AppointmentBookingType.newTreatment;

      case 'continue_treatment':
        return AppointmentBookingType.continueTreatment;

      case 'walk_in':
      case 'walkin':
        return AppointmentBookingType.walkIn;

      default:
        return AppointmentBookingType.unknown;
    }
  }

  static String _statusToJson(
      AppointmentStatus status,
      ) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'pending';

      case AppointmentStatus.pendingSecretary:
        return 'pending_secretary';

      case AppointmentStatus.approved:
        return 'approved';

      case AppointmentStatus.rejected:
        return 'rejected';

      case AppointmentStatus.cancelled:
        return 'cancelled';

      case AppointmentStatus.completed:
        return 'completed';

      case AppointmentStatus.patientNoShow:
        return 'patient_no_show';

      case AppointmentStatus.unknown:
        return 'unknown';
    }
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

  static DateTime _parseDateTime(
      dynamic value,
      ) {
    final rawValue =
        value?.toString().trim() ?? '';

    if (rawValue.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.tryParse(rawValue) ??
        DateTime.tryParse(
          rawValue.replaceFirst(' ', 'T'),
        ) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  static String _formatDateTimeForCache(
      DateTime value,
      ) {
    return value.toIso8601String();
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static Map<String, dynamic> _parseMap(
      dynamic value,
      ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return const {};
  }

  static Map<String, dynamic>? _parseNullableMap(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  static String? _parseNullableString(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final normalized = value.toString().trim();

    if (normalized.isEmpty ||
        normalized.toLowerCase() == 'null') {
      return null;
    }

    return normalized;
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
  }
}

class AppointmentTreatmentModel
    extends AppointmentTreatmentEntity {
  const AppointmentTreatmentModel({
    required super.id,
    required super.treatmentTypeName,
    required super.treatmentTypeNameEn,
    required super.status,
    required super.totalSessionsNeeded,
    required super.sessionsCompleted,
    super.notes,
  });

  factory AppointmentTreatmentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final treatmentType =
    AppointmentModel._parseMap(
      json['treatment_type'],
    );

    return AppointmentTreatmentModel(
      id: AppointmentModel._parseInt(
        json['id'],
      ),
      treatmentTypeName:
      treatmentType['ar']?.toString().trim() ?? '',
      treatmentTypeNameEn:
      treatmentType['en']?.toString().trim() ?? '',
      status:
      json['status']?.toString().trim() ?? '',
      totalSessionsNeeded:
      AppointmentModel._parseInt(
        json['total_sessions_needed'],
      ),
      sessionsCompleted:
      AppointmentModel._parseInt(
        json['sessions_completed'],
      ),
      notes:
      AppointmentModel._parseNullableString(
        json['notes'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'treatment_type': {
        'ar': treatmentTypeName,
        'en': treatmentTypeNameEn,
      },
      'status': status,
      'total_sessions_needed':
      totalSessionsNeeded,
      'sessions_completed':
      sessionsCompleted,
      'notes': notes,
    };
  }
}