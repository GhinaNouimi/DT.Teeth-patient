import '../../../medical_record/data/models/treatment/treatment_type_model.dart';
import '../../domain/entities/offer_entity.dart';

class OfferModel extends OfferEntity {
  const OfferModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.conditions,
    required super.discountPercentage,
    required super.photoPath,
    required super.treatmentTypes,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final treatmentTypesJson = json['treatment_types'];

    return OfferModel(
      id: _parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      conditions: json['conditions']?.toString() ?? '',
      discountPercentage: _parseDouble(
        json['discount_percentage'],
      ),
      photoPath: _parseNullableString(json['photo_path']),
      treatmentTypes: treatmentTypesJson is List
          ? treatmentTypesJson
          .whereType<Map<String, dynamic>>()
          .map(TreatmentTypeModel.fromJson)
          .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_date': _dateToJson(startDate),
      'end_date': _dateToJson(endDate),
      'conditions': conditions,
      'discount_percentage': discountPercentage,
      'photo_path': photoPath,
      'treatment_types': treatmentTypes
          .map(
            (type) => {
          'id': type.id,
          'name': type.name,
          'name_en': type.nameEn,
        },
      )
          .toList(),
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    final date = value?.toString();

    if (date == null || date.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(date);
  }

  static String? _parseNullableString(dynamic value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  static String? _dateToJson(DateTime? date) {
    if (date == null) {
      return null;
    }

    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}