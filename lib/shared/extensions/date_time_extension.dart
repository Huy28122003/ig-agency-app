import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime{
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
}