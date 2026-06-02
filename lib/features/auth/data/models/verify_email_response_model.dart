class VerifyEmailResponseModel {
  final String message;
  final VerifiedUserModel user;
  final String token;
  final String tokenType;

  const VerifyEmailResponseModel({
    required this.message,
    required this.user,
    required this.token,
    required this.tokenType,
  });

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponseModel(
      message: json['message'] ?? '',
      user: VerifiedUserModel.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? '',
    );
  }
}

class VerifiedUserModel {
  final int id;
  final String name;
  final String email;
  final int role;

  const VerifiedUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory VerifiedUserModel.fromJson(Map<String, dynamic> json) {
    return VerifiedUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
    );
  }
}
