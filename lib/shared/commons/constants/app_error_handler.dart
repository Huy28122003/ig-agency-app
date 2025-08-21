import 'package:flutter/material.dart';
import 'package:ig_agency_app/shared/commons/failure.dart';

import '../../../di/di.dart';
import '../../utils/alert.dart';
import '../../utils/logger.dart';

class AppErrorHandler {
  static void handle(
    Object? error, {
    BuildContext? context,
    dynamic stackTrace,
    VoidCallback? onPressed,
  }) {
    var message = 'Something went wrong...';
    if (error is Failure) {
      message = error.message ?? message;
    }

    logger.e(message, error: error, stackTrace: stackTrace);
    getIt<AppAlertDialog>().show(
      context,
      type: AppAlertType.error,
      message: message,
      onConfirmBtnTap: onPressed,
    );
  }
}
