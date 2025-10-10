part of 'pinned_message_list_bloc.dart';

class PinnedMessageListEvent {}

class LoadDataEvent extends PinnedMessageListEvent {}

class LoadMorePinMessageInGroupEvent extends PinnedMessageListEvent {}

class UnpinMessageInGroupEvent extends PinnedMessageListEvent {
  final String messageId;

  UnpinMessageInGroupEvent({required this.messageId});
}
