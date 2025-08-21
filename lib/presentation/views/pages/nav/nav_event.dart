part of 'nav_bloc.dart';

sealed class NavEvent {
  const NavEvent();
}

class LoadDataEvent extends NavEvent {
  const LoadDataEvent();
}
