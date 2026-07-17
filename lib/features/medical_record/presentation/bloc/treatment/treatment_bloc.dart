import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_error_handler.dart';
import '../../../domain/usecases/treatment/get_all_treatments_use_case.dart';
import '../../../domain/usecases/treatment/get_treatment_details_use_case.dart';
import 'treatment_event.dart';
import 'treatment_state.dart';

class TreatmentBloc extends Bloc<TreatmentEvent, TreatmentState> {
  final GetAllTreatmentsUseCase getAllTreatmentsUseCase;
  final GetTreatmentDetailsUseCase getTreatmentDetailsUseCase;

  TreatmentBloc({
    required this.getAllTreatmentsUseCase,
    required this.getTreatmentDetailsUseCase,
  }) : super(const TreatmentInitial()) {
    on<LoadTreatmentsRequested>(
      _onLoadTreatmentsRequested,
    );

    on<LoadTreatmentDetailsRequested>(
      _onLoadTreatmentDetailsRequested,
    );
  }

  Future<void> _onLoadTreatmentsRequested(
      LoadTreatmentsRequested event,
      Emitter<TreatmentState> emit,
      ) async {
    emit(const TreatmentLoading());

    try {
      final result = await getAllTreatmentsUseCase(
        languageCode: event.languageCode,
      );

      emit(
        TreatmentsLoaded(
          treatments: result.data,
          isFromCache: result.isFromCache,
        ),
      );
    } catch (error) {
      emit(
        TreatmentFailure(
          message: ApiErrorHandler.handle(
            error,
            languageCode: event.languageCode,
          ),
        ),
      );
    }
  }

  Future<void> _onLoadTreatmentDetailsRequested(
      LoadTreatmentDetailsRequested event,
      Emitter<TreatmentState> emit,
      ) async {
    emit(const TreatmentLoading());

    try {
      final result = await getTreatmentDetailsUseCase(
        treatmentId: event.treatmentId,
        languageCode: event.languageCode,
      );

      emit(
        TreatmentDetailsLoaded(
          treatment: result.data,
          isFromCache: result.isFromCache,
        ),
      );
    } catch (error) {
      emit(
        TreatmentFailure(
          message: ApiErrorHandler.handle(
            error,
            languageCode: event.languageCode,
          ),
        ),
      );
    }
  }
}