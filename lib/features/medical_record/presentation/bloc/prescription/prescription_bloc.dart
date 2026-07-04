import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/prescription/get_all_prescriptions_use_case.dart';
import '../../../domain/usecases/prescription/get_prescription_details_use_case.dart';
import 'prescription_event.dart';
import 'prescription_state.dart';

class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
  final GetAllPrescriptionsUseCase getAllPrescriptionsUseCase;
  final GetPrescriptionDetailsUseCase getPrescriptionDetailsUseCase;

  PrescriptionBloc({
    required this.getAllPrescriptionsUseCase,
    required this.getPrescriptionDetailsUseCase,
  }) : super(const PrescriptionInitial()) {
    on<LoadPrescriptionsRequested>(_onLoadPrescriptionsRequested);
    on<LoadPrescriptionDetailsRequested>(
      _onLoadPrescriptionDetailsRequested,
    );
  }

  Future<void> _onLoadPrescriptionsRequested(
      LoadPrescriptionsRequested event,
      Emitter<PrescriptionState> emit,
      ) async {
    emit(const PrescriptionLoading());

    try {
      final result = await getAllPrescriptionsUseCase(
        languageCode: event.languageCode,
      );

      emit(
        PrescriptionsLoaded(
          prescriptions: result.data,
          isFromCache: result.isFromCache,
        ),
      );
    } catch (error) {
      emit(
        PrescriptionFailure(
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoadPrescriptionDetailsRequested(
      LoadPrescriptionDetailsRequested event,
      Emitter<PrescriptionState> emit,
      ) async {
    emit(const PrescriptionLoading());

    try {
      final result = await getPrescriptionDetailsUseCase(
        prescriptionId: event.prescriptionId,
        languageCode: event.languageCode,
      );

      emit(
        PrescriptionDetailsLoaded(
          prescription: result.data,
          isFromCache: result.isFromCache,
        ),
      );
    } catch (error) {
      emit(
        PrescriptionFailure(
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}