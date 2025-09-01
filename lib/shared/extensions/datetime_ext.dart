import 'package:intl/intl.dart';

extension FormattedDateTimeExtension on DateTime {
  String toShortDateString() {
    final now = DateTime.now();
    if (year == now.year) {
      return DateFormat('MMM d').format(this);
    } else {
      return DateFormat('MMM d, yyyy').format(this);
    }
  }
}
