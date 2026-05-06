import "package:flutter_app/core/storage/token_store.dart";
import "package:flutter_app/domain/models/gossip_comment.dart";
import "package:flutter_app/domain/models/gossip_post.dart";
import "package:flutter_app/domain/models/university_event.dart";
import "package:flutter_app/domain/models/user_profile.dart";
import "package:flutter_app/domain/repositories/auth_repository.dart";
import "package:flutter_app/features/feed/data/feed_repository.dart";
import "package:flutter_app/features/feed/data/models/feed_posts_page.dart";

class InMemoryTokenStore implements TokenStore {
  InMemoryTokenStore({this.initialToken});

  final String? initialToken;
  String? _token;

  @override
  Future<void> clear() async {
    _token = null;
  }

  @override
  Future<String?> read() async {
    return _token ?? initialToken;
  }

  @override
  Future<void> write(String token) async {
    _token = token;
  }
}

class FakeAuthRepository implements AuthRepository {
  final user = const UserProfile(
    id: "user-123",
    username: "aluna",
    email: "aluna@graduacao.uerj.br",
    firstName: "Aluna",
    lastName: "UERJ",
  );

  @override
  Future<UserProfile> getCurrentUser() async => user;

  @override
  Future<void> logout() async {}

  @override
  Future<void> register({required String firstName, required String lastName, required String email, String? personalEmail}) async {}

  @override
  Future<void> requestLoginMagicLink(String email) async {}

  @override
  Future<UserProfile> updateCurrentUser({String? username, String? course, String? bio, String? avatarUrl, String? gender, String? orientation, bool? showInGallery}) async {
    return user.copyWith(
      username: username,
      course: course,
      bio: bio,
      avatarUrl: avatarUrl,
      gender: gender,
      orientation: orientation,
      showInGallery: showInGallery,
    );
  }

  @override
  Future<String> verifyMagicLink(String token) async => token;
}

class FakeFeedRepository implements FeedRepository {
  FakeFeedRepository({List<GossipPost>? initialPosts})
    : _posts = List<GossipPost>.from(initialPosts ?? const []);

  final List<GossipPost> _posts;
  final Map<String, List<GossipComment>> _commentsByPost = {};

  @override
  Future<GossipComment> createComment({
    required String postId,
    required String content,
  }) async {
    final comment = GossipComment(
      id: "comment-${DateTime.now().microsecondsSinceEpoch}",
      content: content,
      createdAt: DateTime.now(),
      authorId: "user-123",
    );
    _commentsByPost.update(postId, (value) => [...value, comment], ifAbsent: () => [comment]);
    return comment;
  }

  @override
  Future<GossipPost> createPost({
    required String title,
    required String content,
    required String category,
  }) async {
    final post = GossipPost(
      id: "post-${DateTime.now().microsecondsSinceEpoch}",
      title: title,
      content: content,
      timestamp: DateTime.now(),
      category: category,
      authorId: "user-123",
    );
    _posts.insert(0, post);
    return post;
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final comments = _commentsByPost[postId] ?? [];
    _commentsByPost[postId] = comments.where((item) => item.id != commentId).toList();
  }

  @override
  Future<void> deletePost(String postId) async {
    _posts.removeWhere((item) => item.id == postId);
  }

  @override
  Future<void> likePost(String postId) async {}

  @override
  Future<FeedPostsPage> load({
    String? category,
    int page = 0,
    int pageSize = 20,
  }) async {
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, _posts.length);
    final sliced = start >= _posts.length ? <GossipPost>[] : _posts.sublist(start, end);
    final totalPages = _posts.isEmpty ? 0 : ((_posts.length - 1) ~/ pageSize) + 1;
    return FeedPostsPage(
      posts: List<GossipPost>.from(sliced),
      page: page,
      totalPages: totalPages,
      totalElements: _posts.length,
    );
  }

  @override
  Future<List<GossipComment>> loadComments(
    String postId, {
    int page = 0,
    int pageSize = 20,
  }) async {
    return List<GossipComment>.from(_commentsByPost[postId] ?? const []);
  }

  @override
  Future<void> unlikePost(String postId) async {}
}

UniversityEvent fakeEvent() {
  return const UniversityEvent(
    id: "x",
    title: "Novo",
    category: "Social",
    location: "Campus",
    time: "20:00",
    description: "Teste",
  );
}
