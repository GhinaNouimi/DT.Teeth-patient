import '../../../domain/entities/treatment/treatment_procedure_entity.dart';

class TreatmentProcedureModel extends TreatmentProcedureEntity {
  const TreatmentProcedureModel({
    required super.id,
    required super.name,
    required super.nameEn,
    required super.price,
  });

  factory TreatmentProcedureModel.fromJson(Map<String, dynamic> json) {
    return TreatmentProcedureModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'price': price,
    };
  }
}