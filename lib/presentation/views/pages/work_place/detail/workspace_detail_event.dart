part of 'workspace_detail_bloc.dart';

sealed class WSDetailEvent {
  const WSDetailEvent();
}

class LoadDataEvent extends WSDetailEvent {
  const LoadDataEvent();
}
