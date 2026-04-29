import "dart:math";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

import "../../domain/models/chat_message.dart";
import "../../domain/models/conversation_summary.dart";
import "../../domain/models/gossip_comment.dart";
import "../../domain/models/gossip_post.dart";
import "../../domain/models/university_event.dart";
import "../../domain/models/user_profile.dart";
import "../../features/auth/data/session_repository.dart";
import "../../features/crushes/data/profile_repository.dart";
import "../../features/events/data/events_repository.dart";
import "../../features/feed/data/feed_repository.dart";
import "../../features/messages/data/messages_repository.dart";
import "../seed/mock_seed_data.dart";

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return const MockSessionRepository(seedUser: mockUser);
});

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return InMemoryFeedRepository(mockGossips);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return InMemoryProfileRepository(mockProfiles);
});

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  return InMemoryMessagesRepository(
    seedConversations: seedConversations,
    seedHistory: seedChatHistory,
  );
});

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return InMemoryEventsRepository(mockEvents);
});

final sessionControllerProvider = ChangeNotifierProvider<SessionController>((
  ref,
) {
  return SessionController(ref.read(sessionRepositoryProvider));
});

final feedControllerProvider = ChangeNotifierProvider<FeedController>((ref) {
  return FeedController(ref);
});

final profilesControllerProvider = ChangeNotifierProvider<ProfilesController>((
  ref,
) {
  return ProfilesController(ref);
});

final messagesControllerProvider = ChangeNotifierProvider<MessagesController>((
  ref,
) {
  return MessagesController(ref.read(messagesRepositoryProvider));
});

final eventsControllerProvider = ChangeNotifierProvider<EventsController>((
  ref,
) {
  return EventsController(ref.read(eventsRepositoryProvider));
});

class SessionController extends ChangeNotifier {
  SessionController(SessionRepository repository)
    : _currentUser = repository.initialUser();

  UserProfile? _currentUser;
  bool isAuthenticating = false;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    isAuthenticating = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    isAuthenticating = false;
    if (username.trim().isEmpty || password.trim().isEmpty) {
      notifyListeners();
      return false;
    }

    final normalized = username.trim().replaceAll("@", "");
    _currentUser = mockUser.copyWith(
      username: normalized,
      instagram: normalized,
    );
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String username,
    required String password,
  }) async {
    isAuthenticating = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    isAuthenticating = false;
    notifyListeners();
    return username.trim().isNotEmpty && password.trim().isNotEmpty;
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  void updateCurrentUser(UserProfile nextUser) {
    _currentUser = nextUser;
    notifyListeners();
  }
}

class FeedController extends ChangeNotifier {
  FeedController(this._ref)
    : _gossips = _ref.read(feedRepositoryProvider).load();

  final Ref _ref;
  final List<GossipPost> _gossips;

  List<GossipPost> get gossips => List<GossipPost>.unmodifiable(_gossips);

  Future<void> postGossip({
    required String target,
    required String content,
    required String category,
  }) async {
    final userId =
        _ref.read(sessionControllerProvider).currentUser?.id ?? "anonymous";
    final post = GossipPost(
      id: "g-${DateTime.now().microsecondsSinceEpoch}",
      content: content,
      timestamp: DateTime.now(),
      category: category,
      authorId: userId,
      target: target.isEmpty ? null : target,
      comments: const [],
    );
    _gossips.insert(0, post);
    notifyListeners();
  }

  void updateGossip(String gossipId, String content) {
    final index = _gossips.indexWhere((item) => item.id == gossipId);
    if (index == -1) {
      return;
    }
    _gossips[index] = _gossips[index].copyWith(content: content);
    notifyListeners();
  }

  void deleteGossip(String gossipId) {
    _gossips.removeWhere((item) => item.id == gossipId);
    notifyListeners();
  }

  void toggleFollowGossip(String gossipId) {
    final index = _gossips.indexWhere((item) => item.id == gossipId);
    if (index == -1) {
      return;
    }
    final current = _gossips[index];
    _gossips[index] = current.copyWith(isFollowing: !current.isFollowing);
    notifyListeners();
  }

