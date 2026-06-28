import 'package:bloc/bloc.dart';

import '../../../domain/usecases/get_complaints_use_case.dart';
import 'complaints_event.dart';
import 'complaints_state.dart';

class ComplaintsBloc extends Bloc<ComplaintsEvent, ComplaintsState> {
  final GetComplaintsUseCase getComplaintsUseCase;

  ComplaintsBloc({
    required this.getComplaintsUseCase,
  }) : super(const ComplaintsState.initial()) {
    on<LoadComplaintsRequested>(_onLoadComplaintsRequested);
    on<ComplaintFilterChanged>(_onComplaintFilterChanged);
    on<RefreshComplaintsRequested>(_onRefreshComplaintsRequested);
  }

  Future<void> _onLoadComplaintsRequested(
      LoadComplaintsRequested event,
      Emitter<ComplaintsState> emit,
      ) async {
    emit(
      state.copyWith(
        status: ComplaintsStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final complaints = await getComplaintsUseCase();

      emit(
        state.copyWith(
          status: ComplaintsStatus.success,
          complaints: complaints,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ComplaintsStatus.failure,
          errorMessage: 'تعذر تحميل الشكاوى حاليًا',
        ),
      );
    }
  }

  void _onComplaintFilterChanged(
      ComplaintFilterChanged event,
      Emitter<ComplaintsState> emit,
      ) {
    emit(
      state.copyWith(
        selectedFilter: event.filter,
      ),
    );
  }

  Future<void> _onRefreshComplaintsRequested(
      RefreshComplaintsRequested event,
      Emitter<ComplaintsState> emit,
      ) async {
    try {
      final complaints = await getComplaintsUseCase();

      emit(
        state.copyWith(
          status: ComplaintsStatus.success,
          complaints: complaints,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ComplaintsStatus.failure,
          errorMessage: 'تعذر تحديث الشكاوى',
        ),
      );
    }
  }
}