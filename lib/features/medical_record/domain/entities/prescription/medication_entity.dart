class MedicationEntity {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String? notes;

  const MedicationEntity({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.notes,
  });
}