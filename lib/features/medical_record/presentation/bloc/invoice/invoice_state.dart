import '../../../domain/entities/invoice/invoice_summary_entity.dart';
import '../../../domain/entities/invoice/treatment_invoice_entity.dart';

abstract class InvoiceState {
  const InvoiceState();
}

class InvoiceInitial extends InvoiceState {
  const InvoiceInitial();
}

class InvoiceLoading extends InvoiceState {
  const InvoiceLoading();
}

class InvoiceSummaryLoaded extends InvoiceState {
  final InvoiceSummaryEntity summary;
  final bool isFromCache;

  const InvoiceSummaryLoaded({
    required this.summary,
    required this.isFromCache,
  });
}

class TreatmentInvoiceLoaded extends InvoiceState {
  final TreatmentInvoiceEntity invoice;
  final bool isFromCache;

  const TreatmentInvoiceLoaded({
    required this.invoice,
    required this.isFromCache,
  });
}

class InvoiceFailure extends InvoiceState {
  final String message;

  const InvoiceFailure({
    required this.message,
  });
}