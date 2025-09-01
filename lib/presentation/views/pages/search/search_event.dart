part of 'search_bloc.dart';

sealed class SearchEvent {
  const SearchEvent();
}

class LoadData extends SearchEvent {}

class ShowResultChanged extends SearchEvent {
  final bool isEnable;

  ShowResultChanged(this.isEnable);
}

class SearchData extends SearchEvent {}

class LoadMoreResult extends SearchEvent {}

class FilterTypeChanged extends SearchEvent {
  final FilterType type;

  FilterTypeChanged(this.type);
}

class SearchTextChanged extends SearchEvent {
  final String text;

  SearchTextChanged(this.text);
}
