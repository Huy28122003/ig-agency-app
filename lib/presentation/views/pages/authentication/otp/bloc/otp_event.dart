part of 'otp_bloc.dart';

sealed class OtpEvent {}

class LoadDataEvent extends OtpEvent {}

class VerifyOtpEvent extends OtpEvent {
  final String otpFromUser;

  VerifyOtpEvent({required this.otpFromUser});
}

class ResetOtpStatusEvent extends OtpEvent {}
