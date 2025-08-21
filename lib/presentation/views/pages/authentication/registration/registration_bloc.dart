import 'package:ig_agency_app/domain/usecases/register_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'registration_event.dart';

part 'registration_state.dart';

@injectable
class RegistrationBloc extends BaseBloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({required RegisterUseCase registerUseCase})
    : _registerUseCase = registerUseCase,
      super(RegistrationState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });

    handleSubEvent<NameChangedEvent>((event, emit) async {
      emit(state.copyWith(name: event.name));
    });

    handleSubEvent<EmailChangedEvent>((event, emit) async {
      emit(state.copyWith(email: event.email));
    });

    handleSubEvent<PasswordChangedEvent>((event, emit) async {
      emit(state.copyWith(password: event.password));
    });

    handleSubEvent<ConfirmPasswordChangedEvent>((event, emit) async {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    handleSubEvent<TogglePasswordVisibilityEvent>((event, emit) async {
      emit(state.copyWith(isObscurePassword: !state.isObscurePassword));
    });

    handleSubEvent<SubmitRegistrationEvent>((event, emit) async {
      emit(state.copyWith(processing: true));
      await _registerUseCase.call(
        RegisterParam(
          name: state.name,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
        ),
      );
      emit(state.copyWith(processing: false, isSuccess: true));
    });
  }

  final RegisterUseCase _registerUseCase;
}
