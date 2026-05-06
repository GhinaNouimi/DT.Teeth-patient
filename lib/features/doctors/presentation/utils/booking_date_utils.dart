import 'package:intl/intl.dart';

class BookingDateUtils {
  static bool isDateAvailable(DateTime date, List<int> availableDays) {
    final now = DateTime.now();
    return date.isAfter(now) &&
        availableDays.contains(date.day) &&
        date.isBefore(now.add(const Duration(days: 30)));
  }

  static String formatSelectedDate(DateTime date) {
    return DateFormat('EEEE, d MMMM', 'ar_SA').format(date);
  }

  static String formatReviewDate(DateTime date) {
    return DateFormat('EEEE, d MMMM y', 'ar_SA').format(date);
  }
}
