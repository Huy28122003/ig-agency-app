part of 'group_info_bloc.dart';

class GroupInfoState extends BaseState<GroupInfoState> {
  const GroupInfoState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.workspace,
  });

  final WorkspaceEntity? workspace;

  @override
  GroupInfoState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    WorkspaceEntity? workspace,
  }) {
    return GroupInfoState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      workspace: workspace ?? this.workspace,
    );
  }
}
