import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/usecases/login_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'login_event.dart';

part 'login_state.dart';

@injectable
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(LoginState()) {
    _registerHandlers();
  }

  final LoginUseCase _loginUseCase;

  void _registerHandlers() {
    handleSubEvent<EmailChangedEvent>(
      (event, emit) async => emit(state.copyWith(email: event.email)),
    );

    handleSubEvent<PasswordChangedEvent>(
      (event, emit) async => emit(state.copyWith(password: event.password)),
    );

    handleSubEvent<SubmitLoginEvent>(_onSubmitLogin);
  }

  void _resetErrorMessages(Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        errorEmailMessage: null,
        errorPasswordMessage: null,
        forceResetErrorMessages: true,
      ),
    );
  }

  Future<void> _onSubmitLogin(
    SubmitLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(processing: true, isSuccess: false));
      _resetErrorMessages(emit);

      await _loginUseCase(
        LoginParam(email: state.email, password: state.password),
      );
      emit(state.copyWith(processing: false, isSuccess: true));
    } catch (error) {
      handleError(emit, error);
    }
  }
}
