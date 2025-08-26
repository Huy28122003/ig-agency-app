part of 'search_bloc.dart';

sealed class SearchEvent {
  const SearchEvent();
}

class LoadDataEvent extends SearchEvent {
  const LoadDataEvent();
}
