part of 'login_bloc.dart';

sealed class LoginEvent {
  const LoginEvent();
}

class LoadDataEvent extends LoginEvent {
  const LoadDataEvent();
}

class SubmitLoginEvent extends LoginEvent {
  const SubmitLoginEvent();
}
