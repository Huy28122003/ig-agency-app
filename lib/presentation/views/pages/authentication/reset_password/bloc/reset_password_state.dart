part of 'reset_password_bloc.dart';

class ResetPasswordState extends BaseState<ResetPasswordState> {
  final bool isObscureNewPassword;
  final bool isObscureConfirmPassword;
  final String? errorMessage;
  final VerifyStatus verifyStatus;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.isObscureNewPassword = true,
    this.isObscureConfirmPassword = true,
    this.errorMessage = "",
    this.verifyStatus = VerifyStatus.initial,
    this.newPassword = "",
    this.confirmPassword = "",
  });

  @override
  ResetPasswordState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    VerifyStatus? otpStatus,
    String? errorMessage,
    VerifyStatus? verifyStatus,
    bool? isObscureNewPassword,
    bool? isObscureConfirmPassword,
    String? newPassword,
    String? confirmPassword,
  }) {
    return ResetPasswordState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      isObscureNewPassword: isObscureNewPassword ?? this.isObscureNewPassword,
      isObscureConfirmPassword:
          isObscureConfirmPassword ?? this.isObscureConfirmPassword,
      errorMessage: errorMessage,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    isObscureConfirmPassword,
    isObscureNewPassword,
    errorMessage,
    verifyStatus,
    newPassword,
    confirmPassword,
  ];
}
