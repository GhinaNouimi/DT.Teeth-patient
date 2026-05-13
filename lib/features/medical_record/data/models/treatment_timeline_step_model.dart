import '../../domain/entities/treatment_timeline_step_entity.dart';

class TreatmentTimelineStepModel {
  final String title;
  final String dateLabel;
  final String? subtitle;
  final TreatmentTimelineStepState state;

  const TreatmentTimelineStepModel({
    required this.title,
    required this.dateLabel,
    this.subtitle,
    required this.state,
  });

  TreatmentTimelineStepEntity toEntity() {
    return TreatmentTimelineStepEntity(
      title: title,
      dateLabel: dateLabel,
      subtitle: subtitle,
      state: state,
    );
  }
}
