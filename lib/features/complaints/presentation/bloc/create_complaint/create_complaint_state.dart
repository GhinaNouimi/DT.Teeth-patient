import '../../../domain/entities/complaint_entity.dart';

enum CreateComplaintStatus {
  initial,
  submitting,
  success,
  failure,
}

class CreateComplaintState {
  final CreateComplaintStatus status;
  final ComplaintEntity? createdComplaint;
  final String? errorMessage;

  const CreateComplaintState({
    required this.status,
    required this.createdComplaint,
    required this.errorMessage,
  });

  const CreateComplaintState.initial()
      : status = CreateComplaintStatus.initial,
        createdComplaint = null,
        errorMessage = null;

  bool get isSubmitting {
    return status == CreateComplaintStatus.submitting;
  }

  CreateComplaintState copyWith({
    CreateComplaintStatus? status,
    ComplaintEntity? createdComplaint,
    String? errorMessage,
    bool clearCreatedComplaint = false,
    bool clearErrorMessage = false,
  }) {
    return CreateComplaintState(
      status: status ?? this.status,
      createdComplaint: clearCreatedComplaint
          ? null
          : createdComplaint ?? this.createdComplaint,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}