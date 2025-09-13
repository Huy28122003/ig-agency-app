part of 'add_to_group_bloc.dart';

class AddToGroupState extends BaseState<AddToGroupState> {
  //TODO: xử lý truyền user từ ngoài vào
  final UserEntity user;

  final Pagination pagination;
  final String searchKeyWord;

  final List<WorkspaceEntity> listGroup;
  final List<WorkspaceEntity> listSelectedGroup;
  final bool addToGroupSuccess;

  const AddToGroupState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.user = const UserEntity(id: "", name: "", email: ""),
    this.pagination = const Pagination(),
    this.searchKeyWord = "",
    this.listGroup = const [],
    this.listSelectedGroup = const [],
    this.addToGroupSuccess = false,
  });

  @override
  AddToGroupState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    UserEntity? user,
    int? totalMember,
    Pagination? pagination,
    String? searchKeyWord,
    List<WorkspaceEntity>? listGroup,
    List<WorkspaceEntity>? listSelectedGroup,
    bool? addToGroupSuccess,
  }) {
    return AddToGroupState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      user: user ?? this.user,
      pagination: pagination ?? this.pagination,
      searchKeyWord: searchKeyWord ?? this.searchKeyWord,
      listGroup: listGroup ?? this.listGroup,
      listSelectedGroup: listSelectedGroup ?? this.listSelectedGroup,
      addToGroupSuccess: addToGroupSuccess ?? this.addToGroupSuccess,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    pagination,
    user,
    searchKeyWord,
    listGroup,
    listSelectedGroup,
    addToGroupSuccess,
  ];
}
