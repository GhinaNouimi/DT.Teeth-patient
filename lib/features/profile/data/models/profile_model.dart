import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String dateOfBirth;
  final int gender;
  final String address;
  final String emergencyContactName;
  final String emergencyContactRelation;
  final String emergencyContactPhone;
  final bool isPregnant;
  final bool isBreastfeeding;
  final bool isSmoker;
  final bool drinksAlcoholFrequently;
  final String teethCleaningFrequency;
  final String? avatarUrl;
  final bool isDarkModeEnabled;
  final String languageCode;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.emergencyContactName,
    required this.emergencyContactRelation,
    required this.emergencyContactPhone,
    required this.isPregnant,
    required this.isBreastfeeding,
    required this.isSmoker,
    required this.drinksAlcoholFrequently,
    required this.teethCleaningFrequency,
    required this.avatarUrl,
    required this.isDarkModeEnabled,
    required this.languageCode,
  });

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      emergencyContactName: emergencyContactName,
      emergencyContactRelation: emergencyContactRelation,
      emergencyContactPhone: emergencyContactPhone,
      isPregnant: isPregnant,
      isBreastfeeding: isBreastfeeding,
      isSmoker: isSmoker,
      drinksAlcoholFrequently: drinksAlcoholFrequently,
      teethCleaningFrequency: teethCleaningFrequency,
      avatarUrl: avatarUrl,
      isDarkModeEnabled: isDarkModeEnabled,
      languageCode: languageCode,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      address: entity.address,
      emergencyContactName: entity.emergencyContactName,
      emergencyContactRelation: entity.emergencyContactRelation,
      emergencyContactPhone: entity.emergencyContactPhone,
      isPregnant: entity.isPregnant,
      isBreastfeeding: entity.isBreastfeeding,
      isSmoker: entity.isSmoker,
      drinksAlcoholFrequently: entity.drinksAlcoholFrequently,
      teethCleaningFrequency: entity.teethCleaningFrequency,
      avatarUrl: entity.avatarUrl,
      isDarkModeEnabled: entity.isDarkModeEnabled,
      languageCode: entity.languageCode,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? dateOfBirth,
    int? gender,
    String? address,
    String? emergencyContactName,
    String? emergencyContactRelation,
    String? emergencyContactPhone,
    bool? isPregnant,
    bool? isBreastfeeding,
    bool? isSmoker,
    bool? drinksAlcoholFrequently,
    String? teethCleaningFrequency,
    String? avatarUrl,
    bool? isDarkModeEnabled,
    String? languageCode,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      emergencyContactName:
      emergencyContactName ?? this.emergencyContactName,
      emergencyContactRelation:
      emergencyContactRelation ?? this.emergencyContactRelation,
      emergencyContactPhone:
      emergencyContactPhone ?? this.emergencyContactPhone,
      isPregnant: isPregnant ?? this.isPregnant,
      isBreastfeeding: isBreastfeeding ?? this.isBreastfeeding,
      isSmoker: isSmoker ?? this.isSmoker,
      drinksAlcoholFrequently:
      drinksAlcoholFrequently ?? this.drinksAlcoholFrequently,
      teethCleaningFrequency:
      teethCleaningFrequency ?? this.teethCleaningFrequency,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] as String? ?? '',
      gender: json['gender'] as int? ?? -1,
      address: json['address'] as String? ?? '',
      emergencyContactName:
      json['emergency_contact_name'] as String? ?? '',
      emergencyContactRelation:
      json['emergency_contact_relation'] as String? ?? '',
      emergencyContactPhone:
      json['emergency_contact_phone'] as String? ?? '',
      isPregnant: json['is_pregnant'] as bool? ?? false,
      isBreastfeeding: json['is_breastfeeding'] as bool? ?? false,
      isSmoker: json['is_smoker'] as bool? ?? false,
      drinksAlcoholFrequently:
      json['drinks_alcohol_frequently'] as bool? ?? false,
      teethCleaningFrequency:
      json['teeth_cleaning_frequency'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      isDarkModeEnabled: json['is_dark_mode_enabled'] as bool? ?? false,
      languageCode: json['language_code'] as String? ?? 'ar',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'address': address,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_relation': emergencyContactRelation,
      'emergency_contact_phone': emergencyContactPhone,
      'is_pregnant': isPregnant,
      'is_breastfeeding': isBreastfeeding,
      'is_smoker': isSmoker,
      'drinks_alcohol_frequently': drinksAlcoholFrequently,
      'teeth_cleaning_frequency': teethCleaningFrequency,
      'avatar_url': avatarUrl,
      'is_dark_mode_enabled': isDarkModeEnabled,
      'language_code': languageCode,
    };
  }
}