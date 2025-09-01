import 'package:ig_agency_app/domain/usecases/send_new_password_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

@injectable
class ResetPasswordBloc
    extends BaseBloc<ResetPasswordEvent, ResetPasswordState> {
  final SendNewPasswordUseCase sendNewPasswordUseCase;

  ResetPasswordBloc({required this.sendNewPasswordUseCase})
    : super(ResetPasswordState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded, email: event.email));
    });

    handleSubEvent<NewPasswordChangedEvent>((event, emit) async {
      emit(state.copyWith(newPassword: event.newPassword));
    });

    handleSubEvent<ConfirmPasswordChangedEvent>((event, emit) async {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    handleSubEvent<ConfirmResetPasswordEvent>((event, emit) async {
      emit(state.copyWith(processing: true));
      await sendNewPasswordUseCase.call(
        SendNewPasswordParams(
          email: state.email,
          newPassword: state.newPassword,
        ),
      );
      await Future.delayed(const Duration(seconds: 1));

      emit(
        state.copyWith(
          processing: false,
          isResetSuccess: true,
          errorMessage: '',
        ),
      );
    });
  }
}
