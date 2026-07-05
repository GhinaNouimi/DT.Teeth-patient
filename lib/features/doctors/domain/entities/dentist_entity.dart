class DentistEntity {
  final int id;
  final int userId;
  final String name;
  final String email;
  final String phone;
  final int role;
  final String specializationName;
  final String specializationNameEn;
  final String? profilePicture;

  const DentistEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.specializationName,
    required this.specializationNameEn,
    this.profilePicture,
  });
}