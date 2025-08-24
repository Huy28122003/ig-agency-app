part of 'registration_bloc.dart';

class RegistrationState extends BaseState<RegistrationState> {
  const RegistrationState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isSuccess = false,
    this.isObscurePassword = true,
    this.isObscureConfirmPassword = true,
    this.errorNameMessage,
    this.errorEmailMessage,
    this.errorPasswordMessage,
    this.errorConfirmPasswordMessage,
  });

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isSuccess;
  final bool isObscurePassword;
  final bool isObscureConfirmPassword;
  final String? errorNameMessage;
  final String? errorEmailMessage;
  final String? errorPasswordMessage;
  final String? errorConfirmPasswordMessage;

  bool get isFormValid =>
      name.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty;

  @override
  RegistrationState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isSuccess,
    bool? isObscurePassword,
    bool? isObscureConfirmPassword,
    String? errorNameMessage,
    String? errorEmailMessage,
    String? errorPasswordMessage,
    String? errorConfirmPasswordMessage,
    bool forceResetErrorMessages = false,
  }) {
    return RegistrationState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSuccess: isSuccess ?? this.isSuccess,
      processing: processing ?? this.processing,
      isObscurePassword: isObscurePassword ?? this.isObscurePassword,
      isObscureConfirmPassword:
          isObscureConfirmPassword ?? this.isObscureConfirmPassword,
      errorNameMessage: forceResetErrorMessages
          ? null
          : errorNameMessage ?? this.errorNameMessage,
      errorEmailMessage: forceResetErrorMessages
          ? null
          : errorEmailMessage ?? this.errorEmailMessage,
      errorPasswordMessage: forceResetErrorMessages
          ? null
          : errorPasswordMessage ?? this.errorPasswordMessage,
      errorConfirmPasswordMessage: forceResetErrorMessages
          ? null
          : errorConfirmPasswordMessage ?? this.errorConfirmPasswordMessage,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    email,
    password,
    confirmPassword,
    isSuccess,
    isObscurePassword,
    isObscureConfirmPassword,
    errorNameMessage,
    errorEmailMessage,
    errorPasswordMessage,
    errorConfirmPasswordMessage,
  ];
}
