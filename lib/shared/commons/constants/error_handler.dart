// import 'dart:io';
//
// import 'package:auto_route/auto_route.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:ldcc/app_controller.dart';
// import 'package:ldcc/app_state.dart';
// import 'package:ldcc/di/di.dart';
// import 'package:ldcc/presentation/router/router.dart';
// import 'package:ldcc/shared/common/failure.dart';
// import 'package:ldcc/shared/utils/toast_util.dart';
// import 'package:provider/provider.dart';
//
// class ErrorHandler {
//   static Future<void> handle(Object? error) async {
//     final context = getIt<AppRouter>().navigatorKey.currentContext;
//     if (context == null) {
//       return;
//     }
//     switch (error) {
//       case final ApiFailure apiFailure:
//         switch (apiFailure.httpCode) {
//           case HttpStatus.unauthorized:
//             final isLoggedIn = context.read<AppState>().driverInfo != null;
//             if (isLoggedIn) {
//               await context.read<AppController>().clearAllData();
//               if (context.mounted) {
//                 await context.router.replaceAll([const LoginRoute()]);
//               }
//             }
//             if (context.mounted) {
//               showError(context, error);
//             }
//           default:
//             showError(context, error);
//         }
//       default:
//         showError(context, error);
//     }
//   }
//
//   static void showError(BuildContext context, Object? error) {
//     switch (error) {
//       case final ApiFailure apiFailure:
//         if (apiFailure.httpCode == HttpStatus.unauthorized) {
//           ToastUtil.showError(context, 'error.token_is_expired'.tr());
//         } else if (apiFailure.message != null &&
//             apiFailure.message!.isNotEmpty) {
//           ToastUtil.showError(context, apiFailure.message!);
//         } else {
//           ToastUtil.showError(context, 'error.something_went_wrong'.tr());
//         }
//
//       case NoInternetFailure _:
//         ToastUtil.showError(context, 'error.no_internet'.tr());
//       case ConnectionTimeoutFailure _:
//         ToastUtil.showError(context, 'error.connection_timeout'.tr());
//       case UnknowFailure _:
//         ToastUtil.showError(context, 'error.something_went_wrong'.tr());
//       default:
//         return;
//     }
//   }
//
//   static Future<void> showErrorMessage(String message) async {
//     final context = getIt<AppRouter>().navigatorKey.currentContext;
//     if (context == null) {
//       return;
//     }
//     ToastUtil.showError(context, message.tr());
//   }
// }
