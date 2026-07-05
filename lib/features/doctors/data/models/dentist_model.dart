import '../../domain/entities/dentist_entity.dart';

class DentistModel extends DentistEntity {
  const DentistModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required super.specializationName,
    required super.specializationNameEn,
    super.profilePicture,
  });

  factory DentistModel.fromJson(Map<String, dynamic> json) {
    return DentistModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as int? ?? 0,
      specializationName: json['specialization_name'] as String? ?? '',
      specializationNameEn: json['specialization_name_en'] as String? ?? '',
      profilePicture: json['profile_picture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'specialization_name': specializationName,
      'specialization_name_en': specializationNameEn,
      'profile_picture': profilePicture,
    };
  }
}