import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'otp_event.dart';

part 'otp_state.dart';

@injectable
class OtpBloc extends BaseBloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          email: event.email,
          otpVerified: event.otpVerified,
        ),
      );
    });

    on<VerifyOtpEvent>((event, emit) {
      emit(
        state.copyWith(
          otpStatus: event.otpFromUser == state.otpVerified
              ? VerifyStatus.valid
              : VerifyStatus.invalid,
        ),
      );
    });
  }
}
