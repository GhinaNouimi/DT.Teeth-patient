import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../bloc/appointment_booking/appointment_booking_state.dart';
import '../widgets/booking_offline_write_message.dart';
import '../widgets/schedule_selector_widget.dart';

class AppointmentBookingScheduleSection
    extends StatelessWidget {
  final AppointmentBookingLoaded state;
  final String languageCode;
  final ValueChanged<DateTime> onSlotSelected;
  final VoidCallback onRetrySchedule;

  const AppointmentBookingScheduleSection({
    super.key,
    required this.state,
    required this.languageCode,
    required this.onSlotSelected,
    required this.onRetrySchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScheduleSelectorWidget(
          schedule: state.dentistSchedule,
          selectedAppointmentTime:
          state.selectedAppointmentTime,
          onSlotSelected: onSlotSelected,
          languageCode: languageCode,
          isLoading:
          state.isLoadingDentistSchedule,
          errorMessage:
          state.dentistScheduleErrorMessage,
          onRetry: onRetrySchedule,
        ),
        if (state.isFromCache) ...[
          const SizedBox(height: 14),
          BookingOfflineWriteMessage(
            message: context.l10n
                .offlineBookingUnavailableMessage,
          ),
        ],
      ],
    );
  }
}