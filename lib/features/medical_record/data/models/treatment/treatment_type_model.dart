import '../../../domain/entities/treatment/treatment_type_entity.dart';

class TreatmentTypeModel extends TreatmentTypeEntity {
  const TreatmentTypeModel({
    required super.id,
    required super.name,
    required super.nameEn,
  });

  factory TreatmentTypeModel.fromJson(Map<String, dynamic> json) {
    return TreatmentTypeModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
    };
  }
}