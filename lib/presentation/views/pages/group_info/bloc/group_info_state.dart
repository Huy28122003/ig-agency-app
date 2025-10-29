part of 'group_info_bloc.dart';

class GroupInfoState extends BaseState<GroupInfoState> {
  const GroupInfoState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.workspace,
    this.isLeaveGroupSuccess,
  });

  final GroupEntity? workspace;
  final bool? isLeaveGroupSuccess;

  @override
  GroupInfoState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    bool? isLeaveGroupSuccess,
    GroupEntity? workspace,
  }) {
    return GroupInfoState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      workspace: workspace ?? this.workspace,
      isLeaveGroupSuccess: isLeaveGroupSuccess ?? this.isLeaveGroupSuccess,
    );
  }

  @override
  List<Object?> get props => [...super.props, workspace, isLeaveGroupSuccess];
}
