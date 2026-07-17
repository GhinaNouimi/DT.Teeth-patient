import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/usecases/cancel_appointment_use_case.dart';
import '../../../domain/usecases/show_appointment_details_use_case.dart';
import 'appointment_details_event.dart';
import 'appointment_details_state.dart';

class AppointmentDetailsBloc extends Bloc<
    AppointmentDetailsEvent,
    AppointmentDetailsState> {
  final ShowAppointmentDetailsUseCase
  showAppointmentDetailsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;

  AppointmentDetailsBloc({
    required this.showAppointmentDetailsUseCase,
    required this.cancelAppointmentUseCase,
  }) : super(const AppointmentDetailsInitial()) {
    on<LoadAppointmentDetailsRequested>(
      _onLoadAppointmentDetailsRequested,
    );

    on<CancelAppointmentFromDetailsRequested>(
      _onCancelAppointmentFromDetailsRequested,
    );
  }

  Future<void> _onLoadAppointmentDetailsRequested(
      LoadAppointmentDetailsRequested event,
      Emitter<AppointmentDetailsState> emit,
      ) async {
    emit(const AppointmentDetailsLoading());

    try {
      final result = await showAppointmentDetailsUseCase(
        appointmentId: event.appointmentId,
        languageCode: event.languageCode,
      );

      emit(
        AppointmentDetailsLoaded(
          appointment: result.data,
          isFromCache: result.isFromCache,
        ),
      );
    } catch (error) {
      emit(
        AppointmentDetailsError(
          message: _errorMessage(error),
        ),
      );
    }
  }

  Future<void> _onCancelAppointmentFromDetailsRequested(
      CancelAppointmentFromDetailsRequested event,
      Emitter<AppointmentDetailsState> emit,
      ) async {
    final currentData = _getCurrentAppointmentData();

    if (currentData == null) {
      return;
    }

    emit(
      AppointmentDetailsCancellationInProgress(
        appointment: currentData.appointment,
        isFromCache: currentData.isFromCache,
      ),
    );

    try {
      final message = await cancelAppointmentUseCase(
        appointmentId: event.appointmentId,
        languageCode: event.languageCode,
      );

      final refreshedResult =
      await showAppointmentDetailsUseCase(
        appointmentId: event.appointmentId,
        languageCode: event.languageCode,
      );

      emit(
        AppointmentDetailsCancellationSuccess(
          appointment: refreshedResult.data,
          isFromCache: refreshedResult.isFromCache,
          message: message,
        ),
      );
    } catch (error) {
      emit(
        AppointmentDetailsCancellationFailure(
          appointment: currentData.appointment,
          isFromCache: currentData.isFromCache,
          message: _errorMessage(error),
        ),
      );
    }
  }

  _AppointmentDetailsData? _getCurrentAppointmentData() {
    final currentState = state;

    if (currentState is AppointmentDetailsLoaded) {
      return _AppointmentDetailsData(
        appointment: currentState.appointment,
        isFromCache: currentState.isFromCache,
      );
    }

    if (currentState
    is AppointmentDetailsCancellationInProgress) {
      return _AppointmentDetailsData(
        appointment: currentState.appointment,
        isFromCache: currentState.isFromCache,
      );
    }

    if (currentState
    is AppointmentDetailsCancellationSuccess) {
      return _AppointmentDetailsData(
        appointment: currentState.appointment,
        isFromCache: currentState.isFromCache,
      );
    }

    if (currentState
    is AppointmentDetailsCancellationFailure) {
      return _AppointmentDetailsData(
        appointment: currentState.appointment,
        isFromCache: currentState.isFromCache,
      );
    }

    return null;
  }

  String _errorMessage(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();
  }
}

class _AppointmentDetailsData {
  final AppointmentEntity appointment;
  final bool isFromCache;

  const _AppointmentDetailsData({
    required this.appointment,
    required this.isFromCache,
  });
}