part of 'profile_bloc.dart';

class ProfileState extends BaseState<ProfileState> {
  const ProfileState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.isDeleteAccountSuccess = false,
    this.user,
  });

  final bool isDeleteAccountSuccess;
  final ProfileInfoEntity? user;

  @override
  ProfileState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    bool? isDeleteAccountSuccess,
    ProfileInfoEntity? user,
  }) {
    return ProfileState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      isDeleteAccountSuccess:
          isDeleteAccountSuccess ?? this.isDeleteAccountSuccess,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [...super.props, isDeleteAccountSuccess, user];
}
