import '../../../../core/cache/cached_result.dart';
import '../entities/applicable_treatment_entity.dart';
import '../entities/offer_entity.dart';

abstract class OffersRepository {
  Future<CachedResult<List<OfferEntity>>> showOffers({
    required String languageCode,
  });

  Future<List<ApplicableTreatmentEntity>> treatmentsByType({
    required int treatmentTypeId,
    required String languageCode,
  });

  Future<String> applyToOffer({
    required int offerId,
    required int treatmentId,
    required String languageCode,
  });
}