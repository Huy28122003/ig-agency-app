part of 'group_info_bloc.dart';

class GroupInfoState extends BaseState<GroupInfoState> {
  const GroupInfoState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.name = '',
    this.avatar = '',
    this.bio,
    this.memberCount = 0,
    this.pinnedMessageCount = 0,
    this.isMute = false,
    this.isLeaveGroupSuccess,
  });

  final String name;
  final String avatar;
  final String? bio;
  final int memberCount;
  final int pinnedMessageCount;
  final bool isMute;
  final bool? isLeaveGroupSuccess;

  @override
  GroupInfoState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    bool? isLeaveGroupSuccess,
    String? name,
    String? avatar,
    String? bio,
    int? memberCount,
    int? pinnedMessageCount,
    bool? isMute,
  }) {
    return GroupInfoState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      avatar: avatar ?? this.avatar,
      processing: processing ?? this.processing,
      isLeaveGroupSuccess: isLeaveGroupSuccess ?? this.isLeaveGroupSuccess,
      bio: bio ?? this.bio,
      name: name ?? this.name,
      memberCount: memberCount ?? this.memberCount,
      pinnedMessageCount: pinnedMessageCount ?? this.pinnedMessageCount,
      isMute: isMute ?? this.isMute,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isLeaveGroupSuccess,
    name,
    bio,
    memberCount,
    pinnedMessageCount,
    isMute,
    avatar,
  ];
}
