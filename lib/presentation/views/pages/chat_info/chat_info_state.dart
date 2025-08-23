part of 'chat_info_bloc.dart';

class ChatInfoState extends BaseState<ChatInfoState> {
  const ChatInfoState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.email = '',
    this.password = '',
  });

  final String email;
  final String password;

  @override
  ChatInfoState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? email,
    String? password,
  }) {
    return ChatInfoState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [...super.props, email, password];
}
