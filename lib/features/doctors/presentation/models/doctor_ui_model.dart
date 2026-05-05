class DoctorUiModel {
  final String id;
  final String name;
  final String specialty;
  final int yearsOfExperience;
  final int treatedPatients;
  final String imageUrl;
  final String graduation;
  final String bio;
  final String phone;

  final double rating;
  final int reviewsCount;
  final List<String> certificates;

  const DoctorUiModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.yearsOfExperience,
    required this.treatedPatients,
    required this.imageUrl,
    required this.graduation,
    required this.bio,
    required this.phone,

    required this.rating,
    required this.reviewsCount,
    required this.certificates,
  });
}