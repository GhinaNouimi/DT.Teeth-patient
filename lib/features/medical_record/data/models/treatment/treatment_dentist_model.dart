import '../../../domain/entities/treatment/treatment_dentist_entity.dart';

class TreatmentDentistModel extends TreatmentDentistEntity {
  const TreatmentDentistModel({
    required super.id,
    required super.name,
  });

  factory TreatmentDentistModel.fromJson(Map<String, dynamic> json) {
    return TreatmentDentistModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}