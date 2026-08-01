import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/apply_to_offer_use_case.dart';
import '../../domain/usecases/get_treatments_by_type_use_case.dart';
import '../../domain/usecases/show_offers_use_case.dart';
import 'offers_event.dart';
import 'offers_state.dart';

class OffersBloc
    extends Bloc<OffersEvent, OffersState> {
  final ShowOffersUseCase showOffersUseCase;

  final GetTreatmentsByTypeUseCase
  getTreatmentsByTypeUseCase;

  final ApplyToOfferUseCase applyToOfferUseCase;

  OffersBloc({
    required this.showOffersUseCase,
    required this.getTreatmentsByTypeUseCase,
    required this.applyToOfferUseCase,
  }) : super(const OffersState()) {
    on<LoadOffersRequested>(
      _onLoadOffersRequested,
    );

    on<LoadApplicableTreatmentsRequested>(
      _onLoadApplicableTreatmentsRequested,
    );

    on<SelectApplicableTreatmentRequested>(
      _onSelectApplicableTreatmentRequested,
    );

    on<ApplyToOfferRequested>(
      _onApplyToOfferRequested,
    );

    on<ResetOfferActionStateRequested>(
      _onResetOfferActionStateRequested,
    );
  }

  Future<void> _onLoadOffersRequested(
      LoadOffersRequested event,
      Emitter<OffersState> emit,
      ) async {
    emit(
      state.copyWith(
        offersStatus: OffersStatus.loading,
        clearOffersErrorMessage: true,
      ),
    );

    try {
      final result = await showOffersUseCase(
        languageCode: event.languageCode,
      );

      emit(
        state.copyWith(
          offersStatus: OffersStatus.success,
          offers: result.data,
          isFromCache: result.isFromCache,
          clearOffersErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          offersStatus: OffersStatus.failure,
          offersErrorMessage:
          error.toString(),
        ),
      );
    }
  }

  Future<void>
  _onLoadApplicableTreatmentsRequested(
      LoadApplicableTreatmentsRequested event,
      Emitter<OffersState> emit,
      ) async {
    emit(
      state.copyWith(
        actionStatus:
        OfferActionStatus.loadingTreatments,
        applicableTreatments: const [],
        selectedTreatmentTypeId:
        event.treatmentTypeId,
        clearSelectedTreatmentId: true,
        clearActionErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final treatments =
      await getTreatmentsByTypeUseCase(
        treatmentTypeId:
        event.treatmentTypeId,
        languageCode: event.languageCode,
      );

      emit(
        state.copyWith(
          actionStatus:
          OfferActionStatus.treatmentsLoaded,
          applicableTreatments: treatments,
          clearActionErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus:
          OfferActionStatus.failure,
          applicableTreatments: const [],
          clearSelectedTreatmentId: true,
          actionErrorMessage:
          error.toString(),
        ),
      );
    }
  }

  void _onSelectApplicableTreatmentRequested(
      SelectApplicableTreatmentRequested event,
      Emitter<OffersState> emit,
      ) {
    emit(
      state.copyWith(
        selectedTreatmentId:
        event.treatmentId,
        clearActionErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );
  }

  Future<void> _onApplyToOfferRequested(
      ApplyToOfferRequested event,
      Emitter<OffersState> emit,
      ) async {
    emit(
      state.copyWith(
        actionStatus:
        OfferActionStatus.applying,
        clearActionErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final message =
      await applyToOfferUseCase(
        offerId: event.offerId,
        treatmentId: event.treatmentId,
        languageCode: event.languageCode,
      );

      emit(
        state.copyWith(
          actionStatus:
          OfferActionStatus.applySuccess,
          successMessage: message,
          clearActionErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus:
          OfferActionStatus.failure,
          actionErrorMessage:
          error.toString(),
        ),
      );
    }
  }

  void _onResetOfferActionStateRequested(
      ResetOfferActionStateRequested event,
      Emitter<OffersState> emit,
      ) {
    emit(
      state.copyWith(
        actionStatus:
        OfferActionStatus.initial,
        applicableTreatments: const [],
        clearSelectedTreatmentTypeId: true,
        clearSelectedTreatmentId: true,
        clearActionErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );
  }
}