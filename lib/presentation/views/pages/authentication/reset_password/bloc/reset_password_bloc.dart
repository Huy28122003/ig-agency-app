import 'package:ig_agency_app/data/remote/models/requests/forgot_password_request_model.dart';
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
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          email: event.email,
          otpVerified: event.otpVerified,
        ),
      );
    });

    handleSubEvent<NewPasswordChangedEvent>((event, emit) async {
      emit(state.copyWith(newPassword: event.newPassword));
    });

    handleSubEvent<ConfirmPasswordChangedEvent>((event, emit) async {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    handleSubEvent<ConfirmResetPasswordEvent>((event, emit) async {
      try {
        emit(state.copyWith(processing: true));
        await sendNewPasswordUseCase.call(
          ForgotPasswordRequestModel(
            email: state.email,
            otp: state.otpVerified,
            password: state.newPassword,
          ),
        );
        emit(
          state.copyWith(
            processing: false,
            isResetSuccess: true,
            errorMessage: '',
          ),
        );
      } catch (error) {
        handleError(emit, error);
      }
    });
  }
}
