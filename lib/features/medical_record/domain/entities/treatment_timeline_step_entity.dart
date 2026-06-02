enum TreatmentTimelineStepState { completed, current, upcoming }

class TreatmentTimelineStepEntity {
  final String title;
  final String dateLabel;
  final String? subtitle;
  final TreatmentTimelineStepState state;

  const TreatmentTimelineStepEntity({
    required this.title,
    required this.dateLabel,
    this.subtitle,
    required this.state,
  });
}
