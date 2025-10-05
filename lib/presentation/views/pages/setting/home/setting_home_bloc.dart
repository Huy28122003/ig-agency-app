import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/app/app_bloc.dart';
import 'package:ig_agency_app/domain/repositories/auth_repository.dart';
import 'package:ig_agency_app/domain/repositories/notification_repository.dart';
import 'package:ig_agency_app/domain/repositories/user_repository.dart';
import 'package:ig_agency_app/domain/usecases/logout_use_case.dart';
import 'package:ig_agency_app/domain/usecases/get_dark_mode_use_case.dart';
import 'package:ig_agency_app/domain/usecases/set_dark_mode_use_case.dart';
import 'package:ig_agency_app/domain/usecases/get_in_app_alerts_use_case.dart';
import 'package:ig_agency_app/domain/usecases/set_in_app_alerts_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/entities/user/profile_info_entity.dart';
import '../../../../../domain/usecases/get_profile_info_use_case.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'setting_home_event.dart';

part 'setting_home_state.dart';

@injectable
class SettingHomeBloc extends BaseBloc<SettingHomeEvent, SettingHomeState> {
  SettingHomeBloc(
    this._logoutUseCase,
    this._getDarkModeUseCase,
    this._setDarkModeUseCase,
    this._getInAppAlertsUseCase,
    this._setInAppAlertsUseCase,
    this._fetchCurrentUserUseCase,
    this._userRepository,
    this._notificationRepository,
    this._appBloc,
    this._authRepository,
  ) : super(SettingHomeState()) {
    _registerHandlers();
    _initializeUserListener();
  }

  final LogoutUseCase _logoutUseCase;
  final GetDarkModeUseCase _getDarkModeUseCase;
  final SetDarkModeUseCase _setDarkModeUseCase;
  final GetInAppAlertsUseCase _getInAppAlertsUseCase;
  final SetInAppAlertsUseCase _setInAppAlertsUseCase;
  final GetProfileInfoUseCase _fetchCurrentUserUseCase;
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  final AuthRepository _authRepository;
  final AppBloc _appBloc;

  StreamSubscription<ProfileInfoEntity>? _userSubscription;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<ToggleDarkModeEvent>(_onToggleDarkMode);

    handleSubEvent<ChangeNotificationEvent>(_onNotificationChanged);

    handleSubEvent<LogoutEvent>(_onLogout);

    handleSubEvent<UpdateUserEvent>(_onUpdateUser);
  }

  void _initializeUserListener() {
    _userSubscription = _userRepository.fetchProfileInfo.listen((user) {
      add(UpdateUserEvent(user: user));
    });
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    final results = await Future.wait([
      _getDarkModeUseCase.call(),
      _getInAppAlertsUseCase.call(null),
      _fetchCurrentUserUseCase.call(),
      _authRepository.getEmail(),
    ]);
    final darkModeResult = results[0] as bool;
    final isEnableNotification = results[1] as bool;
    final userResult = results[2] as ProfileInfoEntity;
    final email = results[3] as String?;
    emit(
      state.copyWith(
        isDarkMode: darkModeResult,
        isInAppAlerts: isEnableNotification,
        name: userResult.name,
        avatar: userResult.avatar,
        email: email,
      ),
    );
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    final newDarkMode = !state.isDarkMode;
    emit(state.copyWith(processing: true));

    await _setDarkModeUseCase(SetDarkModeParam(isDarkMode: newDarkMode));

    emit(state.copyWith(processing: false, isDarkMode: newDarkMode));
  }

  Future<void> _onNotificationChanged(
    ChangeNotificationEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    final enableNotification = !state.isEnableNotification;
    try {
      if (enableNotification) {
        final isEnable = await _notificationRepository.requestPermission();
        if (isEnable) await _notificationRepository.initNotification();
      }
      await _setInAppAlertsUseCase(
        SetInAppAlertsParam(enableNotification: enableNotification),
      );
      emit(state.copyWith(isInAppAlerts: enableNotification));
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    emit(state.copyWith(processing: true));
    await _logoutUseCase.call(null);
    emit(state.copyWith(processing: false, isLogoutSuccess: true));
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    emit(state.copyWith(name: event.user.name, avatar: event.user.avatar));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
