part of 'otp_bloc.dart';

class OtpState extends BaseState<OtpState> {
  final VerifyStatus otpStatus;

  @override
  OtpState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    VerifyStatus? otpStatus,
  }) {
    return OtpState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      otpStatus: otpStatus ?? this.otpStatus,
    );
  }

  const OtpState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.otpStatus = VerifyStatus.initial,
  });

  @override
  List<Object?> get props => [...super.props, otpStatus];
}
