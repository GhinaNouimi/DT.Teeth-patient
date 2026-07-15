import 'complaint_model.dart';

class AddComplaintResponseModel {
  final bool success;
  final String message;
  final ComplaintModel complaint;

  const AddComplaintResponseModel({
    required this.success,
    required this.message,
    required this.complaint,
  });

  factory AddComplaintResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    if (rawData is! Map) {
      throw const FormatException(
        'Invalid add complaint response data.',
      );
    }

    return AddComplaintResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      complaint: ComplaintModel.fromJson(
        Map<String, dynamic>.from(rawData),
      ),
    );
  }
}