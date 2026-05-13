enum PaymentMethod {
  cash,
  bankTransfer,
  card,
}

class PaymentRecordEntity {
  final String id;
  final String title;
  final String dateLabel;
  final String amountLabel;
  final PaymentMethod method;
  final bool isCompleted;

  const PaymentRecordEntity({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.amountLabel,
    required this.method,
    required this.isCompleted,
  });

  String get methodLabel {
    switch (method) {
      case PaymentMethod.cash:
        return 'نقدي';
      case PaymentMethod.bankTransfer:
        return 'تحويل بنكي';
      case PaymentMethod.card:
        return 'بطاقة';
    }
  }
}
