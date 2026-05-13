class TreatmentAppointmentEntity {
  final String title;
  final String dateLabel;
  final String timeLabel;
  final bool isUpcoming;

  const TreatmentAppointmentEntity({
    required this.title,
    required this.dateLabel,
    required this.timeLabel,
    required this.isUpcoming,
  });
}
