class SendVerificationRequestModel {
  final String email;

  const SendVerificationRequestModel({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}