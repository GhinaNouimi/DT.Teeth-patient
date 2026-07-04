import '../../../domain/entities/prescription/prescription_entity.dart';
import 'medication_model.dart';

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.dentistName,
    required super.notes,
    required super.createdAt,
    required super.medications,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      dentistName: json['dentist_name']?.toString() ?? '',
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      medications: (json['medications'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(MedicationModel.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dentist_name': dentistName,
      'notes': notes,
      'created_at': createdAt,
      'medications': medications
          .map(
            (medication) => {
          'name': medication.name,
          'dosage': medication.dosage,
          'frequency': medication.frequency,
          'duration': medication.duration,
          'notes': medication.notes,
        },
      )
          .toList(),
    };
  }
}