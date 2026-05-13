import '../../domain/entities/treatment_entity.dart';
import 'treatment_appointment_model.dart';
import 'treatment_timeline_step_model.dart';

class TreatmentModel {
  final String id;
  final String name;
  final String doctorName;
  final String statusLabel;
  final TreatmentStatus status;
  final TreatmentType type;
  final int completedSessions;
  final int totalSessions;
  final int progressPercent;
  final String startedAtLabel;
  final String? nextSessionLabel;
  final String summary;
  final List<String> completedProcedures;
  final List<String> careInstructions;
  final List<String> doctorNotes;
  final List<TreatmentTimelineStepModel> timeline;
  final List<TreatmentAppointmentModel> relatedAppointments;
  final int attachmentsCount;

  const TreatmentModel({
    required this.id,
    required this.name,
    required this.doctorName,
    required this.statusLabel,
    required this.status,
    required this.type,
    required this.completedSessions,
    required this.totalSessions,
    required this.progressPercent,
    required this.startedAtLabel,
    required this.nextSessionLabel,
    required this.summary,
    required this.completedProcedures,
    required this.careInstructions,
    required this.doctorNotes,
    required this.timeline,
    required this.relatedAppointments,
    required this.attachmentsCount,
  });

  TreatmentEntity toEntity() {
    return TreatmentEntity(
      id: id,
      name: name,
      doctorName: doctorName,
      statusLabel: statusLabel,
      status: status,
      type: type,
      completedSessions: completedSessions,
      totalSessions: totalSessions,
      progressPercent: progressPercent,
      startedAtLabel: startedAtLabel,
      nextSessionLabel: nextSessionLabel,
      summary: summary,
      completedProcedures: completedProcedures,
      careInstructions: careInstructions,
      doctorNotes: doctorNotes,
      timeline: timeline.map((step) => step.toEntity()).toList(),
      relatedAppointments:
          relatedAppointments.map((appointment) => appointment.toEntity()).toList(),
      attachmentsCount: attachmentsCount,
    );
  }
}
