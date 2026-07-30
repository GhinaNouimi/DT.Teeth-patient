import 'dart:convert';

import '../../../../../core/cache/cache_keys.dart';
import '../../../../../core/cache/cache_service.dart';
import '../../models/invoice/invoice_summary_model.dart';
import '../../models/invoice/treatment_invoice_model.dart';
import 'invoice_local_data_source.dart';

class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  @override
  Future<void> cacheInvoiceSummary(
      InvoiceSummaryModel summary,
      ) async {
    await CacheService.saveString(
      key: CacheKeys.invoiceSummary,
      value: jsonEncode(
        summary.toJson(),
      ),
    );
  }

  @override
  Future<InvoiceSummaryModel?> getCachedInvoiceSummary() async {
    final cached = await CacheService.getString(
      key: CacheKeys.invoiceSummary,
    );

    final decoded = jsonDecode(cached);

    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return InvoiceSummaryModel.fromJson(decoded);
  }

  @override
  Future<void> cacheTreatmentInvoice(
      TreatmentInvoiceModel invoice,
      ) async {
    await CacheService.saveString(
      key: CacheKeys.treatmentInvoice(
        invoice.treatmentId,
      ),
      value: jsonEncode(
        invoice.toJson(),
      ),
    );
  }

  @override
  Future<TreatmentInvoiceModel?> getCachedTreatmentInvoice(
      int treatmentId,
      ) async {
    final cached = await CacheService.getString(
      key: CacheKeys.treatmentInvoice(
        treatmentId,
      ),
    );

    final decoded = jsonDecode(cached);

    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return TreatmentInvoiceModel.fromJson(decoded);
  }
}