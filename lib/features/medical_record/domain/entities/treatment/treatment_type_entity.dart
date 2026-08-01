class TreatmentTypeEntity {
  final int id;
  final String name;
  final String nameEn;

  const TreatmentTypeEntity({
    required this.id,
    required this.name,
    required this.nameEn,
  });

  String localizedName(String languageCode) {
    return languageCode
        .toLowerCase()
        .startsWith('ar')
        ? name
        : nameEn;
  }
}