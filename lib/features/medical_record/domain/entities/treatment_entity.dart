import 'treatment_appointment_entity.dart';
import 'treatment_timeline_step_entity.dart';

enum TreatmentStatus { active, completed, planned }

enum TreatmentType { braces, rootCanal, whitening, implant }

class TreatmentEntity {
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
  final List<TreatmentTimelineStepEntity> timeline;
  final List<TreatmentAppointmentEntity> relatedAppointments;
  final int attachmentsCount;

  const TreatmentEntity({
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

  bool get isActive => status == TreatmentStatus.active;
  bool get isCompleted => status == TreatmentStatus.completed;

  String get progressLabel => '$completedSessions / $totalSessions جلسات';
}
