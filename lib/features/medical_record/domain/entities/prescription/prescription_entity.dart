import 'medication_entity.dart';

class PrescriptionEntity {
  final int id;
  final String dentistName;
  final String? notes;
  final String createdAt;
  final List<MedicationEntity> medications;

  const PrescriptionEntity({
    required this.id,
    required this.dentistName,
    required this.notes,
    required this.createdAt,
    required this.medications,
  });
}