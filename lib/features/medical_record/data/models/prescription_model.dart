import '../../domain/entities/prescription_entity.dart';

class PrescriptionModel {
  final String id;
  final String medicineName;
  final String concentration;
  final String dosage;
  final String instructions;
  final String duration;
  final String prescribedAtLabel;
  final String doctorName;
  final PrescriptionStatus status;
  final String notes;
  final String visualEmoji;

  const PrescriptionModel({
    required this.id,
    required this.medicineName,
    required this.concentration,
    required this.dosage,
    required this.instructions,
    required this.duration,
    required this.prescribedAtLabel,
    required this.doctorName,
    required this.status,
    required this.notes,
    required this.visualEmoji,
  });

  PrescriptionEntity toEntity() {
    return PrescriptionEntity(
      id: id,
      medicineName: medicineName,
      concentration: concentration,
      dosage: dosage,
      instructions: instructions,
      duration: duration,
      prescribedAtLabel: prescribedAtLabel,
      doctorName: doctorName,
      status: status,
      notes: notes,
      visualEmoji: visualEmoji,
    );
  }
}
