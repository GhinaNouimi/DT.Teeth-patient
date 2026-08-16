import '../../../../core/cache/cached_result.dart';
import '../entities/bookable_treatment_entity.dart';
import '../repositories/bookable_treatments_provider.dart';

class GetBookableTreatmentsUseCase {
  final BookableTreatmentsProvider provider;

  const GetBookableTreatmentsUseCase({
    required this.provider,
  });

  Future<CachedResult<List<BookableTreatmentEntity>>>
  call({
    required String languageCode,
  }) {
    return provider.getBookableTreatments(
      languageCode: languageCode,
    );
  }
}