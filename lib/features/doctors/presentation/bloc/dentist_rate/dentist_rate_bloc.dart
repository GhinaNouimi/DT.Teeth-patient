import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_dentist_rate_usecase.dart';
import '../../../domain/usecases/show_dentist_rate_usecase.dart';
import 'dentist_rate_event.dart';
import 'dentist_rate_state.dart';

class DentistRateBloc extends Bloc<DentistRateEvent, DentistRateState> {
  final ShowDentistRateUseCase showDentistRateUseCase;
  final AddDentistRateUseCase addDentistRateUseCase;

  DentistRateBloc({
    required this.showDentistRateUseCase,
    required this.addDentistRateUseCase,
  }) : super(const DentistRateInitial()) {
    on<ShowDentistRateRequested>(_onShowDentistRateRequested);
    on<AddDentistRateRequested>(_onAddDentistRateRequested);
  }

  Future<void> _onShowDentistRateRequested(
      ShowDentistRateRequested event,
      Emitter<DentistRateState> emit,
      ) async {
    emit(const DentistRateLoading());

    try {
      final rating = await showDentistRateUseCase(
        dentistId: event.dentistId,
        languageCode: event.languageCode,
      );

      emit(DentistRateLoaded(rating: rating));
    } catch (error) {
      emit(
        DentistRateFailure(
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onAddDentistRateRequested(
      AddDentistRateRequested event,
      Emitter<DentistRateState> emit,
      ) async {
    emit(DentistRateSubmitting(currentRating: event.rating));

    try {
      final averageRating = await addDentistRateUseCase(
        dentistId: event.dentistId,
        rating: event.rating,
        languageCode: event.languageCode,
      );

      emit(DentistRateSubmitted(averageRating: averageRating));
    } catch (error) {
      emit(
        DentistRateFailure(
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}