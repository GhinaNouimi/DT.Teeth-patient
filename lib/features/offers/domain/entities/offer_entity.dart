import '../../../medical_record/domain/entities/treatment/treatment_type_entity.dart';

class OfferEntity {
  final int id;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String conditions;
  final double discountPercentage;
  final String? photoPath;
  final List<TreatmentTypeEntity> treatmentTypes;

  const OfferEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.conditions,
    required this.discountPercentage,
    required this.photoPath,
    required this.treatmentTypes,
  });

  bool get hasPhoto =>
      photoPath != null && photoPath!.trim().isNotEmpty;

  bool get hasMultipleTreatmentTypes => treatmentTypes.length > 1;

  bool get isCurrentlyActive {
    if (startDate == null || endDate == null) {
      return false;
    }

    final now = DateTime.now();
    final start = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
    );
    final end = DateTime(
      endDate!.year,
      endDate!.month,
      endDate!.day,
      23,
      59,
      59,
    );

    return !now.isBefore(start) && !now.isAfter(end);
  }
}