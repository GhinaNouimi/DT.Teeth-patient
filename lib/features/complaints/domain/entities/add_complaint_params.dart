import 'complaint_entity.dart';

class AddComplaintParams {
  final String title;
  final String description;
  final String phoneNumber;
  final ComplaintPriority priority;

  const AddComplaintParams({
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.priority,
  });
}