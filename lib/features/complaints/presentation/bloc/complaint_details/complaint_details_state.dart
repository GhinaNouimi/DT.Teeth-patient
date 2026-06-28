import '../../../domain/entities/complaint_entity.dart';

enum ComplaintDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

class ComplaintDetailsState {
  final ComplaintDetailsStatus status;
  final ComplaintEntity? complaint;
  final String? errorMessage;

  const ComplaintDetailsState({
    required this.status,
    required this.complaint,
    required this.errorMessage,
  });

  const ComplaintDetailsState.initial()
      : status = ComplaintDetailsStatus.initial,
        complaint = null,
        errorMessage = null;

  ComplaintDetailsState copyWith({
    ComplaintDetailsStatus? status,
    ComplaintEntity? complaint,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ComplaintDetailsState(
      status: status ?? this.status,
      complaint: complaint ?? this.complaint,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}