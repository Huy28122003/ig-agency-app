part of 'login_bloc.dart';

class LoginState extends BaseState<LoginState> {
  const LoginState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.email = '',
    this.password = '',
    this.isSuccess = false,
  });

  final String email;
  final String password;
  final bool isSuccess;

  @override
  LoginState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? email,
    String? password,
    bool? isSuccess,
  }) {
    return LoginState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      processing: processing ?? this.processing,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [...super.props, email, password, isSuccess];
}
