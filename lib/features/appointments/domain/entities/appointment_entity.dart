enum AppointmentStatus {
  pending,
  pendingSecretary,
  approved,
  rejected,
  cancelled,
  completed,
  patientNoShow,
  unknown,
}

enum AppointmentBookingType {
  emergency,
  newTreatment,
  continueTreatment,
  walkIn,
  unknown,
}

class AppointmentEntity {
  final int id;
  final String dentistName;

  final String appointmentTypeName;
  final String appointmentTypeNameEn;

  final AppointmentBookingType type;
  final AppointmentStatus status;

  final DateTime appointmentTime;

  final String? rejectionReason;
  final String? notes;

  final AppointmentTreatmentEntity? treatment;

  const AppointmentEntity({
    required this.id,
    required this.dentistName,
    required this.appointmentTypeName,
    required this.appointmentTypeNameEn,
    required this.type,
    required this.status,
    required this.appointmentTime,
    this.rejectionReason,
    this.notes,
    this.treatment,
  });

  String localizedAppointmentType(
      String languageCode,
      ) {
    final isArabic =
    languageCode.toLowerCase().startsWith('ar');

    if (isArabic) {
      return appointmentTypeName.isNotEmpty
          ? appointmentTypeName
          : appointmentTypeNameEn;
    }

    return appointmentTypeNameEn.isNotEmpty
        ? appointmentTypeNameEn
        : appointmentTypeName;
  }

  bool get hasTreatment => treatment != null;

  bool get hasNotes {
    return notes != null &&
        notes!.trim().isNotEmpty;
  }

  bool get hasRejectionReason {
    return rejectionReason != null &&
        rejectionReason!.trim().isNotEmpty;
  }

  bool get isPending {
    return status == AppointmentStatus.pending;
  }

  bool get isPendingSecretary {
    return status ==
        AppointmentStatus.pendingSecretary;
  }

  bool get isApproved {
    return status == AppointmentStatus.approved;
  }

  bool get isCompleted {
    return status == AppointmentStatus.completed;
  }

  bool get isCancelled {
    return status == AppointmentStatus.cancelled;
  }

  bool get isRejected {
    return status == AppointmentStatus.rejected;
  }

  bool get isPatientNoShow {
    return status == AppointmentStatus.patientNoShow;
  }

  bool get isUnknown {
    return status == AppointmentStatus.unknown;
  }

  bool get isUpcoming {
    return isPending ||
        isPendingSecretary ||
        isApproved;
  }

  bool get isPast {
    return isCompleted ||
        isCancelled ||
        isRejected ||
        isPatientNoShow;
  }

  bool get canAttemptCancellation {
    return isPending ||
        isPendingSecretary ||
        isApproved;
  }

  AppointmentEntity copyWith({
    int? id,
    String? dentistName,
    String? appointmentTypeName,
    String? appointmentTypeNameEn,
    AppointmentBookingType? type,
    AppointmentStatus? status,
    DateTime? appointmentTime,
    String? rejectionReason,
    String? notes,
    AppointmentTreatmentEntity? treatment,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      dentistName:
      dentistName ?? this.dentistName,
      appointmentTypeName:
      appointmentTypeName ??
          this.appointmentTypeName,
      appointmentTypeNameEn:
      appointmentTypeNameEn ??
          this.appointmentTypeNameEn,
      type: type ?? this.type,
      status: status ?? this.status,
      appointmentTime:
      appointmentTime ??
          this.appointmentTime,
      rejectionReason:
      rejectionReason ??
          this.rejectionReason,
      notes: notes ?? this.notes,
      treatment: treatment ?? this.treatment,
    );
  }
}

class AppointmentTreatmentEntity {
  final int id;

  final String treatmentTypeName;
  final String treatmentTypeNameEn;

  final String status;
  final int totalSessionsNeeded;
  final int sessionsCompleted;
  final String? notes;

  const AppointmentTreatmentEntity({
    required this.id,
    required this.treatmentTypeName,
    required this.treatmentTypeNameEn,
    required this.status,
    required this.totalSessionsNeeded,
    required this.sessionsCompleted,
    this.notes,
  });

  String localizedTreatmentType(
      String languageCode,
      ) {
    final isArabic =
    languageCode.toLowerCase().startsWith('ar');

    if (isArabic) {
      return treatmentTypeName.isNotEmpty
          ? treatmentTypeName
          : treatmentTypeNameEn;
    }

    return treatmentTypeNameEn.isNotEmpty
        ? treatmentTypeNameEn
        : treatmentTypeName;
  }

  bool get hasNotes {
    return notes != null &&
        notes!.trim().isNotEmpty;
  }

  bool get isOngoing {
    return status.trim().toLowerCase() ==
        'ongoing';
  }

  bool get isCompleted {
    return status.trim().toLowerCase() ==
        'completed';
  }

  bool get isCancelled {
    return status.trim().toLowerCase() ==
        'cancelled';
  }

  double get progress {
    if (totalSessionsNeeded <= 0) {
      return 0;
    }

    return (sessionsCompleted /
        totalSessionsNeeded)
        .clamp(0.0, 1.0);
  }
}