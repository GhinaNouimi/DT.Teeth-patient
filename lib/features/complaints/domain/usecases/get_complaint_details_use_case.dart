import '../entities/complaint_entity.dart';
import '../repositories/complaints_repository.dart';

class GetComplaintDetailsUseCase {
  final ComplaintsRepository repository;

  const GetComplaintDetailsUseCase(this.repository);

  Future<ComplaintEntity> call(String complaintId) {
    return repository.getComplaintDetails(complaintId);
  }
}