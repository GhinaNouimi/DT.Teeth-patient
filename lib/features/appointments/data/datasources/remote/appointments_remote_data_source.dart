import '../../models/cancel_appointment_response_model.dart';
import '../../models/show_appointment_details_response_model.dart';
import '../../models/show_appointments_response_model.dart';

abstract class AppointmentsRemoteDataSource {
  Future<ShowAppointmentsResponseModel> showAppointments();

  Future<ShowAppointmentsResponseModel> showPreviousAppointments();

  Future<ShowAppointmentDetailsResponseModel> showAppointmentDetails(
      int appointmentId,
      );

  Future<CancelAppointmentResponseModel> cancelAppointment(
      int appointmentId,
      );
}