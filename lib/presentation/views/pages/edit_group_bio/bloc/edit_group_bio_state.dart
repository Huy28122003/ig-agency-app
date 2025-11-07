part of 'edit_group_bio_bloc.dart';

class EditGroupBioState extends BaseState<EditGroupBioState> {
  const EditGroupBioState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.bio = '',
    this.updateStatus,
  });

  final String bio;
  final bool? updateStatus;

  @override
  EditGroupBioState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? bio,
    bool? updateStatus,
  }) {
    return EditGroupBioState(
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
