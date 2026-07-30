import '../../../../../core/cache/cached_result.dart';
import '../../entities/invoice/treatment_invoice_entity.dart';
import '../../repositories/invoice_repository.dart';

class GetInvoiceForTreatmentUseCase {
  final InvoiceRepository repository;

  const GetInvoiceForTreatmentUseCase(this.repository);

  Future<CachedResult<TreatmentInvoiceEntity>> call({
    required int treatmentId,
    required String languageCode,
  }) {
    return repository.getInvoiceForTreatment(
      treatmentId: treatmentId,
      languageCode: languageCode,
    );
  }
}