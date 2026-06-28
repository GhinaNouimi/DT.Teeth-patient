import 'package:bloc/bloc.dart';

import '../../../domain/usecases/get_complaint_details_use_case.dart';
import 'complaint_details_event.dart';
import 'complaint_details_state.dart';

class ComplaintDetailsBloc
    extends Bloc<ComplaintDetailsEvent, ComplaintDetailsState> {
  final GetComplaintDetailsUseCase getComplaintDetailsUseCase;

  ComplaintDetailsBloc({
    required this.getComplaintDetailsUseCase,
  }) : super(const ComplaintDetailsState.initial()) {
    on<LoadComplaintDetailsRequested>(_onLoadComplaintDetailsRequested);
  }

  Future<void> _onLoadComplaintDetailsRequested(
      LoadComplaintDetailsRequested event,
      Emitter<ComplaintDetailsState> emit,
      ) async {
    emit(
      state.copyWith(
        status: ComplaintDetailsStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final complaint = await getComplaintDetailsUseCase(event.complaintId);

      emit(
        state.copyWith(
          status: ComplaintDetailsStatus.success,
          complaint: complaint,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ComplaintDetailsStatus.failure,
          errorMessage: 'تعذر تحميل تفاصيل الشكوى',
        ),
      );
    }
  }
}