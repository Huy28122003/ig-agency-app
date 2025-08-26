part of 'shared_content_bloc.dart';

sealed class SharedContentEvent {
  const SharedContentEvent();
}

class LoadDataEvent extends SharedContentEvent {
  const LoadDataEvent();
}
