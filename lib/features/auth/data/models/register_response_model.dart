class RegisterResponseModel {
  final String message;
  final RegisteredUserModel user;

  const RegisterResponseModel({
    required this.message,
    required this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message'] ?? '',
      user: RegisteredUserModel.fromJson(json['user'] ?? {}),
    );
  }
}

class RegisteredUserModel {
  final int id;
  final String name;
  final String email;
  final int role;
  final String profilePicture;

  const RegisteredUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePicture,
  });

  factory RegisteredUserModel.fromJson(Map<String, dynamic> json) {
    return RegisteredUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
      profilePicture: json['profile_picture'] ?? '',
    );
  }
}