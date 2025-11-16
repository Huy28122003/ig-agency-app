part of 'members_bloc.dart';

class MembersState extends BaseState<MembersState> {
  const MembersState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.members = const [],
    this.pagingStatus = PagingStatus.idle,
  });

  final List<MemberEntity> members;
  final PagingStatus pagingStatus;

  @override
  MembersState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    List<MemberEntity>? members,
    PagingStatus? pagingStatus,
  }) {
    return MembersState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      members: members ?? this.members,
      pagingStatus: pagingStatus ?? this.pagingStatus,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    members,
    pagingStatus,
  ];
}
