class GroupSummary {
  final String id;
  final String avatar;
  final String name;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool isSeen;
  final bool isMute;
  final bool isPin;
  final int unReadCount;

  GroupSummary({
    required this.id,
    this.avatar = '',
    this.name = '',
    this.lastMessage = "",
    this.lastMessageTime,
    this.isSeen = false,
    this.isMute = true,
    this.isPin = false,
    this.unReadCount = 0,
  });

  GroupSummary copyWith({
    String? id,
    String? avatar,
    String? name,
    String? lastMessage,
    DateTime? lastMessageTime,
    bool? isSeen,
    bool? isPin,
    bool? isMute,
    int? unReadMessageCount,
  }) {
    return GroupSummary(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isSeen: isSeen ?? this.isSeen,
      isMute: isMute ?? this.isMute,
      isPin: isPin ?? this.isPin,
      unReadCount: unReadMessageCount ?? this.unReadCount,
    );
  }
}
