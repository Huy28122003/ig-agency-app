import 'package:ig_agency_app/domain/usecases/verify_otp_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'otp_event.dart';

part 'otp_state.dart';

@injectable
class OtpBloc extends BaseBloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  OtpBloc({required this.verifyOtpUseCase}) : super(OtpState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded, email: event.email));
    });

    handleSubEvent<VerifyOtpEvent>((event, emit) async {
      final result = await verifyOtpUseCase.call(event.otpFromUser);
      emit(
        state.copyWith(
          otpStatus: result ? VerifyStatus.valid : VerifyStatus.invalid,
        ),
      );
    });
  }
}
