import 'package:bloc/bloc.dart';

import '../../../../../core/network/api_error_handler.dart';
import '../../../domain/usecases/get_complaints_use_case.dart';
import 'complaints_event.dart';
import 'complaints_state.dart';

class ComplaintsBloc
    extends Bloc<ComplaintsEvent, ComplaintsState> {
  final GetComplaintsUseCase getComplaintsUseCase;

  ComplaintsBloc({
    required this.getComplaintsUseCase,
  }) : super(const ComplaintsState.initial()) {
    on<LoadComplaintsRequested>(_onLoadComplaintsRequested);
    on<RefreshComplaintsRequested>(_onRefreshComplaintsRequested);
    on<ComplaintFilterChanged>(_onComplaintFilterChanged);
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

    await _loadComplaints(
      languageCode: event.languageCode,
      emit: emit,
    );
  }

  Future<void> _onRefreshComplaintsRequested(
      RefreshComplaintsRequested event,
      Emitter<ComplaintsState> emit,
      ) async {
    await _loadComplaints(
      languageCode: event.languageCode,
      emit: emit,
    );
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

  Future<void> _loadComplaints({
    required String languageCode,
    required Emitter<ComplaintsState> emit,
  }) async {
    try {
      final result = await getComplaintsUseCase(
        languageCode: languageCode,
      );

      emit(
        state.copyWith(
          status: ComplaintsStatus.success,
          complaints: result.data,
          isFromCache: result.isFromCache,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ComplaintsStatus.failure,
          errorMessage: ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        ),
      );
    }
  }
}