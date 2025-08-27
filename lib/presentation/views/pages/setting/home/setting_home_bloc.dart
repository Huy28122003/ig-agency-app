import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/usecases/logout_use_case.dart';
import 'package:ig_agency_app/domain/usecases/get_dark_mode_use_case.dart';
import 'package:ig_agency_app/domain/usecases/set_dark_mode_use_case.dart';
import 'package:ig_agency_app/domain/usecases/get_in_app_alerts_use_case.dart';
import 'package:ig_agency_app/domain/usecases/set_in_app_alerts_use_case.dart';
import 'package:ig_agency_app/domain/usecases/stream_user_use_case.dart';
import 'package:ig_agency_app/domain/usecases/update_user_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/usecases/fetch_current_user_use_case.dart';
import '../../../../../domain/usecases/use_case.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'setting_home_event.dart';

part 'setting_home_state.dart';

@injectable
class SettingHomeBloc extends BaseBloc<SettingHomeEvent, SettingHomeState> {
  SettingHomeBloc({
    required LogoutUseCase logoutUseCase,
    required GetDarkModeUseCase getDarkModeUseCase,
    required SetDarkModeUseCase setDarkModeUseCase,
    required GetInAppAlertsUseCase getInAppAlertsUseCase,
    required SetInAppAlertsUseCase setInAppAlertsUseCase,
    required StreamUserUseCase streamUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required FetchCurrentUserUseCase fetchCurrentUserUseCase,
  }) : _logoutUseCase = logoutUseCase,
       _getDarkModeUseCase = getDarkModeUseCase,
       _setDarkModeUseCase = setDarkModeUseCase,
       _getInAppAlertsUseCase = getInAppAlertsUseCase,
       _setInAppAlertsUseCase = setInAppAlertsUseCase,
       _streamUserUseCase = streamUserUseCase,
       _fetchCurrentUserUseCase = fetchCurrentUserUseCase,
       super(SettingHomeState()) {
    _registerHandlers();
    _initializeUserListener();
  }

  final LogoutUseCase _logoutUseCase;
  final GetDarkModeUseCase _getDarkModeUseCase;
  final SetDarkModeUseCase _setDarkModeUseCase;
  final GetInAppAlertsUseCase _getInAppAlertsUseCase;
  final SetInAppAlertsUseCase _setInAppAlertsUseCase;
  final FetchCurrentUserUseCase _fetchCurrentUserUseCase;
  final StreamUserUseCase _streamUserUseCase;

  StreamSubscription<UserEntity>? _userSubscription;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<ToggleDarkModeEvent>(_onToggleDarkMode);

    handleSubEvent<ToggleInAppAlertsEvent>(_onToggleInAppAlerts);

    handleSubEvent<LogoutEvent>(_onLogout);

    handleSubEvent<UpdateUserEvent>(_onUpdateUser);
  }

  void _initializeUserListener() {
    _userSubscription = _streamUserUseCase.call(NoParam()).listen((user) {
      add(UpdateUserEvent(user: user));
    });
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final darkModeResult = await _getDarkModeUseCase.call(null);
    final inAppAlertsResult = await _getInAppAlertsUseCase.call(null);
    final userResult = await _fetchCurrentUserUseCase(NoParam());

    // Check if user is not found
    if (!userResult.success || userResult.data == null) {
      emit(
        state.copyWith(
          pageStatus: PageStatus.failure,
          pageErrorMessage: userResult.failure?.message ?? 'User not found',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        isDarkMode: darkModeResult.success
            ? darkModeResult.data ?? false
            : false,
        isInAppAlerts: inAppAlertsResult.success
            ? inAppAlertsResult.data ?? false
            : false,
        user: userResult.data,
      ),
    );
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    final newDarkMode = !state.isDarkMode;
    emit(state.copyWith(processing: true));

    final result = await _setDarkModeUseCase(
      SetDarkModeParam(isDarkMode: newDarkMode),
    );

    emit(
      state.copyWith(
        processing: false,
        isDarkMode: result.success ? newDarkMode : state.isDarkMode,
      ),
    );
  }

  Future<void> _onToggleInAppAlerts(
    ToggleInAppAlertsEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    final newInAppAlerts = !state.isInAppAlerts;
    emit(state.copyWith(processing: true));

    final result = await _setInAppAlertsUseCase(
      SetInAppAlertsParam(isInAppAlerts: newInAppAlerts),
    );

    emit(
      state.copyWith(
        processing: false,
        isInAppAlerts: result.success ? newInAppAlerts : state.isInAppAlerts,
      ),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    final result = await _logoutUseCase.call(null);

    emit(state.copyWith(processing: false, isLogoutSuccess: result.success));
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<SettingHomeState> emit,
  ) async {
    emit(state.copyWith(user: event.user));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
