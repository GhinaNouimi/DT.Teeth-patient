import 'appointment_model.dart';

class ShowAppointmentDetailsResponseModel {
  final bool success;
  final AppointmentModel appointment;

  const ShowAppointmentDetailsResponseModel({
    required this.success,
    required this.appointment,
  });

  factory ShowAppointmentDetailsResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    if (rawData is! Map) {
      throw const FormatException(
        'Invalid appointment details response data.',
      );
    }

    return ShowAppointmentDetailsResponseModel(
      success: json['success'] == true,
      appointment: AppointmentModel.fromJson(
        Map<String, dynamic>.from(rawData),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': appointment.toJson(),
    };
  }
}