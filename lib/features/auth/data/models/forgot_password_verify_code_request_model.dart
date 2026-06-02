class ForgotPasswordVerifyCodeRequestModel {
  final String email;
  final String verificationCode;

  const ForgotPasswordVerifyCodeRequestModel({
    required this.email,
    required this.verificationCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'verification_code': verificationCode,
    };
  }
}