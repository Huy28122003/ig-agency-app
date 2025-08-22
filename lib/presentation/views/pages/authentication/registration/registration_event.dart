part of 'registration_bloc.dart';

sealed class RegistrationEvent {
  const RegistrationEvent();
}

class LoadDataEvent extends RegistrationEvent {
  const LoadDataEvent();
}

class SubmitRegistrationEvent extends RegistrationEvent {
  const SubmitRegistrationEvent();
}

class NameChangedEvent extends RegistrationEvent {
  const NameChangedEvent(this.name);

  final String name;
}

class EmailChangedEvent extends RegistrationEvent {
  const EmailChangedEvent(this.email);

  final String email;
}

class PasswordChangedEvent extends RegistrationEvent {
  const PasswordChangedEvent(this.password);

  final String password;
}

class ConfirmPasswordChangedEvent extends RegistrationEvent {
  const ConfirmPasswordChangedEvent(this.confirmPassword);

  final String confirmPassword;
}

class TogglePasswordVisibilityEvent extends RegistrationEvent {
  const TogglePasswordVisibilityEvent();
}

class ToggleConfirmPasswordVisibilityEvent extends RegistrationEvent {
  const ToggleConfirmPasswordVisibilityEvent();
}
