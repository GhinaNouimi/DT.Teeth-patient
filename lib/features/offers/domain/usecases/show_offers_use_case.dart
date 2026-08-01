import '../../../../core/cache/cached_result.dart';
import '../entities/offer_entity.dart';
import '../repositories/offers_repository.dart';

class ShowOffersUseCase {
  final OffersRepository repository;

  const ShowOffersUseCase(this.repository);

  Future<CachedResult<List<OfferEntity>>> call({
    required String languageCode,
  }) {
    return repository.showOffers(
      languageCode: languageCode,
    );
  }
}