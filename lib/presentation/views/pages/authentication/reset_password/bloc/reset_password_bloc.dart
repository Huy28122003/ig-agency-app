import 'package:ig_agency_app/domain/usecases/send_new_password_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/constants/string.dart';
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
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });
    handleSubEvent<ToggleObscureNewPasswordEvent>((event, emit) async {
      emit(
        ResetPasswordState(isObscureNewPassword: !state.isObscureNewPassword),
      );
    });
    handleSubEvent<ToggleObscureConfirmPasswordEvent>((event, emit) async {
      emit(
        ResetPasswordState(
          isObscureConfirmPassword: !state.isObscureConfirmPassword,
        ),
      );
    });
    handleSubEvent<VerifyPasswordsEvent>((event, emit) async {
      // Check them neu co them dieu kien ve password nhu so luong ky tu, chu cai, so, ky tu dac biet
      if (state.confirmPassword == state.newPassword) {
        emit(
          state.copyWith(verifyStatus: VerifyStatus.valid, errorMessage: null),
        );
      } else {
        emit(
          state.copyWith(
            verifyStatus: VerifyStatus.invalid,
            errorMessage: passwordDoNotMatchMessage,
          ),
        );
      }
    });

    handleSubEvent<NewPasswordChangedEvent>((event, emit) async {
      emit(state.copyWith(newPassword: event.newPassword));
    });

    handleSubEvent<ConfirmPasswordChangedEvent>((event, emit) async {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    handleSubEvent<SendNewPasswordEvent>((event, emit) async {
      emit(state.copyWith(processing: true));
      final result = await sendNewPasswordUseCase.call(
        SendNewPasswordParams(
          email: event.email,
          newPassword: state.newPassword,
        ),
      );
      await Future.delayed(const Duration(seconds: 1));

      final isSuccess = result.success && (result.data ?? false);

      emit(
        state.copyWith(
          processing: false,
          verifyStatus: VerifyStatus.initial,
          isResetSuccess: isSuccess,
        ),
      );
    });
  }
}
