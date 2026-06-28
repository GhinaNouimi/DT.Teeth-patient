import '../../../domain/entities/complaint_entity.dart';

enum CreateComplaintStatus {
  initial,
  submitting,
  success,
  failure,
}

class CreateComplaintState {
  final CreateComplaintStatus status;
  final ComplaintEntity? submittedComplaint;
  final String? errorMessage;

  const CreateComplaintState({
    required this.status,
    required this.submittedComplaint,
    required this.errorMessage,
  });

  const CreateComplaintState.initial()
      : status = CreateComplaintStatus.initial,
        submittedComplaint = null,
        errorMessage = null;

  CreateComplaintState copyWith({
    CreateComplaintStatus? status,
    ComplaintEntity? submittedComplaint,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CreateComplaintState(
      status: status ?? this.status,
      submittedComplaint: submittedComplaint ?? this.submittedComplaint,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}