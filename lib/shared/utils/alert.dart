import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../di/di.dart';
import '../../presentation/routers/app_router.dart';
import '../../presentation/views/modal/confirm_dialog.dart';
import '../../presentation/views/modal/error_dialog.dart';
import '../../presentation/views/widgets/app_loading.dart';

enum AppAlertType { success, error, warning, confirm, info, loading }

@lazySingleton
class AppAlertDialog {
  void show(
    BuildContext? context, {
    String message = '',
    AppAlertType type = AppAlertType.info,
    bool barrierDismissible = false,
    VoidCallback? onConfirmBtnTap,
    VoidCallback? onCancelBtnTap,
  }) {
    final curContext =
        context ?? getIt<AppRouter>().navigatorKey.currentContext;
    if (curContext == null || !curContext.mounted) return;

    final Widget widget;
    switch (type) {
      case AppAlertType.loading:
        widget = Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: const AppLoading(),
          ),
        );
        break;
      case AppAlertType.error:
        widget = ErrorDialog(
          title: 'Error',
          message: message,
          onConfirmBtnTap: onConfirmBtnTap,
        );
        break;
      case AppAlertType.confirm:
        widget = ConfirmDialog(
          message: message,
          onConfirmBtnTap: onConfirmBtnTap,
          onCancelBtnTap: onCancelBtnTap,
        );
      default:
        widget = const SizedBox();
    }
    showDialog(
      context: curContext,
      useRootNavigator: true,
      barrierDismissible: barrierDismissible,
      builder: (context) => widget,
    );
  }

  void hide([BuildContext? context]) {
    final curContext =
        context ?? getIt<AppRouter>().navigatorKey.currentContext;
    if (curContext == null || !curContext.mounted) return;
    Navigator.of(curContext, rootNavigator: true).pop();
  }
}
