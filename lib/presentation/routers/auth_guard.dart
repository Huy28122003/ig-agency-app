import 'package:auto_route/auto_route.dart';
import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/check_authentication_status_use_case.dart';

@singleton
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._authenticationStatusUseCase, this._getProfileInfoUseCase);

  final CheckAuthenticationStatusUseCase _authenticationStatusUseCase;
  final GetProfileInfoUseCase _getProfileInfoUseCase;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final isLogged = await _authenticationStatusUseCase.call();
    if (isLogged) {
      await _initProfileInfo();
      resolver.resolveNext(true);
    } else {
      resolver.redirectUntil(LoginRoute());
    }
  }

  Future _initProfileInfo() async {
    try {
      await _getProfileInfoUseCase.call();
    } catch (e) {
      return;
    }
  }
}
