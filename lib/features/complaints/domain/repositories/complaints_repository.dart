import '../entities/complaint_entity.dart';

abstract class ComplaintsRepository {
  Future<List<ComplaintEntity>> getComplaints();
  Future<ComplaintEntity> getComplaintDetails(String complaintId);
  Future<ComplaintEntity> submitComplaint(ComplaintEntity complaint);
}