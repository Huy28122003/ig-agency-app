part of 'pinned_message_bloc.dart';

sealed class PinnedMessageEvent {
  const PinnedMessageEvent();
}

class LoadDataEvent extends PinnedMessageEvent {
  const LoadDataEvent();
}
