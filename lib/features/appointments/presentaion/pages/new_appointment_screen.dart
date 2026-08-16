import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../appointments_di.dart';
import '../../domain/entities/appointment_booking_dentist_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_type_entity.dart';
import '../bloc/appointment_booking/appointment_booking_bloc.dart';
import '../bloc/appointment_booking/appointment_booking_event.dart';
import '../bloc/appointment_booking/appointment_booking_state.dart';
import '../sections/appointment_booking_step_content.dart';
import '../widgets/booking_bottom_action.dart';
import '../widgets/booking_state_views.dart';
import '../widgets/booking_step_indicator.dart';

class NewAppointmentScreen extends StatelessWidget {
  const NewAppointmentScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) =>
      AppointmentsDi.createAppointmentBookingBloc()
        ..add(
          LoadAppointmentTypesRequested(
            languageCode: languageCode,
          ),
        ),
      child: const _NewAppointmentView(),
    );
  }
}

class _NewAppointmentView extends StatefulWidget {
  const _NewAppointmentView();

  @override
  State<_NewAppointmentView> createState() =>
      _NewAppointmentViewState();
}

class _NewAppointmentViewState
    extends State<_NewAppointmentView> {
  final TextEditingController _notesController =
  TextEditingController();

  int _currentStep = 0;
  bool _showOfflineBanner = true;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String get _languageCode {
    return Localizations.localeOf(
      context,
    ).languageCode;
  }

  String? get _normalizedNotes {
    final value = _notesController.text.trim();

    return value.isEmpty ? null : value;
  }

  void _reloadAppointmentTypes() {
    context.read<AppointmentBookingBloc>().add(
      LoadAppointmentTypesRequested(
        languageCode: _languageCode,
      ),
    );
  }

  void _selectBookingType(
      AppointmentBookingType bookingType,
      ) {
    context.read<AppointmentBookingBloc>().add(
      AppointmentBookingTypeSelected(
        bookingType: bookingType,
        languageCode: _languageCode,
      ),
    );

    if (_currentStep != 0) {
      setState(() {
        _currentStep = 0;
      });
    }
  }

  void _selectTreatment(
      int treatmentId,
      ) {
    context.read<AppointmentBookingBloc>().add(
      AppointmentTreatmentSelected(
        treatmentId: treatmentId,
      ),
    );
  }

  void _selectAppointmentType(
      AppointmentTypeEntity appointmentType,
      ) {
    context.read<AppointmentBookingBloc>().add(
      AppointmentTypeSelected(
        appointmentTypeId:
        appointmentType.id,
        languageCode:
        _languageCode,
      ),
    );
  }

  void _selectDentist(
      AppointmentBookingDentistEntity dentist,
      ) {
    context.read<AppointmentBookingBloc>().add(
      AppointmentDentistSelected(
        dentistId:
        dentist.id,
        languageCode:
        _languageCode,
      ),
    );
  }

  void _selectAppointmentSlot(
      DateTime appointmentTime,
      ) {
    context.read<AppointmentBookingBloc>().add(
      AppointmentSlotSelected(
        appointmentTime:
        appointmentTime,
      ),
    );
  }

  void _editStep(
      int step,
      ) {
    final currentState =
        context
            .read<AppointmentBookingBloc>()
            .state;

    if (currentState
    is! AppointmentBookingLoaded) {
      return;
    }

    final lastStep =
        _totalSteps(currentState) - 1;

    final safeStep = step.clamp(
      0,
      lastStep,
    );

    setState(() {
      _currentStep = safeStep;
    });
  }

  void _retryDentists() {
    final currentState =
        context
            .read<AppointmentBookingBloc>()
            .state;

    if (currentState
    is! AppointmentBookingLoaded) {
      return;
    }

    final appointmentType =
        currentState.selectedAppointmentType;

    if (appointmentType == null) {
      return;
    }

    _selectAppointmentType(
      appointmentType,
    );
  }

  void _retrySchedule() {
    final currentState =
        context
            .read<AppointmentBookingBloc>()
            .state;

    if (currentState
    is! AppointmentBookingLoaded) {
      return;
    }

    if (currentState
        .isContinueTreatmentBooking) {
      final appointmentType =
          currentState.selectedAppointmentType;

      if (appointmentType == null) {
        return;
      }

      // في متابعة العلاج الطبيب معروف مسبقاً
      // من العلاج، لذلك نعيد اختيار نوع
      // الموعد ليعيد الـBloc تحميل جدول
      // طبيب العلاج مباشرة.
      _selectAppointmentType(
        appointmentType,
      );

      return;
    }

    final dentist =
        currentState.selectedDentist;

    if (dentist == null) {
      return;
    }

    _selectDentist(
      dentist,
    );
  }

  int _totalSteps(
      AppointmentBookingLoaded state,
      ) {
    // Standard:
    // 0 booking type
    // 1 appointment type
    // 2 dentist
    // 3 schedule
    // 4 notes
    // 5 review
    //
    // Continue treatment:
    // 0 booking type
    // 1 treatment
    // 2 appointment type
    // 3 schedule
    // 4 notes
    // 5 review

    return 6;
  }

  bool _isLastStep(
      AppointmentBookingLoaded state,
      ) {
    return _currentStep ==
        _totalSteps(state) - 1;
  }

  bool _canContinue(
      AppointmentBookingLoaded state,
      ) {
    if (state.isContinueTreatmentBooking) {
      switch (_currentStep) {
        case 0:
          return state.hasSelectedBookingType &&
              !state.isLoadingBookableTreatments;

        case 1:
          return state.hasSelectedTreatment &&
              state.hasSelectedDentist &&
              !state.isLoadingBookableTreatments;

        case 2:
          return state.hasSelectedAppointmentType &&
              state.hasSelectedDentist &&
              !state.isLoadingDentistSchedule &&
              !state.hasDentistScheduleError &&
              state.hasDentistSchedule;

        case 3:
          return state.hasSelectedAppointmentTime;

        case 4:
        // Notes optional.
          return true;

        default:
        // Review.
          return false;
      }
    }

    switch (_currentStep) {
      case 0:
        return state.hasSelectedBookingType;

      case 1:
        return state.hasSelectedAppointmentType &&
            !state.isLoadingDentists &&
            !state.hasDentistsError;

      case 2:
        return state.hasSelectedDentist &&
            !state.isLoadingDentistSchedule &&
            !state.hasDentistScheduleError &&
            state.hasDentistSchedule;

      case 3:
        return state.hasSelectedAppointmentTime;

      case 4:
      // Notes optional.
        return true;

      default:
      // Review.
        return false;
    }
  }

  void _goBack() {
    if (_currentStep == 0) {
      context.pop();
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  void _goNext(
      AppointmentBookingLoaded state,
      ) {
    if (!_canContinue(state)) {
      return;
    }

    final lastStep =
        _totalSteps(state) - 1;

    if (_currentStep >= lastStep) {
      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  void _submitAppointment(
      AppointmentBookingLoaded state,
      ) {
    if (!state.canSubmit ||
        !_isLastStep(state)) {
      return;
    }

    context.read<AppointmentBookingBloc>().add(
      AddAppointmentRequested(
        notes:
        _normalizedNotes,
        languageCode:
        _languageCode,
      ),
    );
  }

  Future<void> _handleListener(
      BuildContext context,
      AppointmentBookingState state,
      ) async {
    if (state
    is! AppointmentBookingLoaded) {
      return;
    }

    if (state.isSubmissionSuccess &&
        state.submissionResult != null) {
      await showSuccessBottomSheet(
        context,
        title: context
            .l10n
            .appointmentBookingSuccessTitle,
        message: context
            .l10n
            .appointmentBookingSuccessMessage,
        buttonText:
        MaterialLocalizations.of(
          context,
        ).okButtonLabel,
        onPressed: () {
          if (context.canPop()) {
            context.pop(true);
          }
        },
      );

      return;
    }

    if (state.isSubmissionFailure &&
        state.submissionErrorMessage != null) {
      await showErrorBottomSheet(
        context,
        title: context
            .l10n
            .appointmentBookingFailedTitle,
        message:
        state.submissionErrorMessage!,
        buttonText:
        MaterialLocalizations.of(
          context,
        ).okButtonLabel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        context.colors;

    return Scaffold(
      backgroundColor:
      colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                0,
              ),
              child: AppTopBar(
                title: context
                    .l10n
                    .bookAppointmentTitle,
                onBackTap:
                _goBack,
              ),
            ),
            Expanded(
              child: BlocConsumer<
                  AppointmentBookingBloc,
                  AppointmentBookingState>(
                listener:
                _handleListener,
                builder:
                    (context, state) {
                  if (state
                  is AppointmentBookingInitial ||
                      state
                      is AppointmentBookingLoading) {
                    return const BookingSkeleton();
                  }

                  if (state
                  is AppointmentBookingEmpty) {
                    return BookingEmptyView(
                      onRetry:
                      _reloadAppointmentTypes,
                    );
                  }

                  if (state
                  is AppointmentBookingError) {
                    return BookingErrorView(
                      message:
                      state.message,
                      onRetry:
                      _reloadAppointmentTypes,
                    );
                  }

                  if (state
                  is AppointmentBookingLoaded) {
                    return _buildLoadedContent(
                      context,
                      state,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(
      BuildContext context,
      AppointmentBookingLoaded state,
      ) {
    final totalSteps =
    _totalSteps(state);

    final lastStep =
        totalSteps - 1;

    if (_currentStep > lastStep) {
      WidgetsBinding.instance
          .addPostFrameCallback(
            (_) {
          if (!mounted) {
            return;
          }

          setState(() {
            _currentStep =
                lastStep;
          });
        },
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            physics:
            const BouncingScrollPhysics(),
            padding:
            const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              24,
            ),
            children: [
              BookingStepIndicator(
                currentStep:
                _currentStep,
                totalSteps:
                totalSteps,
                isContinueTreatment:
                state
                    .isContinueTreatmentBooking,
              ),

              if (state.isFromCache &&
                  _showOfflineBanner) ...[
                const SizedBox(
                  height: 18,
                ),
                OfflineCachedBanner(
                  message: context
                      .l10n
                      .appointmentBookingOfflineMessage,
                  onClose: () {
                    setState(() {
                      _showOfflineBanner =
                      false;
                    });
                  },
                ),
              ],

              const SizedBox(
                height: 22,
              ),

              AppointmentBookingStepContent(
                state:
                state,
                currentStep:
                _currentStep,
                languageCode:
                _languageCode,
                notesController:
                _notesController,
                onBookingTypeSelected:
                _selectBookingType,
                onTreatmentSelected:
                _selectTreatment,
                onAppointmentTypeSelected:
                _selectAppointmentType,
                onDentistSelected:
                _selectDentist,
                onSlotSelected:
                _selectAppointmentSlot,
                onRetryDentists:
                _retryDentists,
                onRetrySchedule:
                _retrySchedule,
                onEditStep:
                _editStep,
              ),
            ],
          ),
        ),

        BookingBottomAction(
          isLastStep:
          _isLastStep(state),
          canContinue:
          _canContinue(state),
          canSubmit:
          state.canSubmit,
          isSubmitting:
          state.isSubmitting,
          onContinue: () {
            _goNext(
              state,
            );
          },
          onSubmit: () {
            _submitAppointment(
              state,
            );
          },
        ),
      ],
    );
  }
}