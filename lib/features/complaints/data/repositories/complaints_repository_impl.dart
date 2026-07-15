import '../../../../core/cache/cache_exception.dart';
import '../../../../core/cache/cached_result.dart';
import '../../../../core/network/network_error_messages.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/add_complaint_params.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaints_repository.dart';
import '../datasources/local/complaints_local_data_source.dart';
import '../datasources/remote/complaints_remote_data_source.dart';
import '../models/add_complaint_request_model.dart';

class ComplaintsRepositoryImpl implements ComplaintsRepository {
  final ComplaintsRemoteDataSource remoteDataSource;
  final ComplaintsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const ComplaintsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CachedResult<List<ComplaintEntity>>> showAllComplaints({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      final remoteComplaints =
      await remoteDataSource.showAllComplaints();

      await localDataSource.cacheComplaints(
        remoteComplaints,
      );

      final complaints = remoteComplaints
          .map((complaint) => complaint.toEntity())
          .toList();

      return CachedResult.remote(complaints);
    }

    final cachedComplaints =
    await localDataSource.getCachedComplaints();

    if (cachedComplaints.isEmpty) {
      throw CacheException(
        NetworkErrorMessages.noCachedData(languageCode),
      );
    }

    final complaints = cachedComplaints
        .map((complaint) => complaint.toEntity())
        .toList();

    return CachedResult.cache(complaints);
  }

  @override
  Future<ComplaintEntity> addComplaint({
    required AddComplaintParams params,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      throw CacheException(
        NetworkErrorMessages.offlineActionNotAllowed(
          languageCode,
        ),
      );
    }

    final requestModel =
    AddComplaintRequestModel.fromParams(params);

    final createdComplaint =
    await remoteDataSource.addComplaint(requestModel);

    await localDataSource.addComplaintToCache(
      createdComplaint,
    );

    return createdComplaint.toEntity();
  }
}