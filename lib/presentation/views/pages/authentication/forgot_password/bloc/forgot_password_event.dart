part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent {}

class LoadDataEvent extends ForgotPasswordEvent {}

class EmailChangeEvent extends ForgotPasswordEvent {
  final String email;

  EmailChangeEvent({required this.email});
}

class SendOtpEvent extends ForgotPasswordEvent {}

