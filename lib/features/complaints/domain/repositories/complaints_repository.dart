import '../../../../core/cache/cached_result.dart';
import '../entities/add_complaint_params.dart';
import '../entities/complaint_entity.dart';

abstract class ComplaintsRepository {
  Future<CachedResult<List<ComplaintEntity>>> showAllComplaints({
    required String languageCode,
  });

  Future<ComplaintEntity> addComplaint({
    required AddComplaintParams params,
    required String languageCode,
  });
}