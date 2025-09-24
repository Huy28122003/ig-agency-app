part of 'nav_bloc.dart';

class NavState extends BaseState<NavState> {
  const NavState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing,
    this.currentIndex = 0,
    this.roleSystem = RoleSystem.guest,
  });

  final int currentIndex;
  final RoleSystem roleSystem;

  @override
  NavState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    int? currentIndex,
    RoleSystem? roleSystem,
  }) {
    return NavState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      currentIndex: currentIndex ?? this.currentIndex,
      roleSystem: roleSystem ?? this.roleSystem,
    );
  }

  @override
  List<Object?> get props => [...super.props, currentIndex, roleSystem];
}
