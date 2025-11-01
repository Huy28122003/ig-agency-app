part of 'profile_bloc.dart';

class ProfileState extends BaseState<ProfileState> {
  const ProfileState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.isDeleteAccountSuccess = false,
    this.user,
    this.email = '',
    this.newAvatar = '',
  });

  final bool isDeleteAccountSuccess;
  final ProfileInfoEntity? user;
  final String email;
  final String newAvatar;

  @override
  ProfileState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    bool? isDeleteAccountSuccess,
    ProfileInfoEntity? user,
    String? email,
    String? newAvatar,
  }) {
    return ProfileState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      isDeleteAccountSuccess:
          isDeleteAccountSuccess ?? this.isDeleteAccountSuccess,
      user: user ?? this.user,
      email: email ?? this.email,
      newAvatar: newAvatar ?? this.newAvatar,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isDeleteAccountSuccess,
    user,
    email,
    newAvatar,
  ];
}
