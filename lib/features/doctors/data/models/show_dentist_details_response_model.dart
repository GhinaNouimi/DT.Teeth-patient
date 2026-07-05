import 'dentist_details_model.dart';

class ShowDentistDetailsResponseModel {
  final bool success;
  final DentistDetailsModel? data;

  const ShowDentistDetailsResponseModel({
    required this.success,
    required this.data,
  });

  factory ShowDentistDetailsResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final responseData = json['data'];

    return ShowDentistDetailsResponseModel(
      success: json['success'] as bool? ?? false,
      data: responseData is Map<String, dynamic>
          ? DentistDetailsModel.fromJson(responseData)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}