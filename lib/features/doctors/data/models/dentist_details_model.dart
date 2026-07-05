import '../../domain/entities/dentist_details_entity.dart';

class DentistDetailsModel extends DentistDetailsEntity {
  const DentistDetailsModel({
    required super.id,
    required super.name,
    required super.profilePicture,
    required super.specializationAr,
    required super.specializationEn,
    required super.yearsOfExperience,
    required super.averageRating,
    required super.bio,
  });

  factory DentistDetailsModel.fromJson(Map<String, dynamic> json) {
    final specialization =
        json['specialization'] as Map<String, dynamic>? ?? {};

    return DentistDetailsModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      profilePicture: json['profile_picture'] as String?,
      specializationAr: specialization['ar'] as String? ?? '',
      specializationEn: specialization['en'] as String? ?? '',
      yearsOfExperience: json['years_of_experience'] as int? ?? 0,
      averageRating: json['average_rating']?.toString() ?? '0.00',
      bio: json['bio'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_picture': profilePicture,
      'specialization': {
        'ar': specializationAr,
        'en': specializationEn,
      },
      'years_of_experience': yearsOfExperience,
      'average_rating': averageRating,
      'bio': bio,
    };
  }
}