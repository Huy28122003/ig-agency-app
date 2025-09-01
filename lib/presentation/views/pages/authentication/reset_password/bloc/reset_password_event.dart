part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent {}

class LoadDataEvent extends ResetPasswordEvent {
  final String email;
  LoadDataEvent(this.email);
}

class NewPasswordChangedEvent extends ResetPasswordEvent {
  final String newPassword;

  NewPasswordChangedEvent({required this.newPassword});
}

class ConfirmPasswordChangedEvent extends ResetPasswordEvent {
  final String confirmPassword;

  ConfirmPasswordChangedEvent({required this.confirmPassword});
}

class ConfirmResetPasswordEvent extends ResetPasswordEvent {
  ConfirmResetPasswordEvent();
}
