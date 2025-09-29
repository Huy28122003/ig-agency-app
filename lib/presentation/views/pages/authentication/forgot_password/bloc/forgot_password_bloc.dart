import 'package:ig_agency_app/domain/usecases/send_otp_code_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/constants/string.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

@injectable
class ForgotPasswordBloc
    extends BaseBloc<ForgotPasswordEvent, ForgotPasswordState> {
  final SendOtpCodeUseCase sendOtpCodeUseCase;

  ForgotPasswordBloc({required this.sendOtpCodeUseCase})
    : super(ForgotPasswordState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });

    handleSubEvent<EmailChangeEvent>((event, emit) async {
      final isEmail = _formatValidateEmail(event.email);

      emit(
        state.copyWith(
          email: event.email,
          errorMessage: isEmail ? null : emailIncorrectFormatMessage,
        ),
      );
    });

    handleSubEvent<SendOtpEvent>((event, emit) async {
      try {
        emit(state.copyWith(processing: true));
        final result = await sendOtpCodeUseCase.call(state.email);
        emit(
          state.copyWith(
            isSendMailSuccess: true,
            otp: result.otp,
            processing: false,
          ),
        );
      } catch (error) {
        handleError(emit, error);
      }
    });

    handleSubEvent<ResetSendMailEvent>((event, emit) async {
      emit(state.copyWith(isSendMailSuccess: false));
    });
  }

  bool _formatValidateEmail(String email) {
    final regex = RegExp(r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$");
    return regex.hasMatch(email.trim());
  }
}
