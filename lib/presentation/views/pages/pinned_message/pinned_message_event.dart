part of 'pinned_message_bloc.dart';

sealed class PinnedMessageEvent {
  const PinnedMessageEvent();
}

class LoadDataEvent extends PinnedMessageEvent {
  const LoadDataEvent();
}

class RefreshPinnedMessageEvent extends PinnedMessageEvent {
  const RefreshPinnedMessageEvent();
}

class LoadMorePinnedMessageEvent extends PinnedMessageEvent {
  const LoadMorePinnedMessageEvent();
}

class UnpinMessageEvent extends PinnedMessageEvent {
  final String messageId;

  const UnpinMessageEvent({required this.messageId});
}
