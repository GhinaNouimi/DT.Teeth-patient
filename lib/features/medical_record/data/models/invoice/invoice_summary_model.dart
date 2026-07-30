import '../../../domain/entities/invoice/invoice_summary_entity.dart';

class InvoiceSummaryModel extends InvoiceSummaryEntity {
  const InvoiceSummaryModel({
    required super.totalAmount,
    required super.paidAmount,
    required super.remainingAmount,
  });

  factory InvoiceSummaryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return InvoiceSummaryModel(
      totalAmount: _parseNum(json['total_amount']),
      paidAmount: _parseNum(json['paid_amount']),
      remainingAmount: _parseNum(json['remaining_amount']),
    );
  }

  static num _parseNum(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
    };
  }
}