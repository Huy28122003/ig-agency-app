import 'dart:async';
import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../../../data/cache/ram_cache.dart';
import '../../../../domain/entities/message/message.dart';
import '../../../../domain/entities/pinned_message_summary.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/enums/message_enums.dart';

@singleton
class MessageMockService {
  final _random = Random(42);

  final Map<String, List<MessageEntity>> _messageMockData = {};

  MessageMockService(this._ramCache) {
    _initializeMockData();
  }

  final RamCache _ramCache;

  void _initializeMockData() {
    if (_messageMockData.isEmpty) {
      for (final group in _mockGroups) {
        final groupId = group["id"] as String;
        _messageMockData[groupId] = _createMockMessages(groupId);
      }
    }
  }

  // Mock user data
  static final List<Map<String, String>> _mockUsers = [
    {
      'id': '1',
      'name': 'Trần Văn A',
      'avatarUrl': 'https://placehold.co/44x44/4CAF50/FFFFFF?text=TA',
    },
    {
      'id': '2',
      'name': 'Nguyễn Thị B',
      'avatarUrl': 'https://placehold.co/44x44/2196F3/FFFFFF?text=NB',
    },
    {
      'id': '3',
      'name': 'Lê Văn C',
      'avatarUrl': 'https://placehold.co/44x44/FF9800/FFFFFF?text=LC',
    },
    {
      'id': '4',
      'name': 'Phạm Thị D',
      'avatarUrl': 'https://placehold.co/44x44/9C27B0/FFFFFF?text=PD',
    },
    {
      'id': '5',
      'name': 'Hoàng Văn E',
      'avatarUrl': 'https://placehold.co/44x44/F44336/FFFFFF?text=HE',
    },
    {
      'id': '6',
      'name': 'Vũ Thị F',
      'avatarUrl': 'https://placehold.co/44x44/607D8B/FFFFFF?text=VF',
    },
    {
      'id': '7',
      'name': 'Đặng Văn G',
      'avatarUrl': 'https://placehold.co/44x44/795548/FFFFFF?text=DG',
    },
    {
      'id': '8',
      'name': 'Bùi Thị H',
      'avatarUrl': 'https://placehold.co/44x44/009688/FFFFFF?text=BH',
    },
  ];

  static final List<Map<String, dynamic>> _mockGroups = [
    {'id': 1, 'name': 'Vaga bala blo'},
    {'id': 2, 'name': 'Team Development'},
    {'id': 3, 'name': 'Marketing Team'},
    {'id': 4, 'name': 'Design Team'},
    {'id': 5, 'name': 'Project Alpha'},
  ];

  static final List<String> _mockTexts = [
    'Send me the code pls!!!',
    'Just give me as soon as possible',
    'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
    'Can you help me with this issue?',
    'Meeting at 3 PM today',
    'Please review the latest changes',
    'Great work everyone!',
    'Don\'t forget to submit your reports',
    'Happy birthday!',
    'The project is on track',
    'Let\'s discuss this tomorrow',
    'Thanks for your help!',
    'Important announcement for all team members',
    'Please check the updated schedule',
    'The deadline has been extended',
    'New features are now available',
    'Please update your software',
    ('Hoannk alabama kamekameha\n' * 30),
  ];

  final List<String> _mockImages = [
    "https://picsum.photos/200/300",
    "https://picsum.photos/400/300",
    "https://picsum.photos/300/400",
  ];

  final List<Map<String, dynamic>> _mockVideos = [
    {
      "videoUrl": "https://example.com/video1.mp4",
      "duration": Duration(minutes: 1),
      "size": 10000,
      "thumbnailUrl": "https://picsum.photos/200/300",
    },
    {
      "videoUrl": "https://example.com/video2.mp4",
      "duration": Duration(minutes: 3),
      "size": 20000,
      "thumbnailUrl": "https://picsum.photos/300/400",
    },
  ];

  final List<Map<String, dynamic>> _mockFiles = [
    {
      "fileUrl": "https://example.com/file1.pdf",
      "fileName": "Tài liệu A",
      "fileExtension": "pdf",
      "fileSize": 10240,
      "fileType": FileType.document,
    },
    {
      "fileUrl": "https://example.com/file2.zip",
      "fileName": "Source Code",
      "fileExtension": "zip",
      "fileSize": 20480,
      "fileType": FileType.archive,
    },
  ];

  final List<String> _mockLinks = ["https://flutter.dev", "https://dart.dev"];

  final List<Map<String, dynamic>> _mockSystems = [
    {
      "systemType": SystemMessageType.userJoined,
      "message": "User joined the group",
    },
  ];

