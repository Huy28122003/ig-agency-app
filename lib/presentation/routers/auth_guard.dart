import 'package:auto_route/auto_route.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/constants/string.dart';

@singleton
class AuthGuard extends AutoRouteGuard {
  AuthGuard();

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    if (kTesting) {
      resolver.resolveNext(true);
    } else {
      resolver.redirectUntil(LoginRoute());
    }
  }
}
