import "../../../domain/models/gossip_post.dart";
import "../../../domain/models/gossip_comment.dart";
import "models/feed_posts_page.dart";

abstract class FeedRepository {
  Future<FeedPostsPage> load({
    String? category,
    int page = 0,
    int pageSize = 20,
  });

  Future<GossipPost> createPost({
    required String title,
    required String content,
    required String category,
  });

  Future<void> deletePost(String postId);

  Future<void> likePost(String postId);

  Future<void> unlikePost(String postId);

  Future<List<GossipComment>> loadComments(
    String postId, {
    int page = 0,
    int pageSize = 20,
  });

  Future<GossipComment> createComment({
    required String postId,
    required String content,
  });

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  });
}
