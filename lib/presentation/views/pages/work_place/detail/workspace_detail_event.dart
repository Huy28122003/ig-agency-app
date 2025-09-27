part of 'workspace_detail_bloc.dart';

sealed class WSDetailEvent {
  const WSDetailEvent();
}

class LoadDataEvent extends WSDetailEvent {
  final bool isSearchMode;

  const LoadDataEvent(this.isSearchMode);
}

class ReplyToMessageEvent extends WSDetailEvent {
  const ReplyToMessageEvent({required this.message});

  final MessageEntity message;
}

class CloseReplyMessageEvent extends WSDetailEvent {
  const CloseReplyMessageEvent();
}

class ToggleShowScrollToBottomIcon extends WSDetailEvent {
  const ToggleShowScrollToBottomIcon();
}

class ResetScrollToBottomEvent extends WSDetailEvent {
  const ResetScrollToBottomEvent();
}

class SendMessageEvent extends WSDetailEvent {
  const SendMessageEvent({required this.type});

  final SendMessageType type;
}

class AddMessageEvent extends WSDetailEvent {
  const AddMessageEvent({required this.message});

  final MessageEntity message;
}

class ToggleHasOptionsEvent extends WSDetailEvent {
  const ToggleHasOptionsEvent({required this.showOptions});

  final bool showOptions;
}

class ToggleHasSendButtonEvent extends WSDetailEvent {
  const ToggleHasSendButtonEvent({required this.showSendButton});

  final bool showSendButton;
}

class ToggleShowTagOverlayEvent extends WSDetailEvent {
  const ToggleShowTagOverlayEvent({required this.showTagOverlay});

  final bool showTagOverlay;
}

class SearchMembersEvent extends WSDetailEvent {
  const SearchMembersEvent({required this.query});

  final String query;
}

class JumpToMessageEvent extends WSDetailEvent {
  const JumpToMessageEvent({required this.messageId});

  final String messageId;
}

class ToggleShowTimeEvent extends WSDetailEvent {
  const ToggleShowTimeEvent({required this.messageId});

  final String messageId;
}

class TogglePinMessageFromDetailEvent extends WSDetailEvent {
  const TogglePinMessageFromDetailEvent({required this.messageId});

  final String messageId;
}

class GetPinnedMessageSummaryEvent extends WSDetailEvent {
  const GetPinnedMessageSummaryEvent();
}

class LoadMoreChatMessagesEvent extends WSDetailEvent {
  const LoadMoreChatMessagesEvent();
}

class DeleteMessageForEveryoneEvent extends WSDetailEvent {
  const DeleteMessageForEveryoneEvent({required this.messageId});

  final String messageId;
}

class DeleteMessageForYouEvent extends WSDetailEvent {
  const DeleteMessageForYouEvent({required this.messageId});

  final String messageId;
}

class DeleteConversationEvent extends WSDetailEvent {
  const DeleteConversationEvent();
}

class CancelSearchEvent extends WSDetailEvent {}

class SearchMessageEvent extends WSDetailEvent {
  SearchMessageEvent();
}

class SearchMessageDebouncedEvent extends WSDetailEvent {
  final String value;

  SearchMessageDebouncedEvent({required this.value});
}

class SearchKeywordChangeEvent extends WSDetailEvent {
  final String value;

  SearchKeywordChangeEvent({required this.value});
}

class GoToMessageEvent extends WSDetailEvent {
  final bool isGoUp;

  GoToMessageEvent({this.isGoUp = false});
}

class OnShowGroupInfoEvent extends WSDetailEvent {
  OnShowGroupInfoEvent();
}
