part of 'workspace_detail_bloc.dart';

class WorkspaceDetailState extends BaseState<WorkspaceDetailState> {
  const WorkspaceDetailState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.email = '',
    this.password = '',
  });

  final String email;
  final String password;

  @override
  WorkspaceDetailState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? email,
    String? password,
  }) {
    return WorkspaceDetailState(
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
