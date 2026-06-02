class ForgotPasswordResponseModel {
  final String message;

  const ForgotPasswordResponseModel({
    required this.message,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      message: json['message']?.toString() ?? '',
    );
  }
}