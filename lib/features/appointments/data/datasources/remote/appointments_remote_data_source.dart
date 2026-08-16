import '../../models/add_appointment_request_model.dart';
import '../../models/appointment_action_response_model.dart';
import '../../models/cancel_appointment_response_model.dart';
import '../../models/show_appointment_details_response_model.dart';
import '../../models/show_appointment_types_response_model.dart';
import '../../models/show_appointments_response_model.dart';
import '../../models/show_dentist_schedule_response_model.dart';
import '../../models/show_dentists_by_appointment_type_response_model.dart';
import '../../models/update_appointment_request_model.dart';

abstract class AppointmentsRemoteDataSource {
  Future<ShowAppointmentsResponseModel> showAppointments();

  Future<ShowAppointmentsResponseModel>
  showPreviousAppointments();

  Future<ShowAppointmentDetailsResponseModel>
  showAppointmentDetails(
      int appointmentId,
      );

  Future<ShowAppointmentTypesResponseModel>
  showAppointmentTypes();

  Future<ShowDentistsByAppointmentTypeResponseModel>
  showDentistsByAppointmentType(
      int appointmentTypeId,
      );

  Future<ShowDentistScheduleResponseModel>
  showDentistSchedule(
      int dentistId,
      );

  Future<AppointmentActionResponseModel>
  addAppointment(
      AddAppointmentRequestModel request,
      );

  Future<AppointmentActionResponseModel>
  updateAppointment(
      int appointmentId,
      UpdateAppointmentRequestModel request,
      );

  Future<CancelAppointmentResponseModel>
  cancelAppointment(
      int appointmentId,
      );
}