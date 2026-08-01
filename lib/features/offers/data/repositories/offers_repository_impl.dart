import '../../../../core/cache/cache_exception.dart';
import '../../../../core/cache/cached_result.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/network_error_messages.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/applicable_treatment_entity.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/repositories/offers_repository.dart';
import '../datasources/local/offers_local_data_source.dart';
import '../datasources/remote/offers_remote_data_source.dart';

class OffersRepositoryImpl implements OffersRepository {
  final OffersRemoteDataSource remoteDataSource;
  final OffersLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const OffersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CachedResult<List<OfferEntity>>> showOffers({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final offers =
        await remoteDataSource.showOffers();

        await localDataSource.cacheOffers(offers);

        return CachedResult.remote(offers);
      } catch (error) {
        throw AppException(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    try {
      final cachedOffers =
      await localDataSource.getCachedOffers();

      return CachedResult.cache(cachedOffers);
    } on CacheException {
      throw AppException(
        NetworkErrorMessages.noCachedData(
          languageCode,
        ),
      );
    } catch (_) {
      throw AppException(
        NetworkErrorMessages.noCachedData(
          languageCode,
        ),
      );
    }
  }

  @override
  Future<List<ApplicableTreatmentEntity>>
  treatmentsByType({
    required int treatmentTypeId,
    required String languageCode,
  }) async {
    final isConnected =
    await networkInfo.isConnected;

    if (!isConnected) {
      throw AppException(
        NetworkErrorMessages
            .offlineActionNotAllowed(
          languageCode,
        ),
      );
    }

    try {
      return await remoteDataSource
          .treatmentsByType(
        treatmentTypeId: treatmentTypeId,
      );
    } catch (error) {
      throw AppException(
        ApiErrorHandler.handle(
          error,
          languageCode: languageCode,
        ),
      );
    }
  }

  @override
  Future<String> applyToOffer({
    required int offerId,
    required int treatmentId,
    required String languageCode,
  }) async {
    final isConnected =
    await networkInfo.isConnected;

    if (!isConnected) {
      throw AppException(
        NetworkErrorMessages
            .offlineActionNotAllowed(
          languageCode,
        ),
      );
    }

    try {
      return await remoteDataSource.applyToOffer(
        offerId: offerId,
        treatmentId: treatmentId,
      );
    } catch (error) {
      throw AppException(
        ApiErrorHandler.handle(
          error,
          languageCode: languageCode,
        ),
      );
    }
  }
}