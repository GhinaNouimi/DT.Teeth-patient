import '../../../domain/entities/invoice/invoice_item_entity.dart';

class InvoiceItemModel extends InvoiceItemEntity {
  const InvoiceItemModel({
    required super.description,
    required super.unitPrice,
    required super.discountPercentage,
    required super.finalPrice,
  });

  factory InvoiceItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return InvoiceItemModel(
      description: json['description'] ?? '',
      unitPrice: json['unit_price'] ?? 0,
      discountPercentage: json['discount_percentage'] ?? 0,
      finalPrice: json['final_price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'unit_price': unitPrice,
      'discount_percentage': discountPercentage,
      'final_price': finalPrice,
    };
  }
}