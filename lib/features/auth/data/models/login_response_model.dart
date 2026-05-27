class LoginResponseModel {
  final String message;
  final LoginUserModel user;
  final String token;
  final String tokenType;

  const LoginResponseModel({
    required this.message,
    required this.user,
    required this.token,
    required this.tokenType,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] ?? '',
      user: LoginUserModel.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? '',
    );
  }
}

class LoginUserModel {
  final int id;
  final String name;
  final String email;
  final int role;

  const LoginUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
    );
  }
}