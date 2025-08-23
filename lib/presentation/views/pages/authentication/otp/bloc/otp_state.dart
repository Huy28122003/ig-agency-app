part of 'otp_bloc.dart';

class OtpState extends BaseState<OtpState> {
  final OtpStatus otpStatus;

  @override
  OtpState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    OtpStatus? otpStatus,
  }) {
    return OtpState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      otpStatus: otpStatus ?? this.otpStatus,
    );
  }

  OtpState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.otpStatus = OtpStatus.initial,
  });

  @override
  List<Object?> get props => [...super.props, otpStatus];
}
