part of 'nav_bloc.dart';

class NavState extends BaseState<NavState> {
  const NavState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing,
    this.currentIndex = 0,
  });

  final int currentIndex;

  @override
  NavState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    int? currentIndex,
  }) {
    return NavState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [...super.props, currentIndex];
}
