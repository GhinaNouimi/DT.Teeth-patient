
import 'appointment_status.dart';
import 'appointment_type.dart';
import 'service_type.dart';

class AppointmentUiModel {
  final String id;

  // final DoctorUiModel doctor;

  final DateTime appointmentDate;
  final String appointmentTime;

  final AppointmentType type;
  final ServiceType service;
  final AppointmentStatus status;

  final String? patientNotes;
  final String? doctorNotes;

  final String? emergencyDescription;
  final bool requiresCall;

  final String location;
  final int durationMinutes;

  final DateTime createdAt;

  const AppointmentUiModel({
    required this.id,
    // required this.doctor,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.type,
    required this.service,
    required this.status,
    required this.patientNotes,
    required this.doctorNotes,
    required this.emergencyDescription,
    required this.requiresCall,
    required this.location,
    required this.durationMinutes,
    required this.createdAt,
  });

  bool get isUpcoming {
    if (status == AppointmentStatus.cancelled) {
      return false;
    }

    return status == AppointmentStatus.pending ||
        status == AppointmentStatus.confirmed;
  }

  bool get isPast {
    return status == AppointmentStatus.completed;
  }

  bool get isEmergency => type.isEmergency;

  bool get canReschedule =>
      isUpcoming && status == AppointmentStatus.confirmed && !isEmergency;

  bool get canCancel => isUpcoming && status != AppointmentStatus.cancelled;

  AppointmentUiModel copyWith({
    String? id,
    // DoctorUiModel? doctor,
    DateTime? appointmentDate,
    String? appointmentTime,
    AppointmentType? type,
    ServiceType? service,
    AppointmentStatus? status,
    String? patientNotes,
    String? doctorNotes,
    String? emergencyDescription,
    bool? requiresCall,
    String? location,
    int? durationMinutes,
    DateTime? createdAt,
  }) {
    return AppointmentUiModel(
      id: id ?? this.id,
      // doctor: doctor ?? this.doctor,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      type: type ?? this.type,
      service: service ?? this.service,
      status: status ?? this.status,
      patientNotes: patientNotes ?? this.patientNotes,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      emergencyDescription: emergencyDescription ?? this.emergencyDescription,
      requiresCall: requiresCall ?? this.requiresCall,
      location: location ?? this.location,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
