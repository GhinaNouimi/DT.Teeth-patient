class InvoiceTreatmentTypeEntity {
  final String name;
  final String nameEn;

  const InvoiceTreatmentTypeEntity({
    required this.name,
    required this.nameEn,
  });

  String localizedName(String languageCode) {
    return languageCode.toLowerCase().startsWith('ar')
        ? name
        : nameEn;
  }
}