part of 'workspace_list_bloc.dart';

class WorkspaceListState extends BaseState<WorkspaceListState> {
  const WorkspaceListState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
  });

  @override
  WorkspaceListState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
  }) {
    return WorkspaceListState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}
