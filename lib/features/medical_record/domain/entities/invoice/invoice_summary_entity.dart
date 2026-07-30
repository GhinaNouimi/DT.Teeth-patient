class InvoiceSummaryEntity {
  final num totalAmount;
  final num paidAmount;
  final num remainingAmount;

  const InvoiceSummaryEntity({
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
  });

  double get paymentProgress {
    if (totalAmount <= 0) {
      return 0;
    }

    return (paidAmount / totalAmount).clamp(0.0, 1.0).toDouble();
  }

  int get paymentProgressPercent {
    return (paymentProgress * 100).round();
  }

  bool get hasInvoiceAmount {
    return totalAmount > 0;
  }

  bool get hasPaidAmount {
    return paidAmount > 0;
  }

  bool get hasRemainingAmount {
    return remainingAmount > 0;
  }

  bool get isFullyPaid {
    return totalAmount > 0 && remainingAmount <= 0;
  }
}