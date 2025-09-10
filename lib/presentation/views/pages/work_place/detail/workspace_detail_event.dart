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

class UpdateHasOptionsEvent extends WSDetailEvent {
  const UpdateHasOptionsEvent({required this.hasOptions});
  final bool hasOptions;
}

class UpdateHasSendButtonEvent extends WSDetailEvent {
  const UpdateHasSendButtonEvent({required this.hasSendButton});

  final bool hasSendButton;
}

class FetchMembersEvent extends WSDetailEvent {
  const FetchMembersEvent();
}

class SearchMembersEvent extends WSDetailEvent {
  const SearchMembersEvent({required this.query});

  final String query;
}

class LoadPinnedMessagesEvent extends WSDetailEvent {
  const LoadPinnedMessagesEvent();
}

class RefreshPinnedMessagesEvent extends WSDetailEvent {
  const RefreshPinnedMessagesEvent();
}

class LoadMorePinnedMessagesEvent extends WSDetailEvent {
  const LoadMorePinnedMessagesEvent();
}

class UnpinMessageFromDetailEvent extends WSDetailEvent {
  const UnpinMessageFromDetailEvent({required this.messageId});

  final String messageId;
}

class ResetUnpinSuccessEvent extends WSDetailEvent {
  const ResetUnpinSuccessEvent();
}

class JumpToMessageEvent extends WSDetailEvent {
  const JumpToMessageEvent({required this.messageId});

  final String messageId;
}

class ResetJumpToMessageEvent extends WSDetailEvent {
  const ResetJumpToMessageEvent();
}

class ShowTimeEvent extends WSDetailEvent {
  const ShowTimeEvent({required this.messageId});

  final String messageId;
}

class DisableShowTimeEvent extends WSDetailEvent {
  const DisableShowTimeEvent();
}

class GetPinnedMessageSummaryEvent extends WSDetailEvent {
  const GetPinnedMessageSummaryEvent();
}
