abstract class InvoiceEvent {
  const InvoiceEvent();
}

class LoadInvoiceSummaryRequested extends InvoiceEvent {
  final String languageCode;

  const LoadInvoiceSummaryRequested({
    required this.languageCode,
  });
}

class LoadTreatmentInvoiceRequested extends InvoiceEvent {
  final int treatmentId;
  final String languageCode;

  const LoadTreatmentInvoiceRequested({
    required this.treatmentId,
    required this.languageCode,
  });
}