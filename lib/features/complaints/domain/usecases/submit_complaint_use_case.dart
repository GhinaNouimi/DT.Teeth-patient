import '../entities/complaint_entity.dart';
import '../repositories/complaints_repository.dart';

class SubmitComplaintUseCase {
  final ComplaintsRepository repository;

  const SubmitComplaintUseCase(this.repository);

  Future<ComplaintEntity> call(ComplaintEntity complaint) {
    return repository.submitComplaint(complaint);
  }
}