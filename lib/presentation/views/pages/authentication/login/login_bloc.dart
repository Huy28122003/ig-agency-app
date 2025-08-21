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
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });

    handleSubEvent<EmailChangedEvent>((event, emit) async {
      emit(state.copyWith(email: event.email));
    });

    handleSubEvent<PasswordChangedEvent>((event, emit) async {
      emit(state.copyWith(password: event.password));
    });

    handleSubEvent<TogglePasswordVisibilityEvent>((event, emit) async {
      emit(state.copyWith(isObscurePassword: !state.isObscurePassword));
    });

    handleSubEvent<SubmitLoginEvent>((event, emit) async {
      emit(state.copyWith(processing: true));
      await _loginUseCase.call(
        LoginParam(email: state.email, password: state.password),
      );
      emit(state.copyWith(processing: false, isSuccess: true));
    });
  }

  final LoginUseCase _loginUseCase;
}
