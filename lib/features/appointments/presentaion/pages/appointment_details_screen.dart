import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../appointments_di.dart';
import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment_details/appointment_details_bloc.dart';
import '../bloc/appointment_details/appointment_details_event.dart';
import '../bloc/appointment_details/appointment_details_state.dart';
import '../dialogs/cancel_appointment_dialog.dart';
import '../widgets/appointment_details/appointment_details_content.dart';
import '../widgets/appointment_details/appointment_details_error_view.dart';
import '../widgets/appointment_details/appointment_details_skeleton.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final int appointmentId;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => AppointmentDetailsBloc(
        showAppointmentDetailsUseCase:
        AppointmentsDi.showAppointmentDetailsUseCase,
        cancelAppointmentUseCase:
        AppointmentsDi.cancelAppointmentUseCase,
      )..add(
        LoadAppointmentDetailsRequested(
          appointmentId: appointmentId,
          languageCode: languageCode,
        ),
      ),
      child: _AppointmentDetailsView(
        appointmentId: appointmentId,
      ),
    );
  }
}

class _AppointmentDetailsView extends StatefulWidget {
  final int appointmentId;

  const _AppointmentDetailsView({
    required this.appointmentId,
  });

  @override
  State<_AppointmentDetailsView> createState() =>
      _AppointmentDetailsViewState();
}

class _AppointmentDetailsViewState
    extends State<_AppointmentDetailsView> {
  bool _showOfflineBanner = true;

  void _reloadAppointment() {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    context.read<AppointmentDetailsBloc>().add(
      LoadAppointmentDetailsRequested(
        appointmentId: widget.appointmentId,
        languageCode: languageCode,
      ),
    );
  }

  Future<void> _refreshAppointment() async {
    _reloadAppointment();

    await context
        .read<AppointmentDetailsBloc>()
        .stream
        .firstWhere(
          (state) =>
      state is AppointmentDetailsLoaded ||
          state is AppointmentDetailsError,
    );
  }

  Future<void> _confirmCancellation(
      AppointmentEntity appointment,
      ) async {
    final shouldCancel =
    await CancelAppointmentDialog.show(context);

    if (!shouldCancel || !mounted) {
      return;
    }

    final languageCode =
        Localizations.localeOf(context).languageCode;

    context.read<AppointmentDetailsBloc>().add(
      CancelAppointmentFromDetailsRequested(
        appointmentId: appointment.id,
        languageCode: languageCode,
      ),
    );
  }

  Future<void> _handleStateListener(
      BuildContext context,
      AppointmentDetailsState state,
      ) async {
    final l10n = context.l10n;
    final buttonText =
        MaterialLocalizations.of(context).okButtonLabel;

    if (state
    is AppointmentDetailsCancellationSuccess) {
      await showSuccessBottomSheet(
        context,
        title: l10n.appointmentCancelledTitle,
        message: state.message,
        buttonText: buttonText,
        onPressed: () {
          if (context.canPop()) {
            context.pop(true);
          }
        },
      );

      return;
    }

    if (state
    is AppointmentDetailsCancellationFailure) {
      await showErrorBottomSheet(
        context,
        title:
        l10n.appointmentCancellationFailedTitle,
        message: state.message,
        buttonText: buttonText,
      );

      return;
    }

    if (state is AppointmentDetailsError) {
      await showErrorBottomSheet(
        context,
        title:
        l10n.appointmentDetailsLoadFailedTitle,
        message: state.message,
        buttonText: l10n.retryButton,
        onPressed: _reloadAppointment,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                0,
              ),
              child: AppTopBar(
                title:
                context.l10n.appointmentDetailsTitle,
                onBackTap: () => context.pop(),
              ),
            ),
            Expanded(
              child: BlocConsumer<
                  AppointmentDetailsBloc,
                  AppointmentDetailsState>(
                listener: _handleStateListener,
                builder: (context, state) {
                  if (state
                  is AppointmentDetailsInitial ||
                      state
                      is AppointmentDetailsLoading) {
                    return const AppointmentDetailsSkeleton();
                  }

                  final detailsData =
                  _extractDetailsData(state);

                  if (detailsData != null) {
                    return AppointmentDetailsContent(
                      appointment:
                      detailsData.appointment,
                      isFromCache:
                      detailsData.isFromCache,
                      isCancelling:
                      detailsData.isCancelling,
                      showOfflineBanner:
                      _showOfflineBanner,
                      onCloseOfflineBanner: () {
                        setState(() {
                          _showOfflineBanner = false;
                        });
                      },
                      onRefresh: _refreshAppointment,
                      onCancelAppointment:
                      _confirmCancellation,
                    );
                  }

                  if (state
                  is AppointmentDetailsError) {
                    return AppointmentDetailsErrorView(
                      message: state.message,
                      onRetry: _reloadAppointment,
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

  _AppointmentDetailsUiData? _extractDetailsData(
      AppointmentDetailsState state,
      ) {
    if (state is AppointmentDetailsLoaded) {
      return _AppointmentDetailsUiData(
        appointment: state.appointment,
        isFromCache: state.isFromCache,
        isCancelling: false,
      );
    }

    if (state
    is AppointmentDetailsCancellationInProgress) {
      return _AppointmentDetailsUiData(
        appointment: state.appointment,
        isFromCache: state.isFromCache,
        isCancelling: true,
      );
    }

    if (state
    is AppointmentDetailsCancellationSuccess) {
      return _AppointmentDetailsUiData(
        appointment: state.appointment,
        isFromCache: state.isFromCache,
        isCancelling: false,
      );
    }

    if (state
    is AppointmentDetailsCancellationFailure) {
      return _AppointmentDetailsUiData(
        appointment: state.appointment,
        isFromCache: state.isFromCache,
        isCancelling: false,
      );
    }

    return null;
  }
}

class _AppointmentDetailsUiData {
  final AppointmentEntity appointment;
  final bool isFromCache;
  final bool isCancelling;

  const _AppointmentDetailsUiData({
    required this.appointment,
    required this.isFromCache,
    required this.isCancelling,
  });
}