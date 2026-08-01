import '../../../medical_record/domain/entities/treatment/treatment_type_entity.dart';

class ApplicableTreatmentEntity {
  final int id;
  final int dentistId;
  final TreatmentTypeEntity treatmentType;
  final int totalSessionsNeeded;
  final int sessionsCompleted;
  final String status;
  final String? notes;
  final String createdAt;

  const ApplicableTreatmentEntity({
    required this.id,
    required this.dentistId,
    required this.treatmentType,
    required this.totalSessionsNeeded,
    required this.sessionsCompleted,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  String get normalizedStatus {
    return status.trim().toLowerCase();
  }

  bool get isOngoing => normalizedStatus == 'ongoing';

  bool get isCompleted => normalizedStatus == 'completed';

  bool get isCancelled {
    return normalizedStatus == 'cancelled' ||
        normalizedStatus == 'canceled';
  }

  bool get hasNotes {
    return notes != null && notes!.trim().isNotEmpty;
  }

  int get remainingSessions {
    final remaining =
        totalSessionsNeeded - sessionsCompleted;

    return remaining < 0 ? 0 : remaining;
  }

  double get progress {
    if (totalSessionsNeeded <= 0) {
      return 0;
    }

    return (sessionsCompleted / totalSessionsNeeded)
        .clamp(0.0, 1.0);
  }

  int get progressPercent {
    return (progress * 100).round();
  }
}