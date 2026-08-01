import '../../../medical_record/data/models/treatment/treatment_type_model.dart';
import '../../domain/entities/applicable_treatment_entity.dart';

class ApplicableTreatmentModel
    extends ApplicableTreatmentEntity {
  const ApplicableTreatmentModel({
    required super.id,
    required super.dentistId,
    required super.treatmentType,
    required super.totalSessionsNeeded,
    required super.sessionsCompleted,
    required super.status,
    super.notes,
    required super.createdAt,
  });

  factory ApplicableTreatmentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ApplicableTreatmentModel(
      id: _parseInt(json['id']),
      dentistId: _parseInt(json['dentist_id']),
      treatmentType: TreatmentTypeModel.fromJson(
        json['treatment_type'] is Map<String, dynamic>
            ? json['treatment_type']
        as Map<String, dynamic>
            : <String, dynamic>{},
      ),
      totalSessionsNeeded: _parseInt(
        json['total_sessions_needed'],
      ),
      sessionsCompleted: _parseInt(
        json['sessions_completed'],
      ),
      status: json['status']?.toString() ?? '',
      notes: _parseNullableString(json['notes']),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final treatmentTypeValue = treatmentType;

    return {
      'id': id,
      'dentist_id': dentistId,
      'treatment_type': treatmentTypeValue
      is TreatmentTypeModel
          ? treatmentTypeValue.toJson()
          : {
        'id': treatmentType.id,
        'name': treatmentType.name,
        'name_en': treatmentType.nameEn,
      },
      'total_sessions_needed':
      totalSessionsNeeded,
      'sessions_completed': sessionsCompleted,
      'status': status,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static String? _parseNullableString(
      dynamic value,
      ) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }
}