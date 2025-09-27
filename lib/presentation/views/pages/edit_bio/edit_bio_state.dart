part of 'edit_bio_bloc.dart';

class EditBioState extends BaseState<EditBioState> {
  const EditBioState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.bio = '',
    this.isSaveSuccess = false,
  });

  final String bio;
  final bool isSaveSuccess;

  @override
  EditBioState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? bio,
    bool? isSaveSuccess,
  }) {
    return EditBioState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      bio: bio ?? this.bio,
      isSaveSuccess: isSaveSuccess ?? this.isSaveSuccess,
    );
  }

  @override
  List<Object?> get props => [...super.props, bio, isSaveSuccess];
}
