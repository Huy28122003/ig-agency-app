part of 'create_group_bloc.dart';

class CreateGroupState extends BaseState<CreateGroupState> {
  final Pagination pagination;
  final String searchKeyWord;
  final String groupName;

  final List<UserEntity> listUser;
  final List<UserEntity> listSelectedUser;
  final bool createGroupSuccess;

  const CreateGroupState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.pagination = const Pagination(),
    this.searchKeyWord = "",
    this.groupName = "",
    this.listUser = const [],
    this.listSelectedUser = const [],
    this.createGroupSuccess = false,
  });

  @override
  CreateGroupState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    int? totalMember,
    Pagination? pagination,
    String? searchKeyWord,
    String? groupName,
    List<UserEntity>? listUser,
    List<UserEntity>? listSelectedUser,
    bool? createGroupSuccess,
  }) {
    return CreateGroupState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      pagination: pagination ?? this.pagination,
      searchKeyWord: searchKeyWord ?? this.searchKeyWord,
      groupName: groupName ?? this.groupName,
      listUser: listUser ?? this.listUser,
      listSelectedUser: listSelectedUser ?? this.listSelectedUser,
      createGroupSuccess: createGroupSuccess ?? this.createGroupSuccess,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    pagination,
    searchKeyWord,
    groupName,
    listUser,
    listSelectedUser,
    createGroupSuccess,
  ];
}
