import "dart:math";
import "package:flutter/foundation.dart";
import "package:intl/intl.dart";

import "mock_data.dart";
import "models.dart";

class AppController extends ChangeNotifier {
  UserProfile? _currentUser = mockUser;
  final List<GossipPost> _gossips = List<GossipPost>.from(mockGossips);
  final List<UserProfile> _profiles = List<UserProfile>.from(mockProfiles);
  final Map<String, List<UniversityEvent>> _events =
      Map<String, List<UniversityEvent>>.from(mockEvents);
  final List<ConversationSummary> _conversations =
      List<ConversationSummary>.from(seedConversations);
  final Map<int, List<ChatMessage>> _chatHistory =
      Map<int, List<ChatMessage>>.from(seedChatHistory);
  final Set<String> _likedProfiles = <String>{};

  bool isAuthenticating = false;
  bool isSavingProfile = false;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  List<GossipPost> get gossips => List<GossipPost>.unmodifiable(_gossips);
  List<UserProfile> get profiles => List<UserProfile>.unmodifiable(_profiles);
  Map<String, List<UniversityEvent>> get events =>
      Map<String, List<UniversityEvent>>.unmodifiable(_events);
  List<ConversationSummary> get conversations =>
      List<ConversationSummary>.unmodifiable(_conversations);
  Map<int, List<ChatMessage>> get chatHistory =>
      Map<int, List<ChatMessage>>.unmodifiable(_chatHistory);
  Set<String> get likedProfiles => Set<String>.unmodifiable(_likedProfiles);

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
    _upsertCurrentUserProfile(_currentUser!);
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

  Future<void> postGossip({
    required String target,
    required String content,
    required String category,
  }) async {
    final userId = _currentUser?.id ?? "anonymous";
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
    final index = _gossips.indexWhere((item) => item.id == gossipId);
    if (index == -1) {
      return;
    }
    final comment = GossipComment(
      id: "comment-${DateTime.now().microsecondsSinceEpoch}",
      text: text,
      author: isLoggedIn ? "@você" : "Anônimo",
      authorId: _currentUser?.id,
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
    _currentUser = nextUser;
    _upsertCurrentUserProfile(nextUser);
    isSavingProfile = false;
    notifyListeners();
  }

  void addEvent({required String dateKey, required UniversityEvent event}) {
    final current = _events[dateKey] ?? <UniversityEvent>[];
    _events[dateKey] = [...current, event];
    notifyListeners();
  }

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

  List<GossipPost> postsByCurrentUser() {
    final currentUserId = _currentUser?.id;
    if (currentUserId == null) {
      return const [];
    }
    return _gossips.where((item) => item.authorId == currentUserId).toList();
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

  void _upsertCurrentUserProfile(UserProfile profile) {
    final index = _profiles.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      _profiles.insert(0, profile);
    } else {
      _profiles[index] = profile;
    }
  }
}
