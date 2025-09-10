part of 'members_bloc.dart';

class MembersState extends BaseState<MembersState> {
  const MembersState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.members = const [],
    this.countActiveMember = 0,
    this.countMember = 0,
    this.pagingStatus = PagingStatus.idle,
  });

  final List<UserEntity> members;
  final int countActiveMember;
  final int countMember;
  final PagingStatus pagingStatus;

  @override
  MembersState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    int? countActiveMember,
    int? countMember,
    List<UserEntity>? members,
    PagingStatus? pagingStatus,
  }) {
    return MembersState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      countActiveMember: countActiveMember ?? this.countActiveMember,
      countMember: countMember ?? this.countMember,
      members: members ?? this.members,
      pagingStatus: pagingStatus ?? this.pagingStatus,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    members,
    countMember,
    countActiveMember,
    pagingStatus,
  ];
}
