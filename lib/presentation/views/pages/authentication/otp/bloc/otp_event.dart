part of 'otp_bloc.dart';

sealed class OtpEvent {}

class LoadDataEvent extends OtpEvent {
  final String email;

  LoadDataEvent(this.email);
}

class VerifyOtpEvent extends OtpEvent {
  final String otpFromUser;

  VerifyOtpEvent({required this.otpFromUser});
}
