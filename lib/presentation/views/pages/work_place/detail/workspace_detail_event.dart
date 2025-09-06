part of 'workspace_detail_bloc.dart';

sealed class WSDetailEvent {
  const WSDetailEvent();
}

class LoadDataEvent extends WSDetailEvent {
  const LoadDataEvent();
}

class CloseReplyMessageEvent extends WSDetailEvent {
  const CloseReplyMessageEvent();
}

class UpdateScrollPositionEvent extends WSDetailEvent {
  const UpdateScrollPositionEvent({required this.isScrollToBottom});

  final bool isScrollToBottom;
}

class ReplyToMessageEvent extends WSDetailEvent {
  const ReplyToMessageEvent({required this.message});

  final MessageEntity message;
}
