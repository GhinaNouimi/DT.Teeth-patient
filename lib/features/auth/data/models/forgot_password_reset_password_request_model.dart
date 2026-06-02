class ForgotPasswordResetPasswordRequestModel {
  final String email;
  final String password;

  const ForgotPasswordResetPasswordRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}