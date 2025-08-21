part of 'workspace_list_bloc.dart';

class WorkspaceListState extends BaseState<WorkspaceListState> {
  const WorkspaceListState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.email = '',
    this.password = '',
  });

  final String email;
  final String password;

  @override
  WorkspaceListState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? email,
    String? password,
  }) {
    return WorkspaceListState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [...super.props, email, password];
}
