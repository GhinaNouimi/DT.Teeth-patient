import 'invoice_item_entity.dart';
import 'invoice_payment_entity.dart';
import 'invoice_treatment_type_entity.dart';

enum InvoiceStatus {
  paid,
  partial,
  unpaid,
  unknown,
}

class TreatmentInvoiceEntity {
  final int id;
  final int treatmentId;
  final InvoiceTreatmentTypeEntity treatmentType;
  final String dentistName;
  final InvoiceStatus status;
  final num totalAmount;
  final num paidAmount;
  final num remainingAmount;
  final List<InvoiceItemEntity> items;
  final List<InvoicePaymentEntity> payments;

  const TreatmentInvoiceEntity({
    required this.id,
    required this.treatmentId,
    required this.treatmentType,
    required this.dentistName,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.items,
    required this.payments,
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

  bool get isPaid {
    return status == InvoiceStatus.paid;
  }

  bool get isPartiallyPaid {
    return status == InvoiceStatus.partial;
  }

  bool get isUnpaid {
    return status == InvoiceStatus.unpaid;
  }

  bool get hasRemainingAmount {
    return remainingAmount > 0;
  }

  bool get hasItems {
    return items.isNotEmpty;
  }

  bool get hasPayments {
    return payments.isNotEmpty;
  }
}