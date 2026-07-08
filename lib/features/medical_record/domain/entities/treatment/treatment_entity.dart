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

  bool get isCompleted => status == 'completed';

  bool get isActive => status != 'completed';
}