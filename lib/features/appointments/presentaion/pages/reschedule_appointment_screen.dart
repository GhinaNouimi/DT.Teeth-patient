import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../appointments_di.dart';
import '../bloc/appointment_edit/appointment_edit_bloc.dart';
import '../bloc/appointment_edit/appointment_edit_event.dart';
import '../bloc/appointment_edit/appointment_edit_state.dart';
import '../widgets/appointment_edit/appointment_edit_review_sheet.dart';
import '../widgets/appointment_edit/current_appointment_card.dart';
import '../widgets/appointment_notes_field.dart';
import '../widgets/booking_state_views.dart';
import '../widgets/schedule_selector_widget.dart';

class RescheduleAppointmentScreen
    extends StatelessWidget {
  final int appointmentId;

  const RescheduleAppointmentScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(
          context,
        ).languageCode;

    return BlocProvider(
      create: (_) =>
      AppointmentsDi.createAppointmentEditBloc()
        ..add(
          LoadAppointmentEditRequested(
            appointmentId:
            appointmentId,
            languageCode:
            languageCode,
          ),
        ),
      child: _RescheduleAppointmentView(
        appointmentId:
        appointmentId,
      ),
    );
  }
}

class _RescheduleAppointmentView
    extends StatefulWidget {
  final int appointmentId;

  const _RescheduleAppointmentView({
    required this.appointmentId,
  });

  @override
  State<_RescheduleAppointmentView>
  createState() =>
      _RescheduleAppointmentViewState();
}

