part of 'add_to_group_bloc.dart';

sealed class AddToGroupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDataEvent extends AddToGroupEvent {}

class LoadMoreDataEvent extends AddToGroupEvent {}

class SearchKeyWordChangedEvent extends AddToGroupEvent {
  SearchKeyWordChangedEvent(this.searchKeyWord);

  final String searchKeyWord;

  @override
  List<Object?> get props => [searchKeyWord];
}

class SelectGroupEvent extends AddToGroupEvent {
  SelectGroupEvent(this.group, this.isSelected);

  final WorkspaceEntity group;
  final bool isSelected;

  @override
  List<Object?> get props => [group, isSelected];
}

class SubmitAddToGroupEvent extends AddToGroupEvent {}
