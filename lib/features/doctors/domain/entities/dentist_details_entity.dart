class DentistDetailsEntity {
  final int id;
  final String name;
  final String? profilePicture;
  final String specializationAr;
  final String specializationEn;
  final int yearsOfExperience;
  final String averageRating;
  final String bio;

  const DentistDetailsEntity({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.specializationAr,
    required this.specializationEn,
    required this.yearsOfExperience,
    required this.averageRating,
    required this.bio,
  });
}