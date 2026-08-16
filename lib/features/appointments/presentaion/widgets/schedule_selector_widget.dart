import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/dentist_schedule_entity.dart';

class ScheduleSelectorWidget extends StatefulWidget {
  final DentistScheduleEntity? schedule;
  final DateTime? selectedAppointmentTime;
  final ValueChanged<DateTime> onSlotSelected;

  final String languageCode;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ScheduleSelectorWidget({
    super.key,
    required this.schedule,
    required this.selectedAppointmentTime,
    required this.onSlotSelected,
    required this.languageCode,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<ScheduleSelectorWidget> createState() =>
      _ScheduleSelectorWidgetState();
}

class _ScheduleSelectorWidgetState
    extends State<ScheduleSelectorWidget> {
  DateTime? _selectedDay;

  List<DentistScheduleDayEntity> get _availableDays {
    final days = widget.schedule?.days
        .where(
          (day) => day.hasSlots,
    )
        .toList() ??
        <DentistScheduleDayEntity>[];

    days.sort(
          (first, second) =>
          first.date.compareTo(second.date),
    );

    return days;
  }

  @override
  void initState() {
    super.initState();
    _syncSelectedDay();
  }

  @override
  void didUpdateWidget(
      covariant ScheduleSelectorWidget oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    final scheduleChanged =
        oldWidget.schedule != widget.schedule;

    final selectedTimeChanged =
        oldWidget.selectedAppointmentTime !=
            widget.selectedAppointmentTime;

    if (scheduleChanged ||
        selectedTimeChanged) {
      _syncSelectedDay();
    }
  }

  void _syncSelectedDay() {
    final days = _availableDays;

    if (days.isEmpty) {
      _selectedDay = null;
      return;
    }

    final selectedAppointmentTime =
        widget.selectedAppointmentTime;

    if (selectedAppointmentTime != null) {
      final matchingDay = _findScheduleDay(
        selectedAppointmentTime,
      );

      if (matchingDay != null) {
        _selectedDay = matchingDay.date;
        return;
      }
    }

    if (_selectedDay != null) {
      final stillAvailable = days.any(
            (day) => _isSameDate(
          day.date,
          _selectedDay!,
        ),
      );

      if (stillAvailable) {
        return;
      }
    }

    _selectedDay = days.first.date;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectAppointmentTimeTitle,
          style:
          theme.textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.selectAppointmentTimeDescription,
          style:
          theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 18),

        if (widget.isLoading)
          const _ScheduleLoadingView()
        else if (_hasError)
          _ScheduleErrorView(
            message: widget.errorMessage!,
            onRetry: widget.onRetry,
          )
        else if (!_hasSchedule)
            _ScheduleEmptyView(
              message:
              l10n.noAvailableAppointmentSlots,
            )
          else
            _buildScheduleContent(context),
      ],
    );
  }

  Widget _buildScheduleContent(
      BuildContext context,
      ) {
    final availableDays =
        _availableDays;

    if (availableDays.isEmpty) {
      return _ScheduleEmptyView(
        message: context
            .l10n
            .noAvailableAppointmentSlots,
      );
    }

    final selectedDay =
        _selectedDay ??
            availableDays.first.date;

    final selectedScheduleDay =
        _findScheduleDay(
          selectedDay,
        ) ??
            availableDays.first;

    final firstDate = _dateOnly(
      availableDays.first.date,
    );

    final lastDate = _dateOnly(
      availableDays.last.date,
    );

    final initialDate =
    _resolveCalendarInitialDate(
      selectedDay: selectedDay,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _ScheduleCalendarCard(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          isDayAvailable:
          _isDayAvailable,
          onDateSelected:
          _onDateSelected,
        ),
        const SizedBox(height: 22),
        _SelectedDaySlotsSection(
          day:
          selectedScheduleDay,
          selectedAppointmentTime:
          widget
              .selectedAppointmentTime,
          languageCode:
          widget.languageCode,
          onSlotSelected:
          widget.onSlotSelected,
        ),
      ],
    );
  }

  void _onDateSelected(
      DateTime selectedDate,
      ) {
    final scheduleDay =
    _findScheduleDay(
      selectedDate,
    );

    if (scheduleDay == null) {
      return;
    }

    setState(() {
      _selectedDay =
          scheduleDay.date;
    });
  }

  DateTime _resolveCalendarInitialDate({
    required DateTime selectedDay,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    final normalizedSelectedDay =
    _dateOnly(selectedDay);

    if (normalizedSelectedDay.isBefore(
      firstDate,
    )) {
      return firstDate;
    }

    if (normalizedSelectedDay.isAfter(
      lastDate,
    )) {
      return lastDate;
    }

    return normalizedSelectedDay;
  }

  DentistScheduleDayEntity?
  _findScheduleDay(
      DateTime date,
      ) {
    for (final day in _availableDays) {
      if (_isSameDate(
        day.date,
        date,
      )) {
        return day;
      }
    }

    return null;
  }

  bool _isDayAvailable(
      DateTime date,
      ) {
    return _availableDays.any(
          (day) => _isSameDate(
        day.date,
        date,
      ),
    );
  }

  bool get _hasError {
    return widget.errorMessage != null &&
        widget.errorMessage!
            .trim()
            .isNotEmpty;
  }

  bool get _hasSchedule {
    return widget.schedule != null &&
        widget.schedule!
            .hasAvailableSlots;
  }

  DateTime _dateOnly(
      DateTime date,
      ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  bool _isSameDate(
      DateTime first,
      DateTime second,
      ) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class _ScheduleCalendarCard
    extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayPredicate
  isDayAvailable;
  final ValueChanged<DateTime>
  onDateSelected;

  const _ScheduleCalendarCard({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.isDayAvailable,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    final accentColor =
    theme.brightness ==
        Brightness.dark
        ? AppColors.darkPrimaryPurple
        : AppColors.midnightNavy;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color: colors.borderSoft,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: 0.08,
            ),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(
          colorScheme:
          theme.colorScheme.copyWith(
            primary:
            accentColor,
            onPrimary:
            AppColors.white,
            surface:
            colors.surfacePrimary,
            onSurface:
            colors.textPrimary,
          ),
          datePickerTheme:
          DatePickerThemeData(
            backgroundColor:
            colors.surfacePrimary,
            headerBackgroundColor:
            colors.surfacePrimary,
            headerForegroundColor:
            colors.textPrimary,
            weekdayStyle:
            theme.textTheme.bodySmall
                ?.copyWith(
              color:
              colors.textSecondary,
              fontWeight:
              FontWeight.w700,
            ),
            dayStyle:
            theme.textTheme.bodyMedium
                ?.copyWith(
              color:
              colors.textPrimary,
              fontWeight:
              FontWeight.w700,
            ),
            todayBorder:
            BorderSide(
              color:
              accentColor,
              width: 1.4,
            ),
          ),
        ),
        child: CalendarDatePicker(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: DateTime.now(),
          selectableDayPredicate:
          isDayAvailable,
          onDateChanged:
          onDateSelected,
          initialCalendarMode:
          DatePickerMode.day,
        ),
      ),
    );
  }
}

