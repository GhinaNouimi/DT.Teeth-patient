import '../../../domain/entities/invoice/invoice_treatment_type_entity.dart';

class InvoiceTreatmentTypeModel extends InvoiceTreatmentTypeEntity {
  const InvoiceTreatmentTypeModel({
    required super.name,
    required super.nameEn,
  });

  factory InvoiceTreatmentTypeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return InvoiceTreatmentTypeModel(
      name: json['ar'] ?? '',
      nameEn: json['en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ar': name,
      'en': nameEn,
    };
  }
}