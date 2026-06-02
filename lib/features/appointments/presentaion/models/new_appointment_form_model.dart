import '../../../doctors/presentation/models/doctor_ui_model.dart';

import 'appointment_status.dart';
import 'appointment_type.dart';
import 'appointment_ui_model.dart';
import 'service_type.dart';

class NewAppointmentFormModel {
  final AppointmentType? appointmentType;

  final ServiceType? serviceType;

  final DoctorUiModel? selectedDoctor;

  final DateTime? selectedDate;
  final String? selectedTime;

  final String? patientNotes;

  /// للطوارئ
  final String? emergencyDescription;
  final int? painLevel;
  final bool requiresCall;

  const NewAppointmentFormModel({
    this.appointmentType,
    this.serviceType,
    this.selectedDoctor,
    this.selectedDate,
    this.selectedTime,
    this.patientNotes,
    this.emergencyDescription,
    this.painLevel,
    this.requiresCall = false,
  });

  bool get isAppointmentTypeSelected => appointmentType != null;

  bool get isServiceSelected => serviceType != null;

  bool get isDoctorSelected => selectedDoctor != null;

  bool get isScheduleSelected => selectedDate != null && selectedTime != null;

  bool get isEmergencyDataValid =>
      emergencyDescription != null &&
      emergencyDescription!.trim().isNotEmpty &&
      painLevel != null;

  bool get isComplete {
    if (appointmentType?.isEmergency ?? false) {
      return isAppointmentTypeSelected && isEmergencyDataValid;
    }

    return isAppointmentTypeSelected &&
        isServiceSelected &&
        isDoctorSelected &&
        isScheduleSelected;
  }

  AppointmentUiModel buildAppointment({
    required String id,
    required String location,
  }) {
    return AppointmentUiModel(
      id: id,

      doctor: selectedDoctor!,

      appointmentDate: selectedDate!,
      appointmentTime: selectedTime!,

      type: appointmentType!,
      service: serviceType!,

      status: AppointmentStatus.confirmed,

      patientNotes: patientNotes,
      doctorNotes: null,

      emergencyDescription: emergencyDescription,
      requiresCall: requiresCall,

      location: location,

      durationMinutes: 45,

      createdAt: DateTime.now(),
    );
  }

  NewAppointmentFormModel copyWith({
    AppointmentType? appointmentType,
    ServiceType? serviceType,
    DoctorUiModel? selectedDoctor,
    DateTime? selectedDate,
    String? selectedTime,
    String? patientNotes,
    String? emergencyDescription,
    int? painLevel,
    bool? requiresCall,
    bool clearDoctor = false,
    bool clearSchedule = false,
  }) {
    return NewAppointmentFormModel(
      appointmentType: appointmentType ?? this.appointmentType,

      serviceType: serviceType ?? this.serviceType,

      selectedDoctor: clearDoctor
          ? null
          : (selectedDoctor ?? this.selectedDoctor),

      selectedDate: clearSchedule ? null : (selectedDate ?? this.selectedDate),

      selectedTime: clearSchedule ? null : (selectedTime ?? this.selectedTime),

      patientNotes: patientNotes ?? this.patientNotes,

      emergencyDescription: emergencyDescription ?? this.emergencyDescription,

      painLevel: painLevel ?? this.painLevel,

      requiresCall: requiresCall ?? this.requiresCall,
    );
  }

  NewAppointmentFormModel reset() {
    return const NewAppointmentFormModel();
  }
}