  final List<Map<String, dynamic>> _mockStickers = [
    {
      "stickerUrl": "https://example.com/sticker1.png",
      "width": 100,
      "height": 100,
    },
  ];

  final List<Duration> _timeSteps = [
    Duration(minutes: 1),
    Duration(minutes: 5),
    Duration(hours: 1),
    Duration(hours: 5),
    Duration(days: 1),
    Duration(days: 5),
  ];

  (String, List<TextSegment>) mockText() {
    final caseType = _random.nextInt(4); // 0..3
    final segments = <TextSegment>[];
    final buffer = StringBuffer();

    void addSegment(String value, TextSegmentType type) {
      final start = buffer.length;
      buffer.write(value);
      final end = buffer.length;
      segments.add(TextSegment(start: start, end: end, type: type));
    }

    switch (caseType) {
      case 0:
        // Normal only
        addSegment(
          _mockTexts[_random.nextInt(_mockTexts.length)],
          TextSegmentType.normal,
        );
        break;

      case 1:
        // Text + mention
        addSegment(
          "${_mockTexts[_random.nextInt(_mockTexts.length)]} ",
          TextSegmentType.normal,
        );
        final user = _mockUsers[_random.nextInt(_mockUsers.length)];
        addSegment("@${user['name']}", TextSegmentType.tag);
        break;

      case 2:
        // Text + link
        addSegment(
          "${_mockTexts[_random.nextInt(_mockTexts.length)]} ",
          TextSegmentType.normal,
        );
        final link = _mockLinks[_random.nextInt(_mockLinks.length)];
        addSegment(link, TextSegmentType.link);
        break;

      case 3:
        // Mention + text + link
        final user = _mockUsers[_random.nextInt(_mockUsers.length)];
        addSegment("@${user['name']} ", TextSegmentType.tag);
        addSegment(
          "${_mockTexts[_random.nextInt(_mockTexts.length)]} ",
          TextSegmentType.normal,
        );
        final link = _mockLinks[_random.nextInt(_mockLinks.length)];
        addSegment(link, TextSegmentType.link);
        break;
    }

    return (buffer.toString(), segments);
  }

  List<MessageEntity> _createMockMessages(String groupId, {int count = 50}) {
    DateTime current = DateTime.now();
    current = current.subtract(Duration(days: 365));

    final List<MessageEntity> messages = [];

    for (int i = 0; i < count; i++) {
      current = current.add(_timeSteps[_random.nextInt(_timeSteps.length)]);

      final type = MessageContentType
          .values[_random.nextInt(MessageContentType.values.length)];
      final content = _generateContent(type);

      MessageEntity? reply;
      if (messages.isNotEmpty && _random.nextDouble() < 0.3 && i != 0) {
        final message = messages[_random.nextInt(messages.length)];
        if (message.content.isNotSystem) {
          reply = message;
        }
      }

      final user = _mockUsers[_random.nextInt(_mockUsers.length)];

      messages.add(
        MessageEntity(
          id: "msg_${groupId}_${current.millisecondsSinceEpoch}",
          user: UserSummary(
            id: user['id']!,
            name: user['name']!,
            avatar: user['avatarUrl']!,
          ),
          createdAt: current,
          content: content,
          status: MessageStatus.sent,
          groupId: groupId,
          repliedMessage: reply,
          isPinned: type == MessageContentType.system
              ? false
              : _random.nextBool(),
          pinnedAt: type == MessageContentType.system ? null : current,
        ),
      );
    }

    return messages;
  }

  MessageContent _generateContent(MessageContentType type) {
    switch (type) {
      case MessageContentType.text:
        final (text, segments) = mockText();
        return TextMessageContent(text: text, textSegments: segments);
      case MessageContentType.image:
        final imageUrl = _mockImages[_random.nextInt(_mockImages.length)];
        final (width, height) = extractDimensions(imageUrl);
        return ImageMessageContent(
          imageUrl: imageUrl,
          width: width,
          height: height,
        );
      case MessageContentType.video:
        final video = _mockVideos[_random.nextInt(_mockVideos.length)];
        final thumbnailUrl = video['thumbnailUrl'];
        final (width, height) = extractDimensions(thumbnailUrl);
        return VideoMessageContent(
          videoUrl: video['videoUrl'],
          duration: video['duration'],
          thumbnailUrl: thumbnailUrl,
          width: width,
          height: height,
        );
      case MessageContentType.file:
        final file = _mockFiles[_random.nextInt(_mockFiles.length)];
        return FileMessageContent(
          fileUrl: file['fileUrl'],
          fileName: file['fileName'],
          fileExtension: file['fileExtension'],
          fileSize: file['fileSize'],
          fileType: file['fileType'],
        );
      case MessageContentType.system:
        final sys = _mockSystems[_random.nextInt(_mockSystems.length)];
        return SystemMessageContent(
          systemType: sys['systemType'],
          message: sys['message'],
        );
      case MessageContentType.sticker:
        final sticker = _mockStickers[_random.nextInt(_mockStickers.length)];
        return StickerMessageContent(
          stickerUrl: sticker['stickerUrl'],
          width: sticker['width'],
          height: sticker['height'],
          fileSize: null,
        );
    }
  }

