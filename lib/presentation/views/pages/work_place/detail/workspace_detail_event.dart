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

class ToggleShowScrollToBottomIcon extends WSDetailEvent {
  const ToggleShowScrollToBottomIcon();
}

class ReplyToMessageEvent extends WSDetailEvent {
  const ReplyToMessageEvent({required this.message});

  final MessageEntity message;
}

class SendMessageEvent extends WSDetailEvent {
  const SendMessageEvent({required this.content});

  final dynamic content;
}

class ResetScrollToBottomEvent extends WSDetailEvent {
  const ResetScrollToBottomEvent();
}

class UpdateMessageEvent extends WSDetailEvent {
  const UpdateMessageEvent({required this.message});

  final MessageEntity message;
}
