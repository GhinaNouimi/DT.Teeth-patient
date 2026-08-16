import 'package:dio/dio.dart';

import '../../../../../core/network/api_constants.dart';
import '../../models/add_appointment_request_model.dart';
import '../../models/appointment_action_response_model.dart';
import '../../models/cancel_appointment_response_model.dart';
import '../../models/show_appointment_details_response_model.dart';
import '../../models/show_appointment_types_response_model.dart';
import '../../models/show_appointments_response_model.dart';
import '../../models/show_dentist_schedule_response_model.dart';
import '../../models/show_dentists_by_appointment_type_response_model.dart';
import '../../models/update_appointment_request_model.dart';
import 'appointments_remote_data_source.dart';

class AppointmentsRemoteDataSourceImpl
    implements AppointmentsRemoteDataSource {
  final Dio dio;

  AppointmentsRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<ShowAppointmentsResponseModel>
  showAppointments() async {
    final response = await dio.get(
      ApiConstants.patientShowAppointments,
    );

    return ShowAppointmentsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ShowAppointmentsResponseModel>
  showPreviousAppointments() async {
    final response = await dio.get(
      ApiConstants.patientShowPreviousAppointments,
    );

    return ShowAppointmentsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ShowAppointmentDetailsResponseModel>
  showAppointmentDetails(
      int appointmentId,
      ) async {
    final response = await dio.get(
      ApiConstants.patientShowAppointmentDetails(
        appointmentId,
      ),
    );

    return ShowAppointmentDetailsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ShowAppointmentTypesResponseModel>
  showAppointmentTypes() async {
    final response = await dio.get(
      ApiConstants.appointmentTypes,
    );

    return ShowAppointmentTypesResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<CancelAppointmentResponseModel>
  cancelAppointment(
      int appointmentId,
      ) async {
    final response = await dio.post(
      ApiConstants.patientCancelAppointment(
        appointmentId,
      ),
    );

    return CancelAppointmentResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ShowDentistsByAppointmentTypeResponseModel>
  showDentistsByAppointmentType(
      int appointmentTypeId,
      ) async {
    final response = await dio.get(
      ApiConstants.patientDentistsByAppointmentType(
        appointmentTypeId,
      ),
    );

    return ShowDentistsByAppointmentTypeResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ShowDentistScheduleResponseModel>
  showDentistSchedule(
      int dentistId,
      ) async {
    final response = await dio.get(
      ApiConstants.patientShowDentistSchedule(
        dentistId,
      ),
    );

    return ShowDentistScheduleResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<AppointmentActionResponseModel>
  addAppointment(
      AddAppointmentRequestModel request,
      ) async {
    final response = await dio.post(
      ApiConstants.patientAddAppointment,
      data: request.toJson(),
    );

    return AppointmentActionResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<AppointmentActionResponseModel>
  updateAppointment(
      int appointmentId,
      UpdateAppointmentRequestModel request,
      ) async {
    final response = await dio.post(
      ApiConstants.patientUpdateAppointment(
        appointmentId,
      ),
      data: request.toJson(),
    );

    return AppointmentActionResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}