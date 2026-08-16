class AppointmentBookingDentistEntity {
  final int id;
  final String name;
  final String? profilePicture;

  final String specializationName;
  final String specializationNameEn;

  final int yearsOfExperience;
  final double averageRating;
  final String? bio;

  const AppointmentBookingDentistEntity({
    required this.id,
    required this.name,
    this.profilePicture,
    required this.specializationName,
    required this.specializationNameEn,
    required this.yearsOfExperience,
    required this.averageRating,
    this.bio,
  });

  String localizedSpecialization(
      String languageCode,
      ) {
    final isArabic =
    languageCode.toLowerCase().startsWith('ar');

    if (isArabic) {
      return specializationName.isNotEmpty
          ? specializationName
          : specializationNameEn;
    }

    return specializationNameEn.isNotEmpty
        ? specializationNameEn
        : specializationName;
  }

  bool get hasProfilePicture {
    return profilePicture != null &&
        profilePicture!.trim().isNotEmpty;
  }

  bool get hasBio {
    return bio != null &&
        bio!.trim().isNotEmpty;
  }
}