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
  final bool isFromCache;
  final String? errorMessage;

  const ComplaintsState({
    required this.status,
    required this.complaints,
    required this.selectedFilter,
    required this.isFromCache,
    required this.errorMessage,
  });

  const ComplaintsState.initial()
      : status = ComplaintsStatus.initial,
        complaints = const [],
        selectedFilter = ComplaintFilter.all,
        isFromCache = false,
        errorMessage = null;

  List<ComplaintEntity> get filteredComplaints {
    return complaints
        .where(selectedFilter.matches)
        .toList(growable: false);
  }

  bool get isInitialLoading {
    return status == ComplaintsStatus.loading && complaints.isEmpty;
  }

  bool get hasData => complaints.isNotEmpty;

  bool get hasErrorWithoutData {
    return status == ComplaintsStatus.failure && complaints.isEmpty;
  }

  ComplaintsState copyWith({
    ComplaintsStatus? status,
    List<ComplaintEntity>? complaints,
    ComplaintFilter? selectedFilter,
    bool? isFromCache,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ComplaintsState(
      status: status ?? this.status,
      complaints: complaints ?? this.complaints,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isFromCache: isFromCache ?? this.isFromCache,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}