import '../../../domain/entities/complaint_entity.dart';

abstract class CreateComplaintEvent {
  const CreateComplaintEvent();
}

class SubmitComplaintRequested extends CreateComplaintEvent {
  final ComplaintEntity complaint;

  const SubmitComplaintRequested(this.complaint);
}

class CreateComplaintStateResetRequested extends CreateComplaintEvent {
  const CreateComplaintStateResetRequested();
}