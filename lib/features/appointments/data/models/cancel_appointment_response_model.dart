class CancelAppointmentResponseModel {
  final bool success;
  final String message;

  const CancelAppointmentResponseModel({
    required this.success,
    required this.message,
  });

  factory CancelAppointmentResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CancelAppointmentResponseModel(
      success: json['success'] == true,
      message:
      json['message']?.toString().trim() ?? '',
    );
  }
}