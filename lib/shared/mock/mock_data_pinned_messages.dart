import 'dart:math';
import '../../domain/entities/message_entity.dart';
import '../../domain/enums/message_enums.dart';

class MockDataPinnedMessages {
  static final Random _random = Random();

  // Mock user data
  static final List<Map<String, String>> _mockUsers = [
    {
      'id': '1',
      'name': 'Trần Văn A',
      'avatar': 'https://placehold.co/44x44/4CAF50/FFFFFF?text=TA',
    },
    {
      'id': '2',
      'name': 'Nguyễn Thị B',
      'avatar': 'https://placehold.co/44x44/2196F3/FFFFFF?text=NB',
    },
    {
      'id': '3',
      'name': 'Lê Văn C',
      'avatar': 'https://placehold.co/44x44/FF9800/FFFFFF?text=LC',
    },
    {
      'id': '4',
      'name': 'Phạm Thị D',
      'avatar': 'https://placehold.co/44x44/9C27B0/FFFFFF?text=PD',
    },
    {
      'id': '5',
      'name': 'Hoàng Văn E',
      'avatar': 'https://placehold.co/44x44/F44336/FFFFFF?text=HE',
    },
    {
      'id': '6',
      'name': 'Vũ Thị F',
      'avatar': 'https://placehold.co/44x44/607D8B/FFFFFF?text=VF',
    },
    {
      'id': '7',
      'name': 'Đặng Văn G',
      'avatar': 'https://placehold.co/44x44/795548/FFFFFF?text=DG',
    },
    {
      'id': '8',
      'name': 'Bùi Thị H',
      'avatar': 'https://placehold.co/44x44/009688/FFFFFF?text=BH',
    },
  ];

  // Mock group data
  static final List<Map<String, String>> _mockGroups = [
    {'id': 'g1', 'name': 'Vaga bala blo - Tên nhóm'},
    {'id': 'g2', 'name': 'Team Development'},
    {'id': 'g3', 'name': 'Marketing Team'},
    {'id': 'g4', 'name': 'Design Team'},
    {'id': 'g5', 'name': 'Project Alpha'},
  ];

  // Mock text content
  static final List<String> _mockTexts = [
    'Send me the code pls!!!',
    'Just give me as soon as possible',
    'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
    'www.hahaha.vn/hkdkdodko/jaiaiowjw',
    'thuviensach.vn',
    '@Nguyễn Văn B',
    'Can you help me with this issue?',
    'Meeting at 3 PM today',
    'Please review the latest changes',
    'Great work everyone!',
    'Don\'t forget to submit your reports',
    'Happy birthday! ��',
    'The project is on track',
    'Let\'s discuss this tomorrow',
    'Thanks for your help!',
    'Important announcement for all team members',
    'Please check the updated schedule',
    'The deadline has been extended',
    'New features are now available',
    'Please update your software',
  ];

  // Mock file names
  static final List<String> _mockFileNames = [
    'ITHALSTITLE.pdg',
    'project_document.pdf',
    'presentation.pptx',
    'data_analysis.xlsx',
    'design_mockup.fig',
    'code_review.docx',
    'meeting_notes.txt',
    'budget_report.xlsx',
    'user_manual.pdf',
    'technical_specs.docx',
  ];

  // Mock links
  static final List<Map<String, String>> _mockLinks = [
    {
      'url': 'https://nchmf.gov.vn',
      'title': 'Trung tâm dự báo KTTV quốc gia',
      'description':
          'Website thông tin dự báo thời tiết biển, đất liền 24h,48h,72h, sản phẩm mô hình số',
      'domain': 'nchmf.gov.vn',
    },
    {
      'url': 'https://github.com/flutter/flutter',
      'title': 'Flutter - GitHub',
      'description':
          'Flutter makes it easy and fast to build beautiful apps for mobile and beyond',
      'domain': 'github.com',
    },
    {
      'url': 'https://dart.dev',
      'title': 'Dart programming language',
      'description':
          'Dart is a client-optimized language for fast apps on any platform',
      'domain': 'dart.dev',
    },
    {
      'url': 'https://pub.dev',
      'title': 'pub.dev - Flutter packages',
      'description': 'Find and use packages to build Flutter apps',
      'domain': 'pub.dev',
    },
    {
      'url': 'https://flutter.dev',
      'title': 'Flutter - Beautiful native apps',
      'description': 'Build apps for any screen',
      'domain': 'flutter.dev',
    },
  ];