class _SelectedDaySlotsSection
    extends StatelessWidget {
  final DentistScheduleDayEntity day;
  final DateTime?
  selectedAppointmentTime;
  final String languageCode;
  final ValueChanged<DateTime>
  onSlotSelected;

  const _SelectedDaySlotsSection({
    required this.day,
    required this.selectedAppointmentTime,
    required this.languageCode,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);
    final colors =
        context.colors;

    final localeName =
    _localeName(
      languageCode,
    );

    final formattedDate =
    intl.DateFormat(
      'EEEE، d MMMM yyyy',
      localeName,
    ).format(day.date);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    context
                        .l10n
                        .availableTimesTitle,
                    style: theme
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      color:
                      colors.textPrimary,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    formattedDate,
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color:
                      colors.textSecondary,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration:
              BoxDecoration(
                color:
                colors.surfaceMuted,
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
                border:
                Border.all(
                  color:
                  colors.borderSoft,
                ),
              ),
              child: Text(
                context
                    .l10n
                    .availableSlotsCount(
                  day.slots.length,
                ),
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                  colors.textSecondary,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (day.slots.isEmpty)
          _ScheduleEmptyView(
            message: context
                .l10n
                .noAvailableAppointmentSlots,
          )
        else
          GridView.builder(
            itemCount:
            day.slots.length,
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.05,
            ),
            itemBuilder: (
                context,
                index,
                ) {
              final slot =
              day.slots[index];

              final isSelected =
              _isSameMoment(
                selectedAppointmentTime,
                slot.dateTime,
              );

              return _AppointmentSlotTile(
                slot: slot,
                selected:
                isSelected,
                languageCode:
                languageCode,
                onTap: () {
                  onSlotSelected(
                    slot.dateTime,
                  );
                },
              );
            },
          ),
      ],
    );
  }

  bool _isSameMoment(
      DateTime? first,
      DateTime second,
      ) {
    if (first == null) {
      return false;
    }

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day &&
        first.hour == second.hour &&
        first.minute == second.minute;
  }
}