  (double?, double?) extractDimensions(String url) {
    try {
      final regexWidthHeight = RegExp(r'/(\d+)/(\d+)(?:/|$|\?|#)');
      final matchWidthHeight = regexWidthHeight.firstMatch(url);

      if (matchWidthHeight != null) {
        final width = double.tryParse(matchWidthHeight.group(1)!);
        final height = double.tryParse(matchWidthHeight.group(2)!);

        if (width != null && height != null) {
          return (width, height);
        }
      }

      final regexWidthOnly = RegExp(r'/(\d+)(?:/|$|\?|#)');
      final matchWidthOnly = regexWidthOnly.firstMatch(url);

      if (matchWidthOnly != null) {
        final width = double.tryParse(matchWidthOnly.group(1)!);
        if (width != null) {
          return (width, width); // width = height
        }
      }

      return (null, null);
    } catch (e) {
      return (null, null);
    }
  }

  // Mock function call
  List<MessageEntity> mockFetchPinnedMessages({
    String? groupId,
    int limit = 10,
    int offset = 0,
  }) {
    if (groupId != null) {
      final messages = _messageMockData[groupId];

      if (messages == null || messages.isEmpty) {
        return [];
      }

      final allPinnedMessages = messages
          .where((element) => element.isPinned)
          .toList();

      final pinnedMessages = allPinnedMessages
          .skip(offset)
          .take(limit)
          .toList();

      return pinnedMessages;
    }

    final messages = _messageMockData.values.expand((e) => e).toList();

    if (messages.isEmpty) {
      return [];
    }

    final allPinnedMessages = messages
        .where((element) => element.isPinned)
        .toList();

    final pinnedMessages = allPinnedMessages.skip(offset).take(limit).toList();

    return pinnedMessages;
  }

  Future<void> mockUnpinMessage(String messageId) async {
    MessageEntity? targetMessage;
    String? targetGroupId;
    int? targetMessageIndex;

    for (final entry in _messageMockData.entries) {
      final groupId = entry.key;
      final messages = entry.value;

      final messageIndex = messages.indexWhere(
        (message) => message.id == messageId,
      );
      if (messageIndex != -1) {
        targetMessage = messages[messageIndex];
        targetGroupId = groupId.toString();
        targetMessageIndex = messageIndex;
        break;
      }
    }

    if (targetMessage == null ||
        targetMessageIndex == null ||
        targetGroupId == null) {
      throw Exception('Message not found');
    }

    if (!targetMessage.isPinned) {
      throw Exception('Message is not pinned');
    }

    final updatedMessage = targetMessage.copyWith(
      isPinned: false,
      pinnedAt: null,
    );

    final messages = _messageMockData[targetGroupId]!;
    messages[targetMessageIndex] = updatedMessage;
    _messageMockData[targetGroupId] = messages;
  }

  Future<void> mockPinMessage(String messageId) async {
    MessageEntity? targetMessage;
    String? targetGroupId;
    int? targetMessageIndex;

    for (final entry in _messageMockData.entries) {
      final groupId = entry.key;
      final messages = entry.value;

      final messageIndex = messages.indexWhere(
        (message) => message.id == messageId,
      );
      if (messageIndex != -1) {
        targetMessage = messages[messageIndex];
        targetGroupId = groupId.toString();
        targetMessageIndex = messageIndex;
        break;
      }
    }

    if (targetMessage == null ||
        targetMessageIndex == null ||
        targetGroupId == null) {
      throw Exception('Message not found');
    }

    if (targetMessage.isPinned) {
      throw Exception('Message is already pinned');
    }

    final updatedMessage = targetMessage.copyWith(
      isPinned: true,
      pinnedAt: DateTime.now(),
    );

    final messages = _messageMockData[targetGroupId]!;
    messages[targetMessageIndex] = updatedMessage;
    _messageMockData[targetGroupId] = messages;
  }

