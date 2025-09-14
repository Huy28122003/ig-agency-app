part of 'edit_workspace_bio_bloc.dart';

class EditWorkspaceBioState extends BaseState<EditWorkspaceBioState> {
  const EditWorkspaceBioState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.bio = '',
    this.updateStatus,
  });

  final String bio;
  final bool? updateStatus;

  @override
  EditWorkspaceBioState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? bio,
    bool? updateStatus,
  }) {
    return EditWorkspaceBioState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      bio: bio ?? this.bio,
      updateStatus: updateStatus ?? this.updateStatus,
    );
  }

  @override
  List<Object?> get props => [...super.props, bio, updateStatus];
}
