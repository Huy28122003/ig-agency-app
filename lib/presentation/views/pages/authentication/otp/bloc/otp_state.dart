part of 'otp_bloc.dart';

class OtpState extends BaseState<OtpState> {
  final VerifyStatus otpStatus;
  final String email;
  final String otpVerified;

  @override
  OtpState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    String? email,
    String? otpVerified,
    bool? processing,
    VerifyStatus? otpStatus,
  }) {
    return OtpState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      email: email ?? this.email,
      otpVerified: otpVerified ?? this.otpVerified,
      processing: processing ?? this.processing,
      otpStatus: otpStatus ?? this.otpStatus,
    );
  }

  const OtpState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.email = '',
    this.otpVerified = '',
    this.otpStatus = VerifyStatus.initial,
  });

  @override
  List<Object?> get props => [...super.props, email, otpVerified, otpStatus];
}
