import 'tooth_treatment_entity.dart';
import 'treatment_dentist_entity.dart';

class TreatmentSessionEntity {
  final int id;
  final int treatmentId;
  final int sessionNumber;
  final String status;
  final String? actualStartTime;
  final String? actualEndTime;
  final TreatmentDentistEntity? dentist;
  final String? notes;
  final num sessionCost;
  final List<ToothTreatmentEntity> toothTreatments;

  const TreatmentSessionEntity({
    required this.id,
    required this.treatmentId,
    required this.sessionNumber,
    required this.status,
    this.actualStartTime,
    this.actualEndTime,
    this.dentist,
    this.notes,
    required this.sessionCost,
    required this.toothTreatments,
  });
}