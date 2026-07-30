
import '../../../domain/entities/invoice/invoice_payment_entity.dart';

class InvoicePaymentModel extends InvoicePaymentEntity {
  const InvoicePaymentModel({
    required super.amount,
    required super.paymentMethod,
    required super.paidAt,
  });

  factory InvoicePaymentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return InvoicePaymentModel(
      amount: json['amount'] ?? 0,
      paymentMethod: _parsePaymentMethod(
        json['payment_method'],
      ),
      paidAt: json['paid_at'] ?? '',
    );
  }

  static InvoicePaymentMethod _parsePaymentMethod(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'cash':
        return InvoicePaymentMethod.cash;

      case 'card':
        return InvoicePaymentMethod.card;

      default:
        return InvoicePaymentMethod.unknown;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'payment_method': paymentMethod.name,
      'paid_at': paidAt,
    };
  }
}