  PinnedMessageSummary mockGetPinnedMessageSummary(String groupId) {
    final pinnedMessages = (_messageMockData[groupId] ?? [])
        .where((element) => element.isPinned)
        .toList();

    if (pinnedMessages.isEmpty) {
      return PinnedMessageSummary(totalPinnedMessages: 0);
    }

    return PinnedMessageSummary(
      latestMessage: pinnedMessages.lastOrNull,
      totalPinnedMessages: pinnedMessages.length,
    );
  }

  List<MessageEntity> mockFetchMessagesByGroupId({
    required String groupId,
    int limit = 10,
    String? oldestMessageId,
    String? targetMessageId,
  }) {
    final messages = _messageMockData[groupId];
    if (messages == null || messages.isEmpty) {
      return [];
    }

    var messageIndex = 0;

    if (oldestMessageId == null) {
      messageIndex = messages.length - 1;
    } else {
      messageIndex = messages.indexWhere(
        (message) => message.id == oldestMessageId,
      );
      if (messageIndex == -1) {
        throw Exception();
      }
    }

    var offset = 0;

    if (targetMessageId != null) {
      final targetMessageIndex = messages.indexWhere(
        (message) => message.id == targetMessageId,
      );
      if (targetMessageIndex == -1) {
        throw Exception();
      } else {
        offset = max(0, targetMessageIndex);
        if (targetMessageIndex >= messageIndex) {
          throw Exception();
        }
        final filteredMessages = messages
            .skip(offset)
            .take(messageIndex - targetMessageIndex)
            .toList();
        return filteredMessages;
      }
    }

    offset = max(0, messageIndex + 1 - limit);

    if (offset == 0) {
      return [];
    }

    final newLimit = limit >= messageIndex ? limit : (messageIndex + 1);

    final filteredMessages = messages.skip(offset).take(newLimit).toList();
    return filteredMessages;
  }

  UserEntity? getUserById(String userId) {
    final userData = _mockUsers
        .where((element) => element['id'] == userId)
        .firstOrNull;

    if (userData == null) {
      return null;
    }

    return UserEntity(
      id: userData['id']!,
      name: userData['name']!,
      email: '',
      avatar: userData['avatarUrl']!,
    );
  }

  Future<void> addMessage(
    String userId,
    String groupId,
    String? replyMessageId,
    dynamic content,
  ) async {
    final messageId = "msg_${groupId}_${DateTime.now().millisecondsSinceEpoch}";

    final user =
        getUserById(userId) ??
        UserEntity(id: userId, name: 'Unknown', email: '', avatar: '');

    final type = switch (content) {
      TextMessageContent _ => MessageContentType.text,
      ImageMessageContent _ => MessageContentType.image,
      VideoMessageContent _ => MessageContentType.video,
      FileMessageContent _ => MessageContentType.file,
      _ => throw Exception(),
    };

    MessageEntity? reply;
    if (replyMessageId != null) {
      final replyMessage = _messageMockData[groupId]
          ?.where((message) => message.id == replyMessageId)
          .firstOrNull;
      reply = replyMessage;
    }

    final sentMessage = MessageEntity(
      id: messageId,
      user: UserSummary(id: user.id, name: user.name, avatar: user.avatar),
      repliedMessage: reply,
      status: MessageStatus.sent,
      createdAt: DateTime.now(),
      content: switch (content) {
        TextMessageContent _ => content,
        _ => _generateContent(type),
      },
      groupId: groupId,
    );

    if (_messageMockData[groupId] == null) {
      _messageMockData[groupId] = [];
    }
    _messageMockData[groupId]?.add(sentMessage);
    _ramCache.saveMessage(sentMessage);
  }

  List<UserEntity> mockGetMemberInGroup(String groupId) {
    return _mockUsers
        .map(
          (e) => UserEntity(
            id: e['id']!,
            name: e['name']!,
            email: '',
            avatar: e['avatarUrl']!,
            isOnline: _random.nextBool(),
          ),
        )
        .toList();
  }

  List<UserEntity> mockSearchMemberInGroup(String groupId, String query) {
    return _mockUsers
        .map(
          (e) => UserEntity(
            id: e['id']!,
            name: e['name']!,
            email: '',
            avatar: e['avatarUrl']!,
          ),
        )
        .where((e) => e.name.contains(query))
        .toList();
  }

  Future<void> mockDeleteMessageForEveryone(String messageId) async {
    for (final groupId in _messageMockData.keys) {
      _messageMockData[groupId]?.removeWhere(
        (message) => message.id == messageId,
      );
    }
  }

  Future<void> mockDeleteMessageForYou(String messageId) async {
    mockDeleteMessageForEveryone(messageId);
  }
}
