import '../../models/offer_model.dart';

abstract class OffersLocalDataSource {
  Future<void> cacheOffers(
      List<OfferModel> offers,
      );

  Future<List<OfferModel>> getCachedOffers();
}