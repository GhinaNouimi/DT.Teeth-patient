enum InvoicePaymentMethod {
  cash,
  card,
  unknown,
}

extension InvoicePaymentMethodExtension on InvoicePaymentMethod {
  String localizedName(String languageCode) {
    final isArabic = languageCode == 'ar';

    switch (this) {
      case InvoicePaymentMethod.cash:
        return isArabic ? 'نقداً' : 'Cash';

      case InvoicePaymentMethod.card:
        return isArabic ? 'بطاقة' : 'Card';

      case InvoicePaymentMethod.unknown:
        return isArabic ? 'غير معروف' : 'Unknown';
    }
  }
}

class InvoicePaymentEntity {
  final num amount;
  final InvoicePaymentMethod paymentMethod;
  final String paidAt;

  const InvoicePaymentEntity({
    required this.amount,
    required this.paymentMethod,
    required this.paidAt,
  });

  bool get hasPaidAt => paidAt.trim().isNotEmpty;
}