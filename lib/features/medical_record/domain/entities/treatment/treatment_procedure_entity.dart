class TreatmentProcedureEntity {
  final int id;
  final String name;
  final String nameEn;
  final String price;

  const TreatmentProcedureEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.price,
  });

  String localizedName(String languageCode) {
    return languageCode.toLowerCase().startsWith('ar') ? name : nameEn;
  }
}