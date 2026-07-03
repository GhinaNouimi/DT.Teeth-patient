class ProfileEntity {
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

  const ProfileEntity({
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

  bool get isMale => gender == 1;
  bool get isFemale => gender == 2;

  ProfileEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? dateOfBirth,
    int? gender,
    String? address,
    String? profilePicture,
    String? emergencyContactName,
    String? emergencyContactRelation,
    String? emergencyContactPhone,
    bool? isPregnant,
    bool? isBreastfeeding,
    bool? isSmoker,
    bool? drinksAlcoholFrequently,
    String? teethCleaningFrequency,
    List<String>? allergies,
    List<String>? chronicDiseases,
    List<String>? medications,
    bool? isDarkModeEnabled,
    String? languageCode,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactRelation:
      emergencyContactRelation ?? this.emergencyContactRelation,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      isPregnant: isPregnant ?? this.isPregnant,
      isBreastfeeding: isBreastfeeding ?? this.isBreastfeeding,
      isSmoker: isSmoker ?? this.isSmoker,
      drinksAlcoholFrequently:
      drinksAlcoholFrequently ?? this.drinksAlcoholFrequently,
      teethCleaningFrequency:
      teethCleaningFrequency ?? this.teethCleaningFrequency,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      medications: medications ?? this.medications,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}