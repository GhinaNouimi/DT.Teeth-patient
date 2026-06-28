abstract class ComplaintDetailsEvent {
  const ComplaintDetailsEvent();
}

class LoadComplaintDetailsRequested extends ComplaintDetailsEvent {
  final String complaintId;

  const LoadComplaintDetailsRequested(this.complaintId);
}