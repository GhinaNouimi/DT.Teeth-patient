class ProfileEntity {
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
  final String? avatarStyleId;
  final bool isDarkModeEnabled;
  final String languageCode;

  const ProfileEntity({
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
    required this.avatarStyleId,
    required this.isDarkModeEnabled,
    required this.languageCode,
  });

  ProfileEntity copyWith({
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
    String? avatarStyleId,
    bool? isDarkModeEnabled,
    String? languageCode,
  }) {
    return ProfileEntity(
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
      avatarStyleId: avatarStyleId ?? this.avatarStyleId,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  bool get isMale => gender == 1;
  bool get isFemale => gender == 0;

  String get genderLabel {
    if (gender == 1) {
      return 'ذكر';
    }
    if (gender == 0) {
      return 'أنثى';
    }
    return 'غير محدد';
  }
}