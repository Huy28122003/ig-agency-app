part of 'pinned_message_bloc.dart';

class PinnedMessageState extends BaseState<PinnedMessageState> {
  const PinnedMessageState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.messages = const [],
    this.isUnpinSuccess = false,
  });

  final List<PinnedMessageUIModel> messages;
  final bool isUnpinSuccess;

  @override
  PinnedMessageState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    List<PinnedMessageUIModel>? messages,
    bool? isUnpinSuccess,
  }) {
    return PinnedMessageState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      messages: messages ?? this.messages,
      isUnpinSuccess: isUnpinSuccess ?? this.isUnpinSuccess,
    );
  }

  @override
  List<Object?> get props => [...super.props, messages, isUnpinSuccess];
}
