part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends BaseState<ForgotPasswordState> {
  const ForgotPasswordState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.email = "",
    this.errorMessage,
  });

  final String email;
  final String? errorMessage;

  bool get isEnableSendCode => email.isNotEmpty;

  @override
  ForgotPasswordState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? email,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      email: email ?? this.email,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [...super.props, email, errorMessage];
}
