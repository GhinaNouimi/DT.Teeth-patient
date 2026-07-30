import '../../../../../core/cache/cached_result.dart';
import '../../entities/invoice/invoice_summary_entity.dart';
import '../../repositories/invoice_repository.dart';

class GetInvoiceSummaryUseCase {
  final InvoiceRepository repository;

  const GetInvoiceSummaryUseCase(this.repository);

  Future<CachedResult<InvoiceSummaryEntity>> call({
    required String languageCode,
  }) {
    return repository.getInvoiceSummary(
      languageCode: languageCode,
    );
  }
}