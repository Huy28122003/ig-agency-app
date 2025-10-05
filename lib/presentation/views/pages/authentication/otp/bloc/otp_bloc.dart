import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../domain/usecases/verify_otp_code_use_case.dart';

part 'otp_event.dart';

part 'otp_state.dart';

@injectable
class OtpBloc extends BaseBloc<OtpEvent, OtpState> {
  final VerifyOtpCodeUseCase _verifyOtpCodeUseCase;

  OtpBloc(this._verifyOtpCodeUseCase) : super(OtpState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          email: event.email,
          otpVerified: event.otpVerified,
        ),
      );
    });

    on<VerifyOtpEvent>((event, emit) async {
      try {
        emit(state.copyWith(processing: true));
        await _verifyOtpCodeUseCase.call(
          VerifyOtpParam(state.otpVerified, state.email),
        );
        emit(state.copyWith(otpStatus: VerifyStatus.valid));
      } catch (e) {
        emit(state.copyWith(otpStatus: VerifyStatus.invalid));
        handleError(emit, e);
      }
    });
  }
}
