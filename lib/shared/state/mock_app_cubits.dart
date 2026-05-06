import "dart:math";
import "dart:typed_data";

import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

import "../../domain/models/chat_message.dart";
import "../../domain/models/conversation_summary.dart";
import "../../domain/models/gossip_comment.dart";
import "../../domain/models/gossip_post.dart";
import "../../domain/models/university_event.dart";
import "../../domain/models/user_profile.dart";
import "../seed/mock_seed_data.dart";
import "../../features/auth/presentation/session/session_cubit.dart";

class FeedState extends Equatable {
  const FeedState({required this.gossips});

  final List<GossipPost> gossips;

  @override
  List<Object?> get props => [gossips];
}

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(this._sessionCubit)
    : super(FeedState(gossips: List<GossipPost>.from(mockGossips)));

  final SessionCubit _sessionCubit;

  Future<void> postGossip({
    required String target,
    required String content,
    required String category,
  }) async {
    final userId = _sessionCubit.state.user?.id ?? "anonymous";
    final post = GossipPost(
      id: "g-${DateTime.now().microsecondsSinceEpoch}",
      content: content,
      timestamp: DateTime.now(),
      category: category,
      authorId: userId,
      target: target.isEmpty ? null : target,
      comments: const [],
    );
    emit(FeedState(gossips: [post, ...state.gossips]));
  }

  void updateGossip(String gossipId, String content) {
    emit(
      FeedState(
        gossips: state.gossips
            .map(
              (item) =>
                  item.id == gossipId ? item.copyWith(content: content) : item,
            )
            .toList(),
      ),
    );
  }

  void deleteGossip(String gossipId) {
    emit(
      FeedState(
        gossips: state.gossips.where((item) => item.id != gossipId).toList(),
      ),
    );
  }

  void toggleFollowGossip(String gossipId) {
    emit(
      FeedState(
        gossips: state.gossips
            .map(
              (item) => item.id == gossipId
                  ? item.copyWith(isFollowing: !item.isFollowing)
                  : item,
            )
            .toList(),
      ),
    );
  }

  void addComment(String gossipId, String text) {
    final comment = GossipComment(
      id: "comment-${DateTime.now().microsecondsSinceEpoch}",
      text: text,
      author: _sessionCubit.state.isAuthenticated ? "@você" : "Anônimo",
      authorId: _sessionCubit.state.user?.id,
    );
    emit(
      FeedState(
        gossips: state.gossips.map((item) {
          if (item.id != gossipId) {
            return item;
          }
          return item.copyWith(comments: [...item.comments, comment]);
        }).toList(),
      ),
    );
  }

  void deleteComment(String gossipId, String commentId) {
    emit(
      FeedState(
        gossips: state.gossips.map((item) {
          if (item.id != gossipId) {
            return item;
          }
          return item.copyWith(
            comments: item.comments
                .where((comment) => comment.id != commentId)
                .toList(),
          );
        }).toList(),
      ),
    );
  }

  List<GossipPost> postsByUser(String? userId) {
    if (userId == null) {
      return const [];
    }
    return state.gossips.where((item) => item.authorId == userId).toList();
  }
}

class ProfilesState extends Equatable {
  const ProfilesState({required this.profiles, required this.likedProfiles});

  final List<UserProfile> profiles;
  final Set<String> likedProfiles;

  @override
  List<Object?> get props => [profiles, likedProfiles];
}

class ProfilesCubit extends Cubit<ProfilesState> {
  ProfilesCubit()
    : super(
        ProfilesState(
          profiles: List<UserProfile>.from(mockProfiles),
          likedProfiles: const {},
        ),
      );

  void toggleLikedProfile(String username) {
    final liked = Set<String>.from(state.likedProfiles);
    if (liked.contains(username)) {
      liked.remove(username);
    } else {
      liked.add(username);
    }
    emit(ProfilesState(profiles: state.profiles, likedProfiles: liked));
  }

  Uint8List? buildAvatarBytes(Uint8List bytes) => bytes;

  String normalizedOrientation(String value) {
    const map = <String, String>{
      "Gay": "Homossexual",
      "Lésbica": "Homossexual",
      "Assexual": "Assexual",
      "Asexual": "Assexual",
      "Não-binário": "Não-Binário",
      "Não-binário ": "Não-Binário",
    };
    return map[value] ?? value;
  }

  String normalizedGender(String value) {
    const map = <String, String>{"Não-binário": "Não-Binário"};
    return map[value] ?? value;
  }
}

class MessagesState extends Equatable {
  const MessagesState({required this.conversations, required this.chatHistory});

  final List<ConversationSummary> conversations;
  final Map<int, List<ChatMessage>> chatHistory;

  @override
  List<Object?> get props => [conversations, chatHistory];
}

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit()
    : super(
        MessagesState(
          conversations: List<ConversationSummary>.from(seedConversations),
          chatHistory: {
            for (final entry in seedChatHistory.entries)
              entry.key: List<ChatMessage>.from(entry.value),
          },
        ),
      );

  ConversationSummary? findConversationByUsername(String username) {
    for (final conversation in state.conversations) {
      if (conversation.user == username) {
        return conversation;
      }
    }
    return null;
  }

  ConversationSummary openOrCreateConversation(String username) {
    final existing = findConversationByUsername(username);
    if (existing != null) {
      return existing;
    }
    final nextId =
        (state.conversations.map((item) => item.id).fold<int>(0, max)) + 1;
    final created = ConversationSummary(
      id: nextId,
      user: username,
      lastMessage: "Conversa iniciada pelo perfil.",
      timeLabel: "agora",
      unread: false,
    );
    final nextHistory = Map<int, List<ChatMessage>>.from(state.chatHistory);
    nextHistory[nextId] = const [
      ChatMessage(
        id: 9001,
        text: "Oi! Vim do seu perfil na galeria de crushes.",
        timeLabel: "agora",
        sender: ChatSender.me,
      ),
    ];
    emit(
      MessagesState(
        conversations: [created, ...state.conversations],
        chatHistory: nextHistory,
      ),
    );
    return created;
  }

  void sendMessage({required int conversationId, required String text}) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch,
      text: text,
      timeLabel: DateFormat("HH:mm").format(DateTime.now()),
      sender: ChatSender.me,
    );
    final nextHistory = Map<int, List<ChatMessage>>.from(state.chatHistory);
    nextHistory[conversationId] = [
      ...(nextHistory[conversationId] ?? const <ChatMessage>[]),
      message,
    ];
    final conversations = List<ConversationSummary>.from(state.conversations);
    final index = conversations.indexWhere((item) => item.id == conversationId);
    if (index != -1) {
      final current = conversations.removeAt(index);
      conversations.insert(
        0,
        current.copyWith(lastMessage: text, timeLabel: "agora", unread: false),
      );
    }
    emit(MessagesState(conversations: conversations, chatHistory: nextHistory));
  }
}

class EventsState extends Equatable {
  const EventsState({required this.events});

  final Map<String, List<UniversityEvent>> events;

  @override
  List<Object?> get props => [events];
}

class EventsCubit extends Cubit<EventsState> {
  EventsCubit()
    : super(
        EventsState(
          events: {
            for (final entry in mockEvents.entries)
              entry.key: List<UniversityEvent>.from(entry.value),
          },
        ),
      );

  void addEvent({required String dateKey, required UniversityEvent event}) {
    final nextEvents = Map<String, List<UniversityEvent>>.from(state.events);
    nextEvents[dateKey] = [...(nextEvents[dateKey] ?? const []), event];
    emit(EventsState(events: nextEvents));
  }
}
