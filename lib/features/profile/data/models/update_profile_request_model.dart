import 'dart:io';

class UpdateProfileRequestModel {
  final String name;
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
  final File? profilePicture;

  const UpdateProfileRequestModel({
    required this.name,
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
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'address': address,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_relation': emergencyContactRelation,
      'emergency_contact_phone': emergencyContactPhone,
      'is_pregnant': isPregnant ? 1 : 0,
      'is_breastfeeding': isBreastfeeding ? 1 : 0,
      'is_smoker': isSmoker ? 1 : 0,
      'drinks_alcohol_frequently': drinksAlcoholFrequently ? 1 : 0,
      'teeth_cleaning_frequency': teethCleaningFrequency,
    };
  }
}