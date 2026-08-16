import '../../domain/entities/dentist_schedule_entity.dart';

class ShowDentistScheduleResponseModel {
  final bool success;
  final DentistScheduleModel schedule;

  const ShowDentistScheduleResponseModel({
    required this.success,
    required this.schedule,
  });

  factory ShowDentistScheduleResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    if (rawData is! List) {
      throw const FormatException(
        'Invalid dentist schedule response data.',
      );
    }

    return ShowDentistScheduleResponseModel(
      success: json['success'] == true,
      schedule: DentistScheduleModel(
        dentistId: _parseInt(
          json['dentist_id'],
        ),
        days: rawData
            .whereType<Map>()
            .map(
              (item) =>
              DentistScheduleDayModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
        )
            .toList(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'dentist_id': schedule.dentistId,
      'data': schedule.days
          .map(
            (day) => day is DentistScheduleDayModel
            ? day.toJson()
            : {
          'date': _formatDate(day.date),
          'day': day.day,
          'slots': day.slots
              .map(
                (slot) =>
            slot is AppointmentSlotModel
                ? slot.toJson()
                : {
              'time': slot.time,
              'datetime':
              _formatDateTime(
                slot.dateTime,
              ),
            },
          )
              .toList(),
        },
      )
          .toList(),
    };
  }

  static int _parseInt(
      dynamic value,
      ) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static String _formatDate(
      DateTime value,
      ) {
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  static String _formatDateTime(
      DateTime value,
      ) {
    final date = _formatDate(value);
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');

    return '$date $hour:$minute:$second';
  }
}

class DentistScheduleModel
    extends DentistScheduleEntity {
  const DentistScheduleModel({
    required super.dentistId,
    required super.days,
  });
}

class DentistScheduleDayModel
    extends DentistScheduleDayEntity {
  const DentistScheduleDayModel({
    required super.date,
    required super.day,
    required super.slots,
  });

  factory DentistScheduleDayModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawSlots = json['slots'];

    return DentistScheduleDayModel(
      date: _parseDate(
        json['date'],
      ),
      day:
      json['day']?.toString().trim() ?? '',
      slots: rawSlots is List
          ? rawSlots
          .whereType<Map>()
          .map(
            (item) =>
            AppointmentSlotModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
      )
          .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date':
      ShowDentistScheduleResponseModel._formatDate(
        date,
      ),
      'day': day,
      'slots': slots
          .map(
            (slot) => slot is AppointmentSlotModel
            ? slot.toJson()
            : {
          'time': slot.time,
          'datetime':
          ShowDentistScheduleResponseModel
              ._formatDateTime(
            slot.dateTime,
          ),
        },
      )
          .toList(),
    };
  }

  static DateTime _parseDate(
      dynamic value,
      ) {
    final rawValue =
        value?.toString().trim() ?? '';

    return DateTime.tryParse(rawValue) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }
}

class AppointmentSlotModel
    extends AppointmentSlotEntity {
  const AppointmentSlotModel({
    required super.time,
    required super.dateTime,
  });

  factory AppointmentSlotModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AppointmentSlotModel(
      time:
      json['time']?.toString().trim() ?? '',
      dateTime: _parseDateTime(
        json['datetime'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'datetime':
      ShowDentistScheduleResponseModel
          ._formatDateTime(
        dateTime,
      ),
    };
  }

  static DateTime _parseDateTime(
      dynamic value,
      ) {
    final rawValue =
        value?.toString().trim() ?? '';

    if (rawValue.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.tryParse(rawValue) ??
        DateTime.tryParse(
          rawValue.replaceFirst(' ', 'T'),
        ) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }
}