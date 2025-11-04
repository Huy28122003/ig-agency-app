import 'package:dartx/dartx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

enum DateTimeType {
  date,
  dateHyphen,
  dateAndTime,
  monthly,
  dateTimeSecond,
  dateTimeSecondHyphen,
  dateSlash,
  dateSlashFull,
  dateSlashFullTimeSecond,
  monthDay,
  hourMinuteAmPm,
  dateWithTimeCurrentYear,
  dateWithTimeFullYear,
}

extension DateTimeTypeExtenstions on DateTimeType {
  String getDateFormat() {
    switch (this) {
      case DateTimeType.date:
        return 'dd/MM/yyyy';
      case DateTimeType.dateAndTime:
        return 'dd/MM/yyyy HH:mm';
      case DateTimeType.monthly:
        return 'MM/yyyy';
      case DateTimeType.dateTimeSecond:
        return 'dd/MM/yyyy HH:mm:ss';
      case DateTimeType.dateHyphen:
        return 'yyyy-MM-dd';
      case DateTimeType.dateTimeSecondHyphen:
        return 'yyyy/MM/dd HH:mm:ss.SSS';
      case DateTimeType.dateSlash:
        return 'yyyy/M/d';
      case DateTimeType.dateSlashFull:
        return 'yyyy/MM/dd';
      case DateTimeType.dateSlashFullTimeSecond:
        return 'yyyy/MM/dd HH:mm:ss';
      case DateTimeType.monthDay:
        return 'MMM d';
      case DateTimeType.hourMinuteAmPm:
        return 'h:mm a';
      case DateTimeType.dateWithTimeCurrentYear:
        return 'h:mm a, MMM d';
      case DateTimeType.dateWithTimeFullYear:
        return 'h:mm a, MMM d, yyyy';
    }
  }
}

extension DateTimeExtensions on DateTime {
  String format({DateTimeType type = DateTimeType.date, bool utc = false}) {
    return DateFormat(type.getDateFormat()).format(utc ? toUtc() : this);
  }

  String formatDateWithTime({bool utc = false}) {
    final now = DateTime.now();
    if (isAtSameYearAs(now)) {
      return format(type: DateTimeType.dateWithTimeCurrentYear, utc: utc);
    } else {
      return format(type: DateTimeType.dateWithTimeFullYear, utc: utc);
    }
  }

  String formatHourMinuteAmPm({bool utc = false}) {
    return format(type: DateTimeType.hourMinuteAmPm, utc: utc);
  }
}

extension DateTimeNumExtensions on int {
  DateTime toDate({bool utc = false}) {
    final bool isSecond = this < 100000000000;
    final millis = isSecond ? this * 1000 : this;
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: utc);
  }
}

extension DateTimeStringExtensions on String {
  DateTime? toDate({DateTimeType type = DateTimeType.date, bool utc = false}) {
    try {
      if (contains("T") && contains("Z")) {
        // ISO 8601
        return DateTime.parse(this);
      }
      return DateFormat(type.getDateFormat()).parse(this, utc);
    } on FormatException catch (_) {
      return null;
    }
  }
}

extension DateTimeUtilsExtensions on DateTime {
  String getTimeDifferenceFromNow() {
    final Duration difference = DateTime.now().difference(this);
    if (difference.inSeconds < 5) {
      return 'time_ago.just_now'.tr();
    } else if (difference.inMinutes < 1) {
      return 'time_ago.secs_ago'.tr(args: [difference.inSeconds.toString()]);
    } else if (difference.inHours < 1) {
      return 'time_ago.min_ago'.tr(args: [difference.inMinutes.toString()]);
    } else if (difference.inHours < 24) {
      return 'time_ago.hour_ago'.tr(args: [difference.inHours.toString()]);
    } else {
      return 'time_ago.day_ago'.tr(args: [difference.inDays.toString()]);
    }
    // todo: apply more
  }
}

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

  String toShortTimeString() {
    return DateFormat('h:mm a').format(this);
  }
}
