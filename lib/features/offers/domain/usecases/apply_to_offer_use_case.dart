import '../repositories/offers_repository.dart';

class ApplyToOfferUseCase {
  final OffersRepository repository;

  const ApplyToOfferUseCase(this.repository);

  Future<String> call({
    required int offerId,
    required int treatmentId,
    required String languageCode,
  }) {
    return repository.applyToOffer(
      offerId: offerId,
      treatmentId: treatmentId,
      languageCode: languageCode,
    );
  }
}