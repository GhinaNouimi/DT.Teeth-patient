import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String dateOfBirth;
  final int gender;
  final String address;
  final String profilePicture;
  final String emergencyContactName;
  final String emergencyContactRelation;
  final String emergencyContactPhone;
  final bool isPregnant;
  final bool isBreastfeeding;
  final bool isSmoker;
  final bool drinksAlcoholFrequently;
  final String teethCleaningFrequency;
  final List<String> allergies;
  final List<String> chronicDiseases;
  final List<String> medications;
  final bool isDarkModeEnabled;
  final String languageCode;

  const ProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.profilePicture,
    required this.emergencyContactName,
    required this.emergencyContactRelation,
    required this.emergencyContactPhone,
    required this.isPregnant,
    required this.isBreastfeeding,
    required this.isSmoker,
    required this.drinksAlcoholFrequently,
    required this.teethCleaningFrequency,
    required this.allergies,
    required this.chronicDiseases,
    required this.medications,
    required this.isDarkModeEnabled,
    required this.languageCode,
  });

  factory ProfileModel.fromApiJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final user = data['user'] as Map<String, dynamic>? ?? {};

    return ProfileModel(
      id: data['id']?.toString() ?? '',
      userId: data['user_id']?.toString() ?? '',
      name: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      phone: user['phone']?.toString() ?? '',
      dateOfBirth: user['date_of_birth']?.toString() ?? '',
      gender: _toInt(user['gender']),
      address: user['address']?.toString() ?? '',
      profilePicture: user['profile_picture']?.toString() ?? '',
      emergencyContactName: data['emergency_contact_name']?.toString() ?? '',
      emergencyContactRelation:
      data['emergency_contact_relation']?.toString() ?? '',
      emergencyContactPhone: data['emergency_contact_phone']?.toString() ?? '',
      isPregnant: _toBool(data['is_pregnant']),
      isBreastfeeding: _toBool(data['is_breastfeeding']),
      isSmoker: _toBool(data['is_smoker']),
      drinksAlcoholFrequently: _toBool(data['drinks_alcohol_frequently']),
      teethCleaningFrequency:
      data['teeth_cleaning_frequency']?.toString() ?? '',
      allergies: _toStringList(data['allergies']),
      chronicDiseases: _toStringList(data['chronic_diseases']),
      medications: _toStringList(data['medications']),
      isDarkModeEnabled: false,
      languageCode: 'ar',
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString() ?? '',
      gender: _toInt(json['gender']),
      address: json['address']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString() ?? '',
      emergencyContactName:
      json['emergencyContactName']?.toString() ?? '',
      emergencyContactRelation:
      json['emergencyContactRelation']?.toString() ?? '',
      emergencyContactPhone:
      json['emergencyContactPhone']?.toString() ?? '',
      isPregnant: _toBool(json['isPregnant']),
      isBreastfeeding: _toBool(json['isBreastfeeding']),
      isSmoker: _toBool(json['isSmoker']),
      drinksAlcoholFrequently: _toBool(json['drinksAlcoholFrequently']),
      teethCleaningFrequency:
      json['teethCleaningFrequency']?.toString() ?? '',
      allergies: _toStringList(json['allergies']),
      chronicDiseases: _toStringList(json['chronicDiseases']),
      medications: _toStringList(json['medications']),
      isDarkModeEnabled: _toBool(json['isDarkModeEnabled']),
      languageCode: json['languageCode']?.toString() ?? 'ar',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'profilePicture': profilePicture,
      'emergencyContactName': emergencyContactName,
      'emergencyContactRelation': emergencyContactRelation,
      'emergencyContactPhone': emergencyContactPhone,
      'isPregnant': isPregnant,
      'isBreastfeeding': isBreastfeeding,
      'isSmoker': isSmoker,
      'drinksAlcoholFrequently': drinksAlcoholFrequently,
      'teethCleaningFrequency': teethCleaningFrequency,
      'allergies': allergies,
      'chronicDiseases': chronicDiseases,
      'medications': medications,
      'isDarkModeEnabled': isDarkModeEnabled,
      'languageCode': languageCode,
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      profilePicture: profilePicture,
      emergencyContactName: emergencyContactName,
      emergencyContactRelation: emergencyContactRelation,
      emergencyContactPhone: emergencyContactPhone,
      isPregnant: isPregnant,
      isBreastfeeding: isBreastfeeding,
      isSmoker: isSmoker,
      drinksAlcoholFrequently: drinksAlcoholFrequently,
      teethCleaningFrequency: teethCleaningFrequency,
      allergies: allergies,
      chronicDiseases: chronicDiseases,
      medications: medications,
      isDarkModeEnabled: isDarkModeEnabled,
      languageCode: languageCode,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? -1;
    return -1;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }
    return false;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((element) => element.toString()).toList();
    }

    return [];
  }
}