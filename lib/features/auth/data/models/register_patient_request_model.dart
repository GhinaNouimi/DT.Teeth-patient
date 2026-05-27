class RegisterPatientRequestModel {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
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

  const RegisterPatientRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
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
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
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
    };
  }
}