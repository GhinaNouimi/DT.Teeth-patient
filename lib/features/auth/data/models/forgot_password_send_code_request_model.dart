class ForgotPasswordSendCodeRequestModel {
  final String email;

  const ForgotPasswordSendCodeRequestModel({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}