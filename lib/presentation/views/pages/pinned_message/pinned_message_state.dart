part of 'pinned_message_bloc.dart';

class PinnedMessageState extends BaseState<PinnedMessageState> {
  const PinnedMessageState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.messages = const [],
  });

  final List<MessageEntity> messages;

  @override
  PinnedMessageState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    List<MessageEntity>? messages,
  }) {
    return PinnedMessageState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}
