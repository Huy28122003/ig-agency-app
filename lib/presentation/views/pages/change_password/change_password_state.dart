part of 'change_password_bloc.dart';

class ChangePasswordState extends BaseState<ChangePasswordState> {
  const ChangePasswordState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isSaveSuccess = false,
    this.isObscureCurrentPassword = true,
    this.isObscureNewPassword = true,
    this.isObscureConfirmPassword = true,
    this.errorCurrentPasswordMessage,
    this.errorNewPasswordMessage,
    this.errorConfirmPasswordMessage,
  });

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isSaveSuccess;
  final bool isObscureCurrentPassword;
  final bool isObscureNewPassword;
  final bool isObscureConfirmPassword;
  final String? errorCurrentPasswordMessage;
  final String? errorNewPasswordMessage;
  final String? errorConfirmPasswordMessage;

  bool get isFormValid =>
      currentPassword.isNotEmpty &&
      newPassword.isNotEmpty &&
      confirmPassword.isNotEmpty;

  @override
  ChangePasswordState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isSaveSuccess,
    bool? isObscureCurrentPassword,
    bool? isObscureNewPassword,
    bool? isObscureConfirmPassword,
    String? errorCurrentPasswordMessage,
    String? errorNewPasswordMessage,
    String? errorConfirmPasswordMessage,
    bool forceResetErrorMessages = false,
  }) {
    return ChangePasswordState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSaveSuccess: isSaveSuccess ?? this.isSaveSuccess,
      isObscureCurrentPassword:
          isObscureCurrentPassword ?? this.isObscureCurrentPassword,
      isObscureNewPassword: isObscureNewPassword ?? this.isObscureNewPassword,
      isObscureConfirmPassword:
          isObscureConfirmPassword ?? this.isObscureConfirmPassword,
      errorCurrentPasswordMessage: forceResetErrorMessages
          ? null
          : (errorCurrentPasswordMessage ?? this.errorCurrentPasswordMessage),
      errorNewPasswordMessage: forceResetErrorMessages
          ? null
          : (errorNewPasswordMessage ?? this.errorNewPasswordMessage),
      errorConfirmPasswordMessage: forceResetErrorMessages
          ? null
          : (errorConfirmPasswordMessage ?? this.errorConfirmPasswordMessage),
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    currentPassword,
    newPassword,
    confirmPassword,
    isSaveSuccess,
    isObscureCurrentPassword,
    isObscureNewPassword,
    isObscureConfirmPassword,
    errorCurrentPasswordMessage,
    errorNewPasswordMessage,
    errorConfirmPasswordMessage,
  ];
}
