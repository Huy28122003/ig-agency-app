class MessageSender {
  final String id;
  final String name;
  final String avatarUrl;

  const MessageSender({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  static const system = MessageSender(
    id: "system",
    name: "System",
    avatarUrl: "",
  );
}
