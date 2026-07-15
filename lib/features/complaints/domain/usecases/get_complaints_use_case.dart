import '../../../../core/cache/cached_result.dart';
import '../entities/complaint_entity.dart';
import '../repositories/complaints_repository.dart';

class GetComplaintsUseCase {
  final ComplaintsRepository repository;

  const GetComplaintsUseCase(this.repository);

  Future<CachedResult<List<ComplaintEntity>>> call({
    required String languageCode,
  }) {
    return repository.showAllComplaints(
      languageCode: languageCode,
    );
  }
}