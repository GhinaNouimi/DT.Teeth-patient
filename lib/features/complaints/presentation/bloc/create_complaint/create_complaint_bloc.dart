import 'package:bloc/bloc.dart';

import '../../../../../core/network/api_error_handler.dart';
import '../../../domain/usecases/add_complaint_use_case.dart';
import 'create_complaint_event.dart';
import 'create_complaint_state.dart';

class CreateComplaintBloc
    extends Bloc<CreateComplaintEvent, CreateComplaintState> {
  final AddComplaintUseCase addComplaintUseCase;

  CreateComplaintBloc({
    required this.addComplaintUseCase,
  }) : super(const CreateComplaintState.initial()) {
    on<SubmitComplaintRequested>(_onSubmitComplaintRequested);
    on<CreateComplaintStateResetRequested>(
      _onCreateComplaintStateResetRequested,
    );
  }

  Future<void> _onSubmitComplaintRequested(
      SubmitComplaintRequested event,
      Emitter<CreateComplaintState> emit,
      ) async {
    if (state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        status: CreateComplaintStatus.submitting,
        clearCreatedComplaint: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final createdComplaint = await addComplaintUseCase(
        params: event.params,
        languageCode: event.languageCode,
      );

      emit(
        state.copyWith(
          status: CreateComplaintStatus.success,
          createdComplaint: createdComplaint,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CreateComplaintStatus.failure,
          errorMessage: ApiErrorHandler.handle(
            error,
            languageCode: event.languageCode,
          ),
        ),
      );
    }
  }

  void _onCreateComplaintStateResetRequested(
      CreateComplaintStateResetRequested event,
      Emitter<CreateComplaintState> emit,
      ) {
    emit(const CreateComplaintState.initial());
  }
}