import "dart:math";
import "dart:typed_data";

import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

import "../../core/error/app_exception.dart";
import "../../domain/models/chat_message.dart";
import "../../domain/models/conversation_summary.dart";
import "../../domain/models/gossip_comment.dart";
import "../../domain/models/gossip_post.dart";
import "../../domain/models/university_event.dart";
import "../../domain/models/user_profile.dart";
import "../../features/feed/data/feed_repository.dart";
import "../seed/mock_seed_data.dart";
import "../../features/auth/presentation/session/session_cubit.dart";

class FeedState extends Equatable {
  const FeedState({
    required this.gossips,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSubmitting = false,
    this.currentPage = 0,
    this.hasMore = true,
    this.loadingCommentsFor = const <String>{},
    this.likedPostIds = const <String>{},
    this.message,
    this.selectedCategory,
  });

  final List<GossipPost> gossips;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSubmitting;
  final int currentPage;
  final bool hasMore;
  final Set<String> loadingCommentsFor;
  final Set<String> likedPostIds;
  final String? message;
  final String? selectedCategory;

  FeedState copyWith({
    List<GossipPost>? gossips,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSubmitting,
    int? currentPage,
    bool? hasMore,
    Set<String>? loadingCommentsFor,
    Set<String>? likedPostIds,
    String? message,
    bool clearMessage = false,
    String? selectedCategory,
    bool clearSelectedCategory = false,
  }) {
    return FeedState(
      gossips: gossips ?? this.gossips,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      loadingCommentsFor: loadingCommentsFor ?? this.loadingCommentsFor,
      likedPostIds: likedPostIds ?? this.likedPostIds,
      message: clearMessage ? null : (message ?? this.message),
      selectedCategory: clearSelectedCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
    );
  }

  @override
  List<Object?> get props => [
    gossips,
    isLoading,
    isLoadingMore,
    isSubmitting,
    currentPage,
    hasMore,
    loadingCommentsFor,
    likedPostIds,
    message,
    selectedCategory,
  ];
}

class FeedCubit extends Cubit<FeedState> {
  static const _pageSize = 20;

  FeedCubit(this._repository, this._sessionCubit)
    : super(const FeedState(gossips: [])) {
    loadPosts();
  }

  final FeedRepository _repository;
  final SessionCubit _sessionCubit;

