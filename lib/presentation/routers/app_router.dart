import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import '../../di/di.dart';
import '../views/pages/authentication/forgot_password/forgot_password_page.dart';
import '../views/pages/authentication/login/login_page.dart';
import '../views/pages/authentication/otp/otp_page.dart';
import '../views/pages/authentication/registration/registration_page.dart';
import '../views/pages/nav/nav_page.dart';
import '../views/pages/setting/setting_page.dart';
import '../views/pages/work_place/detail/workspace_detail_page.dart';
import '../views/pages/work_place/list/workspace_list_page.dart';
import 'auth_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Dialog|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegistrationRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: OtpRoute.page),
    AutoRoute(
      guards: [getIt<AuthGuard>()],
      page: NavRoute.page,
      initial: true,
      children: [
        AutoRoute(page: WorkspaceDetailRoute.page),
        AutoRoute(page: WorkspaceListRoute.page, initial: true),
        AutoRoute(page: SettingRoute.page),
      ],
    ),
  ];
}
