import 'appointment_model.dart';

class AppointmentActionResponseModel {
  final bool success;
  final String message;
  final AppointmentModel appointment;

  const AppointmentActionResponseModel({
    required this.success,
    required this.message,
    required this.appointment,
  });

  factory AppointmentActionResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    if (rawData is! Map) {
      throw const FormatException(
        'Invalid appointment action response data.',
      );
    }

    return AppointmentActionResponseModel(
      success: json['success'] == true,
      message:
      json['message']?.toString().trim() ?? '',
      appointment: AppointmentModel.fromJson(
        Map<String, dynamic>.from(rawData),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': appointment.toJson(),
    };
  }
}