  void addComment(String gossipId, String text) {
    final session = _ref.read(sessionControllerProvider);
    final index = _gossips.indexWhere((item) => item.id == gossipId);
    if (index == -1) {
      return;
    }
    final comment = GossipComment(
      id: "comment-${DateTime.now().microsecondsSinceEpoch}",
      text: text,
      author: session.isLoggedIn ? "@você" : "Anônimo",
      authorId: session.currentUser?.id,
    );
    final current = _gossips[index];
    _gossips[index] = current.copyWith(
      comments: [...current.comments, comment],
    );
    notifyListeners();
  }

  void deleteComment(String gossipId, String commentId) {
    final index = _gossips.indexWhere((item) => item.id == gossipId);
    if (index == -1) {
      return;
    }
    final current = _gossips[index];
    _gossips[index] = current.copyWith(
      comments: current.comments.where((item) => item.id != commentId).toList(),
    );
    notifyListeners();
  }

  List<GossipPost> postsByUser(String? userId) {
    if (userId == null) {
      return const [];
    }
    return _gossips.where((item) => item.authorId == userId).toList();
  }
}

class ProfilesController extends ChangeNotifier {
  ProfilesController(this._ref)
    : _profiles = _ref.read(profileRepositoryProvider).load();

  final Ref _ref;
  final List<UserProfile> _profiles;
  final Set<String> _likedProfiles = <String>{};

  bool isSavingProfile = false;

  List<UserProfile> get profiles => List<UserProfile>.unmodifiable(_profiles);
  Set<String> get likedProfiles => Set<String>.unmodifiable(_likedProfiles);

  void syncCurrentUserProfile(UserProfile profile) {
    final index = _profiles.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      _profiles.insert(0, profile);
    } else {
      _profiles[index] = profile;
    }
    notifyListeners();
  }

  void toggleLikedProfile(String username) {
    if (_likedProfiles.contains(username)) {
      _likedProfiles.remove(username);
    } else {
      _likedProfiles.add(username);
    }
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile nextUser) async {
    isSavingProfile = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _ref.read(sessionControllerProvider).updateCurrentUser(nextUser);
    syncCurrentUserProfile(nextUser);
    isSavingProfile = false;
    notifyListeners();
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

class MessagesController extends ChangeNotifier {
  MessagesController(MessagesRepository repository)
    : _conversations = repository.loadConversations(),
      _chatHistory = repository.loadHistory();

  final List<ConversationSummary> _conversations;
  final Map<int, List<ChatMessage>> _chatHistory;

  List<ConversationSummary> get conversations =>
      List<ConversationSummary>.unmodifiable(_conversations);
  Map<int, List<ChatMessage>> get chatHistory =>
      Map<int, List<ChatMessage>>.unmodifiable(_chatHistory);

  ConversationSummary? findConversationByUsername(String username) {
    for (final conversation in _conversations) {
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
        (_conversations.map((item) => item.id).fold<int>(0, max)) + 1;
    final created = ConversationSummary(
      id: nextId,
      user: username,
      lastMessage: "Conversa iniciada pelo perfil.",
      timeLabel: "agora",
      unread: false,
    );
    _conversations.insert(0, created);
    _chatHistory[nextId] = const [
      ChatMessage(
        id: 9001,
        text: "Oi! Vim do seu perfil na galeria de crushes.",
        timeLabel: "agora",
        sender: ChatSender.me,
      ),
    ];
    notifyListeners();
    return created;
  }

  void sendMessage({required int conversationId, required String text}) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch,
      text: text,
      timeLabel: DateFormat("HH:mm").format(DateTime.now()),
      sender: ChatSender.me,
    );
    final history = _chatHistory[conversationId] ?? <ChatMessage>[];
    _chatHistory[conversationId] = [...history, message];

    final index = _conversations.indexWhere(
      (item) => item.id == conversationId,
    );
    if (index != -1) {
      final current = _conversations.removeAt(index);
      _conversations.insert(
        0,
        current.copyWith(lastMessage: text, timeLabel: "agora", unread: false),
      );
    }
    notifyListeners();
  }
}

class EventsController extends ChangeNotifier {
  EventsController(EventsRepository repository) : _events = repository.load();

  final Map<String, List<UniversityEvent>> _events;

  Map<String, List<UniversityEvent>> get events =>
      Map<String, List<UniversityEvent>>.unmodifiable(_events);

  void addEvent({required String dateKey, required UniversityEvent event}) {
    final current = _events[dateKey] ?? <UniversityEvent>[];
    _events[dateKey] = [...current, event];
    notifyListeners();
  }
}
