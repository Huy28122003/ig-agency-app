part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent {
  const ChangePasswordEvent();
}

class LoadDataEvent extends ChangePasswordEvent {
  const LoadDataEvent();
}

class CurrentPasswordChangedEvent extends ChangePasswordEvent {
  const CurrentPasswordChangedEvent(this.currentPassword);

  final String currentPassword;
}

class NewPasswordChangedEvent extends ChangePasswordEvent {
  const NewPasswordChangedEvent(this.newPassword);

  final String newPassword;
}

class ConfirmPasswordChangedEvent extends ChangePasswordEvent {
  const ConfirmPasswordChangedEvent(this.confirmPassword);

  final String confirmPassword;
}

class SavePasswordEvent extends ChangePasswordEvent {
  const SavePasswordEvent();
}
