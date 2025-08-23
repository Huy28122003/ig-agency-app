part of 'otp_bloc.dart';

sealed class OtpEvent {}

class LoadDataEvent extends OtpEvent {}

class VerifyOtpEvent extends OtpEvent {
  final String otpFromUser;
  final String otpFromServer;

  VerifyOtpEvent({required this.otpFromUser, required this.otpFromServer});
}

class ResetOtpStatusEvent extends OtpEvent {}