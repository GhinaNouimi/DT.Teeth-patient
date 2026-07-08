import '../../../domain/entities/treatment/treatment_entity.dart';
import 'treatment_dentist_model.dart';
import 'treatment_session_model.dart';
import 'treatment_type_model.dart';

class TreatmentModel extends TreatmentEntity {
  const TreatmentModel({
    required super.id,
    required super.treatmentType,
    required super.dentist,
    required super.status,
    required super.totalSessionsNeeded,
    required super.sessionsCompleted,
    super.notes,
    required super.createdAt,
    required super.sessions,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      treatmentType: TreatmentTypeModel.fromJson(
        json['treatment_type'] is Map<String, dynamic>
            ? json['treatment_type']
            : <String, dynamic>{},
      ),
      dentist: TreatmentDentistModel.fromJson(
        json['dentist'] is Map<String, dynamic>
            ? json['dentist']
            : <String, dynamic>{},
      ),
      status: json['status']?.toString() ?? '',
      totalSessionsNeeded: json['total_sessions_needed'] is int
          ? json['total_sessions_needed']
          : int.tryParse(json['total_sessions_needed']?.toString() ?? '') ?? 0,
      sessionsCompleted: json['sessions_completed'] is int
          ? json['sessions_completed']
          : int.tryParse(json['sessions_completed']?.toString() ?? '') ?? 0,
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      sessions: (json['sessions'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(TreatmentSessionModel.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final treatmentTypeValue = treatmentType;
    final dentistValue = dentist;

    return {
      'id': id,
      'treatment_type': treatmentTypeValue is TreatmentTypeModel
          ? treatmentTypeValue.toJson()
          : {
        'id': treatmentType.id,
        'name': treatmentType.name,
        'name_en': treatmentType.nameEn,
      },
      'dentist': dentistValue is TreatmentDentistModel
          ? dentistValue.toJson()
          : {
        'id': dentist.id,
        'name': dentist.name,
      },
      'status': status,
      'total_sessions_needed': totalSessionsNeeded,
      'sessions_completed': sessionsCompleted,
      'notes': notes,
      'created_at': createdAt,
      'sessions': sessions.map((session) {
        if (session is TreatmentSessionModel) return session.toJson();

        return {
          'id': session.id,
          'treatment_id': session.treatmentId,
          'session_number': session.sessionNumber,
          'status': session.status,
          'actual_start_time': session.actualStartTime,
          'actual_end_time': session.actualEndTime,
          'dentist': session.dentist == null
              ? null
              : {
            'id': session.dentist!.id,
            'name': session.dentist!.name,
          },
          'notes': session.notes,
          'session_cost': session.sessionCost,
          'tooth_treatments': session.toothTreatments.map((item) {
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
      }).toList(),
    };
  }
}