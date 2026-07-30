import '../../../../core/cache/cached_result.dart';
import '../entities/invoice/invoice_summary_entity.dart';
import '../entities/invoice/treatment_invoice_entity.dart';

abstract class InvoiceRepository {
  Future<CachedResult<InvoiceSummaryEntity>> getInvoiceSummary({
    required String languageCode,
  });

  Future<CachedResult<TreatmentInvoiceEntity>> getInvoiceForTreatment({
    required int treatmentId,
    required String languageCode,
  });
}