class _RescheduleAppointmentViewState
    extends State<_RescheduleAppointmentView> {
  final TextEditingController
  _notesController =
  TextEditingController();

  bool _didInitializeNotes = false;
  bool _showOfflineBanner = true;

  String get _languageCode {
    return Localizations.localeOf(
      context,
    ).languageCode;
  }

  String? get _normalizedNotes {
    final value =
    _notesController.text.trim();

    if (value.isEmpty) {
      return null;
    }

    return value;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _reload() {
    _didInitializeNotes = false;
    _showOfflineBanner = true;

    context
        .read<AppointmentEditBloc>()
        .add(
      LoadAppointmentEditRequested(
        appointmentId:
        widget.appointmentId,
        languageCode:
        _languageCode,
      ),
    );
  }

  void _selectSlot(
      DateTime appointmentTime,
      ) {
    context
        .read<AppointmentEditBloc>()
        .add(
      AppointmentEditSlotSelected(
        appointmentTime:
        appointmentTime,
      ),
    );
  }

  bool _isSameAppointmentTime(
      DateTime first,
      DateTime second,
      ) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day &&
        first.hour == second.hour &&
        first.minute == second.minute;
  }

  bool _canReview(
      AppointmentEditLoaded state,
      ) {
    final selectedTime =
        state.selectedAppointmentTime;

    if (selectedTime == null) {
      return false;
    }

    if (state.isFromCache ||
        state.isSubmitting) {
      return false;
    }

    if (_isSameAppointmentTime(
      selectedTime,
      state.appointment.appointmentTime,
    )) {
      return false;
    }

    return state.canSubmit;
  }

  Future<void> _openReview(
      AppointmentEditLoaded state,
      ) async {
    final selectedTime =
        state.selectedAppointmentTime;

    if (selectedTime == null ||
        !_canReview(state)) {
      return;
    }

    await AppointmentEditReviewSheet.show(
      context,
      appointment:
      state.appointment,
      newAppointmentTime:
      selectedTime,
      notes:
      _normalizedNotes,
      languageCode:
      _languageCode,
      onConfirm: () {
        if (!mounted) {
          return;
        }

        final currentState =
            context
                .read<AppointmentEditBloc>()
                .state;

        if (currentState
        is! AppointmentEditLoaded ||
            !_canReview(
              currentState,
            )) {
          return;
        }

        context
            .read<AppointmentEditBloc>()
            .add(
          SubmitAppointmentEditRequested(
            notes:
            _normalizedNotes,
            languageCode:
            _languageCode,
          ),
        );
      },
    );
  }

  Future<void> _handleListener(
      BuildContext context,
      AppointmentEditState state,
      ) async {
    if (state
    is! AppointmentEditLoaded) {
      return;
    }

    if (state.isSubmissionSuccess &&
        state.submissionResult != null) {
      await showSuccessBottomSheet(
        context,
        title: context
            .l10n
            .appointmentEditSuccessTitle,
        message: context
            .l10n
            .appointmentEditSuccessMessage,
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
            .appointmentEditFailedTitle,
        message:
        state.submissionErrorMessage!,
        buttonText:
        MaterialLocalizations.of(
          context,
        ).okButtonLabel,
      );
    }
  }

  void _initializeNotes(
      AppointmentEditLoaded state,
      ) {
    if (_didInitializeNotes) {
      return;
    }

    _didInitializeNotes = true;

    _notesController.text =
        state.appointment.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        context.colors;

    final isSubmitting =
    context.select<
        AppointmentEditBloc,
        bool>(
          (bloc) {
        final state =
            bloc.state;

        return state
        is AppointmentEditLoaded &&
            state.isSubmitting;
      },
    );

    return PopScope(
      canPop:
      !isSubmitting,
      child: Scaffold(
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
                      .editAppointmentTitle,
                  onBackTap: () {
                    if (isSubmitting) {
                      return;
                    }

                    context.pop();
                  },
                ),
              ),

              Expanded(
                child: BlocConsumer<
                    AppointmentEditBloc,
                    AppointmentEditState>(
                  listener:
                  _handleListener,
                  builder:
                      (context, state) {
                    if (state
                    is AppointmentEditInitial ||
                        state
                        is AppointmentEditLoading) {
                      return const BookingSkeleton();
                    }

                    if (state
                    is AppointmentEditError) {
                      return BookingErrorView(
                        message:
                        state.message,
                        onRetry:
                        _reload,
                      );
                    }

                    if (state
                    is AppointmentEditEmpty) {
                      return BookingEmptyView(
                        onRetry:
                        _reload,
                      );
                    }

                    if (state
                    is AppointmentEditLoaded) {
                      _initializeNotes(
                        state,
                      );

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
      ),
    );
  }

  Widget _buildLoadedContent(
      BuildContext context,
      AppointmentEditLoaded state,
      ) {
    final colors =
        context.colors;

    final theme =
    Theme.of(context);

    final canReview =
    _canReview(state);

    final actionColor =
    theme.brightness ==
        Brightness.dark
        ? AppColors.darkPrimaryPurple
        : AppColors.midnightNavy;

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
              16,
            ),
            children: [
              if (state.isFromCache &&
                  _showOfflineBanner) ...[
                OfflineCachedBanner(
                  message: context
                      .l10n
                      .offlineAppointmentEditUnavailable,
                  onClose: () {
                    setState(() {
                      _showOfflineBanner =
                      false;
                    });
                  },
                ),

                const SizedBox(
                  height: 16,
                ),
              ],

              CurrentAppointmentCard(
                appointment:
                state.appointment,
                languageCode:
                _languageCode,
              ),

              const SizedBox(
                height: 24,
              ),

              //
              // لا نعيد هنا:
              // "اختر موعداً جديداً"
              // لأن ScheduleSelectorWidget
              // يحتوي عنوان الاختيار ووصفه.
              //
              ScheduleSelectorWidget(
                schedule:
                state.dentistSchedule,
                selectedAppointmentTime:
                state
                    .selectedAppointmentTime,
                onSlotSelected:
                _selectSlot,
                languageCode:
                _languageCode,
              ),

              const SizedBox(
                height: 26,
              ),

              Divider(
                color:
                colors.borderSoft,
                height: 1,
              ),

              const SizedBox(
                height: 22,
              ),

              AppointmentNotesField(
                controller:
                _notesController,
              ),

              const SizedBox(
                height: 22,
              ),

              Container(
                width:
                double.infinity,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration:
                BoxDecoration(
                  color:
                  colors.surfaceMuted,
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                  border:
                  Border.all(
                    color:
                    colors.borderSoft,
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration:
                      BoxDecoration(
                        color: actionColor
                            .withValues(
                          alpha: 0.08,
                        ),
                        borderRadius:
                        BorderRadius.circular(
                          11,
                        ),
                      ),
                      child: Icon(
                        Icons
                            .info_outline_rounded,
                        color:
                        actionColor,
                        size: 20,
                      ),
                    ),

                    const SizedBox(
                      width: 11,
                    ),

                    Expanded(
                      child: Text(
                        context
                            .l10n
                            .appointmentEditPendingNotice,
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color:
                          colors
                              .textSecondary,
                          height: 1.5,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SafeArea(
          top: false,
          child: Container(
            width:
            double.infinity,
            padding:
            const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              16,
            ),
            decoration:
            BoxDecoration(
              color:
              colors.background,
              border:
              Border(
                top:
                BorderSide(
                  color:
                  colors.borderSoft,
                ),
              ),
            ),
            child:
            ElevatedButton(
              onPressed:
              canReview
                  ? () {
                _openReview(
                  state,
                );
              }
                  : null,
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                actionColor,
                foregroundColor:
                AppColors.white,
                disabledBackgroundColor:
                actionColor.withValues(
                  alpha: 0.30,
                ),
                disabledForegroundColor:
                AppColors.white.withValues(
                  alpha: 0.80,
                ),
                elevation:
                0,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
              ),
              child:
              state.isSubmitting
                  ? const SizedBox(
                width: 22,
                height: 22,
                child:
                CircularProgressIndicator(
                  strokeWidth:
                  2.3,
                  valueColor:
                  AlwaysStoppedAnimation<
                      Color>(
                    AppColors.white,
                  ),
                ),
              )
                  : Text(
                context
                    .l10n
                    .reviewAppointmentEditButton,
                style: theme
                    .textTheme
                    .titleSmall
                    ?.copyWith(
                  color:
                  AppColors.white,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}