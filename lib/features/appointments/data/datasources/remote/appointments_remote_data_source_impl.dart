import 'package:dio/dio.dart';

import '../../../../../core/network/api_constants.dart';
import '../../models/cancel_appointment_response_model.dart';
import '../../models/show_appointment_details_response_model.dart';
import '../../models/show_appointments_response_model.dart';
import 'appointments_remote_data_source.dart';

class AppointmentsRemoteDataSourceImpl
    implements AppointmentsRemoteDataSource {
  final Dio dio;

  AppointmentsRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<ShowAppointmentsResponseModel> showAppointments() async {
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
  Future<CancelAppointmentResponseModel> cancelAppointment(
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
}