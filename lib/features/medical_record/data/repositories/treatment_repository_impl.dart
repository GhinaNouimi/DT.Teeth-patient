import '../../../../core/cache/cached_result.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/network_error_messages.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/treatment/treatment_entity.dart';
import '../../domain/repositories/treatment_repository.dart';
import '../datasources/local/treatment_local_data_source.dart';
import '../datasources/remote/treatment_remote_data_source.dart';

class TreatmentRepositoryImpl implements TreatmentRepository {
  final TreatmentRemoteDataSource remoteDataSource;
  final TreatmentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const TreatmentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CachedResult<List<TreatmentEntity>>> getAllTreatments({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final treatments = await remoteDataSource.getAllTreatments();

        await localDataSource.cacheTreatments(treatments);

        return CachedResult.remote(treatments);
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    final cachedTreatments = await localDataSource.getCachedTreatments();

    if (cachedTreatments.isEmpty) {
      throw Exception(
        NetworkErrorMessages.noCachedData(languageCode),
      );
    }

    return CachedResult.cache(cachedTreatments);
  }

  @override
  Future<CachedResult<TreatmentEntity>> getTreatmentDetails({
    required int treatmentId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final treatment = await remoteDataSource.getTreatmentDetails(
          treatmentId,
        );

        await localDataSource.cacheTreatmentDetails(treatment);

        return CachedResult.remote(treatment);
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    final cachedTreatment =
    await localDataSource.getCachedTreatmentDetails(treatmentId);

    if (cachedTreatment == null) {
      throw Exception(
        NetworkErrorMessages.noCachedData(languageCode),
      );
    }

    return CachedResult.cache(cachedTreatment);
  }
}