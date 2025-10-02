part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends BaseState<ForgotPasswordState> {
  const ForgotPasswordState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.email = "",
    this.otp = "",
    this.errorMessage,
    this.isSendMailSuccess = false,
  });

  final String email;
  final String otp;
  final String? errorMessage;
  final bool isSendMailSuccess;

  bool get isEnableSendCode => email.isNotEmpty && errorMessage == null;

  @override
  ForgotPasswordState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? email,
    String? otp,
    String? errorMessage,
    bool? isSendMailSuccess,
  }) {
    return ForgotPasswordState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      errorMessage: errorMessage,
      isSendMailSuccess: isSendMailSuccess ?? this.isSendMailSuccess,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    email,
    otp,
    errorMessage,
    isSendMailSuccess,
  ];
}
