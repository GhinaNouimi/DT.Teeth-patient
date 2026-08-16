class DentistScheduleEntity {
  final int dentistId;
  final List<DentistScheduleDayEntity> days;

  const DentistScheduleEntity({
    required this.dentistId,
    required this.days,
  });

  bool get isEmpty => days.isEmpty;

  bool get hasAvailableSlots {
    return days.any(
          (day) => day.slots.isNotEmpty,
    );
  }
}

class DentistScheduleDayEntity {
  final DateTime date;
  final String day;
  final List<AppointmentSlotEntity> slots;

  const DentistScheduleDayEntity({
    required this.date,
    required this.day,
    required this.slots,
  });

  bool get hasSlots => slots.isNotEmpty;
}

class AppointmentSlotEntity {
  final String time;
  final DateTime dateTime;

  const AppointmentSlotEntity({
    required this.time,
    required this.dateTime,
  });
}