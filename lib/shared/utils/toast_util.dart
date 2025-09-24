import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../presentation/resources/colors.dart';

class ToastUtil {
  static void showError(BuildContext context, String message) {
    final toastWithButton = Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // color: ,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: AppColors.surfaceBackgroundBackground),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              // style: ,
            ),
          ),
        ],
      ),
    );
    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: Center(child: toastWithButton),
      positionedToastBuilder: (context, child, _) {
        return Positioned(right: 24.0, left: 24.0, bottom: 48, child: child);
      },
    );
  }

  static void showSuccess(BuildContext context, String message) {
    final toastWithButton = Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // color: ,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.surfaceBackgroundBackground,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              // style:
            ),
          ),
        ],
      ),
    );
    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: Center(child: toastWithButton),
      positionedToastBuilder: (context, child, _) {
        return Positioned(right: 24.0, left: 24.0, bottom: 48, child: child);
      },
    );
  }
}
