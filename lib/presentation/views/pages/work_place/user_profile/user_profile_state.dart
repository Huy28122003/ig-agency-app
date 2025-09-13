part of 'user_profile_bloc.dart';

class UserProfileState extends BaseState<UserProfileState> {
  const UserProfileState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.userId,
    this.user,
  });
  //TODO: xử lý truyền userId từ ngoài vào
  final String? userId;
  final UserEntity? user;

  @override
  UserProfileState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? userId,
    UserEntity? user,
  }) {
    return UserProfileState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      userId: userId ?? this.userId,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [...super.props, userId, user];
}
