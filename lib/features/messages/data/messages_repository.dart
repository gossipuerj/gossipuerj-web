import "../../../domain/models/chat_message.dart";
import "../../../domain/models/conversation_summary.dart";

abstract class MessagesRepository {
  List<ConversationSummary> loadConversations();
  Map<int, List<ChatMessage>> loadHistory();
}

class InMemoryMessagesRepository implements MessagesRepository {
  const InMemoryMessagesRepository({
    required this.seedConversations,
    required this.seedHistory,
  });

  final List<ConversationSummary> seedConversations;
  final Map<int, List<ChatMessage>> seedHistory;

  @override
  List<ConversationSummary> loadConversations() {
    return List<ConversationSummary>.from(seedConversations);
  }

  @override
  Map<int, List<ChatMessage>> loadHistory() {
    return {
      for (final entry in seedHistory.entries)
        entry.key: List<ChatMessage>.from(entry.value),
    };
  }
}
