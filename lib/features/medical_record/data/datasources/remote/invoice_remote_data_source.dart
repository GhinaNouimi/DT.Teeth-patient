import '../../models/invoice/invoice_summary_model.dart';
import '../../models/invoice/treatment_invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<InvoiceSummaryModel> getInvoiceSummary(
      );

  Future<TreatmentInvoiceModel> getInvoiceForTreatment(
      int treatmentId,
      );
}