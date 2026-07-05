class AddDentistRateResponseModel {
  final bool success;
  final String message;
  final int averageRating;

  const AddDentistRateResponseModel({
    required this.success,
    required this.message,
    required this.averageRating,
  });

  factory AddDentistRateResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return AddDentistRateResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      averageRating: data['average_rating'] as int? ?? 0,
    );
  }
}