import '../entities/add_complaint_params.dart';
import '../entities/complaint_entity.dart';
import '../repositories/complaints_repository.dart';

class AddComplaintUseCase {
  final ComplaintsRepository repository;

  const AddComplaintUseCase(this.repository);

  Future<ComplaintEntity> call({
    required AddComplaintParams params,
    required String languageCode,
  }) {
    return repository.addComplaint(
      params: params,
      languageCode: languageCode,
    );
  }
}