part of 'workspace_detail_bloc.dart';

class WSDetailState extends BaseState<WSDetailState> {
  const WSDetailState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.messages = const [],
  });

  final List<MessageEntity> messages;

  @override
  WSDetailState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    List<MessageEntity>? messages,
  }) {
    return WSDetailState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [...super.props, messages];
}
