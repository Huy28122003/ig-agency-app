part of 'login_bloc.dart';

sealed class LoginEvent {
  const LoginEvent();
}

class SubmitLoginEvent extends LoginEvent {
  const SubmitLoginEvent();
}

class EmailChangedEvent extends LoginEvent {
  const EmailChangedEvent(this.email);

  final String email;
}

class PasswordChangedEvent extends LoginEvent {
  const PasswordChangedEvent(this.password);

  final String password;
}

class TogglePasswordVisibilityEvent extends LoginEvent {
  const TogglePasswordVisibilityEvent();
}
