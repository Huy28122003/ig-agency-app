part of 'registration_bloc.dart';

class RegistrationState extends BaseState<RegistrationState> {
  const RegistrationState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isSuccess = false,
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
    errorNameMessage,
    errorEmailMessage,
    errorPasswordMessage,
    errorConfirmPasswordMessage,
  ];
}
