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
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });

    handleSubEvent<VerifyOtpEvent>((event, emit) async {
      if (event.otpFromServer == event.otpFromUser) {
        emit(state.copyWith(otpStatus: OtpStatus.valid));
      } else {
        emit(state.copyWith(otpStatus: OtpStatus.invalid));
      }
    });
    handleSubEvent<ResetOtpStatusEvent>((event, emit) async {
      emit(state.copyWith(otpStatus: OtpStatus.initial));
    });
  }
}
