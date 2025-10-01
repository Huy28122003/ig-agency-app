import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String convertDateTimeToString() {
    final now = DateTime.now();

    final isToday = now.year == year && now.month == month && now.day == day;
    if (isToday) {
      return toHourMinuteAmPm;
    } else {
      return toRelativeString;
    }
  }

  String get toHourMinuteAmPm {
    return DateFormat('h:mm a').format(this).toLowerCase();
  }

  String get toRelativeString {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h";
    } else if (diff.inDays < 7) {
      return "${diff.inDays}d";
    } else if (diff.inDays < 30) {
      return "${(diff.inDays / 7).floor()}w";
    } else if (diff.inDays < 365) {
      return "${(diff.inDays / 30).floor()}m";
    } else {
      return "${(diff.inDays / 365).floor()}y";
    }
  }

  String toShortDateString() {
    final now = DateTime.now();
    if (year == now.year) {
      return DateFormat('h:mm a, MMM d').format(this);
    } else {
      return DateFormat('h:mm a, MMM d, yyyy').format(this);
    }
  }

  String toShortTimeString() {
    return DateFormat('h:mm a').format(this);
  }
}
