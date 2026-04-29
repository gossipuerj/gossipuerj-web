class ConversationSummary {
  const ConversationSummary({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.timeLabel,
    this.unread = false,
  });

  final int id;
  final String user;
  final String lastMessage;
  final String timeLabel;
  final bool unread;

  ConversationSummary copyWith({
    String? lastMessage,
    String? timeLabel,
    bool? unread,
  }) {
    return ConversationSummary(
      id: id,
      user: user,
      lastMessage: lastMessage ?? this.lastMessage,
      timeLabel: timeLabel ?? this.timeLabel,
      unread: unread ?? this.unread,
    );
  }
}
