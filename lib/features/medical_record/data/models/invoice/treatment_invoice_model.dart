import '../../../domain/entities/invoice/treatment_invoice_entity.dart';
import 'invoice_item_model.dart';
import 'invoice_payment_model.dart';
import 'invoice_treatment_type_model.dart';

class TreatmentInvoiceModel extends TreatmentInvoiceEntity {
  const TreatmentInvoiceModel({
    required super.id,
    required super.treatmentId,
    required super.treatmentType,
    required super.dentistName,
    required super.status,
    required super.totalAmount,
    required super.paidAmount,
    required super.remainingAmount,
    required super.items,
    required super.payments,
  });

  factory TreatmentInvoiceModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final treatmentTypeJson = json['treatment_type'];
    final itemsJson = json['items'];
    final paymentsJson = json['payments'];

    return TreatmentInvoiceModel(
      id: _parseInt(json['id']),
      treatmentId: _parseInt(json['treatment_id']),
      treatmentType: treatmentTypeJson is Map<String, dynamic>
          ? InvoiceTreatmentTypeModel.fromJson(treatmentTypeJson)
          : const InvoiceTreatmentTypeModel(
        name: '',
        nameEn: '',
      ),
      dentistName: json['dentist_name']?.toString() ?? '',
      status: _parseStatus(json['status']),
      totalAmount: _parseNum(json['total_amount']),
      paidAmount: _parseNum(json['paid_amount']),
      remainingAmount: _parseNum(json['remaining_amount']),
      items: itemsJson is List
          ? itemsJson
          .whereType<Map<String, dynamic>>()
          .map(InvoiceItemModel.fromJson)
          .toList()
          : const [],
      payments: paymentsJson is List
          ? paymentsJson
          .whereType<Map<String, dynamic>>()
          .map(InvoicePaymentModel.fromJson)
          .toList()
          : const [],
    );
  }

  static InvoiceStatus _parseStatus(dynamic value) {
    switch (value?.toString().trim().toLowerCase()) {
      case 'paid':
        return InvoiceStatus.paid;

      case 'partial':
        return InvoiceStatus.partial;

      case 'unpaid':
        return InvoiceStatus.unpaid;

      default:
        return InvoiceStatus.unknown;
    }
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _parseNum(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'treatment_id': treatmentId,
      'treatment_type': {
        'ar': treatmentType.name,
        'en': treatmentType.nameEn,
      },
      'dentist_name': dentistName,
      'status': status.name,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
      'items': items
          .map(
            (item) => {
          'description': item.description,
          'unit_price': item.unitPrice,
          'discount_percentage': item.discountPercentage,
          'final_price': item.finalPrice,
        },
      )
          .toList(),
      'payments': payments
          .map(
            (payment) => {
          'amount': payment.amount,
          'payment_method': payment.paymentMethod.name,
          'paid_at': payment.paidAt,
        },
      )
          .toList(),
    };
  }
}