  static List<MessageEntity> getMockPinnedMessages() {
    final List<MessageEntity> messages = [];

    for (int i = 0; i < 20; i++) {
      final user = _mockUsers[_random.nextInt(_mockUsers.length)];
      final group = _mockGroups[_random.nextInt(_mockGroups.length)];
      final messageType =
          MessageType.values[_random.nextInt(MessageType.values.length)];

      // Create message content based on type
      MessageContent content;
      switch (messageType) {
        case MessageType.text:
          content = MessageContent.text(
            text: _mockTexts[_random.nextInt(_mockTexts.length)],
          );
          break;
        case MessageType.image:
          content = MessageContent.image(
            imageUrl:
                'https://picsum.photos/300/200?random=${_random.nextInt(1000)}',
            width: 300,
            height: 200,
          );
          break;
        case MessageType.audio:
          content = MessageContent.audio(
            audioUrl: 'https://example.com/audio_${_random.nextInt(100)}.mp3',
            duration: Duration(seconds: _random.nextInt(300) + 30),
            fileSize: _random.nextInt(5000000) + 100000,
          );
          break;
        case MessageType.file:
          final fileName =
              _mockFileNames[_random.nextInt(_mockFileNames.length)];
          content = MessageContent.file(
            fileUrl: 'https://example.com/files/$fileName',
            fileName: fileName,
            fileExtension: fileName.split('.').last,
            fileSize: _random.nextInt(10000000) + 100000,
            fileType: FileType.values[_random.nextInt(FileType.values.length)],
          );
          break;
        case MessageType.link:
          final link = _mockLinks[_random.nextInt(_mockLinks.length)];
          content = MessageContent.link(
            url: link['url']!,
            title: link['title']!,
            description: link['description']!,
            domain: link['domain']!,
          );
          break;
      }

      // Create reply info for some messages (30% chance)
      MessageReplyInfo? replyInfo;
      if (_random.nextDouble() < 0.3) {
        final replyUser = _mockUsers[_random.nextInt(_mockUsers.length)];
        final selectedText = _mockTexts[_random.nextInt(_mockTexts.length)];
        // Fix: Use safe substring to avoid RangeError
        final previewText = selectedText.length > 30
            ? '${selectedText.substring(0, 30)}...'
            : selectedText;

        replyInfo = MessageReplyInfo(
          messageId: 'reply_${_random.nextInt(1000)}',
          senderName: replyUser['name']!,
          previewText: previewText,
          originalMessageType: MessageType.text,
        );
      }

      final message = MessageEntity(
        id: 'msg_${_random.nextInt(10000)}',
        senderId: user['id']!,
        senderName: user['name']!,
        senderAvatar: user['avatar']!,
        createdAt: DateTime.now().subtract(
          Duration(
            days: _random.nextInt(30),
            hours: _random.nextInt(24),
            minutes: _random.nextInt(60),
          ),
        ),
        type: messageType,
        content: content,
        status: MessageStatus.sent, // Always sent as requested
        groupId: group['id'],
        groupName: group['name'],
        replyToMessageId: replyInfo != null
            ? 'reply_${_random.nextInt(1000)}'
            : null,
        replyInfo: replyInfo,
        isPinned: true, // All messages are pinned
        pinnedAt: DateTime.now().subtract(
          Duration(days: _random.nextInt(7), hours: _random.nextInt(24)),
        ),
      );

      messages.add(message);
    }

    // Sort by pinned date (newest first)
    messages.sort(
      (a, b) =>
          (b.pinnedAt ?? b.createdAt).compareTo(a.pinnedAt ?? a.createdAt),
    );

    return messages;
  }
}
