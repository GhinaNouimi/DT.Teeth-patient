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

  DoctorUiModel copyWith({
    String? id,
    String? name,
    String? specialty,
    int? yearsOfExperience,
    int? treatedPatients,
    String? imageUrl,
    String? graduation,
    String? bio,
    String? phone,
    double? rating,
    int? reviewsCount,
    List<String>? certificates,
  }) {
    return DoctorUiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      treatedPatients: treatedPatients ?? this.treatedPatients,
      imageUrl: imageUrl ?? this.imageUrl,
      graduation: graduation ?? this.graduation,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      certificates: certificates ?? this.certificates,
    );
  }
}
