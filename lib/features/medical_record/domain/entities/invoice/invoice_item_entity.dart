class InvoiceItemEntity {
  final String description;
  final num unitPrice;
  final num discountPercentage;
  final num finalPrice;

  const InvoiceItemEntity({
    required this.description,
    required this.unitPrice,
    required this.discountPercentage,
    required this.finalPrice,
  });

  bool get hasDiscount {
    return discountPercentage > 0;
  }

  num get discountAmount {
    final calculatedDiscount = unitPrice - finalPrice;

    return calculatedDiscount > 0
        ? calculatedDiscount
        : 0;
  }
}