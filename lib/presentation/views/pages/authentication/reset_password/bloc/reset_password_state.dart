part of 'reset_password_bloc.dart';

class ResetPasswordState extends BaseState<ResetPasswordState> {
  final String? errorMessage;
  final VerifyStatus verifyStatus;
  final String newPassword;
  final String confirmPassword;
  final String email;
  final String otpVerified;
  final bool isResetSuccess;

  const ResetPasswordState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.errorMessage = "",
    this.verifyStatus = VerifyStatus.initial,
    this.newPassword = "",
    this.confirmPassword = "",
    this.email = "",
    this.otpVerified = "",
    this.isResetSuccess = false,
  });

  @override
  ResetPasswordState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    VerifyStatus? otpStatus,
    String? errorMessage,
    String? email,
    String? otpVerified,
    VerifyStatus? verifyStatus,
    String? newPassword,
    String? confirmPassword,
    bool? isResetSuccess,
  }) {
    return ResetPasswordState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      errorMessage: errorMessage,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      email: email ?? this.email,
      otpVerified: otpVerified ?? this.otpVerified,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isResetSuccess: isResetSuccess ?? this.isResetSuccess,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    errorMessage,
    verifyStatus,
    email,
    otpVerified,
    newPassword,
    isResetSuccess,
    confirmPassword,
  ];
}
