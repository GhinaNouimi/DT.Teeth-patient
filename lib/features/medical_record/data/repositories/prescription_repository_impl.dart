import '../../../../core/cache/cached_result.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/network_error_messages.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/prescription/prescription_entity.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../datasources/local/prescription_local_data_source.dart';
import '../datasources/remote/prescription_remote_data_source.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource remoteDataSource;
  final PrescriptionLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const PrescriptionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CachedResult<List<PrescriptionEntity>>> getAllPrescriptions({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final prescriptions = await remoteDataSource.getAllPrescriptions();
        await localDataSource.cachePrescriptions(prescriptions);

        return CachedResult.remote(prescriptions);
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    final cachedPrescriptions =
    await localDataSource.getCachedPrescriptions();

    if (cachedPrescriptions.isEmpty) {
      throw Exception(NetworkErrorMessages.noCachedData(languageCode));
    }

    return CachedResult.cache(cachedPrescriptions);
  }

  @override
  Future<CachedResult<PrescriptionEntity>> getPrescriptionDetails({
    required int prescriptionId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final prescription = await remoteDataSource.getPrescriptionDetails(
          prescriptionId,
        );

        await localDataSource.cachePrescriptionDetails(prescription);

        return CachedResult.remote(prescription);
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    final cachedPrescription =
    await localDataSource.getCachedPrescriptionDetails(prescriptionId);

    if (cachedPrescription == null) {
      throw Exception(NetworkErrorMessages.noCachedData(languageCode));
    }

    return CachedResult.cache(cachedPrescription);
  }
}