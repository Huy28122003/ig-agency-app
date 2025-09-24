part of 'forward_bloc.dart';

class ForwardEvent {}

class LoadDataEvent extends ForwardEvent{}

class GetDataEvent extends ForwardEvent{}

class ChangeKeyWordEvent extends ForwardEvent{
  final String value;

  ChangeKeyWordEvent({required this.value});
}

class SearchDebouncedEvent extends ForwardEvent {
  final String value;

  SearchDebouncedEvent(this.value);
}

class SearchEvent extends ForwardEvent {
  final String value;

  SearchEvent({required this.value});
}

class SendMessageToGroupEvent extends ForwardEvent{
  final String groupId;

  SendMessageToGroupEvent({required this.groupId});
}

