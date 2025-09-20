part of 'edit_bio_bloc.dart';

class EditBioState extends BaseState<EditBioState> {
  const EditBioState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.user,
    this.bio = '',
    this.isSaveSuccess = false,
  });

  final ProfileInfoEntity? user;
  final String bio;
  final bool isSaveSuccess;

  bool get isBioChanged => bio.isNotEmpty && bio != user?.bio;

  @override
  EditBioState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    ProfileInfoEntity? user,
    String? bio,
    bool? isSaveSuccess,
  }) {
    return EditBioState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      user: user ?? this.user,
      bio: bio ?? this.bio,
      isSaveSuccess: isSaveSuccess ?? this.isSaveSuccess,
    );
  }

  @override
  List<Object?> get props => [...super.props, user, bio, isSaveSuccess];
}
