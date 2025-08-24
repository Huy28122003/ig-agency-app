part of 'login_bloc.dart';

class LoginState extends BaseState<LoginState> {
  const LoginState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.email = '',
    this.password = '',
    this.isSuccess = false,
    this.isObscurePassword = true,
    this.errorPasswordMessage,
    this.errorEmailMessage,
  });

  final String email;
  final String password;
  final bool isSuccess;
  final bool isObscurePassword;
  final String? errorEmailMessage;
  final String? errorPasswordMessage;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  @override
  LoginState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? email,
    String? password,
    bool? isSuccess,
    bool? isObscurePassword,
    String? errorPasswordMessage,
    String? errorEmailMessage,
    bool forceResetErrorMessages = false,
  }) {
    return LoginState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      processing: processing ?? this.processing,
      isSuccess: isSuccess ?? this.isSuccess,
      isObscurePassword: isObscurePassword ?? this.isObscurePassword,
      errorPasswordMessage: forceResetErrorMessages
          ? null
          : errorPasswordMessage ?? this.errorPasswordMessage,
      errorEmailMessage: forceResetErrorMessages
          ? null
          : errorEmailMessage ?? this.errorEmailMessage,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    email,
    password,
    isSuccess,
    isObscurePassword,
    errorPasswordMessage,
    errorEmailMessage,
  ];
}
