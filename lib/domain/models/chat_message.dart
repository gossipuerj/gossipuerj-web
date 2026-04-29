enum ChatSender { me, them }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.timeLabel,
    required this.sender,
  });

  final int id;
  final String text;
  final String timeLabel;
  final ChatSender sender;
}
