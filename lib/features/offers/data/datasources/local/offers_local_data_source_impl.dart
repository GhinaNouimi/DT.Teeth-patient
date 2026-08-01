import 'dart:convert';

import '../../../../../core/cache/cache_keys.dart';
import '../../../../../core/cache/cache_service.dart';
import '../../models/offer_model.dart';
import 'offers_local_data_source.dart';

class OffersLocalDataSourceImpl
    implements OffersLocalDataSource {
  @override
  Future<void> cacheOffers(
      List<OfferModel> offers,
      ) async {
    await CacheService.saveString(
      key: CacheKeys.offers,
      value: jsonEncode(
        offers
            .map((offer) => offer.toJson())
            .toList(),
      ),
    );
  }

  @override
  Future<List<OfferModel>> getCachedOffers() async {
    final cached = await CacheService.getString(
      key: CacheKeys.offers,
    );

    final decoded = jsonDecode(cached);

    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(OfferModel.fromJson)
        .toList();
  }
}