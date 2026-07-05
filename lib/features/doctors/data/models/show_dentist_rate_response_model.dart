class ShowDentistRateResponseModel {
  final bool success;
  final int rating;

  const ShowDentistRateResponseModel({
    required this.success,
    required this.rating,
  });

  factory ShowDentistRateResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final data = json['data'];

    return ShowDentistRateResponseModel(
      success: json['success'] as bool? ?? false,
      rating: data is Map<String, dynamic>
          ? data['rating'] as int? ?? 0
          : 0,
    );
  }
}