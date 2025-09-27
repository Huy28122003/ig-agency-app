part of 'nav_bloc.dart';

sealed class NavEvent {
  const NavEvent();
}

class LoadDataEvent extends NavEvent {
  const LoadDataEvent();
}

class OnChangeTabEvent extends NavEvent {
  final int index;

  const OnChangeTabEvent(this.index);
}

class UpdateRoleSystemEvent extends NavEvent {
  final RoleSystem roleSystem;

  const UpdateRoleSystemEvent(this.roleSystem);
}
