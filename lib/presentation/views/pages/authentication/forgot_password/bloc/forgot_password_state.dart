part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends BaseState<ForgotPasswordState> {
  const ForgotPasswordState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.email = "",
    this.errorMessage,
    this.otp = "",
  });

  final String email;
  final String? errorMessage;
  final String otp;

  bool get isEnableSendCode => email.isNotEmpty && errorMessage == null;

  @override
  ForgotPasswordState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? email,
    String? errorMessage,
    String? otp,
  }) {
    return ForgotPasswordState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      email: email ?? this.email,
      errorMessage: errorMessage,
      otp: otp ?? this.otp,
    );
  }

  @override
  List<Object?> get props => [...super.props, email, errorMessage, otp];
}
