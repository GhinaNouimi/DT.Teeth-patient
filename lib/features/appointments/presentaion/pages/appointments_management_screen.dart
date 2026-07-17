import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../bloc/appointments/appointments_bloc.dart';
import '../bloc/appointments/appointments_event.dart';
import '../bloc/appointments/appointments_state.dart';
import '../sections/appointments_list_section.dart';
import '../sections/appointments_tab_section.dart';
import '../widgets/appointments_empty_state_widget.dart';
import '../widgets/appointments_list_skeleton.dart';

class AppointmentsManagementScreen extends StatefulWidget {
  const AppointmentsManagementScreen({
    super.key,
  });

  @override
  State<AppointmentsManagementScreen> createState() =>
      _AppointmentsManagementScreenState();
}

class _AppointmentsManagementScreenState
    extends State<AppointmentsManagementScreen> {
  int _currentTabIndex = 0;
  bool _showOfflineBanner = true;

  Future<void> _refreshAppointments() async {
    final bloc = context.read<AppointmentsBloc>();

    final languageCode =
        Localizations.localeOf(context).languageCode;

    bloc.add(
      RefreshAppointmentsRequested(
        languageCode: languageCode,
      ),
    );

    await bloc.stream.firstWhere(
          (state) =>
      state is AppointmentsLoaded ||
          state is AppointmentsError,
    );
  }

  void _retryLoading() {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    context.read<AppointmentsBloc>().add(
      LoadAppointmentsRequested(
        languageCode: languageCode,
      ),
    );
  }

  void _handleStateListener(
      BuildContext context,
      AppointmentsState state,
      ) {
    final l10n = context.l10n;

    final buttonText =
        MaterialLocalizations.of(context).okButtonLabel;

    if (state is AppointmentCancellationSuccess) {
      showSuccessBottomSheet(
        context,
        title:
        l10n.appointmentsCancellationSuccessTitle,
        message: state.message,
        buttonText: buttonText,
      );

      return;
    }

    if (state is AppointmentCancellationFailure) {
      showErrorBottomSheet(
        context,
        title: l10n.appointmentsOperationFailedTitle,
        message: state.message,
        buttonText: buttonText,
      );

      return;
    }

    if (state is AppointmentsRefreshFailure) {
      showErrorBottomSheet(
        context,
        title: l10n.appointmentsRefreshFailedTitle,
        message: state.message,
        buttonText: buttonText,
      );

      return;
    }

    if (state is AppointmentsError) {
      showErrorBottomSheet(
        context,
        title: l10n.appointmentsOperationFailedTitle,
        message: state.message,
        buttonText: buttonText,
        onPressed: _retryLoading,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<
            AppointmentsBloc,
            AppointmentsState>(
          listener: _handleStateListener,
          builder: (context, state) {
            if (state is AppointmentsInitial ||
                state is AppointmentsLoading) {
              return const AppointmentsListSkeleton();
            }

            if (state is AppointmentsLoaded) {
              return _buildLoadedContent(
                context,
                state,
              );
            }

            return _buildErrorContent(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoadedContent(
      BuildContext context,
      AppointmentsLoaded state,
      ) {
    final l10n = context.l10n;

    final upcomingAppointments =
        state.upcomingAppointments;

    final pastAppointments =
        state.pastAppointments;

    final isUpcomingTab =
        _currentTabIndex == 0;

    final displayedAppointments =
    isUpcomingTab
        ? upcomingAppointments
        : pastAppointments;

    final isCurrentTabFromCache =
    isUpcomingTab
        ? state.isUpcomingFromCache
        : state.isPastFromCache;

    return RefreshIndicator(
      onRefresh: _refreshAppointments,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          20,
          3,
          20,
          120,
        ),
        children: [
          const SizedBox(height: 20),

          AppointmentsTabSection(
            upcomingCount:
            upcomingAppointments.length,
            pastCount:
            pastAppointments.length,
            currentTabIndex:
            _currentTabIndex,
            onTabChanged: (index) {
              if (_currentTabIndex == index) {
                return;
              }

              setState(() {
                _currentTabIndex = index;
                _showOfflineBanner = true;
              });
            },
          ),

          if (isCurrentTabFromCache &&
              _showOfflineBanner) ...[
            const SizedBox(height: 16),

            OfflineCachedBanner(
              message:
              l10n.appointmentsOfflineCachedMessage,
              onClose: () {
                setState(() {
                  _showOfflineBanner = false;
                });
              },
            ),
          ],

          const SizedBox(height: 20),

          if (displayedAppointments.isEmpty)
            AppointmentsEmptyStateWidget(
              isUpcoming: isUpcomingTab,
            )
          else
            AppointmentsListSection(
              appointments:
              displayedAppointments,
              cancellingAppointmentId:
              state.cancellingAppointmentId,
            ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(
      BuildContext context,
      ) {
    return RefreshIndicator(
      onRefresh: _refreshAppointments,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          120,
        ),
        children: [
          AppointmentsEmptyStateWidget(
            isUpcoming:
            _currentTabIndex == 0,
          ),
        ],
      ),
    );
  }
}