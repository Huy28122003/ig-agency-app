class WorkspaceEntity {
  final int id;
  final String workspaceAvatar;
  final String workspaceName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isSeen;
  final bool isMute;
  final bool isPin;
  final int countNewMessage;
  final int countMember;
  final String? bio;
  final int countPin;

  WorkspaceEntity({
    required this.id,
    required this.workspaceAvatar,
    required this.workspaceName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isSeen,
    required this.isMute,
    required this.isPin,
    this.countNewMessage = 0,
    this.countMember = 0,
    this.countPin = 0,
    this.bio,
  });

  WorkspaceEntity copyWith({
    String? workspaceAvatar,
    String? workspaceName,
    String? lastMessage,
    DateTime? lastMessageTime,
    bool? isSeen,
    bool? isPin,
    bool? isMute,
    int? countNewMessage,
    int? countMember,
    int? countPin,
    String? bio,
  }) {
    return WorkspaceEntity(
      id: id,
      workspaceAvatar: workspaceAvatar ?? this.workspaceAvatar,
      workspaceName: workspaceName ?? this.workspaceName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isSeen: isSeen ?? this.isSeen,
      isMute: isMute ?? this.isMute,
      isPin: isPin ?? this.isPin,
      countNewMessage: countNewMessage ?? this.countNewMessage,
      countMember: countMember ?? this.countMember,
      countPin: countPin ?? this.countPin,
      bio: bio ?? this.bio,
    );
  }
}
