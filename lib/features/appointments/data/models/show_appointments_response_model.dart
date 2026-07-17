import 'appointment_model.dart';

class ShowAppointmentsResponseModel {
  final bool success;
  final int count;
  final List<AppointmentModel> appointments;

  const ShowAppointmentsResponseModel({
    required this.success,
    required this.count,
    required this.appointments,
  });

  factory ShowAppointmentsResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    final appointments = rawData is List
        ? rawData
        .whereType<Map>()
        .map(
          (item) => AppointmentModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList()
        : <AppointmentModel>[];

    return ShowAppointmentsResponseModel(
      success: json['success'] == true,
      count: _parseInt(
        json['count'],
        fallback: appointments.length,
      ),
      appointments: appointments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': appointments
          .map((appointment) => appointment.toJson())
          .toList(),
    };
  }

  static int _parseInt(
      dynamic value, {
        required int fallback,
      }) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        fallback;
  }
}