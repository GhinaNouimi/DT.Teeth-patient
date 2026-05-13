import '../../domain/entities/treatment_appointment_entity.dart';

class TreatmentAppointmentModel {
  final String title;
  final String dateLabel;
  final String timeLabel;
  final bool isUpcoming;

  const TreatmentAppointmentModel({
    required this.title,
    required this.dateLabel,
    required this.timeLabel,
    required this.isUpcoming,
  });

  TreatmentAppointmentEntity toEntity() {
    return TreatmentAppointmentEntity(
      title: title,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      isUpcoming: isUpcoming,
    );
  }
}
