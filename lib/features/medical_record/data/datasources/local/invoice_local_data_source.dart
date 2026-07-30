import '../../models/invoice/invoice_summary_model.dart';
import '../../models/invoice/treatment_invoice_model.dart';

abstract class InvoiceLocalDataSource {
  Future<void> cacheInvoiceSummary(
      InvoiceSummaryModel summary,
      );

  Future<InvoiceSummaryModel?> getCachedInvoiceSummary();

  Future<void> cacheTreatmentInvoice(
      TreatmentInvoiceModel invoice,
      );

  Future<TreatmentInvoiceModel?> getCachedTreatmentInvoice(
      int treatmentId,
      );
}