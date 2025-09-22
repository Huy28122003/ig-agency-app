import 'package:flutter/material.dart';
import 'package:ig_agency_app/domain/usecases/logout_use_case.dart';

import '../../di/di.dart';
import '../../presentation/routers/app_router.dart';
import '../utils/alert.dart';
import 'failure.dart';

abstract class ErrorHandler {
  static final _errorList = <String>[];

  static void handle(Object error, {VoidCallback? onConfirm}) {
    String? message;
    if (error is Failure) {
      message = error.message;
    }
    message ??= 'Error something..';

    if (_errorList.contains(message)) {
      return;
    }

    _errorList.add(message);

    if (error is UnauthorizedFailure) {
      _hideAll();
      _showErrorDialog(
        message,
        onPressed: () async {
          onConfirm?.call();
          _errorList.clear();
          await getIt<LogoutUseCase>().call();
          getIt<AppRouter>().replaceAll([LoginRoute()]);
        },
      );
      return;
    }
    _showErrorDialog(
      message,
      onPressed: () {
        onConfirm?.call();
        _errorList.remove(message);
      },
    );
  }

  static void _showErrorDialog(String message, {VoidCallback? onPressed}) {
    final appDialog = getIt<AppAlertDialog>();
    appDialog.show(
      null,
      message: message,
      type: AppAlertType.error,
      onConfirmBtnTap: onPressed,
      barrierDismissible: false,
    );
  }

  static void _hideAll() {
    final appDialog = getIt<AppAlertDialog>();
    appDialog.hide();
  }
}
