import 'dart:math';

import 'package:ig_agency_app/domain/entities/message.dart';
import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/enums/filter_type.dart';

import '../../domain/entities/file_entity.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/media_entity.dart';
import '../../domain/entities/message/message_content.dart';
import '../../domain/entities/message/message_entity.dart';
import '../../domain/entities/search.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/workspace_entity.dart';
import '../../domain/enums/message_enums.dart';

class MockData {
  final List<MediaEntity> mockMediaData = List.generate(50, (index) {
    final isVideo = index % 3 == 0;
    return MediaEntity(
      id: index + 1,
      isVideo: isVideo,
      previewUrl: "https://picsum.photos/id/${index + 10}/200/200",
      duration: isVideo
          ? Duration(
              minutes: Random().nextInt(59),
              seconds: Random().nextInt(59),
            )
          : null,
    );
  });

  List<FileEntity> mockFileEntities() {
    final random = Random();
    return List.generate(50, (index) {
      return FileEntity(
        id: index + 1,
        name: "File_${index + 1}.pdf",
        size: (random.nextDouble() * 100).clamp(0.1, 99.9),
        url: "https://example.com/files/file_${index + 1}.pdf",
      );
    });
  }

  final List<String> mockLinks = [
    "https://www.wikipedia.org",
    "https://www.britannica.com",
    "https://www.nationalgeographic.com",
    "https://www.imdb.com",
    "https://stackoverflow.com",
    "https://medium.com",
    "https://reddit.com",
    "https://quora.com",
    "https://khanacademy.org",
    "https://codecademy.com",
    "https://coursera.org",
    "https://edx.org",
    "https://udemy.com",
    "https://ted.com",
    "https://allrecipes.com",
    "https://epicurious.com",
    "https://foodnetwork.com",
    "https://tripadvisor.com",
    "https://lonelyplanet.com",
    "https://booking.com",
    "https://airbnb.com",
    "https://expedia.com",
    "https://zillow.com",
    "https://realtor.com",
    "https://cars.com",
    "https://autotrader.com",
    "https://nike.com",
    "https://adidas.com",
    "https://apple.com",
    "https://samsung.com",
    "https://microsoft.com",
    "https://ibm.com",
    "https://intel.com",
    "https://nvidia.com",
    "https://tesla.com",
    "https://spacex.com",
    "https://nasa.gov",
    "https://who.int",
    "https://unicef.org",
    "https://un.org",
    "https://worldbank.org",
    "https://bloomberg.com",
    "https://reuters.com",
    "https://cnn.com",
    "https://bbc.com",
    "https://aljazeera.com",
    "https://nytimes.com",
    "https://theguardian.com",
    "https://wired.com",
  ];

  Future<PagedResult<SearchResult>> getSearchResult(FilterType type) async {
    await Future.delayed(Duration(seconds: 1));
    final list = listSearch
        .where(
          (e) => (type == FilterType.message)
              ? (e.message != null)
              : e.message == null,
        )
        .toList();
    return PagedResult(data: list, totalRecords: 50);
  }

  final listSearch = List.generate(
    40,
    (index) => SearchResult(
      id: 1,
      groupInfo: GroupSummary(
        id: 1,
        name: 'WorkSpace ${index + 1}',
        avatar: '.png',
      ),
      userInfo: index % 2 == 0
          ? null
          : UserSummary(
              id: '1',
              name: 'Nguyen Van A',
              avatar:
                  'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png',
            ),
      message: index % 2 == 0
          ? null
          : MessageSummary(id: 1, message: "Long time no see"),
    ),
  );

  final users = List.generate(
    50,
    (index) => UserEntity(
      id: 'user_$index',
      name: 'User ${index + 1}',
      avatar: 'https://placehold.co/44x44?text=U${index + 1}',
      bio: (index % 3 == 0) ? 'This is bio of user ${index + 1}' : '',
      lastActiveAt: DateTime.now().subtract(Duration(minutes: index * 5)),
      isAdmin: index % 10 == 0,
    ),
  );

