part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class OnForegroundMessageEvent extends AppEvent {}

final class OnBackgroundMessageEvent extends AppEvent {}
