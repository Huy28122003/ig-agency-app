class GroupEntity {
  final String id;
  final String groupAvatar;
  final String groupName;
  // final String lastMessage;
  // final DateTime? lastMessageTime;
  // final bool isSeen;
  final bool isMute;
  // final bool isPin;
  final int countNewMessage;
  final int countMember;
  final String bio;
  final int countPin;

  GroupEntity({
    required this.id,
    required this.groupAvatar,
    required this.groupName,
    // this.lastMessage = "",
    //  this.lastMessageTime,
    // required this.isSeen,
    required this.isMute,
    // required this.isPin,
    this.countNewMessage = 0,
    this.countMember = 0,
    this.countPin = 0,
    this.bio = '',
  });

  GroupEntity copyWith({
    String? id,
    String? groupAvatar,
    String? groupName,
    // String? lastMessage,
    // DateTime? lastMessageTime,
    // bool? isSeen,
    // bool? isPin,
    bool? isMute,
    int? countNewMessage,
    int? countMember,
    int? countPin,
    String? bio,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      groupAvatar: groupAvatar ?? this.groupAvatar,
      groupName: groupName ?? this.groupName,
      // lastMessage: lastMessage ?? this.lastMessage,
      // lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      // isSeen: isSeen ?? this.isSeen,
      isMute: isMute ?? this.isMute,
      // isPin: isPin ?? this.isPin,
      countNewMessage: countNewMessage ?? this.countNewMessage,
      countMember: countMember ?? this.countMember,
      countPin: countPin ?? this.countPin,
      bio: bio ?? this.bio,
    );
  }
}
