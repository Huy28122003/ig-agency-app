part of 'otp_bloc.dart';

class OtpState extends BaseState<OtpState> {
  final VerifyStatus otpStatus;
  final String email;

  @override
  OtpState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    String? email,
    bool? processing,
    VerifyStatus? otpStatus,
  }) {
    return OtpState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      email: email ?? this.email,
      processing: processing ?? this.processing,
      otpStatus: otpStatus ?? this.otpStatus,
    );
  }

  const OtpState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.email = '',
    this.otpStatus = VerifyStatus.initial,
  });

  @override
  List<Object?> get props => [...super.props, email, otpStatus];
}