  static List<WorkspaceEntity> getWorkspaces() {
    return [
      WorkspaceEntity(
        id: '1',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=1',
        workspaceName: 'Design Team',
        lastMessage: 'Please review the latest designs.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        isSeen: false,
        isMute: false,
        isPin: true,
        countNewMessage: 3,
        countMember: 8,
        countPin: 2,
        bio: 'Creative group focusing on UI/UX.',
      ),
      WorkspaceEntity(
        id: '2',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=2',
        workspaceName: 'Marketing Team',
        lastMessage: 'Campaign report updated.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        isSeen: true,
        isMute: false,
        isPin: false,
        countNewMessage: 0,
        countMember: 12,
        countPin: 1,
      ),
      WorkspaceEntity(
        id: '3',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=3',
        workspaceName: 'Developers',
        lastMessage: 'Bug in payment flow fixed.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        isSeen: false,
        isMute: true,
        isPin: false,
        countNewMessage: 5,
        countMember: 15,
        countPin: 4,
      ),
      WorkspaceEntity(
        id: '4',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=4',
        workspaceName: 'HR Department',
        lastMessage: 'New leave policy announced.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 4)),
        isSeen: true,
        isMute: false,
        isPin: false,
        countNewMessage: 0,
        countMember: 6,
        countPin: 0,
      ),
      WorkspaceEntity(
        id: '5',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=5',
        workspaceName: 'Finance',
        lastMessage: 'Invoice #123 approved.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 5)),
        isSeen: false,
        isMute: false,
        isPin: true,
        countNewMessage: 2,
        countMember: 10,
        countPin: 3,
        bio: 'Manages budgets and financial planning.',
      ),
      WorkspaceEntity(
        id: '6',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=6',
        workspaceName: 'Operations',
        lastMessage: 'Warehouse restocked successfully.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 6)),
        isSeen: true,
        isMute: true,
        isPin: false,
        countNewMessage: 0,
        countMember: 7,
        countPin: 0,
        bio: 'Oversees daily business operations.',
      ),
      WorkspaceEntity(
        id: '7',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=7',
        workspaceName: 'Legal Team',
        lastMessage: 'Contract draft ready.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 7)),
        isSeen: false,
        isMute: false,
        isPin: false,
        countNewMessage: 4,
        countMember: 5,
        countPin: 1,
        bio: 'Ensures compliance and contracts.',
      ),
      WorkspaceEntity(
        id: '8',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=8',
        workspaceName: 'QA Team',
        lastMessage: 'Regression test completed.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 8)),
        isSeen: true,
        isMute: false,
        isPin: false,
        countNewMessage: 0,
        countMember: 9,
        countPin: 0,
        bio: 'Testing and quality assurance.',
      ),
      WorkspaceEntity(
        id: '9',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=9',
        workspaceName: 'Support',
        lastMessage: 'Ticket #987 resolved.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 9)),
        isSeen: false,
        isMute: true,
        isPin: false,
        countNewMessage: 1,
        countMember: 20,
        countPin: 2,
        bio: 'Customer support and helpdesk.',
      ),
      WorkspaceEntity(
        id: '10',
        workspaceAvatar: 'https://i.pravatar.cc/150?img=10',
        workspaceName: 'Product Team',
        lastMessage: 'Specs document updated.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 10)),
        isSeen: true,
        isMute: false,
        isPin: true,
        countNewMessage: 0,
        countMember: 14,
        countPin: 3,
        bio: 'Defines product roadmap and features.',
      ),
      // … tương tự cho các id còn lại từ '11' đến '30'
    ];
  }

  List<MessageEntity> mockMessages() {
    final now = DateTime.now();
    final random = Random();

    final senders = [
      UserSummary(
        id: "u1",
        name: "Alice",
        avatar: "https://i.pravatar.cc/100?img=1",
      ),
      UserSummary(
        id: "u2",
        name: "Bob",
        avatar: "https://i.pravatar.cc/100?img=2",
      ),
      UserSummary(
        id: "u3",
        name: "Charlie",
        avatar: "https://i.pravatar.cc/100?img=3",
      ),
    ];

    final statuses = MessageStatus.values;
    List<MessageEntity> messages = [];

    for (int i = 0; i < 30; i++) {
      final sender = senders[random.nextInt(senders.length)];
      final status = statuses[random.nextInt(statuses.length)];
      final createdAt = now.subtract(Duration(minutes: i * 5));

      // 🔹 Nội dung chỉ là text
      final content = TextMessageContent(
        text: "This is text message $i from ${sender.name}",
      );

      // 🔹 Nếu có reply thì tham chiếu lại message trước đó
      MessageEntity? repliedMessage;
      if (i % 7 == 0 && messages.isNotEmpty) {
        repliedMessage = messages[random.nextInt(messages.length)];
      }

      messages.add(
        MessageEntity(
          id: "msg_$i",
          user: sender,
          createdAt: createdAt,
          content: content,
          status: status,
          groupId: "1",
          repliedMessage: repliedMessage,
          isPinned: i % 10 == 0,
          pinnedAt: i % 10 == 0 ? now.subtract(Duration(minutes: i * 2)) : null,
        ),
      );
    }

    return messages;
  }
}
