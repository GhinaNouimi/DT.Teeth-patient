import 'dentist_details_model.dart';

class ShowDentistsBySpecializationResponseModel {
  final bool success;
  final int count;
  final List<DentistDetailsModel> data;

  const ShowDentistsBySpecializationResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ShowDentistsBySpecializationResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final responseData = json['data'];

    return ShowDentistsBySpecializationResponseModel(
      success: json['success'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      data: responseData is List
          ? responseData
          .whereType<Map<String, dynamic>>()
          .map(DentistDetailsModel.fromJson)
          .toList()
          : <DentistDetailsModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': data.map((dentist) => dentist.toJson()).toList(),
    };
  }
}