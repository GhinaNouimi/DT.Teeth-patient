import '../../../domain/entities/complaint_entity.dart';
import '../../models/complaint_filter.dart';

enum ComplaintsStatus {
  initial,
  loading,
  success,
  failure,
}

class ComplaintsState {
  final ComplaintsStatus status;
  final List<ComplaintEntity> complaints;
  final ComplaintFilter selectedFilter;
  final String? errorMessage;

  const ComplaintsState({
    required this.status,
    required this.complaints,
    required this.selectedFilter,
    required this.errorMessage,
  });

  const ComplaintsState.initial()
      : status = ComplaintsStatus.initial,
        complaints = const [],
        selectedFilter = ComplaintFilter.all,
        errorMessage = null;

  List<ComplaintEntity> get filteredComplaints {
    if (selectedFilter == ComplaintFilter.all) {
      return complaints;
    }

    return complaints
        .where((item) => item.status == selectedFilter.status)
        .toList();
  }

  ComplaintsState copyWith({
    ComplaintsStatus? status,
    List<ComplaintEntity>? complaints,
    ComplaintFilter? selectedFilter,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ComplaintsState(
      status: status ?? this.status,
      complaints: complaints ?? this.complaints,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}