class AppointmentTypeEntity {
  final int id;
  final String name;
  final String nameEn;
  final List<AppointmentTypeSpecializationEntity>
  specializations;

  const AppointmentTypeEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.specializations,
  });

  String localizedName(
      String languageCode,
      ) {
    final isArabic =
    languageCode.toLowerCase().startsWith('ar');

    if (isArabic) {
      return name.isNotEmpty ? name : nameEn;
    }

    return nameEn.isNotEmpty ? nameEn : name;
  }

  bool get hasSpecializations {
    return specializations.isNotEmpty;
  }
}

class AppointmentTypeSpecializationEntity {
  final int id;
  final String name;

  const AppointmentTypeSpecializationEntity({
    required this.id,
    required this.name,
  });
}