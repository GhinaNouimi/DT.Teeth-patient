import '../../../domain/entities/treatment/treatment_session_entity.dart';
import 'tooth_treatment_model.dart';
import 'treatment_dentist_model.dart';

class TreatmentSessionModel extends TreatmentSessionEntity {
  const TreatmentSessionModel({
    required super.id,
    required super.treatmentId,
    required super.sessionNumber,
    required super.status,
    super.actualStartTime,
    super.actualEndTime,
    super.dentist,
    super.notes,
    required super.sessionCost,
    required super.toothTreatments,
  });

  factory TreatmentSessionModel.fromJson(Map<String, dynamic> json) {
    return TreatmentSessionModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      treatmentId: json['treatment_id'] is int
          ? json['treatment_id']
          : int.tryParse(json['treatment_id']?.toString() ?? '') ?? 0,
      sessionNumber: json['session_number'] is int
          ? json['session_number']
          : int.tryParse(json['session_number']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? '',
      actualStartTime: json['actual_start_time']?.toString(),
      actualEndTime: json['actual_end_time']?.toString(),
      dentist: json['dentist'] is Map<String, dynamic>
          ? TreatmentDentistModel.fromJson(json['dentist'])
          : null,
      notes: json['notes']?.toString(),
      sessionCost: json['session_cost'] is num
          ? json['session_cost']
          : num.tryParse(json['session_cost']?.toString() ?? '') ?? 0,
      toothTreatments: (json['tooth_treatments'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ToothTreatmentModel.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final dentistValue = dentist;

    return {
      'id': id,
      'treatment_id': treatmentId,
      'session_number': sessionNumber,
      'status': status,
      'actual_start_time': actualStartTime,
      'actual_end_time': actualEndTime,
      'dentist': dentistValue is TreatmentDentistModel
          ? dentistValue.toJson()
          : dentistValue == null
          ? null
          : {
        'id': dentistValue.id,
        'name': dentistValue.name,
      },
      'notes': notes,
      'session_cost': sessionCost,
      'tooth_treatments': toothTreatments.map((item) {
        if (item is ToothTreatmentModel) return item.toJson();

        return {
          'id': item.id,
          'tooth_number': item.toothNumber,
          'procedure': {
            'id': item.procedure.id,
            'name': item.procedure.name,
            'name_en': item.procedure.nameEn,
            'price': item.procedure.price,
          },
          'notes': item.notes,
        };
      }).toList(),
    };
  }
}