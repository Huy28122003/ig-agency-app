part of 'chat_input_cubit.dart';

class ChatInputState {
  const ChatInputState({
    this.users = const [],
    this.hasOptions = true,
    this.hasSendButton = false,
  });

  final List<UserEntity> users;
  final bool hasOptions;
  final bool hasSendButton;

  ChatInputState copyWith({
    List<UserEntity>? users,
    bool? hasOptions,
    bool? hasSendButton,
  }) {
    return ChatInputState(
      users: users ?? this.users,
      hasOptions: hasOptions ?? this.hasOptions,
      hasSendButton: hasSendButton ?? this.hasSendButton,
    );
  }
}
