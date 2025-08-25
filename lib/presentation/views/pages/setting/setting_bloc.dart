import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/usecases/logout_use_case.dart';
import 'package:ig_agency_app/domain/usecases/get_dark_mode_use_case.dart';
import 'package:ig_agency_app/domain/usecases/set_dark_mode_use_case.dart';
import 'package:ig_agency_app/domain/usecases/get_in_app_alerts_use_case.dart';
import 'package:ig_agency_app/domain/usecases/set_in_app_alerts_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'setting_event.dart';

part 'setting_state.dart';

@injectable
class SettingBloc extends BaseBloc<SettingEvent, SettingState> {
  SettingBloc({
    required LogoutUseCase logoutUseCase,
    required GetDarkModeUseCase getDarkModeUseCase,
    required SetDarkModeUseCase setDarkModeUseCase,
    required GetInAppAlertsUseCase getInAppAlertsUseCase,
    required SetInAppAlertsUseCase setInAppAlertsUseCase,
  }) : _logoutUseCase = logoutUseCase,
       _getDarkModeUseCase = getDarkModeUseCase,
       _setDarkModeUseCase = setDarkModeUseCase,
       _getInAppAlertsUseCase = getInAppAlertsUseCase,
       _setInAppAlertsUseCase = setInAppAlertsUseCase,
       super(SettingState()) {
    _registerHandlers();
  }

  final LogoutUseCase _logoutUseCase;
  final GetDarkModeUseCase _getDarkModeUseCase;
  final SetDarkModeUseCase _setDarkModeUseCase;
  final GetInAppAlertsUseCase _getInAppAlertsUseCase;
  final SetInAppAlertsUseCase _setInAppAlertsUseCase;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<ToggleDarkModeEvent>(_onToggleDarkMode);

    handleSubEvent<ToggleInAppAlertsEvent>(_onToggleInAppAlerts);

    handleSubEvent<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<SettingState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final darkModeResult = await _getDarkModeUseCase.call(null);
    final inAppAlertsResult = await _getInAppAlertsUseCase.call(null);

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        isDarkMode: darkModeResult.success
            ? darkModeResult.data ?? false
            : false,
        isInAppAlerts: inAppAlertsResult.success
            ? inAppAlertsResult.data ?? false
            : false,
      ),
    );
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<SettingState> emit,
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
    Emitter<SettingState> emit,
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

  Future<void> _onLogout(LogoutEvent event, Emitter<SettingState> emit) async {
    emit(state.copyWith(processing: true));

    final result = await _logoutUseCase.call(null);

    emit(state.copyWith(processing: false, isLogoutSuccess: result.success));
  }
}
