class SendVerificationResponseModel {
  final String message;

  const SendVerificationResponseModel({
    required this.message,
  });

  factory SendVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return SendVerificationResponseModel(
      message: json['message']?.toString() ?? '',
    );
  }
}