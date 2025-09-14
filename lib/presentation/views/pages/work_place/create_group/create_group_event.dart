part of 'create_group_bloc.dart';

sealed class CreateGroupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDataEvent extends CreateGroupEvent {}

class LoadMoreDataEvent extends CreateGroupEvent {}

class GroupNameChangedEvent extends CreateGroupEvent {
  GroupNameChangedEvent(this.groupName);

  final String groupName;

  @override
  List<Object?> get props => [groupName];
}

class SearchKeyWordChangedEvent extends CreateGroupEvent {
  SearchKeyWordChangedEvent(this.searchKeyWord);

  final String searchKeyWord;

  @override
  List<Object?> get props => [searchKeyWord];
}

class SelectUserEvent extends CreateGroupEvent {
  SelectUserEvent(this.user, this.isSelected);

  final UserEntity user;
  final bool isSelected;

  @override
  List<Object?> get props => [user, isSelected];
}

class SubmitCreateGroupEvent extends CreateGroupEvent {}
