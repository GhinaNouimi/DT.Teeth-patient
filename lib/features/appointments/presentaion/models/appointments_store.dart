import 'package:flutter/material.dart';

import '../models/appointment_ui_model.dart';
import '../models/mock_appointments_data.dart';
import 'appointment_status.dart';

class AppointmentsStore extends ChangeNotifier {
  AppointmentsStore._internal()
      : _appointments = List<AppointmentUiModel>.from(
    MockAppointmentsData.getAppointments(),
  );

  static final AppointmentsStore instance = AppointmentsStore._internal();

  final List<AppointmentUiModel> _appointments;

  List<AppointmentUiModel> get appointments =>
      List<AppointmentUiModel>.unmodifiable(_appointments);

  List<AppointmentUiModel> get upcomingAppointments =>
      _appointments.where((e) => e.isUpcoming).toList();

  List<AppointmentUiModel> get pastAppointments =>
      _appointments.where((e) => e.isPast).toList();

  void addAppointment(AppointmentUiModel appointment) {
    _appointments.insert(0, appointment);
    notifyListeners();
  }

  void updateAppointment(AppointmentUiModel appointment) {
    final index = _appointments.indexWhere((e) => e.id == appointment.id);
    if (index == -1) return;
    _appointments[index] = appointment;
    notifyListeners();
  }

  void cancelAppointment(String appointmentId) {
    final index = _appointments.indexWhere((e) => e.id == appointmentId);
    if (index == -1) return;
    _appointments[index] = _appointments[index].copyWith(
      status: AppointmentStatus.cancelled,
    );
    notifyListeners();
  }
}
