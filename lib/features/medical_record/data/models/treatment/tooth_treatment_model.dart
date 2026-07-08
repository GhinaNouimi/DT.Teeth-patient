import '../../../domain/entities/treatment/tooth_treatment_entity.dart';
import 'treatment_procedure_model.dart';

class ToothTreatmentModel extends ToothTreatmentEntity {
  const ToothTreatmentModel({
    required super.id,
    required super.toothNumber,
    required super.procedure,
    super.notes,
  });

  factory ToothTreatmentModel.fromJson(Map<String, dynamic> json) {
    return ToothTreatmentModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      toothNumber: json['tooth_number'] is int
          ? json['tooth_number']
          : int.tryParse(json['tooth_number']?.toString() ?? '') ?? 0,
      procedure: TreatmentProcedureModel.fromJson(
        json['procedure'] is Map<String, dynamic>
            ? json['procedure']
            : <String, dynamic>{},
      ),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final procedureValue = procedure;

    return {
      'id': id,
      'tooth_number': toothNumber,
      'procedure': procedureValue is TreatmentProcedureModel
          ? procedureValue.toJson()
          : {
        'id': procedure.id,
        'name': procedure.name,
        'name_en': procedure.nameEn,
        'price': procedure.price,
      },
      'notes': notes,
    };
  }
}