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
