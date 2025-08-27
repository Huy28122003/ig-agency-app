class WorkspaceEntity {
  final String id;
  final String workspaceAvatar;
  final String workspaceName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isSeen;

  WorkspaceEntity({
    required this.id,
    required this.workspaceAvatar,
    required this.workspaceName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isSeen,
  });

  WorkspaceEntity copyWith({
    String? workspaceAvatar,
    String? workspaceName,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return WorkspaceEntity(
      id: id,
      workspaceAvatar: workspaceAvatar ?? this.workspaceAvatar,
      workspaceName: workspaceName ?? this.workspaceName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isSeen: isSeen,
    );
  }
}
