import '../../../../core/cache/cache_exception.dart';
import '../../../../core/cache/cached_result.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/network_error_messages.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/dentist_details_entity.dart';
import '../../domain/entities/dentist_entity.dart';
import '../../domain/repositories/doctors_repository.dart';
import '../datasources/local/doctors_local_data_source.dart';
import '../datasources/remote/doctors_remote_data_source.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  final DoctorsRemoteDataSource remoteDataSource;
  final DoctorsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const DoctorsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CachedResult<List<DentistEntity>>> showAllDentists({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response = await remoteDataSource.showAllDentists();
        await localDataSource.cacheDentists(response);
        return CachedResult.remote(response.data);
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(error, languageCode: languageCode),
        );
      }
    }

    try {
      final cachedResponse = await localDataSource.getCachedDentists();

      if (cachedResponse.data.isEmpty) {
        throw const CacheException();
      }

      return CachedResult.cache(cachedResponse.data);
    } catch (_) {
      throw Exception(NetworkErrorMessages.noCachedData(languageCode));
    }
  }

  @override
  Future<CachedResult<DentistDetailsEntity>> showDentistDetails({
    required int dentistId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response = await remoteDataSource.showDentistDetails(dentistId);

        if (response.data == null) {
          throw Exception(NetworkErrorMessages.noCachedData(languageCode));
        }

        await localDataSource.cacheDentistDetails(dentistId, response);

        return CachedResult.remote(response.data!);
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(error, languageCode: languageCode),
        );
      }
    }

    try {
      final cachedResponse = await localDataSource.getCachedDentistDetails(
        dentistId,
      );

      if (cachedResponse.data == null) {
        throw const CacheException();
      }

      return CachedResult.cache(cachedResponse.data!);
    } catch (_) {
      throw Exception(NetworkErrorMessages.noCachedData(languageCode));
    }
  }

  @override
  Future<CachedResult<List<DentistDetailsEntity>>>
  showDentistsBySpecialization({
    required int specializationId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response =
        await remoteDataSource.showDentistsBySpecialization(
          specializationId,
        );

        await localDataSource.cacheDentistsBySpecialization(
          specializationId,
          response,
        );

        return CachedResult.remote(response.data);
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(error, languageCode: languageCode),
        );
      }
    }

    try {
      final cachedResponse =
      await localDataSource.getCachedDentistsBySpecialization(
        specializationId,
      );

      if (cachedResponse.data.isEmpty) {
        throw const CacheException();
      }

      return CachedResult.cache(cachedResponse.data);
    } catch (_) {
      throw Exception(NetworkErrorMessages.noCachedData(languageCode));
    }
  }

  @override
  Future<int> showDentistRate({
    required int dentistId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      throw Exception(NetworkErrorMessages.noInternet(languageCode));
    }

    try {
      final response = await remoteDataSource.showDentistRate(dentistId);
      return response.rating;
    } catch (error) {
      throw Exception(
        ApiErrorHandler.handle(error, languageCode: languageCode),
      );
    }
  }

  @override
  Future<int> addDentistRate({
    required int dentistId,
    required int rating,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      throw Exception(
        NetworkErrorMessages.offlineActionNotAllowed(languageCode),
      );
    }

    try {
      final response = await remoteDataSource.addDentistRate(
        dentistId: dentistId,
        rating: rating,
      );

      return response.averageRating;
    } catch (error) {
      throw Exception(
        ApiErrorHandler.handle(error, languageCode: languageCode),
      );
    }
  }
}