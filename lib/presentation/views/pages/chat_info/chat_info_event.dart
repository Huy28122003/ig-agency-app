part of 'chat_info_bloc.dart';

sealed class ChatInfoEvent {
  const ChatInfoEvent();
}

class LoadDataEvent extends ChatInfoEvent {
  const LoadDataEvent();
}
