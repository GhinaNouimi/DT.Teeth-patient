import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/usecases/cancel_appointment_use_case.dart';
import '../../../domain/usecases/show_appointments_use_case.dart';
import '../../../domain/usecases/show_previous_appointments_use_case.dart';
import 'appointments_event.dart';
import 'appointments_state.dart';

class AppointmentsBloc
    extends Bloc<AppointmentsEvent, AppointmentsState> {
  final ShowAppointmentsUseCase showAppointmentsUseCase;
  final ShowPreviousAppointmentsUseCase
  showPreviousAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;

  AppointmentsBloc({
    required this.showAppointmentsUseCase,
    required this.showPreviousAppointmentsUseCase,
    required this.cancelAppointmentUseCase,
  }) : super(const AppointmentsInitial()) {
    on<LoadAppointmentsRequested>(
      _onLoadAppointmentsRequested,
    );

    on<RefreshAppointmentsRequested>(
      _onRefreshAppointmentsRequested,
    );

    on<CancelAppointmentRequested>(
      _onCancelAppointmentRequested,
    );
  }

  Future<void> _onLoadAppointmentsRequested(
      LoadAppointmentsRequested event,
      Emitter<AppointmentsState> emit,
      ) async {
    emit(const AppointmentsLoading());

    try {
      final result = await _fetchAppointments(
        languageCode: event.languageCode,
      );

      emit(
        AppointmentsLoaded(
          upcomingAppointments:
          result.upcomingAppointments,
          pastAppointments: result.pastAppointments,
          isUpcomingFromCache:
          result.isUpcomingFromCache,
          isPastFromCache: result.isPastFromCache,
        ),
      );
    } catch (error) {
      emit(
        AppointmentsError(
          message: _errorMessage(error),
        ),
      );
    }
  }

  Future<void> _onRefreshAppointmentsRequested(
      RefreshAppointmentsRequested event,
      Emitter<AppointmentsState> emit,
      ) async {
    final currentState = state;

    try {
      final result = await _fetchAppointments(
        languageCode: event.languageCode,
      );

      emit(
        AppointmentsLoaded(
          upcomingAppointments:
          result.upcomingAppointments,
          pastAppointments: result.pastAppointments,
          isUpcomingFromCache:
          result.isUpcomingFromCache,
          isPastFromCache: result.isPastFromCache,
        ),
      );
    } catch (error) {
      if (currentState is AppointmentsLoaded) {
        emit(
          AppointmentsRefreshFailure(
            upcomingAppointments:
            currentState.upcomingAppointments,
            pastAppointments:
            currentState.pastAppointments,
            isUpcomingFromCache:
            currentState.isUpcomingFromCache,
            isPastFromCache:
            currentState.isPastFromCache,
            message: _errorMessage(error),
          ),
        );
        return;
      }

      emit(
        AppointmentsError(
          message: _errorMessage(error),
        ),
      );
    }
  }

  Future<void> _onCancelAppointmentRequested(
      CancelAppointmentRequested event,
      Emitter<AppointmentsState> emit,
      ) async {
    final currentState = state;

    if (currentState is! AppointmentsLoaded) {
      return;
    }

    if (currentState.cancellingAppointmentId != null) {
      return;
    }

    emit(
      currentState.copyWith(
        cancellingAppointmentId:
        event.appointmentId,
      ),
    );

    try {
      final successMessage =
      await cancelAppointmentUseCase(
        appointmentId: event.appointmentId,
        languageCode: event.languageCode,
      );

      /*
       * الإلغاء نجح بالفعل.
       * نحاول بعدها تحديث القوائم من المصدر.
       */
      try {
        final result = await _fetchAppointments(
          languageCode: event.languageCode,
        );

        emit(
          AppointmentCancellationSuccess(
            upcomingAppointments:
            result.upcomingAppointments,
            pastAppointments:
            result.pastAppointments,
            isUpcomingFromCache:
            result.isUpcomingFromCache,
            isPastFromCache:
            result.isPastFromCache,
            message: successMessage,
          ),
        );
      } catch (_) {
        /*
         * لا نعتبر الإلغاء فاشلًا إذا فشلت فقط
         * إعادة تحميل القوائم بعد نجاح الطلب.
         *
         * نحذف الموعد محليًا من قائمة المواعيد القادمة
         * إلى أن يتم التحديث مرة أخرى.
         */
        final updatedUpcoming =
        currentState.upcomingAppointments
            .where(
              (appointment) =>
          appointment.id !=
              event.appointmentId,
        )
            .toList();

        emit(
          AppointmentCancellationSuccess(
            upcomingAppointments:
            updatedUpcoming,
            pastAppointments:
            currentState.pastAppointments,
            isUpcomingFromCache:
            currentState.isUpcomingFromCache,
            isPastFromCache:
            currentState.isPastFromCache,
            message: successMessage,
          ),
        );
      }
    } catch (error) {
      emit(
        AppointmentCancellationFailure(
          upcomingAppointments:
          currentState.upcomingAppointments,
          pastAppointments:
          currentState.pastAppointments,
          isUpcomingFromCache:
          currentState.isUpcomingFromCache,
          isPastFromCache:
          currentState.isPastFromCache,
          message: _errorMessage(error),
        ),
      );
    }
  }

  Future<_AppointmentsFetchResult> _fetchAppointments({
    required String languageCode,
  }) async {
    final upcomingResult =
    await showAppointmentsUseCase(
      languageCode: languageCode,
    );

    final pastResult =
    await showPreviousAppointmentsUseCase(
      languageCode: languageCode,
    );

    return _AppointmentsFetchResult(
      upcomingAppointments:
      upcomingResult.data,
      pastAppointments: pastResult.data,
      isUpcomingFromCache:
      upcomingResult.isFromCache,
      isPastFromCache:
      pastResult.isFromCache,
    );
  }

  String _errorMessage(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();
  }
}

class _AppointmentsFetchResult {
  final List<AppointmentEntity> upcomingAppointments;
  final List<AppointmentEntity> pastAppointments;

  final bool isUpcomingFromCache;
  final bool isPastFromCache;

  const _AppointmentsFetchResult({
    required this.upcomingAppointments,
    required this.pastAppointments,
    required this.isUpcomingFromCache,
    required this.isPastFromCache,
  });
}