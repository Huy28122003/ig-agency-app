part of 'dashboard_home_bloc.dart';

class DashboardHomeState extends BaseState<DashboardHomeState> {
  final int totalMember;
  final List<OverviewMemberEntity> listOverviewMember;
  final List<OverviewDashboardEntity> listOverviewDashboard;

  const DashboardHomeState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.totalMember = 0,
    this.listOverviewMember = const [],
    this.listOverviewDashboard = const [],
  });

  @override
  DashboardHomeState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    int? totalMember,
    List<OverviewMemberEntity>? listOverviewMember,
    List<OverviewDashboardEntity>? listOverviewDashboard,
  }) {
    return DashboardHomeState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      totalMember: totalMember ?? this.totalMember,
      listOverviewMember: listOverviewMember ?? this.listOverviewMember,
      listOverviewDashboard: listOverviewDashboard ?? this.listOverviewDashboard,
    );
  }

  @override
  List<Object?> get props => [...super.props, totalMember, listOverviewMember, listOverviewDashboard];
}
