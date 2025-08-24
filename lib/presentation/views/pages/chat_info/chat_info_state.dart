part of 'chat_info_bloc.dart';

class ChatInfoState extends BaseState<ChatInfoState> {
  const ChatInfoState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
  });

  @override
  ChatInfoState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
  }) {
    return ChatInfoState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}
