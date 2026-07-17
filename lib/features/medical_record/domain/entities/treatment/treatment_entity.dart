import 'treatment_dentist_entity.dart';
import 'treatment_session_entity.dart';
import 'treatment_type_entity.dart';

class TreatmentEntity {
  final int id;
  final TreatmentTypeEntity treatmentType;
  final TreatmentDentistEntity dentist;
  final String status;
  final int totalSessionsNeeded;
  final int sessionsCompleted;
  final String? notes;
  final String createdAt;
  final List<TreatmentSessionEntity> sessions;

  const TreatmentEntity({
    required this.id,
    required this.treatmentType,
    required this.dentist,
    required this.status,
    required this.totalSessionsNeeded,
    required this.sessionsCompleted,
    this.notes,
    required this.createdAt,
    required this.sessions,
  });

  String get normalizedStatus {
    return status.trim().toLowerCase();
  }

  bool get isOngoing {
    return normalizedStatus == 'ongoing';
  }

  bool get isCompleted {
    return normalizedStatus == 'completed';
  }

  bool get isCancelled {
    return normalizedStatus == 'cancelled' ||
        normalizedStatus == 'canceled';
  }

  bool get isActive {
    return isOngoing;
  }

  bool get hasNotes {
    return notes != null && notes!.trim().isNotEmpty;
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