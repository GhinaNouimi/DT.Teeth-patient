import 'package:bloc/bloc.dart';

import '../../../domain/usecases/submit_complaint_use_case.dart';
import 'create_complaint_event.dart';
import 'create_complaint_state.dart';

class CreateComplaintBloc
    extends Bloc<CreateComplaintEvent, CreateComplaintState> {
  final SubmitComplaintUseCase submitComplaintUseCase;

  CreateComplaintBloc({
    required this.submitComplaintUseCase,
  }) : super(const CreateComplaintState.initial()) {
    on<SubmitComplaintRequested>(_onSubmitComplaintRequested);
    on<CreateComplaintStateResetRequested>(_onCreateComplaintStateResetRequested);
  }

  Future<void> _onSubmitComplaintRequested(
      SubmitComplaintRequested event,
      Emitter<CreateComplaintState> emit,
      ) async {
    emit(
      state.copyWith(
        status: CreateComplaintStatus.submitting,
        clearErrorMessage: true,
      ),
    );

    try {
      final submittedComplaint = await submitComplaintUseCase(event.complaint);

      emit(
        state.copyWith(
          status: CreateComplaintStatus.success,
          submittedComplaint: submittedComplaint,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CreateComplaintStatus.failure,
          errorMessage: 'تعذر إرسال الشكوى حاليًا',
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