  Future<void> loadPosts({String? category}) async {
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        clearMessage: true,
        selectedCategory: category,
      ),
    );
    try {
      final page = await _repository.load(
        category: _toApiCategory(category),
        page: 0,
        pageSize: _pageSize,
      );
      emit(
        state.copyWith(
          gossips: page.posts,
          isLoading: false,
          currentPage: page.page,
          hasMore: page.hasMore,
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(isLoading: false, message: error.message));
    }
  }

  Future<void> loadMorePosts() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearMessage: true));
    try {
      final page = await _repository.load(
        category: _toApiCategory(state.selectedCategory),
        page: state.currentPage + 1,
        pageSize: _pageSize,
      );
      emit(
        state.copyWith(
          isLoadingMore: false,
          gossips: [...state.gossips, ...page.posts],
          currentPage: page.page,
          hasMore: page.hasMore,
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(isLoadingMore: false, message: error.message));
    }
  }

  Future<void> postGossip({
    required String title,
    required String content,
    required String category,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearMessage: true));
    try {
      final post = await _repository.createPost(
        title: title,
        content: content,
        category: _toApiCategory(category)!,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          gossips: [post, ...state.gossips],
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(isSubmitting: false, message: error.message));
    }
  }

  Future<void> deleteGossip(String gossipId) async {
    try {
      await _repository.deletePost(gossipId);
      emit(
        state.copyWith(
          gossips: state.gossips.where((item) => item.id != gossipId).toList(),
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(message: error.message));
    }
  }

  Future<void> toggleLikeGossip(String gossipId) async {
    final previousPosts = state.gossips;
    final previousLikedPostIds = state.likedPostIds;
    final likedPostIds = Set<String>.from(state.likedPostIds);
    final isLiked = likedPostIds.contains(gossipId);
    final posts = state.gossips.map((item) {
      if (item.id != gossipId) {
        return item;
      }
      final nextLikes = isLiked
          ? (item.likesCount > 0 ? item.likesCount - 1 : 0)
          : item.likesCount + 1;
      return item.copyWith(likesCount: nextLikes);
    }).toList();

    if (isLiked) {
      likedPostIds.remove(gossipId);
    } else {
      likedPostIds.add(gossipId);
    }

    emit(state.copyWith(gossips: posts, likedPostIds: likedPostIds));

    try {
      if (isLiked) {
        await _repository.unlikePost(gossipId);
      } else {
        await _repository.likePost(gossipId);
      }
    } on AppException catch (error) {
      emit(
        state.copyWith(
          gossips: previousPosts,
          likedPostIds: previousLikedPostIds,
          message: error.message,
        ),
      );
    }
  }

  Future<void> loadComments(String gossipId) async {
    final loading = Set<String>.from(state.loadingCommentsFor)..add(gossipId);
    emit(state.copyWith(loadingCommentsFor: loading, clearMessage: true));
    try {
      final comments = await _repository.loadComments(gossipId);
      final nextLoading = Set<String>.from(state.loadingCommentsFor)
        ..remove(gossipId);
      emit(
        state.copyWith(
          gossips: state.gossips.map((item) {
            if (item.id != gossipId) {
              return item;
            }
            return item.copyWith(comments: comments);
          }).toList(),
          loadingCommentsFor: nextLoading,
        ),
      );
    } on AppException catch (error) {
      final nextLoading = Set<String>.from(state.loadingCommentsFor)
        ..remove(gossipId);
      emit(
        state.copyWith(loadingCommentsFor: nextLoading, message: error.message),
      );
    }
  }

  Future<void> addComment(String gossipId, String text) async {
    try {
      final comment = await _repository.createComment(
        postId: gossipId,
        content: text,
      );
      emit(
        state.copyWith(
          gossips: state.gossips.map((item) {
            if (item.id != gossipId) {
              return item;
            }
            return item.copyWith(comments: [...item.comments, comment]);
          }).toList(),
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(message: error.message));
    }
  }

  Future<void> deleteComment(String gossipId, String commentId) async {
    try {
      await _repository.deleteComment(postId: gossipId, commentId: commentId);
      emit(
        state.copyWith(
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
    } on AppException catch (error) {
      emit(state.copyWith(message: error.message));
    }
  }

  void clearFeedback() {
    emit(state.copyWith(clearMessage: true));
  }

  String? _toApiCategory(String? category) {
    switch (category) {
      case null:
      case "Todos":
        return null;
      case "Fofoca":
        return "GOSSIP";
      case "Desabafo":
        return "CONFESSION";
      case "Paquera":
        return "FLIRT";
      case "Pergunta":
        return "QUESTION";
      default:
        return category.toUpperCase();
    }
  }

  String displayCategory(String category) {
    switch (category) {
      case "GOSSIP":
        return "Fofoca";
      case "CONFESSION":
        return "Desabafo";
      case "FLIRT":
        return "Paquera";
      case "QUESTION":
        return "Pergunta";
      default:
        return category;
    }
  }

  List<GossipPost> postsByUser(String? userId) {
    if (userId == null) {
      return const [];
    }
    return state.gossips.where((item) => item.authorId == userId).toList();
  }

  String commentAuthorLabel(GossipComment comment) {
    final currentUserId = _sessionCubit.state.user?.id;
    if (comment.authorId != null && comment.authorId == currentUserId) {
      return "Você";
    }
    return "Anônimo";
  }

  String postAuthorLabel(GossipPost post) {
    final currentUserId = _sessionCubit.state.user?.id;
    if (post.authorId != null && post.authorId == currentUserId) {
      return "Você";
    }
    return "Anônimo";
  }

  bool isPostLiked(String postId) => state.likedPostIds.contains(postId);

  bool isCommentsLoading(String postId) =>
      state.loadingCommentsFor.contains(postId);
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
