part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent {}

class LoadDataEvent extends ResetPasswordEvent {}

class ToggleObscureNewPasswordEvent extends ResetPasswordEvent {}

class ToggleObscureConfirmPasswordEvent extends ResetPasswordEvent {}

class VerifyPasswordsEvent extends ResetPasswordEvent {
  VerifyPasswordsEvent();
}

class NewPasswordChangedEvent extends ResetPasswordEvent {
  final String newPassword;

  NewPasswordChangedEvent({required this.newPassword});
}

class ConfirmPasswordChangedEvent extends ResetPasswordEvent {
  final String confirmPassword;

  ConfirmPasswordChangedEvent({required this.confirmPassword});
}

class SendNewPasswordEvent extends ResetPasswordEvent {
  final String email;

  SendNewPasswordEvent({required this.email});
}
