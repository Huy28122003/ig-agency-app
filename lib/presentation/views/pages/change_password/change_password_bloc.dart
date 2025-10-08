import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/domain/usecases/change_password_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

@injectable
class ChangePasswordBloc
    extends BaseBloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({required ChangePasswordUseCase changePasswordUseCase})
    : _changePasswordUseCase = changePasswordUseCase,
      super(ChangePasswordState()) {
    _registerHandlers();
  }

  final ChangePasswordUseCase _changePasswordUseCase;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<CurrentPasswordChangedEvent>(_onCurrentPasswordChanged);
    handleSubEvent<NewPasswordChangedEvent>(_onNewPasswordChanged);
    handleSubEvent<ConfirmPasswordChangedEvent>(_onConfirmPasswordChanged);

    handleSubEvent<SavePasswordEvent>(_onSavePassword);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loaded));
  }

  Future<void> _onCurrentPasswordChanged(
    CurrentPasswordChangedEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(currentPassword: event.currentPassword));
  }

  Future<void> _onNewPasswordChanged(
    NewPasswordChangedEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(newPassword: event.newPassword));
  }

  Future<void> _onConfirmPasswordChanged(
    ConfirmPasswordChangedEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  Future<void> _onSavePassword(
    SavePasswordEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    try {
      emit(state.copyWith(processing: true));

      await _changePasswordUseCase.call(
        ChangePasswordParam(
          currentPassword: state.currentPassword,
          newPassword: state.newPassword,
          passwordConfirm: state.confirmPassword,
        ),
      );

      emit(state.copyWith(processing: false, isSaveSuccess: true));
    } catch (error) {
      handleError(emit, error);
    }
  }
}
