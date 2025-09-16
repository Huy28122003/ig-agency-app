import 'package:dartx/dartx.dart';
import 'package:intl/intl.dart';

extension TimeParserUtil on DateTime {
  String formatDateTimeWithTimezone() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes <= 5) {
      return 'Now';
    }

    if (isSameDate(now)) {
      return 'Today at ${_formatTime()}';
    }

    if (isSameDate(now.subtract(const Duration(days: 1)))) {
      return 'Yesterday at ${_formatTime()}';
    }

    return _formatDate();
  }

  String _formatTime() {
    return DateFormat("h:mm a").format(this);
  }

  String _formatDate() {
    return DateFormat("MMM d 'at' h:mm a").format(this);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameWeek(DateTime other) {
    return firstDayOfWeek.isAtSameDayAs(other.firstDayOfWeek);
  }
}
