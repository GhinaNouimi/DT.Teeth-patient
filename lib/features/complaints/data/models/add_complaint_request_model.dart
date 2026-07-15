import '../../domain/entities/add_complaint_params.dart';
import '../../domain/entities/complaint_entity.dart';

class AddComplaintRequestModel {
  final String title;
  final String description;
  final String phoneNumber;
  final String priority;

  const AddComplaintRequestModel({
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.priority,
  });

  factory AddComplaintRequestModel.fromParams(
      AddComplaintParams params,
      ) {
    return AddComplaintRequestModel(
      title: params.title.trim(),
      description: params.description.trim(),
      phoneNumber: params.phoneNumber.trim(),
      priority: _mapPriority(params.priority),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'phone_number': phoneNumber,
      'priority': priority,
    };
  }

  static String _mapPriority(ComplaintPriority priority) {
    switch (priority) {
      case ComplaintPriority.low:
        return 'low';

      case ComplaintPriority.medium:
        return 'medium';

      case ComplaintPriority.high:
        return 'high';

      case ComplaintPriority.unknown:
        return 'medium';
    }
  }
}