import 'dentist_model.dart';

class ShowAllDentistsResponseModel {
  final bool success;
  final List<DentistModel> data;

  const ShowAllDentistsResponseModel({
    required this.success,
    required this.data,
  });

  factory ShowAllDentistsResponseModel.fromJson(Map<String, dynamic> json) {
    final responseData = json['data'];

    return ShowAllDentistsResponseModel(
      success: json['success'] as bool? ?? false,
      data: responseData is List
          ? responseData
          .whereType<Map<String, dynamic>>()
          .map(DentistModel.fromJson)
          .toList()
          : <DentistModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((dentist) => dentist.toJson()).toList(),
    };
  }
}