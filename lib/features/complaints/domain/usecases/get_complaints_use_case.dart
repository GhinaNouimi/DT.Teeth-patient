import '../entities/complaint_entity.dart';
import '../repositories/complaints_repository.dart';

class GetComplaintsUseCase {
  final ComplaintsRepository repository;

  const GetComplaintsUseCase(this.repository);

  Future<List<ComplaintEntity>> call() {
    return repository.getComplaints();
  }
}