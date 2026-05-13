enum PrescriptionStatus {
  active,
  completed,
}

class PrescriptionEntity {
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

  const PrescriptionEntity({
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

  bool get isActive => status == PrescriptionStatus.active;
}