class _AppointmentSlotTile
    extends StatelessWidget {
  final AppointmentSlotEntity slot;
  final bool selected;
  final String languageCode;
  final VoidCallback onTap;

  const _AppointmentSlotTile({
    required this.slot,
    required this.selected,
    required this.languageCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);
    final colors =
        context.colors;

    final accentColor =
    theme.brightness ==
        Brightness.dark
        ? AppColors.darkPrimaryPurple
        : AppColors.midnightNavy;

    final formattedTime =
    intl.DateFormat(
      'hh:mm a',
      _localeName(
        languageCode,
      ),
    ).format(slot.dateTime);

    return Material(
      color: Colors.transparent,
      borderRadius:
      BorderRadius.circular(14),
      clipBehavior:
      Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(14),
        child: AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 180,
          ),
          alignment:
          Alignment.center,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration:
          BoxDecoration(
            color: selected
                ? accentColor
                : colors.surfaceMuted,
            borderRadius:
            BorderRadius.circular(
              14,
            ),
            border:
            Border.all(
              color: selected
                  ? accentColor
                  : colors.borderSoft,
              width:
              selected ? 2 : 1,
            ),
            boxShadow:
            selected
                ? [
              BoxShadow(
                color: accentColor
                    .withValues(
                  alpha: 0.20,
                ),
                blurRadius: 10,
                offset:
                const Offset(
                  0,
                  4,
                ),
              ),
            ]
                : null,
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              if (selected) ...[
                const Icon(
                  Icons.check_rounded,
                  color:
                  AppColors.white,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
              ],
              Flexible(
                child: Text(
                  formattedTime,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  textAlign:
                  TextAlign.center,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: selected
                        ? AppColors.white
                        : colors.textPrimary,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleLoadingView
    extends StatelessWidget {
  const _ScheduleLoadingView();

  @override
  Widget build(BuildContext context) {
    final colors =
        context.colors;

    return Column(
      children: [
        Container(
          width:
          double.infinity,
          height:
          340,
          decoration:
          BoxDecoration(
            color:
            colors.surfaceMuted,
            borderRadius:
            BorderRadius.circular(
              22,
            ),
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        GridView.builder(
          itemCount: 6,
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.05,
          ),
          itemBuilder: (_, __) {
            return Container(
              decoration:
              BoxDecoration(
                color:
                colors.surfaceMuted,
                borderRadius:
                BorderRadius.circular(
                  14,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ScheduleEmptyView
    extends StatelessWidget {
  final String message;

  const _ScheduleEmptyView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);
    final colors =
        context.colors;

    return Container(
      width:
      double.infinity,
      padding:
      const EdgeInsets.all(
        20,
      ),
      decoration:
      BoxDecoration(
        color:
        colors.surfaceSecondary,
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
      child: Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 38,
            color:
            colors.textSecondary,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            message,
            textAlign:
            TextAlign.center,
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              colors.textSecondary,
              height: 1.5,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleErrorView
    extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ScheduleErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);
    final colors =
        context.colors;
    final errorColor =
        theme.colorScheme.error;

    return Container(
      width:
      double.infinity,
      padding:
      const EdgeInsets.all(
        18,
      ),
      decoration:
      BoxDecoration(
        color:
        errorColor.withValues(
          alpha: 0.07,
        ),
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        border:
        Border.all(
          color:
          errorColor.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 36,
            color:
            errorColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            message,
            textAlign:
            TextAlign.center,
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              colors.textPrimary,
              height: 1.5,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(
              height: 14,
            ),
            OutlinedButton.icon(
              onPressed:
              onRetry,
              icon:
              const Icon(
                Icons.refresh_rounded,
              ),
              label:
              Text(
                context
                    .l10n
                    .retryButton,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _localeName(
    String languageCode,
    ) {
  return languageCode
      .toLowerCase()
      .startsWith('ar')
      ? 'ar'
      : 'en';
}