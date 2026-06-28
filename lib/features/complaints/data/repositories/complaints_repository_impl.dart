import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaints_repository.dart';
import '../models/complaint_model.dart';
import '../sources/complaints_mock_data_source.dart';

class ComplaintsRepositoryImpl implements ComplaintsRepository {
  final ComplaintsMockDataSource mockDataSource;

  const ComplaintsRepositoryImpl(this.mockDataSource);

  @override
  Future<List<ComplaintEntity>> getComplaints() async {
    final result = await mockDataSource.getComplaints();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<ComplaintEntity> getComplaintDetails(String complaintId) async {
    final result = await mockDataSource.getComplaintDetails(complaintId);
    return result.toEntity();
  }

  @override
  Future<ComplaintEntity> submitComplaint(ComplaintEntity complaint) async {
    final result = await mockDataSource.submitComplaint(
      ComplaintModel.fromEntity(complaint),
    );
    return result.toEntity();
  }
}